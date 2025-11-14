extends Resource
class_name Stats

enum BuffableStats{
	current_max_health,
	current_defense,
	current_attack,
	speed,
}

const stat_curves:Dictionary[BuffableStats,Curve]={
	BuffableStats.current_max_health:preload("uid://3vch3h8vn8nn"),
	BuffableStats.current_defense:preload("uid://4cbidtfvw2ml"),
	BuffableStats.current_attack:preload("uid://dd4dk1qiprft1")
}

const base_level_xp:float=100

signal health_depleted
signal health_changed(current_health:float,max_health:float)
signal attri_change(n:String,v:float,flag:StatBuff.BuffType)

@export var speed:float=200
@export var jump_speed:float=-350
@export var base_max_health:float
@export var base_defense:float
@export var base_attack:float
@export var experience:float=0:set=_experience_set

var level:int:
	get():return floor(sqrt(experience/base_level_xp)+0.5)
var current_max_health:float
var current_defense:float
var current_attack:float
var health:float=0:set=_health_set

var stat_buffs:Array[StatBuff]

func _init() -> void:
	
	recaculate_stats()
	setup_stats.call_deferred()

func setup_stats():
	health=current_max_health

func _health_set(v:float):
	health=clampf(v,0,current_max_health)
	health_changed.emit(health,current_max_health)
	if health<=0:
		health_depleted.emit()

func _experience_set(v:float):
	var old_level:int=level
	experience=v
	
	if not old_level==level:
		recaculate_stats()

func add_buff(buff:StatBuff):
	stat_buffs.append(buff)

	recaculate_stats()
	
func remove_buff(buff:StatBuff):
	stat_buffs.erase(buff)
	recaculate_stats()

##计算状态
func recaculate_stats():
	##计算各个属性对应的增益值
	var stat_multipliers:Dictionary={}
	var stat_addends:Dictionary={}
	
	for buff in stat_buffs:
		var stat_name:String=BuffableStats.keys()[buff.stat]
		#print(stat_name,"75d")
		match buff.buff_type:
			StatBuff.BuffType.add:
				stat_addends[stat_name]=0.0
				stat_addends[stat_name]+=buff.buff_amount
				#发送buff信号
				attri_change.emit(stat_name,buff.buff_amount,StatBuff.BuffType.add)
				#print(stat_name,buff.buff_amount)
			StatBuff.BuffType.multiply:
				if not stat_multipliers.has(stat_name):
					stat_multipliers[stat_name]=1.0
				stat_multipliers[stat_name]+=buff.buff_amount
				#发送buff信号
				attri_change.emit(stat_name,buff.buff_amount,StatBuff.BuffType.add)
				if stat_multipliers[stat_name]<0.0:
					stat_multipliers[stat_name]=0.0
	##先计算好当前的基础属性，当前的基础属性为基础属性乘以曲线比例
	var curve_level_pos:float=(float(level)/100.0)-0.01
	current_max_health=base_max_health*stat_curves[BuffableStats.current_max_health].sample(curve_level_pos)
	current_defense=base_defense*stat_curves[BuffableStats.current_defense].sample(curve_level_pos)
	current_attack=base_attack*stat_curves[BuffableStats.current_attack].sample(curve_level_pos)
	
	##然后将增益值应用到当前基础属性
	for stat in stat_multipliers:
		set(stat,get(stat)*stat_multipliers[stat])
	for stat in stat_addends:
		#print(stat)
		#print(stat_addends,"99")
		set(stat,get(stat)+stat_addends[stat])
	pass

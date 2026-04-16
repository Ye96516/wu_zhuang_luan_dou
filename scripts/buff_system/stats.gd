extends Resource
class_name Stats

##枚举用于加buff的属性
enum BuffableStats{
	current_max_health,
	current_defense,
	current_attack,
	speed,
	health,
}

#region 此部分用于等级升级，若无次打算可忽略
###数值曲线数组，曲线根据等级返回数值
#const stat_curves:Dictionary[BuffableStats,Curve]={
	#BuffableStats.current_max_health:preload("uid://3vch3h8vn8nn"),
	#BuffableStats.current_defense:preload("uid://4cbidtfvw2ml"),
	#BuffableStats.current_attack:preload("uid://dd4dk1qiprft1")
#}
###基础经验
#const base_level_xp:float=100
#endregion

##生命值小于等于0时发出
signal health_depleted
##生命值改变时发出
signal health_changed(current_health:float,changed_hp:float,max_health:float,)
##属性改变时发出
signal attri_change(n:String,v:float,flag:StatBuff.BuffType)

#列出属性
@export var speed:float=200
@export var jump_speed:float=-350
#region 此部分用于等级升级，若无次打算可忽略
#@export var base_max_health:float
#@export var base_defense:float
#@export var base_attack:float
###经验值
#@export var experience:float=0:set=_experience_set
###等级计算和等级，每当获取level时自动返回等级结果
#var level:int:
	#get():return floor(sqrt(experience/base_level_xp)+0.5)
#endregion
@export var current_max_health:float
@export var current_defense:float
@export var current_attack:float
##生命值
@export var health:float=0:set=_health_set
##StatBuff数组，存放要加的buff
var stat_buffs:Array[StatBuff]

func _init() -> void:
	recaculate_stats()
	#print(current_max_health)
	_setup_stats.call_deferred()

##为了防止
func _setup_stats():
	health=current_max_health

##当血量改变时触发
func _health_set(current_health:float):
	#算出改变的血量
	var changed_hp:float=health-current_health
	#更新血量
	health=clampf(current_health,0,current_max_health)
	#发送血量改变信号
	health_changed.emit(current_health,changed_hp,current_max_health)
	#若血量小于零则发出死亡信号
	if health<=0:
		health_depleted.emit()
		
#region 此部分用于等级升级，若无次打算可忽略
#func _experience_set(v:float):
	#var old_level:int=level
	#experience=v
	#
	#if not old_level==level:
		#recaculate_stats()
#endregion
		
##添加buff
func add_buff(buff:StatBuff):
	stat_buffs.append(buff)
	recaculate_stats()

##移除buff
func remove_buff(buff:StatBuff):
	stat_buffs.erase(buff)
	recaculate_stats()

##计算状态
func recaculate_stats():
	##计算各个属性对应的增益值
	var stat_multipliers:Dictionary={}
	var stat_addends:Dictionary={}
	#便利
	for buff in stat_buffs:
		#这样写的目的是获取字符串类型的属性，而非枚举(int)类型的属性
		var stat_name:String=BuffableStats.keys()[buff.stat]
		# stat_name示例["current_max_health", "current_defense", "current_attack", "speed"] 0
		match buff.buff_type:
			StatBuff.BuffType.add:
				#算出增益总和并放入stat_addends中
				if not stat_addends.has(stat_name):
					stat_addends[stat_name]=0.0
				stat_addends[stat_name]+=buff.buff_amount
				#发送buff信号
				attri_change.emit(stat_name,buff.buff_amount,StatBuff.BuffType.add)
			StatBuff.BuffType.multiply:
				#算出增益总和并放入stat_multipliers中
				if not stat_multipliers.has(stat_name):
					stat_multipliers[stat_name]=1.0
				stat_multipliers[stat_name]+=buff.buff_amount
				#发送buff信号
				attri_change.emit(stat_name,buff.buff_amount,StatBuff.BuffType.multiply)
				#这部分是防止出现负数，看自己需求
				if stat_multipliers[stat_name]<0.0:
					stat_multipliers[stat_name]=0.0
		#移除buff
		remove_buff(buff)
	#region 此部分用于等级升级，若无次打算可忽略
	##先计算好当前的基础属性，当前的属性为基础属性乘以曲线比例
	##level在一个曲线上的位置值。
	#var curve_level_pos:float=(float(level)/100.0)-0.01
	#current_max_health=base_max_health*stat_curves[BuffableStats.current_max_health].sample(curve_level_pos)
	#current_defense=base_defense*stat_curves[BuffableStats.current_defense].sample(curve_level_pos)
	#current_attack=base_attack*stat_curves[BuffableStats.current_attack].sample(curve_level_pos)
	#endregion

	#将增益值应用到当前基础属性
	for stat in stat_multipliers:
		set(stat,get(stat)*stat_multipliers[stat])
	for stat in stat_addends:
		set(stat,get(stat)+stat_addends[stat])
	pass

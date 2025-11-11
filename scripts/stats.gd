extends Resource
class_name Stats

enum BuffableStats{
	max_health,
	defense,
	attack,
}

const stat_curves:Dictionary[BuffableStats,Curve]={
	BuffableStats.max_health:preload("uid://3vch3h8vn8nn"),
	BuffableStats.defense:preload("uid://4cbidtfvw2ml"),
	BuffableStats.attack:preload("uid://dd4dk1qiprft1")
}

const base_level_xp:float=100

signal health_depleted
signal health_changed(current_health:float,max_health:float)

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
var stat_buffs:Array

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
	recaculate_stats().call_deferred()
func recaculate_stats():
	var curve_level_pos:float=(float(level)/100.0)-0.01
	current_max_health=base_max_health*stat_curves[BuffableStats.max_health].sample(curve_level_pos)
	current_defense=base_defense*stat_curves[BuffableStats.defense].sample(curve_level_pos)
	current_attack=base_attack*stat_curves[BuffableStats.attack].sample(curve_level_pos)
	
	pass

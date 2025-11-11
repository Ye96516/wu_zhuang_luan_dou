extends Resource
class_name StatBuff

enum BuffType{
	multiply,
	add,
}

@export var stat:Stats.BuffableStats
@export var buff_amount:float
@export var buff_type:BuffType

func _init(_stat:Stats.BuffableStats=Stats.BuffableStats.max_health,
			_buff_amount:float=1,
			_buff_type:StatBuff.BuffType=BuffType.multiply) -> void:
	stat=_stat
	buff_type=_buff_type
	buff_amount=_buff_amount

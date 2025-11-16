extends BTAction

var _enemy:Node
var _target

func _enter() -> void:
	_enemy=agent
	_enemy.animation_player.play("run")
	pass

func _tick(delta: float) -> Status:
	
	return SUCCESS

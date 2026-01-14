extends BTAction


func _enter() -> void:
	agent.animation_player.play("run")
	pass
	
func _tick(_delta: float) -> Status:
	var check_player=agent.check_player as RayCast2D
	if check_player.is_colliding() :
		var collider=check_player.get_collider()
		if collider is Player:
			blackboard.set_var("target",collider)
			blackboard.set_var("target_sight",true)
	else:
		blackboard.set_var("target",null)
		blackboard.set_var("target_sight",false)
		return FAILURE
	
	var player:Player=blackboard.get_var("target")
	agent.velocity.x=agent.stat.speed*sign(player.global_position.x-agent.global_position.x)
	return RUNNING
	
	
	

	pass

extends BTAction

var _enemy:CharacterBody2D
var boundary:Array
var flag:bool
var dir:int

func _enter() -> void:
	if !flag:
		_enemy=agent 
		_enemy.animation_player.play("run")
		boundary=_enemy.patrol_area.return_rect(0)
		flag=true
	pass

func _tick(delta: float) -> Status:
	_move(delta)
	var  check_player=_enemy.check_player as RayCast2D
	if check_player.is_colliding() :
		var collider=check_player.get_collider()
		if collider is Player:
			blackboard.set_var("target",collider)
			blackboard.set_var("target_sight",true)
			return FAILURE
	else:
		blackboard.set_var("target",null)
		blackboard.set_var("target_sight",false)
	
	return SUCCESS

func _move(_delta:float):
	var gp:Vector2=_enemy.global_position
	
	if dir==1:
		_enemy.transform.x.x=1
		_enemy.velocity.x=dir*(100)
		if gp.x>boundary[1]:
			dir=-1
	else:
		dir=-1
		_enemy.transform.x.x=-1
		_enemy.velocity.x=dir*(100)
		if gp.x<boundary[0]:
			dir=1

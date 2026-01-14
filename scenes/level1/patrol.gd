extends StateBase

@export var goblin:CharacterBody2D
@export var patrol_area:SpriteArea
@onready var hit_player: RayCast2D = %HitPlayer

var boundary:Array

## 进入状态
func enter() -> void:
	super()
	anp.play("run")
	boundary=patrol_area.return_rect()
	pass

## 退出状态
func exit() -> void:
	super()
	pass

## 渲染帧触发
func process_update(_delta: float) -> void:
	#攻击
	if hit_player.is_colliding():
		var co:Node=hit_player.get_collider()
		if co is Player:
			state_machine.change_state("Atk")
	pass

## 物理帧触发
func physical_process_update(_delta: float) -> void:
	var gp:Vector2=goblin.global_position
	
	if goblin.dir==1:
		goblin.transform.x.x=1
		goblin.velocity.x=goblin.dir*(100)
		if gp.x>boundary[1]:
			goblin.dir=-1
	else:
		goblin.dir=-1
		goblin.transform.x.x=-1
		goblin.velocity.x=goblin.dir*(100)
		if gp.x<boundary[0]:
			goblin.dir=1
	
	pass

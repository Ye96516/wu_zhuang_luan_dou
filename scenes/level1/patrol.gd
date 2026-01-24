extends StateBase

@export var goblin:CharacterBody2D
@export var should_flip:Node2D
@export var pause_time:float=2

@onready var hit_player: RayCast2D = %HitPlayer

var boundary:Array

## 进入状态
func enter() -> void:
	super()
	anp.play("run")
	boundary=goblin.patrol_area.return_rect()
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
			#print(anp.current_animation)
			state_machine.change_state("Atk")
	pass

## 物理帧触发
func physical_process_update(_delta: float) -> void:
	var gp:Vector2=goblin.global_position

	if goblin.dir==1:
		should_flip.transform.x.x=1
		goblin.velocity.x=goblin.dir*(100)
		if gp.x>boundary[1]:
			anp.play("idle")
			goblin.velocity.x=0
			await get_tree().create_timer(pause_time).timeout
			if state_machine.current_state==self:
				anp.play("run")
				goblin.dir=-1

	else:
		goblin.dir=-1
		should_flip.transform.x.x=-1
		goblin.velocity.x=goblin.dir*(100)
		if gp.x<boundary[0]:
			anp.play("idle")
			goblin.velocity.x=0
			await get_tree().create_timer(pause_time).timeout
			if state_machine.current_state==self:
				anp.play("run")
				goblin.dir=1

extends StateBase

@onready var hit_player: RayCast2D = %HitPlayer
@export var goblin:CharacterBody2D

@export var pause_time:float=1

## 进入状态
func enter() -> void:
	super()
	goblin.velocity.x=0
	anp.play("atk")
	pass

## 退出状态
func exit() -> void:
	super()
	pass

## 渲染帧触发
func process_update(_delta: float) -> void:

	pass

## 物理帧触发
func physical_process_update(_delta: float) -> void:

	pass

func _animation_finished(_animation:StringName):
	if state_machine.current_state==$"../Death":
		return
	anp.play("idle")
	await get_tree().create_timer(pause_time).timeout
	if hit_player.is_colliding():
		var co:Node=hit_player.get_collider()
		if co is Player:
			state_machine.change_state("Atk")
	else:
		state_machine.change_state("Patrol")
	pass
		


func _on_atk_area_body_entered(body: Node2D) -> void:
	if body is Player:
		var atk:StatBuff=StatBuff.new(Stats.BuffableStats.health,-10,StatBuff.BuffType.add)
		body.stat.add_buff(atk)
		
		pass
	pass # Replace with function body.

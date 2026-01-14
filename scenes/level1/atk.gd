extends StateBase

@onready var hit_player: RayCast2D = %HitPlayer

@export var goblin:CharacterBody2D
## 进入状态
func enter() -> void:
	super()
	goblin.velocity.x=0
	anp.play("atk")
	anp.animation_finished.connect(_animation_finished)
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

func _animation_finished(an:StringName):
	#攻击
	if hit_player.is_colliding() and an=="atk":
		var co:Node=hit_player.get_collider()
		if co is Player:
			state_machine.change_state("Atk")
	pass
	

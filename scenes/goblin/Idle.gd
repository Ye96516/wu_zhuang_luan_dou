extends StateBase

@onready var hit_player: RayCast2D = %HitPlayer


## 进入状态
func enter() -> void:
	super()
	anp.play("idle")
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

	pass

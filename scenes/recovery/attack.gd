extends StateBase

@export var player:Player

## 进入状态
func enter() -> void:
	super()
	player.velocity.x=0
	anp.play("atk")
	pass

## 退出状态
func exit() -> void:
	pass

## 渲染帧触发
func process_update(_delta: float) -> void:
	pass

## 物理帧触发
func physical_process_update(_delta: float) -> void:
	#移动
	if player.dir:
		player.velocity.x = player.dir * player.stat.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.stat.speed)
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="atk":
		state_machine.change_state("Idle")
		pass
	else:
		printerr("在attk状态脚本中，快来看看发生了什么动画名居然不是atk，动画名称是:",anim_name)
	pass # Replace with function body.


func _on_atk_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.

extends StateBase

@export var player:Player

## 进入状态
func enter() -> void:
	super()
	anp.play("hurt")
	player.should_hurt=false
	pass

## 退出状态
func exit() -> void:
	pass

## 渲染帧触发
func process_update(_delta: float) -> void:

	if Input.is_action_just_pressed("atk"):
		state_machine.change_state("Attack")
	if player.dir:
		state_machine.change_state("Run")
	if player.can_jump:
		state_machine.change_state("Jump")
	pass

## 物理帧触发
func physical_process_update(_delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="hurt":
		if player.is_on_floor():
			state_machine.change_state("Idle")
	pass # Replace with function body.

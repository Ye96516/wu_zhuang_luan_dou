extends StateBase

@export var player:Player

## 进入状态
func enter() -> void:
	super()
	player.velocity.y=player.stat.jump_speed
	pass

## 退出状态
func exit() -> void:
	pass

## 渲染帧触发
func process_update(_delta: float) -> void:
	#切换
	if player.is_on_floor():
		state_machine.change_state("Idle")
	if Input.is_action_just_pressed("atk"):
		state_machine.change_state("Attack")
	if player.dir:
		state_machine.change_state("Run")
	pass

## 物理帧触发
func physical_process_update(_delta: float) -> void:
	pass

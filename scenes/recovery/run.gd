extends StateBase

@export var player:Player

## 进入状态
func enter() -> void:
	super()
	anp.play("run")
	pass

## 退出状态
func exit() -> void:
	pass

## 渲染帧触发
func process_update(_delta: float) -> void:
	#切换
	if Input.is_action_just_pressed("atk"):
		state_machine.change_state("Attack")
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("Jump")
	pass

## 物理帧触发
func physical_process_update(_delta: float) -> void:
	#移动
	if player.dir:
		player.velocity.x = player.dir * player.stat.speed

	#切换
	if player.dir==0:
		state_machine.change_state("Idle")

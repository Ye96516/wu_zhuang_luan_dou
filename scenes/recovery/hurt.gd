extends StateBase

@export var player:Player

## 进入状态
func enter() -> void:
	super()
	anp.play("hurt")
	pass

## 退出状态
func exit() -> void:
	pass

## 渲染帧触发
func process_update(_delta: float) -> void:
	pass

## 物理帧触发
func physical_process_update(_delta: float) -> void:
	pass

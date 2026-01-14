extends StateBase

## 进入状态
func enter() -> void:
	super()
	anp.play("run")
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

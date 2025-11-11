
class_name StateBase extends Node2D

var state_machine: StateMachine
@export var an:AnimatedSprite2D
@export var anp:AnimationPlayer

## 进入状态
func enter() -> void:
	if get_parent().print_state_name:
		print(self.name)
	pass

## 退出状态
func exit() -> void:
	pass

## 渲染帧触发
func process_update(delta: float) -> void:
	pass

## 物理帧触发
func physical_process_update(delta: float) -> void:
	pass

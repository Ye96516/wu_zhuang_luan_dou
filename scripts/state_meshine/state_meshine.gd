extends Node2D

class_name StateMachine

@export var current_state: StateBase
@export var print_state_name:bool

var last_state:StateBase


func _ready() -> void:
	for child in get_children():
		if child is StateBase:
			child.state_machine = self
	await get_parent().ready
	assert(is_instance_valid(current_state),"当前状态为空！")
	current_state.enter()

func _process(delta: float) -> void:
	current_state.process_update(delta)

func _physics_process(delta: float) -> void:
	current_state.physical_process_update(delta)

## 修改状态
func change_state(target_state_name: String) -> void:
	var target_state = get_node(target_state_name)
	if target_state == null:
		printerr("目标节点为空，请检查节点名称是否正确，该节点是否存在。")
		return
	last_state=current_state
	current_state.exit()
	current_state = target_state
	current_state.enter()

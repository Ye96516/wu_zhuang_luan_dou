class_name Player extends CharacterBody2D

@export var stat:Stats

@onready var should_flip: Node2D = %ShouldFlip

var dir:float

var should_hurt:bool

#关于跳跃的参数
var can_jump:bool
var jump_time:int=2
var current_jump_time:int=1

func _ready() -> void:

	pass
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor() and not can_jump:
		#await get_tree().process_frame
		current_jump_time=jump_time

	##判断跳跃条件
	if Input.is_action_just_pressed("jump") and current_jump_time>0:
		can_jump=true
		current_jump_time-=1
	else:
		can_jump=false
	#print(current_jump_time)
	

	dir = Input.get_axis("move_left", "move_right")

	#翻转
	if dir>0:
		should_flip.transform.x.x=abs(transform.x.x)
	if dir<0:
		should_flip.transform.x.x=-abs(transform.x.x)

	move_and_slide()


	
	

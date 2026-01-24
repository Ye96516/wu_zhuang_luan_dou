class_name Player extends CharacterBody2D

@export var stat:Stats

@onready var should_flip: Node2D = %ShouldFlip

var dir:float

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	dir = Input.get_axis("move_left", "move_right")

	#翻转
	if dir>0:
		should_flip.transform.x.x=abs(transform.x.x)
	if dir<0:
		should_flip.transform.x.x=-abs(transform.x.x)

	move_and_slide()


	
	

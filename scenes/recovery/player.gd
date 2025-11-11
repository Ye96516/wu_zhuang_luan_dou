class_name Player extends CharacterBody2D

@export var stat:Stats

var dir:float


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	dir = Input.get_axis("move_left", "move_right")
	
	#翻转
	if dir>0:
		transform.x.x=abs(transform.x.x)
	if dir<0:
		transform.x.x=-abs(transform.x.x)

	move_and_slide()

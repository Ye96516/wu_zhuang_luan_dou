extends CharacterBody2D

@export var stat:Stats
@export var patrol_area:SpriteArea

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var check_player: RayCast2D = $CheckPlayer

var dir:int

func _ready() -> void:
	#print($Sprite2D.texture.get_width())
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

extends CharacterBody2D

@export var stat:Stats

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	print($Sprite2D.texture.get_width())

func _physics_process(delta: float) -> void:


	move_and_slide()

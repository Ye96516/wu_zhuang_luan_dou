class_name Goblin extends CharacterBody2D

@export var stat:Stats
@export var patrol_area:SpriteArea

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: JuciyBar = $HealthBar

var dir:int

func _ready() -> void:
	stat.health_changed.connect(_on_health_changed)
	health_bar.init_value(0,stat.current_max_health)
	pass

func _on_health_changed(ch:float,_mh:float):
	health_bar.change_current_value(ch)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

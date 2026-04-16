class_name Goblin extends CharacterBody2D

@export var stat:Stats
@export var patrol_area:SpriteArea

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: JuciyBar = $HealthBar
@onready var state_machine: StateMachine = $ShouldFlip/StateMachine

var dir:int

func _ready() -> void:
	stat.health_depleted.connect(_on_death)

func _on_death():
	state_machine.change_state("Death")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

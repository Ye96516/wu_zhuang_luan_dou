class_name Player extends CharacterBody2D

@export var stat:Stats

@onready var label: Label =%Label
const font = preload("uid://c62d4rqemmh3j")
var label_setting:LabelSettings

var dir:float

var cursor: int = 0

func _ready() -> void:
	stat.attri_change.connect(_trigger_buff)
	label_setting=LabelSettings.new()
	label_setting.font=font

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	dir = Input.get_axis("move_left", "move_right")
	
	#翻转
	if dir>0:
		$Should.transform.x.x=abs(transform.x.x)
	if dir<0:
		$Should.transform.x.x=-abs(transform.x.x)

	move_and_slide()

func _trigger_buff(buff_name:String,value:float,type:StatBuff.BuffType):
	match type:
		StatBuff.BuffType.add:
			_label_show("%s:+%s"%[buff_name,value])
		StatBuff.BuffType.add:
			_label_show("%s:x%s"%[buff_name,value])

func _label_show(tex:String):
	#创建
	var current_label:Label=Label.new()
	add_child(current_label)
	#设置label
	current_label.label_settings=label_setting
	current_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	current_label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	current_label.size=Vector2(500,23)
	current_label.position=Vector2(-43,-50)
	current_label.modulate.a=1
	current_label.text=tex
	#控制动画
	var t:Tween=get_tree().create_tween()
	t.tween_property(current_label,"modulate:a",0,3)
	t.set_parallel()
	t.tween_property(current_label,"position",Vector2(-43,-200),3)
	await  t.finished
	#销毁
	current_label.queue_free()
	
	

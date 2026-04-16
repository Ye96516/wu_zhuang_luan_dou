extends CanvasLayer
class_name StateShow

@export var target:Node2D
@export var top_offset:float=80
var label_setting:LabelSettings
const font = preload("uid://c62d4rqemmh3j")

func _ready() -> void:
	if not is_instance_valid(target):
		target=get_parent()
	#初始化buff的UI和信号连接
	_init_buff_ui()

func _init_buff_ui():
	target.stat.attri_change.connect(_trigger_buff)
	label_setting=LabelSettings.new()
	label_setting.font=font
	label_setting.font_size=32

func _trigger_buff(buff_name:String,value:float,type:StatBuff.BuffType):
	#print(buff_name)
	match type:
		StatBuff.BuffType.add:
			_label_show("%s:+%s"%[buff_name,value])
		StatBuff.BuffType.multiply:
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
	var pos:Vector2=target.get_global_transform_with_canvas().origin-Vector2(current_label.size.x/2,top_offset)
	
	current_label.global_position=pos
	#print(current_label.get_screen_transform())
	#printt(target.global_position,current_label.global_position)
	
	current_label.modulate.a=1
	current_label.text=tex
	#控制动画
	var t:Tween=get_tree().create_tween()
	t.set_parallel()
	t.tween_property(current_label,"modulate:a",0,3)
	t.tween_property(current_label,"position",Vector2(pos.x,pos.y-200),4)
	#销毁
	t.finished.connect(func():current_label.queue_free())

extends CanvasLayer

@onready var player:Player=get_parent()
@onready var hp_bar: JuciyBar = %HPBar
@onready var hp_value:RichTextLabel = %HPValue

var label_setting:LabelSettings
const font = preload("uid://c62d4rqemmh3j")

func _ready() -> void:
	#player.stat.health_depleted.connect(a)
	#初始化buff的UI和信号连接
	_init_buff_ui()
	#初始化生命值的UI和信号连接
	_init_health_ui()
	pass # Replace with function body.

func _init_health_ui():
	player.stat.health_changed.connect(_health_change)
	hp_bar.init_value(0,player.stat.current_max_health)

#当生命值改变时触发此函数
func _health_change(current_h:float,max_h:float):
	hp_bar.change_current_value(current_h)
	hp_value.text="[color=orange]"+str(int(current_h))+"[/color]"+\
	"/"+"[color=red]"+str(int(max_h))+"[/color]"
	#if 
	#player.should_hurt=true
					

func _init_buff_ui():
	player.stat.attri_change.connect(_trigger_buff)
	label_setting=LabelSettings.new()
	label_setting.font=font

func _trigger_buff(buff_name:String,value:float,type:StatBuff.BuffType):
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
	current_label.position=Vector2(player.global_position.x-current_label.size.x/2,player.global_position.y-58)
	current_label.modulate.a=1
	current_label.text=tex
	#控制动画
	var t:Tween=get_tree().create_tween()
	t.tween_property(current_label,"modulate:a",0,3)
	t.set_parallel()
	t.tween_property(current_label,"position",Vector2(player.global_position.x-current_label.size.x/2,player.global_position.y-200),3)
	await  t.finished
	#销毁
	current_label.queue_free()

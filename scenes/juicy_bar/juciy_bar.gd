class_name JuciyBar extends Control

@onready var	top_layer_bar:ProgressBar=%TopBar
@onready var	bottom_layer_bar:ProgressBar=%BottomBar

@export var target:Node
@export	var	min_value:float=	0.0
@export	var	max_value:float	=100.0
@export var top_bar_time:float=0.2

var	current_value:float	

func	 _ready():
	if not is_instance_valid(target):
		return
	if not target.get("stat"):
		print("指定的血量条对象中并无stat属性")
		return
	var target_stat:Stats=target.stat as Stats
	target_stat.health_changed.connect(_on_health_changed)
	init_value(0,target_stat.current_max_health)
	pass	#	Replace	with	function	body.

##为了避免再ready中调用的时序问题，所以改用外部调用
##初始化横条值
func init_value(min_v:float,max_v:float):
	min_value=min_v
	max_value=max_v
	current_value=max_value
	_set_progress_bar_default_values(top_layer_bar)
	_set_progress_bar_default_values(bottom_layer_bar)

func  _set_progress_bar_default_values(bar:ProgressBar):
	bar.min_value=min_value
	bar.max_value=max_value
	bar.value=current_value
	pass

##更改值
func change_current_value(value:	float):
	current_value=clamp(value,min_value,max_value)
	_run_juicy_tween(top_layer_bar,current_value,top_bar_time,0)
	_run_juicy_tween(bottom_layer_bar,current_value,0.4,0.1)
	pass

func	_run_juicy_tween(bar:	ProgressBar,	value:float,length:float,delay:	float):
	var	tween=get_tree().create_tween()
	tween.tween_property(bar,"value",value,length).set_delay(delay)
	pass

func _on_health_changed(current_health:float,_changed_hp:float,_max_health:float,):
	change_current_value(current_health)
	pass

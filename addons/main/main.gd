@tool
extends EditorPlugin

var paths:PackedStringArray=[
	"res://scenes",
	"res://art",
	"res://data",
	"res://data/theme",
	"res://scripts",
	"res://scripts/state_meshine",
	"res://scripts/global"
]

func _enable_plugin() -> void:
	for path in paths:
		if not DirAccess.dir_exists_absolute(path):
			DirAccess.make_dir_absolute(path)
	# Add autoloads here.
	pass

func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

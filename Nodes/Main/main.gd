extends Node2D


func _ready():
	get_tree().get_root().connect("size_changed", myfunc)
	
func myfunc():
	get_viewport().size = Vector2(round(get_viewport().size.x / 2) * 2, round(get_viewport().size.y / 2) * 2)
	RenderingServer.global_shader_parameter_set("ratio", get_viewport().size.x/get_viewport().size.y)

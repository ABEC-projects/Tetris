extends Node2D


func _on_ui_resized():
	print("Old vieport: ", get_viewport().size)
	get_viewport().size = Vector2(round(get_viewport().size.x / 2) * 2, round(get_viewport().size.y / 2) * 2)
	print("New vieport: ", get_viewport().size)


func _ready():
	get_tree().get_root().connect("size_changed", myfunc)
	
func myfunc():
	get_viewport().size = Vector2(round(get_viewport().size.x / 2) * 2, round(get_viewport().size.y / 2) * 2)
	print("Resizing: ", get_viewport().size)

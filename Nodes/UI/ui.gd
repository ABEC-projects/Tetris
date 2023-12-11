extends Control
signal toggle_pause(paused: bool)


func change_score(new_score: int):
	%Score.text = str(new_score)

func _ready():
	$InGameUI.visible = true
	$Pause.visible = false
	$Settings.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if $Pause.visible:
			emit_signal("toggle_pause", false)
			$Pause.visible = false
			$InGameUI.visible = true
		else:
			emit_signal("toggle_pause", true)
			$Pause.visible = true
			$InGameUI.visible = false

func _on_continue_button_up():
	$Pause.visible = false
	$InGameUI.visible = true
	emit_signal("toggle_pause", false)

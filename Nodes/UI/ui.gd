extends Control


func change_score(new_score: int):
	$InGameUI/Score.text = "Your score is: " + str(new_score)

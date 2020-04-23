extends CanvasLayer


func _on_Main_levelLoaded(characterText):
#	print("signal received with msg ", characterText)
	$TopPanel/Label.text = characterText

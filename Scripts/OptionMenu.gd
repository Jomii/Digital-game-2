extends Panel

var masterIndex

func _ready():
	masterIndex = AudioServer.get_bus_index("Master")
	var volume = AudioServer.get_bus_volume_db(masterIndex)
	$Panel/Volume.value = volume


func _on_BackButton_pressed():
	hide()

func _on_Volume_value_changed(value):
	$Panel/Volume.value = value
	AudioServer.set_bus_volume_db(masterIndex, value)

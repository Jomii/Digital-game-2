extends CanvasLayer


func _on_Main_levelLoaded(characterText):
#	print("signal received with msg ", characterText)
	$TopPanel/CharacterText.text = characterText
	var ingredientElements = $TopPanel/Ingredients.get_children()
	print("testing level drops from UI", global.level.drops)
	
	var i = 0
	for drop in global.level.drops:
		var dropObject = drop["drop"].instance()
		var dropTexture = dropObject.find_node("Sprite").texture
		var collectRequirement = drop["amount"]
		
		ingredientElements[i].visible = true
		ingredientElements[i].find_node("DropIcon").texture = dropTexture
		ingredientElements[i].find_node("Label").text = "0 / " + str(collectRequirement)
		ingredientElements[i].name = dropObject.name
		
		i += 1

# Update Ingredient section of UI
func _on_Main_dropCollected(collectedList):
	var ingredientElements = $TopPanel/Ingredients.get_children()
	for ingredient in collectedList:
		for i in ingredientElements:
			if i.name == ingredient.drop:
				var text = i.find_node("Label").text
				var split = text.split("/")
				text = str(ingredient.amount) + " /" + split[1]
				i.find_node("Label").text = text
				
			

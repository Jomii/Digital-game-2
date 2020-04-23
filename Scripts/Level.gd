extends Node

export(Texture) var levelStartIcon
export(String, MULTILINE) var levelStartText
export(String, MULTILINE) var characterText
export(String, MULTILINE) var levelFailText
export(String, MULTILINE) var levelOneStarText
export(String, MULTILINE) var levelTwoStarText
export(String, MULTILINE) var levelThreeStarText
export(Array) var collectGoal = [{"drop": null, "amount": 0},
 {"drop": null, "amount": 0}, {"drop": null, "amount": 0}, 
{"drop": null, "amount": 0} ,{"drop": null, "amount": 0}]

var drops = []
var maxScore = 0

# Remove Null drops from collectGoal and set them to drops + init maxScore
func _ready():
	for item in collectGoal:
		if (item.drop != null):
			drops.append(item)
			
			var dropObject = item.drop.instance()
			maxScore += dropObject.score * item.amount

extends Reference
class_name BodyPart

const StatGauge = preload("res://util/StatGauge.gd")

var name : String
var hp : StatGauge
var strength : StatObservable
var toughness : StatObservable
var agility : StatObservable
var stress : StatObservable

func _init():
	hp = StatGauge.new()
	strength = StatObservable.new()
	toughness = StatObservable.new()
	agility = StatObservable.new()
	stress = StatObservable.new()
	

func new_bodypart(_name:String):
	var name_chunks = _name.split('_', false, 1)
	if name_chunks.size() > 1:
		name = name_chunks[1].replace('_', ' ')+', '+name_chunks[0]
	else:
		name = name_chunks[0]
	hp.max_value = Rand.normal_value() * 50 + 50
	hp.value = hp.max_value
	strength.value = Rand.normal_value() * 50 + 50
	toughness.value = Rand.normal_value() * 50 + 50
	agility.value = Rand.normal_value() * 50 + 50
	stress.value = 0

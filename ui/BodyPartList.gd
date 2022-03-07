extends GridContainer

const BodyPartStatLabel = preload("res://ui/BodyPartStatLabel.tscn")

func _ready():
	for header in get_children():
		header.add_to_group('header')

func render(bodyparts:Array):
	for child in get_children():
		if !child.is_in_group('header'):
			child.queue_free()

	for bodypart in bodyparts:
		var nameLabel = BodyPartStatLabel.instance()
		nameLabel.text = bodypart.name
		add_child(nameLabel)
		var hpLabel = BodyPartStatLabel.instance()
		hpLabel.connect_gauge(bodypart.hp)
		add_child(hpLabel)
		var stressLabel = BodyPartStatLabel.instance()
		stressLabel.connect_value(bodypart.stress)
		add_child(stressLabel)
		var toughLabel = BodyPartStatLabel.instance()
		toughLabel.connect_value(bodypart.toughness)
		add_child(toughLabel)
		var strLabel = BodyPartStatLabel.instance()
		strLabel.connect_value(bodypart.strength)
		add_child(strLabel)
		var agiLabel = BodyPartStatLabel.instance()
		agiLabel.connect_value(bodypart.agility)
		add_child(agiLabel)

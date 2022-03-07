extends PanelContainer

onready var BodyPartList = find_node("BodyPartList")

func render(body, part_names):
	var bodyparts = []
	for part_name in part_names:
		bodyparts.append(body.get(part_name))
	BodyPartList.render(bodyparts)

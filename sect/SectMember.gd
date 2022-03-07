extends Reference
class_name SectMember

const BODYPARTS = [
"head",
"left_shoulder",
"right_shoulder",
"left_upper_arm",
"right_upper_arm",
"left_lower_arm",
"right_lower_arm",
"left_hand",
"right_hand",
"upper_torso",
"lower_torso",
"upper_back",
"lower_back",
"left_upper_leg",
"right_upper_leg",
"left_lower_leg",
"right_lower_leg",
"left_foot",
"right_foot",
]

var head : BodyPart
var left_shoulder : BodyPart
var right_shoulder : BodyPart
var left_upper_arm : BodyPart
var right_upper_arm : BodyPart
var left_lower_arm : BodyPart
var right_lower_arm : BodyPart
var left_hand : BodyPart
var right_hand : BodyPart
var upper_torso : BodyPart
var lower_torso : BodyPart
var upper_back : BodyPart
var lower_back : BodyPart
var left_upper_leg : BodyPart
var right_upper_leg : BodyPart
var left_lower_leg : BodyPart
var right_lower_leg : BodyPart
var left_foot : BodyPart
var right_foot : BodyPart

var id
var name

func _init():
	for bp_name in BODYPARTS:
		var bp = BodyPart.new()
		set(bp_name, bp)

func new_body():
	name = "RandomName "+str(randi()%10000)
	for bp_name in BODYPARTS:
		var bp = get(bp_name)
		bp.new_bodypart(bp_name)

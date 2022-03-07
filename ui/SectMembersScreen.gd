extends HBoxContainer

onready var SectMembersListContainer = find_node('SectMembersListContainer')
onready var SectMembersList = find_node('SectMembersList')
onready var BodyDisplay = find_node('BodyDisplay')

func _ready():
	EventBus.connect("switch_main_screen", self, 'switch_main_screen')

func switch_main_screen(target):
	visible = target == 'sect_members'
	if visible:
		var can_recruit = GameMgr.get_state('can_recruit', false)
		SectMembersListContainer.visible = can_recruit
		var member = GameState.sect_members[0]
		BodyDisplay.render(member, member.BODYPARTS)


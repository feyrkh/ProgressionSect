extends PanelContainer

func _ready():
	find_node("SectButton").connect("pressed", self, "pressed_button", ['sect'])
	find_node("MembersButton").connect("pressed", self, "pressed_button", ['sect_members'])
	find_node("PathsButton").connect("pressed", self, "pressed_button", ['paths'])
	EventBus.connect('post_new_game', self, 'pressed_button', ['sect_members'])

func pressed_button(id):
	EventBus.emit_signal("switch_main_screen", id)

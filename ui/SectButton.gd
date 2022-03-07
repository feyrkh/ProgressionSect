extends Button

func _ready():
	EventBus.connect('post_new_game', self, 'render')
	EventBus.connect('post_load_game', self, 'render')

func render():
	visible = GameMgr.get_state('can_view_sect', false)

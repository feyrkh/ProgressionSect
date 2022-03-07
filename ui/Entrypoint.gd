extends Node2D

func _ready():
	EventBus.connect('finalize_load_game', self, 'finalize_load_game')
	render()

func render():
	var save_file_exists = File.new().file_exists('user://game.dat')
	find_node('NewGameButton').visible = !save_file_exists
	find_node('ContinueButton').visible = save_file_exists
	find_node('WipeSaveButton').visible = save_file_exists

func _on_NewGameButton_pressed():
	load_main_game_window()
	EventBus.emit_signal('pre_new_game')
	EventBus.emit_signal('post_new_game')
	GameMgr.save_game('user://game.dat')
	EventBus.emit_signal("switch_main_screen", 'sect_members')

func _on_ContinueButton_pressed():
	load_main_game_window()
	GameMgr.load_game('user://game.dat')

func finalize_load_game():
	EventBus.emit_signal("switch_main_screen", 'sect_members')

func load_main_game_window():
	Util.delete_children(self)
	var mainGame = load('res://ui/MainGame.tscn').instance()
	add_child(mainGame)
	mainGame.visible = false
	mainGame.visible = true

func _on_WipeSaveButton_pressed():
	var dir = Directory.new()
	dir.remove("user://game.dat")
	render()


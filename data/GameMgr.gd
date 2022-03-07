extends Node

signal setting_updated(setting_name, old_value, new_value)
signal state_updated(state_name, old_value, new_value)

const SAVE_GAME_MAJOR_VERSION = '000001'
const SAVE_GAME_MINOR_VERSION = '000001'

var game_state = {}
var settings = {}
var transients = []
var settings_file = "user://settings.save"

func pre_new_game():
	game_state = {}
	GameState.new_game()

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	save_game_defaults()
	EventBus.connect("pre_new_game", self, "pre_new_game")
	randomize()
	load_settings()

func save_game(save_file):
	EventBus.emit_signal("pre_save_game")
	var f := File.new()
	#var err = f.open_encrypted_with_pass(save_file, File.WRITE, "dof"+str(c)+str(2021)+"|"+"liquid"+"enthusiasm")
	var err = f.open(save_file, File.WRITE)
	if err != 0:
		printerr(save_file, " : Failed to open save file while saving, got error: ", err)
		return false
	f.store_var(SAVE_GAME_MAJOR_VERSION)
	f.store_var(SAVE_GAME_MINOR_VERSION)
	f.store_var(game_state, true)
	f.store_var(transients)
	f.close()
	EventBus.emit_signal("post_save_game")
	return true

func load_game(save_file):
	get_tree().paused = false
	EventBus.emit_signal("pre_load_game")
	var f := File.new()
	#var err = f.open_encrypted_with_pass(save_file, File.READ, "dof"+str(c)+str(2021)+"|"+"liquid"+"enthusiasm")
	var err = f.open(save_file, File.READ)
	if err != 0:
		printerr(save_file, " : Failed to open save file while loading, got error: ", err)
		return false
	var save_game_version = f.get_var()
	if save_game_version != SAVE_GAME_MAJOR_VERSION:
		printerr(save_file, " : has a different save game major version than the current loading code. File: ", save_game_version, "; Code: ", SAVE_GAME_MAJOR_VERSION)
		return false
	save_game_version = f.get_var()
	if save_game_version != SAVE_GAME_MINOR_VERSION:
		printerr(save_file, " : has a different save game minor version than the current loading code. File: ", save_game_version, "; Code: ", SAVE_GAME_MAJOR_VERSION)
		return false # TODO: Support loading older minor versions
	game_state = f.get_var(true)
	transients = f.get_var()
	save_game_defaults()
	load_transients()
	yield(get_tree(), "idle_frame")
	EventBus.emit_signal("post_load_game")
	yield(get_tree(), "idle_frame")
	EventBus.emit_signal("finalize_load_game")
	return true

func save_game_defaults():
	pass
	#save_game_default("grias_levelup_energy", [25, 25, 25, 0])

func save_game_default(k, default_val_if_missing):
	if game_state.has(k):
		return
	game_state[k] = default_val_if_missing

func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		var err = f.open(settings_file, File.READ)
		if err != 0:
			printerr(settings_file, " : Failed to open settings file while loading, got error: ", err)
			return
		var new_settings:Dictionary = f.get_var()
		f.close()
		for setting in new_settings.keys():
			update_setting(setting, new_settings[setting])
			

func update_setting(setting, val):
	var old_value = settings.get(setting, null)
	settings[setting] = val
	if old_value != val:
		emit_signal("setting_updated", setting, old_value, val)
		print("Setting ", setting, "=", val)

func set_setting(setting, val):
	update_setting(setting, val)

func get_setting(setting, defaultVal=null):
	return settings.get(setting, defaultVal)
	
func load_transients():
	for transient in transients:
		var scene = load(transient.get("f"))
		if scene == null:
			printerr("Unable to load scene for transient: ", transient)
			continue
		var instance = scene.instance()
		instance.set_transient_data(transient.get("c"))
		instance.transform = transient.get("t")
		EventBus.emit_signal("transient_loaded", instance)
	transients = []

func add_transient(scene_filename, scene_config, scene_transform):
	transients.append({"f":scene_filename, "c":scene_config, "t":scene_transform})

func get_state(state_entry, default_val=null):
	if !game_state.has(state_entry):
		game_state[state_entry] = default_val
	return game_state.get(state_entry)

func set_state(state_entry, val):
	update_state(state_entry, val)

func inc_state(state_entry, delta, default_val=0, min_val=null, max_val=null):
	var new_val = get_state(state_entry, default_val)
	new_val = new_val + delta
	if min_val != null and new_val < min_val:
		new_val = min_val
	if max_val != null and new_val > max_val:
		new_val = max_val
	update_state(state_entry, new_val)

func update_state(state_entry, val):
	var old_value = game_state.get(state_entry, null)
	game_state[state_entry] = val
	if !state_entry.begins_with("_"):
		emit_signal("state_updated", state_entry, old_value, val)
		#print("State ", state_entry, "=", val)

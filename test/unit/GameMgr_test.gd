extends "res://addons/gut/test.gd"

func test_can_save_and_restore():
	GameMgr.pre_new_game()
	assert_not_null(GameMgr.game_state)
	assert_eq(1, GameState.sect_members.size(), 'sect member count')
	var sect_member_name = GameState.sect_members[0].name
	print('Sect member name: ', sect_member_name)
	var old_left_shoulder_health_max = GameState.sect_members[0].left_shoulder.hp.max_value
	GameMgr.save_game('user://unit_test_save.dat')
	assert_eq(1, GameMgr.get_state('sect_members').size())
	GameMgr.game_state = {}
	GameState.sect_members = []
	assert_null(GameMgr.get_state('sect_members'))
	GameMgr.load_game('user://unit_test_save.dat')
	yield(yield_to(EventBus, 'finalize_load_game', 1, 'Waiting for finalize_load_game to fire'), YIELD)
	assert_eq(sect_member_name, GameMgr.game_state.sect_members[0].name)
	assert_eq(1, GameMgr.get_state('sect_members').size())
	var new_left_shoulder_health_max = GameState.sect_members[0].left_shoulder.hp.max_value
	assert_eq(new_left_shoulder_health_max, old_left_shoulder_health_max, 'max health changed')
	

extends Node

var SectMember = load('res://sect/SectMember.gd')

var sect_members = []

func _ready():
	EventBus.connect('pre_save_game', self, 'pre_save_game')
	EventBus.connect('post_load_game', self, 'post_load_game')

func pre_save_game():
	var sect_members_ser = []
	for sect_member in sect_members:
		var sect_member_c = Util.to_config(sect_member)
		sect_members_ser.append(sect_member_c)
	GameMgr.set_state('sect_members', sect_members_ser)

func post_load_game():
	sect_members = []
	var sect_members_ser = GameMgr.get_state('sect_members', [])
	for config in sect_members_ser:
		var sect_member = SectMember.new()
		Util.config(sect_member, config)
		sect_members.append(sect_member)

func new_game():
	var starting_member = SectMember.new()
	starting_member.new_body()
	add_sect_member(starting_member)

func add_sect_member(new_member):
	new_member.id = sect_members.size()
	sect_members.append(new_member)

extends Node

# save game handling
signal pre_new_game()
signal post_new_game()
signal finalize_new_game()
signal pre_save_game()
signal post_save_game()
signal pre_load_game()
signal post_load_game()
signal finalize_load_game()
signal transient_loaded(transient_instance)

# main game menu
signal switch_main_screen(view_name) # members, sect, 

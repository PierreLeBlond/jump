extends CanvasLayer

class_name Screen

signal wants_to_quit_to_main_menu()
signal wants_to_load_level(level_name: String)
signal wants_to_start_new_game()
signal wants_to_open_leaderboard()

func focus() -> void:
    pass

func quit_to_main_menu() -> void:
    wants_to_quit_to_main_menu.emit()

func load_level(level_name: String) -> void:
    wants_to_load_level.emit(level_name)

func start_new_game() -> void:
    wants_to_start_new_game.emit()

func open_leaderboard() -> void:
    wants_to_open_leaderboard.emit()
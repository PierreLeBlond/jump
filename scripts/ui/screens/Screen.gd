extends Control

class_name Screen

signal wants_to_quit_to_title_screen()
signal wants_to_load_level(level_name: String)
signal wants_to_start_new_game()
signal wants_to_open_leaderboard()
signal wants_to_open_options()

func focus() -> void:
    pass

func quit_to_title_screen() -> void:
    disable()
    wants_to_quit_to_title_screen.emit()

func load_level(level_name: String) -> void:
    disable()
    wants_to_load_level.emit(level_name)

func start_new_game() -> void:
    disable()
    wants_to_start_new_game.emit()

func open_leaderboard() -> void:
    disable()
    wants_to_open_leaderboard.emit()

func open_options() -> void:
    disable()
    wants_to_open_options.emit()

func disable() -> void:
    pass

func enable() -> void:
    pass
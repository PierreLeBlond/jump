extends Node

class_name Level

signal wants_to_load_level(level_name: String)
signal wants_to_quit_to_main_menu()
signal wants_to_start_new_game()
signal wants_to_show_hud()
signal wants_to_hide_hud()

signal died()
signal finished()
signal score_added(value: int)
signal life_added(value: int)

@export var checkpoint_manager: CheckpointManager

func _ready() -> void:
    checkpoint_manager.activate_checkpoints(self)

func load_level(level_name: String) -> void:
    wants_to_load_level.emit(level_name)

func load_checkpoint() -> void:
    checkpoint_manager.load()

func quit_to_main_menu() -> void:
    wants_to_quit_to_main_menu.emit()

func start_new_game() -> void:
    wants_to_start_new_game.emit()

func show_hud() -> void:
    wants_to_show_hud.emit()

func hide_hud() -> void:
    wants_to_hide_hud.emit()

func die() -> void:
    died.emit()

func finish() -> void:
    finished.emit()

func add_score(value: int) -> void:
    score_added.emit(value)

func add_life(value: int) -> void:
    life_added.emit(value)

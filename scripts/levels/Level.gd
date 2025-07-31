extends Node

class_name Level

signal wants_to_load_level(level_name: String)
signal wants_to_quit_to_main_menu()
signal wants_to_start_new_game()

signal score_added(value: int)
signal life_added(value: int)

@export var checkpoint_manager: CheckpointManager

var hud: HUD

func _ready() -> void:
    checkpoint_manager.activate_checkpoints(self)

func initialize(game_hud: HUD) -> void:
    self.hud = game_hud

func load_level(level_name: String) -> void:
    wants_to_load_level.emit(level_name)

func load_checkpoint() -> void:
    checkpoint_manager.load()

func quit_to_main_menu() -> void:
    wants_to_quit_to_main_menu.emit()

func start_new_game() -> void:
    wants_to_start_new_game.emit()

func reveal_hud() -> void:
    hud.reveal()

func unreveal_hud() -> void:
    hud.unreveal()

func show_hud() -> void:
    hud.immediate_reveal()

func hide_hud() -> void:
    hud.immediate_unreveal()

func add_score(value: int) -> void:
    score_added.emit(value)

func add_life(value: int) -> void:
    life_added.emit(value)

extends Node

class_name Level

signal wants_to_load_level(level_name: String)
signal wants_to_quit_to_main_menu()
signal wants_to_start_new_game()

signal died()
signal finished()
signal score_added(value: int)
signal life_added(value: int)

@export var checkpoint_manager: CheckpointManager

var hud: HUD

var game_run: GameRun:
    get:
        return game_run
    set(value):
        if game_run:
            game_run.life_changed.disconnect(hud.life_counter.update_counter)
            game_run.score_changed.disconnect(hud.score_counter.update_counter)
            game_run.time_changed.disconnect(hud.time_counter.update_time_counter)

        game_run = value
        game_run.life_changed.connect(hud.life_counter.update_counter)
        game_run.score_changed.connect(hud.score_counter.update_counter)
        game_run.time_changed.connect(hud.time_counter.update_time_counter)

        hud.life_counter.update_counter(game_run.life)
        hud.score_counter.update_counter(game_run.score)
        hud.time_counter.update_time_counter(game_run.accumulated_time)

func _ready() -> void:
    hud = load("res://scenes/ui/hud/HUD.tscn").instantiate()
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
    if hud.get_parent():
        return

    add_child(hud)

func hide_hud() -> void:
    if !hud.get_parent():
        return

    remove_child(hud)

func die() -> void:
    died.emit()

func finish() -> void:
    finished.emit()

func add_score(value: int) -> void:
    score_added.emit(value)

func add_life(value: int) -> void:
    life_added.emit(value)

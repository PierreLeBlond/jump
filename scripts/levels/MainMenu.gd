extends Level

class_name TitleScreen

@export var tutorial_button: Button
@export var level_1_button: Button
@export var leaderboard_button: Button

@export var fade_in_animation: AnimationPlayer

func _ready() -> void:
    hide_hud()

    tutorial_button.grab_focus()

    tutorial_button.pressed.connect(func(): load_level("Tutorial"))
    level_1_button.pressed.connect(func(): start_new_game())
    leaderboard_button.pressed.connect(func(): open_leaderboard())

func transition_out() -> void:
    tutorial_button.disabled = true
    level_1_button.disabled = true
    leaderboard_button.disabled = true
    fade_in_animation.play_backwards("reveal")
    await fade_in_animation.animation_finished

func load_level(level_name: String) -> void:
    await transition_out()
    wants_to_load_level.emit(level_name)

func start_new_game() -> void:
    await transition_out()
    wants_to_start_new_game.emit()

func open_leaderboard() -> void:
    await transition_out()
    wants_to_open_leaderboard.emit()

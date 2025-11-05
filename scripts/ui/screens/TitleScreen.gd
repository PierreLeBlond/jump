extends Screen

class_name TitleScreen

@export var tutorial_button: Button
@export var level_1_button: Button
@export var leaderboard_button: Button
@export var options_button: Button

@export var options_manager: OptionsManager

func _ready() -> void:
    tutorial_button.pressed.connect(func(): load_level("Tutorial"))
    level_1_button.pressed.connect(start_new_game)
    leaderboard_button.pressed.connect(open_leaderboard)

    options_button.pressed.connect(options_manager.open_options)
    options_manager.options_closed.connect(func(): options_button.grab_focus())

func focus() -> void:
    tutorial_button.grab_focus()

func disable() -> void:
    tutorial_button.disabled = true
    level_1_button.disabled = true
    leaderboard_button.disabled = true
    options_button.disabled = true

func enable() -> void:
    tutorial_button.disabled = false
    level_1_button.disabled = false
    leaderboard_button.disabled = false
    options_button.disabled = false
extends Screen

class_name MainMenu

@export var tutorial_button: Button
@export var level_1_button: Button
@export var leaderboard_button: Button

func _ready() -> void:
    tutorial_button.pressed.connect(func(): load_level("Tutorial"))
    level_1_button.pressed.connect(start_new_game)
    leaderboard_button.pressed.connect(open_leaderboard)

func focus() -> void:
    tutorial_button.grab_focus()

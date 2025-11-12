extends PanelContainer

class_name ScoreSubmit

signal submitted()

@export var score_label: Label
@export var time_label: Label

@export var player_name_input: TextInput

@export var submit_button: Button

var score: int = 0:
    set(value):
        score = value
        score_label.text = str(score)

var time: float = 0:
    set(value):
        time = value
        time_label.text = Utils.format_time(time)

func _ready() -> void:
    submit_button.pressed.connect(on_submit_button_pressed)

func on_submit_button_pressed() -> void:
    if player_name_input.line_edit.text.is_empty():
        return

    submit_button.disabled = true

    await Talo.players.identify("username", player_name_input.line_edit.text.uri_encode())
    await Talo.leaderboards.add_entry(Globals.SCORES_LEADERBOARD_INTERNAL_NAME, score)
    await Talo.leaderboards.add_entry(Globals.TIMES_LEADERBOARD_INTERNAL_NAME, time)

    submit_button.disabled = false

    submitted.emit()
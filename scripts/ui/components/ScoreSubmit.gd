extends PanelContainer

class_name ScoreSubmit

signal submitted()

@export var score_label: Label
@export var time_label: Label

@export var player_name_input: LineEdit

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
    if player_name_input.text.is_empty():
        return

    submit_button.disabled = true

    await SilentWolf.Scores.save_score(player_name_input.text, score)
    await SilentWolf.Scores.save_score(player_name_input.text, -time, "time")

    submit_button.disabled = false

    submitted.emit()

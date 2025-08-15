extends PanelContainer

class_name ScoreSubmit

signal submitted()

@export var score_label: Label
@export var time_label: Label

@export var player_name_input: LineEdit

@export var prompt_button: TextureButton
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
    prompt_button.pressed.connect(on_prompt_button_pressed)
    submit_button.pressed.connect(on_submit_button_pressed)

    if OS.has_feature('web'):
        prompt_button.visible = true
    else:
        prompt_button.visible = false

func on_prompt_button_pressed() -> void:
    if OS.has_feature('web'):
        var player_name = JavaScriptBridge.eval("""
            window.prompt('nom') 
            """)
        player_name_input.text = String(player_name).left(16)

func on_submit_button_pressed() -> void:
    if player_name_input.text.is_empty():
        return

    submit_button.disabled = true

    await SilentWolf.Scores.save_score(player_name_input.text, score)
    await SilentWolf.Scores.save_score(player_name_input.text, -time, "time")

    submit_button.disabled = false

    submitted.emit()

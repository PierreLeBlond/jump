extends Control

class_name CollectorLabel

@export var animation_player: AnimationPlayer
@export var count_label: Label
@export var collector: NoteCollector

func _ready() -> void:
    collector.note_collected.connect(on_note_collected)

func on_note_collected(count: int) -> void:
    animation_player.play("pulse")

    if count < 10:
        count_label.text = "0" + str(count)
    else:
        count_label.text = str(count)

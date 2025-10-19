extends Node

class_name ComboConnector

@export var target: Node2D

@export var music_manager: MusicManager
@export var combo_note: ComboNote

var _timer: Timer

func _process(_delta: float) -> void:
    combo_note.update_position(target)

func _end() -> void:
    music_manager.muffle()
    _timer = null

func update(duration: float, count: int) -> void:
    if _timer:
        _timer.stop()
        _timer = null
    else:
        music_manager.unmuffle()

    combo_note.update(duration, count)

    _timer = Timer.new()
    _timer.wait_time = duration
    _timer.one_shot = true
    add_child(_timer)
    _timer.start()

    _timer.timeout.connect(_end)

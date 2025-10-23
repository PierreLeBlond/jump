extends Node

class_name ComboConnector

@export var target: Node2D

@export var music_manager: MusicManager
@export var combo_note: ComboNote
@export var staff_cape: StaffCape

var _timer: Timer

func _ready() -> void:
    staff_cape.hide()

func _process(delta: float) -> void:
    combo_note.update_position(target)

    var ratio = _timer.time_left / _timer.wait_time if _timer else 1.0
    staff_cape.update(delta, ratio)

func _end() -> void:
    music_manager.muffle()
    staff_cape.hide()
    _timer = null

func update(duration: float, count: int) -> void:
    if _timer:
        _timer.stop()
        _timer = null
    else:
        music_manager.unmuffle()
        staff_cape.show()

    combo_note.update(count)
    staff_cape.update_label(count)

    _timer = Timer.new()
    _timer.wait_time = duration
    _timer.one_shot = true
    add_child(_timer)
    _timer.start()

    _timer.timeout.connect(_end)

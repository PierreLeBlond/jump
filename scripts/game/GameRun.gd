extends Node

class_name GameRun

const MAX_LIFE: int = 3
const DEFAULT_COMBO_DURATION: float = 1.0

signal life_changed(value: int)
signal score_changed(value: int)
signal time_changed(value: int)

signal combo_ended()

var combo_count: int = 0
var combo_timer: Timer

var combo_duration: float = DEFAULT_COMBO_DURATION

var life: int = MAX_LIFE
var score: int = 0

var accumulated_time: float = 0.0
var last_time: float = 0.0

var is_playing: bool = false

var saved_score: int = 0
var saved_time: float = 0.0

func _ready() -> void:
    reset()

func reset() -> void:
    life = MAX_LIFE
    score = 0
    reset_time()

    life_changed.emit(life)
    score_changed.emit(score)
    time_changed.emit(accumulated_time)

func accumulate_time() -> void:
    var time_now = Time.get_unix_time_from_system()
    accumulated_time += time_now - last_time
    last_time = time_now
    time_changed.emit(accumulated_time)

func reset_time() -> void:
    accumulated_time = 0.0
    last_time = Time.get_unix_time_from_system()

func play() -> void:
    is_playing = true
    last_time = Time.get_unix_time_from_system()

func pause() -> void:
    accumulate_time()
    is_playing = false

func add_life() -> void:
    life += 1
    life_changed.emit(life)

func remove_life() -> void:
    life -= 1
    life_changed.emit(life)

func add_note() -> void:
    update_combo()
    score += combo_count
    score_changed.emit(score)

func save() -> void:
    saved_score = score
    saved_time = accumulated_time

func restore() -> void:
    score = saved_score
    score_changed.emit(score)
    accumulated_time = saved_time
    time_changed.emit(accumulated_time)

func update_combo() -> void:
    combo_count += 1
    if combo_timer:
        combo_timer.stop()
        combo_timer.timeout.disconnect(on_combo_timeout)
        combo_timer = null
    combo_timer = Timer.new()
    combo_timer.wait_time = combo_duration
    combo_timer.one_shot = true
    add_child(combo_timer)
    combo_timer.start()
    combo_timer.timeout.connect(on_combo_timeout)
    Events.emit_combo_updated(combo_duration, combo_count)

func on_combo_timeout() -> void:
    combo_count = 0
    combo_ended.emit()

func _process(_delta: float) -> void:
    if !is_playing:
      return

    accumulate_time()
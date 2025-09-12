extends Node

class_name GameRun

const DEFAULT_COMBO_DURATION: float = 1.0

signal life_changed(value: int)
signal score_changed(value: int)
signal time_changed(value: int)

signal combo_updated(duration: float, count: int)
signal combo_ended()

var combo_count: int = 0
var combo_timer: Timer

var combo_duration: float = DEFAULT_COMBO_DURATION

var life: int = 0:
    set(value):
        life = value
        life_changed.emit(life)
var score: int = 0:
    set(value):
        score = value
        score_changed.emit(score)

var elapsed_time: float = 0.0:
    set(value):
        elapsed_time = value
        time_changed.emit(elapsed_time)
var last_time: float = 0.0

var is_playing: bool = false

func update_time() -> void:
    var time_now = Time.get_unix_time_from_system()
    elapsed_time += time_now - last_time
    last_time = time_now

func reset_time() -> void:
    elapsed_time = 0.0
    last_time = Time.get_unix_time_from_system()

func resume() -> void:
    is_playing = true
    last_time = Time.get_unix_time_from_system()

func pause() -> void:
    update_time()
    is_playing = false

func add_life() -> void:
    life += 1

func remove_life() -> void:
    life -= 1

func add_note() -> void:
    update_combo()
    score += combo_count

func clear_timer() -> void:
    if combo_timer:
        combo_timer.stop()
        combo_timer.timeout.disconnect(end_combo)
        combo_timer = null

func update_combo() -> void:
    combo_count += 1
    if combo_timer:
        clear_timer()
    combo_timer = Timer.new()
    combo_timer.wait_time = combo_duration
    combo_timer.one_shot = true
    add_child(combo_timer)
    combo_timer.start()
    combo_timer.timeout.connect(end_combo)
    combo_updated.emit(combo_duration, combo_count)

func end_combo() -> void:
    clear_timer()
    combo_count = 0
    combo_ended.emit()

func _process(_delta: float) -> void:
    if !is_playing:
      return

    update_time()

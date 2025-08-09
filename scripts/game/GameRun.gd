extends Node

class_name GameRun

signal life_changed(value: int)
signal score_changed(value: int)
signal time_changed(value: int)

const MAX_LIFE: int = 3

var life: int = MAX_LIFE
var score: int = 0

var accumulated_time: float = 0.0
var last_time: float = 0.0

var is_playing: bool = false

func _ready() -> void:
    reset()

func reset() -> void:
    life = 0
    score = 0
    accumulated_time = 0.0
    last_time = Time.get_unix_time_from_system()

    add_life(MAX_LIFE)

func accumulate_time() -> void:
    var time_now = Time.get_unix_time_from_system()
    accumulated_time += time_now - last_time
    last_time = time_now
    time_changed.emit(accumulated_time)

func play() -> void:
    is_playing = true
    last_time = Time.get_unix_time_from_system()

func pause() -> void:
    accumulate_time()
    is_playing = false

func add_life(value: int) -> void:
    life += value
    life_changed.emit(life)

func add_score(value: int) -> void:
    score += value
    score_changed.emit(score)

func set_score(value: int) -> void:
    score = value
    score_changed.emit(score)

func _process(_delta: float) -> void:
    if !is_playing:
      return

    accumulate_time()
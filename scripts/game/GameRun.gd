extends Node

class_name GameRun

var life: int = 3
var score: int = 0

var accumulated_time: float = 0.0
var last_time: float = 0.0

var is_playing: bool = false

func _ready() -> void:
    reset()

func reset() -> void:
    life = 3
    score = 0
    accumulated_time = 0.0
    last_time = Time.get_unix_time_from_system()

func accumulate_time() -> void:
    var time_now = Time.get_unix_time_from_system()
    accumulated_time += time_now - last_time
    last_time = time_now

func play() -> void:
    is_playing = true
    last_time = Time.get_unix_time_from_system()

func pause() -> void:
    accumulate_time()
    is_playing = false

func _process(_delta: float) -> void:
    if !is_playing:
      return

    accumulate_time()
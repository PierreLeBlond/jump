extends AudioStreamPlayer2D

class_name AudioPlayer2D

const INAUDIBLE_VOLUME_DB: float = -80.0

@export var target_volume_db: float = 0.0

# Avoid freezes on low end devices by playing samples in advance during world loading
func _ready() -> void:
    volume_db = INAUDIBLE_VOLUME_DB
    play()

    # Maybe we can then stop the samples from playing ?

func fade_out(duration: float = 1.0) -> void:
    volume_db = target_volume_db

    var tween: Tween = create_tween()
    tween.tween_property(self, "volume_db", INAUDIBLE_VOLUME_DB, duration)
    await tween.finished

    stop()

func fade_in(duration: float = 1.0) -> void:
    volume_db = INAUDIBLE_VOLUME_DB

    play()

    var tween: Tween = create_tween()
    tween.tween_property(self, "volume_db", target_volume_db, duration)
    await tween.finished
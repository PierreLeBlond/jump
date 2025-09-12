extends Node

class_name MusicManager

const RACE_MUSIC_DELAY: float = 0.25
const INAUDIBLE_VOLUME_DB: float = -80.0

@export var forest_audio_stream_player: AudioStreamPlayer
@export var note_audio_stream_player: AudioStreamPlayer
@export var soubalien_audio_stream_player: AudioStreamPlayer

@export var race_note_audio_stream_player: AudioStreamPlayer
@export var race_audio_stream_player: AudioStreamPlayer
@export var soubalien_race_audio_stream_player: AudioStreamPlayer2D

var note_collected_tween: Tween

var current_note_audio_stream_player: AudioStreamPlayer
var current_note_duration: float = 0.0

func _ready() -> void:
    preload_samples()

    current_note_audio_stream_player = note_audio_stream_player

    # We need sample playback to support low end devices like mobiles, so looping has to be done manually
    note_audio_stream_player.finished.connect(func():
        note_audio_stream_player.play()
    )

    forest_audio_stream_player.finished.connect(func():
        forest_audio_stream_player.play()
    )

# Avoid freezes on low end devices by playing samples in advance during world loading
func preload_samples() -> void:
    forest_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    note_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    soubalien_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    race_note_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    race_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    soubalien_race_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB

    forest_audio_stream_player.play()
    note_audio_stream_player.play()
    soubalien_audio_stream_player.play()
    race_note_audio_stream_player.play()
    race_audio_stream_player.play()
    soubalien_race_audio_stream_player.play()

    # Maybe we can then stop the samples from playing ?

func play(audio_stream_player: AudioStreamPlayer) -> void:
    audio_stream_player.volume_db = 0.0
    audio_stream_player.play()

func play_2d(audio_stream_player: AudioStreamPlayer2D) -> void:
    audio_stream_player.volume_db = 10.0
    audio_stream_player.play()

func fade_out(audio_stream_player: AudioStreamPlayer, duration: float = 1.0) -> void:
    var tween: Tween = create_tween()
    tween.tween_property(audio_stream_player, "volume_db", INAUDIBLE_VOLUME_DB, duration)
    await tween.finished
    audio_stream_player.stop()

func fade_out_2d(audio_stream_player: AudioStreamPlayer2D, duration: float = 1.0) -> void:
    var tween: Tween = create_tween()
    tween.tween_property(audio_stream_player, "volume_db", INAUDIBLE_VOLUME_DB, duration)
    await tween.finished
    audio_stream_player.stop()

func start() -> void:
    play(forest_audio_stream_player)

func introduce_race() -> void:
    fade_out(forest_audio_stream_player)
    fade_out(note_audio_stream_player)
    play(soubalien_audio_stream_player)

func start_countdown() -> void:
    fade_out(soubalien_audio_stream_player)
    await get_tree().create_timer(RACE_MUSIC_DELAY).timeout

    current_note_audio_stream_player = race_note_audio_stream_player
    current_note_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    current_note_audio_stream_player.play()

    play(race_audio_stream_player)
    play_2d(soubalien_race_audio_stream_player)


func end_race() -> void:
    if note_collected_tween:
        note_collected_tween.stop()
        note_collected_tween = null

    fade_out(race_audio_stream_player)
    fade_out_2d(soubalien_race_audio_stream_player)

func update_combo(duration: float, _count: int) -> void:
    if note_collected_tween:
        note_collected_tween.stop()
        note_collected_tween = null

    var tween = create_tween()
    tween.tween_property(current_note_audio_stream_player, "volume_db", 0.0, 0.2)
    note_collected_tween = tween
    await tween.finished
    await get_tree().create_timer(duration).timeout

    if note_collected_tween != tween:
        return

    tween.stop()

    tween = create_tween()
    tween.tween_property(current_note_audio_stream_player, "volume_db", INAUDIBLE_VOLUME_DB, 1.0)
    note_collected_tween = tween

    await tween.finished

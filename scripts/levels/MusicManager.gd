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

@export var event_dispatcher: EventDispatcher

var note_collected_tween: Tween

var current_note_audio_stream_player: AudioStreamPlayer
var current_note_duration: float = 0.0

func _ready() -> void:
    event_dispatcher.soubalien_appears.connect(on_soubalien_appears)
    event_dispatcher.race_starts.connect(on_race_starts)
    event_dispatcher.race_ends.connect(on_race_ends)
    event_dispatcher.combo_updated.connect(on_combo_updated)

    current_note_audio_stream_player = note_audio_stream_player
    current_note_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    current_note_audio_stream_player.play()

func on_soubalien_appears() -> void:
    fade_out(forest_audio_stream_player)
    play(soubalien_audio_stream_player)

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

func on_race_starts() -> void:
    fade_out(soubalien_audio_stream_player)
    await get_tree().create_timer(RACE_MUSIC_DELAY).timeout

    current_note_audio_stream_player = race_note_audio_stream_player
    current_note_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    current_note_audio_stream_player.play()

    play(race_audio_stream_player)
    play_2d(soubalien_race_audio_stream_player)

func on_race_ends() -> void:
    if note_collected_tween:
        note_collected_tween.stop()
        note_collected_tween = null

    fade_out(race_audio_stream_player)
    fade_out_2d(soubalien_race_audio_stream_player)

func on_combo_updated(duration: float, _count: int) -> void:
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

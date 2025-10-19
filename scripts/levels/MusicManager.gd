extends Node

class_name MusicManager

const RACE_MUSIC_DELAY: float = 0.0
const INAUDIBLE_VOLUME_DB: float = -80.0

const EFFECT_BUS_INDEX: int = 1
const LOW_PASS_FILTER_EFFECT_INDEX: int = 0
const REVERB_EFFECT_INDEX: int = 1

const LOW_PASS_FILTER_INNACTIVE_CUTOFF_HZ: float = 20500.0

const INTRO_LOW_PASS_FILTER_CUTOFF_HZ: float = 500
const INTRO_REVERB_WET: float = 0.5

const RACE_LOW_PASS_FILTER_CUTOFF_HZ: float = 900.0
const RACE_REVERB_WET: float = 0.3

@export var forest_audio_stream_player: AudioStreamPlayer
@export var note_audio_stream_player: AudioStreamPlayer
@export var soubalien_audio_stream_player: AudioStreamPlayer

@export var race_audio_stream_player: AudioStreamPlayer
@export var soubalien_race_audio_stream_player: AudioStreamPlayer2D

@export var whoosh_in_audio_stream_player: AudioStreamPlayer
@export var whoosh_out_audio_stream_player: AudioStreamPlayer

var _muffle_tween: Tween

var current_note_audio_stream_player: AudioStreamPlayer
var current_low_pass_filter_cutoff_hz: float
var current_reverb_wet: float

var low_pass_filter_effect: AudioEffectLowPassFilter
var reverb_effect: AudioEffectReverb

func _ready() -> void:
    preload_samples()

    low_pass_filter_effect = AudioServer.get_bus_effect(EFFECT_BUS_INDEX, LOW_PASS_FILTER_EFFECT_INDEX) as AudioEffectLowPassFilter
    reverb_effect = AudioServer.get_bus_effect(EFFECT_BUS_INDEX, REVERB_EFFECT_INDEX) as AudioEffectReverb

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
    race_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    soubalien_race_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    whoosh_in_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB
    whoosh_out_audio_stream_player.volume_db = INAUDIBLE_VOLUME_DB

    forest_audio_stream_player.play()
    note_audio_stream_player.play()
    soubalien_audio_stream_player.play()
    race_audio_stream_player.play()
    soubalien_race_audio_stream_player.play()
    whoosh_in_audio_stream_player.play()
    whoosh_out_audio_stream_player.play()

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
    current_low_pass_filter_cutoff_hz = INTRO_LOW_PASS_FILTER_CUTOFF_HZ
    current_reverb_wet = INTRO_REVERB_WET

    low_pass_filter_effect.cutoff_hz = current_low_pass_filter_cutoff_hz
    reverb_effect.wet = current_reverb_wet

    play(forest_audio_stream_player)
    play(note_audio_stream_player)

func introduce_race() -> void:
    low_pass_filter_effect.cutoff_hz = LOW_PASS_FILTER_INNACTIVE_CUTOFF_HZ
    reverb_effect.wet = 0.0

    fade_out(forest_audio_stream_player)
    fade_out(note_audio_stream_player)
    play(soubalien_audio_stream_player)

func start_countdown() -> void:
    current_low_pass_filter_cutoff_hz = RACE_LOW_PASS_FILTER_CUTOFF_HZ
    current_reverb_wet = RACE_REVERB_WET

    low_pass_filter_effect.cutoff_hz = LOW_PASS_FILTER_INNACTIVE_CUTOFF_HZ
    reverb_effect.wet = 0.0

    fade_out(soubalien_audio_stream_player)
    await get_tree().create_timer(RACE_MUSIC_DELAY).timeout

    play(race_audio_stream_player)
    play_2d(soubalien_race_audio_stream_player)

func end_race() -> void:
    if _muffle_tween:
        _muffle_tween.stop()
        _muffle_tween = null

    fade_out(race_audio_stream_player)
    fade_out_2d(soubalien_race_audio_stream_player)

func muffle() -> void:
    if _muffle_tween:
        _muffle_tween.stop()
        _muffle_tween = null
    _muffle_tween = create_tween()
    _muffle_tween.tween_property(low_pass_filter_effect, "cutoff_hz", current_low_pass_filter_cutoff_hz, 0.1)
    _muffle_tween.parallel().tween_property(reverb_effect, "wet", current_reverb_wet, 0.1)
    play(whoosh_in_audio_stream_player)

func unmuffle() -> void:
    if _muffle_tween:
        _muffle_tween.stop()
        _muffle_tween = null
    _muffle_tween = create_tween()
    _muffle_tween.tween_property(low_pass_filter_effect, "cutoff_hz", LOW_PASS_FILTER_INNACTIVE_CUTOFF_HZ, 0.5)
    _muffle_tween.parallel().tween_property(reverb_effect, "wet", 0.0, 0.5)
    play(whoosh_out_audio_stream_player)

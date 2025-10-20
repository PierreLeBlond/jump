extends Node

class_name MusicManager

const RACE_MUSIC_DELAY: float = 0.0
const INAUDIBLE_VOLUME_DB: float = -80.0

const EFFECT_BUS_INDEX: int = 1
const LOW_PASS_FILTER_EFFECT_INDEX: int = 0
const REVERB_EFFECT_INDEX: int = 1
const EFFECT_VOLUME_DB := -12.0

const LOW_PASS_FILTER_INNACTIVE_CUTOFF_HZ: float = 20500.0

const INTRO_LOW_PASS_FILTER_CUTOFF_HZ: float = 500
const INTRO_REVERB_WET: float = 0.5

const RACE_LOW_PASS_FILTER_CUTOFF_HZ: float = 900.0
const RACE_REVERB_WET: float = 0.3

@export var forest_audio_player: AudioPlayer
@export var note_audio_player: AudioPlayer2D
@export var soubalien_audio_player: AudioPlayer

@export var race_audio_player: AudioPlayer
@export var soubalien_race_audio_player: AudioPlayer2D

@export var whoosh_in_audio_player: AudioPlayer
@export var whoosh_out_audio_player: AudioPlayer

var _muffle_tween: Tween

var current_low_pass_filter_cutoff_hz: float
var current_reverb_wet: float

var low_pass_filter_effect: AudioEffectLowPassFilter
var reverb_effect: AudioEffectReverb

var effect_volume_db: float:
    set(value):
        AudioServer.set_bus_volume_db(EFFECT_BUS_INDEX, value)
        effect_volume_db = value

func _ready() -> void:
    low_pass_filter_effect = AudioServer.get_bus_effect(EFFECT_BUS_INDEX, LOW_PASS_FILTER_EFFECT_INDEX) as AudioEffectLowPassFilter
    reverb_effect = AudioServer.get_bus_effect(EFFECT_BUS_INDEX, REVERB_EFFECT_INDEX) as AudioEffectReverb

    # We need sample playback to support low end devices like mobiles, so looping has to be done manually
    note_audio_player.finished.connect(func():
        note_audio_player.play()
    )

    forest_audio_player.finished.connect(func():
        forest_audio_player.play()
    )

func start() -> void:
    current_low_pass_filter_cutoff_hz = INTRO_LOW_PASS_FILTER_CUTOFF_HZ
    current_reverb_wet = INTRO_REVERB_WET

    low_pass_filter_effect.cutoff_hz = current_low_pass_filter_cutoff_hz
    reverb_effect.wet = current_reverb_wet

    forest_audio_player.fade_in()
    note_audio_player.fade_in()

func introduce_race() -> void:
    low_pass_filter_effect.cutoff_hz = LOW_PASS_FILTER_INNACTIVE_CUTOFF_HZ
    reverb_effect.wet = 0.0

    forest_audio_player.fade_out()
    note_audio_player.fade_out()
    soubalien_audio_player.fade_in()

func start_countdown() -> void:
    current_low_pass_filter_cutoff_hz = RACE_LOW_PASS_FILTER_CUTOFF_HZ
    current_reverb_wet = RACE_REVERB_WET

    low_pass_filter_effect.cutoff_hz = LOW_PASS_FILTER_INNACTIVE_CUTOFF_HZ
    reverb_effect.wet = 0.0

    soubalien_audio_player.fade_out()
    await get_tree().create_timer(RACE_MUSIC_DELAY).timeout

    race_audio_player.fade_in(0.0)
    soubalien_race_audio_player.fade_in(0.0)

func end_race() -> void:
    if _muffle_tween:
        _muffle_tween.stop()
        _muffle_tween = null

    race_audio_player.fade_out()
    soubalien_race_audio_player.fade_out()

func muffle() -> void:
    if _muffle_tween:
        _muffle_tween.stop()
        _muffle_tween = null
    _muffle_tween = create_tween()
    _muffle_tween.tween_property(low_pass_filter_effect, "cutoff_hz", current_low_pass_filter_cutoff_hz, 0.1)
    _muffle_tween.parallel().tween_property(reverb_effect, "wet", current_reverb_wet, 0.1)
    _muffle_tween.parallel().tween_property(self, "effect_volume_db", EFFECT_VOLUME_DB, 0.1)
    whoosh_in_audio_player.fade_in(0.0)

func unmuffle() -> void:
    if _muffle_tween:
        _muffle_tween.stop()
        _muffle_tween = null
    _muffle_tween = create_tween()
    _muffle_tween.tween_property(low_pass_filter_effect, "cutoff_hz", LOW_PASS_FILTER_INNACTIVE_CUTOFF_HZ, 0.5)
    _muffle_tween.parallel().tween_property(reverb_effect, "wet", 0.0, 0.5)
    _muffle_tween.parallel().tween_property(self, "effect_volume_db", 0.0, 0.1)
    whoosh_out_audio_player.fade_in(0.0)

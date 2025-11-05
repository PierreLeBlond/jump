extends CanvasLayer

class_name OptionsMenu

@export var language_button_french: Button
@export var language_button_english: Button
@export var volume_slider: HSlider

func _ready() -> void:
    language_button_french.pressed.connect(on_language_button_french_pressed)
    language_button_english.pressed.connect(on_language_button_english_pressed)
    volume_slider.value_changed.connect(on_volume_slider_value_changed)

    var locale = TranslationServer.get_locale()
    if locale == "fr":
        language_button_french.button_pressed = true
    else:
        language_button_english.button_pressed = true

func on_language_button_french_pressed() -> void:
    TranslationServer.set_locale("fr")
    print("Language button french pressed")

func on_language_button_english_pressed() -> void:
    TranslationServer.set_locale("en")
    print("Language button english pressed")

func on_volume_slider_value_changed(_value: float) -> void:
    print("Volume slider value changed: ", _value)

func focus() -> void:
    var locale = TranslationServer.get_locale()
    if locale == "fr":
        language_button_french.grab_focus()
    else:
        language_button_english.grab_focus()
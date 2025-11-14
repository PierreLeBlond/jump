extends CanvasLayer

class_name OptionsMenu

signal wants_to_quit()

@export var quit_button: Button
@export var language_button_french: Button
@export var language_button_english: Button
@export var volume_slider: HSlider

func _ready() -> void:
    quit_button.pressed.connect(on_quit_button_pressed)
    language_button_french.pressed.connect(_on_language_button_french_pressed)
    language_button_english.pressed.connect(_on_language_button_english_pressed)

    var locale = TranslationServer.get_locale()
    if locale == "fr":
        language_button_french.button_pressed = true
    else:
        language_button_english.button_pressed = true

func _on_language_button_french_pressed() -> void:
    TranslationServer.set_locale("fr")

func _on_language_button_english_pressed() -> void:
    TranslationServer.set_locale("en")

func on_quit_button_pressed() -> void:
    wants_to_quit.emit()

func focus() -> void:
    var locale = TranslationServer.get_locale()
    if locale == "fr":
        language_button_french.grab_focus()
    else:
        language_button_english.grab_focus()

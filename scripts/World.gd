extends Node

func _ready() -> void:
    RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0))

    SilentWolf.configure({
        "api_key": "HkZq1lw0uB8TJvGYdYPkNMy4ePmnjQN12j2lVJ04",
        "game_id": "pleasemindthespace",
        "log_level": 1
    })

    SilentWolf.configure_scores({
        "open_scene_on_close": "res://scenes/levels/MainMenu.tscn"
    })
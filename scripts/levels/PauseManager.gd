extends Node

class_name PauseManager

signal paused()
signal resumed()

signal wants_to_load_checkpoint()
signal wants_to_restart()
signal wants_to_quit()

var pause_menu: PauseMenu

var can_pause: bool = true

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS

    pause_menu = load("res://scenes/ui/hud/PauseMenu.tscn").instantiate()

    pause_menu.wants_to_resume.connect(close_pause_menu)
    pause_menu.wants_to_load_checkpoint.connect(load_checkpoint)
    pause_menu.wants_to_restart.connect(restart)
    pause_menu.wants_to_quit_to_main_menu.connect(quit)

    # TODO: Create a script whose only purpose is to deactivate or limit pause menu interactions when necessary

    Events.player_unlocked_keys_changed.connect(on_player_unlocked_keys_changed)

    Events.soubalien_appears.connect(disable_load_checkpoint)
    Events.race_pre_starts.connect(disable_load_checkpoint)
    Events.race_starts.connect(enable_load_checkpoint)

    Events.soubalien_captured.connect(disable_load_checkpoint)

    Events.portal_captured.connect(disable_load_checkpoint)
    Events.portal_released.connect(enable_load_checkpoint)

func _input(event: InputEvent) -> void:
    if !event.is_action_pressed("pause") || !can_pause:
        return

    if get_children().has(pause_menu):
        close_pause_menu()
    else:
        open_pause_menu()

func on_player_unlocked_keys_changed(unlocked_keys: UnlockedKeys) -> void:
    can_pause = unlocked_keys.has_unlocked_pause()

func open_pause_menu() -> void:
    paused.emit()
    get_tree().paused = true
    add_child(pause_menu)
    pause_menu.focus()

func close_pause_menu() -> void:
    remove_child(pause_menu)
    get_tree().paused = false
    resumed.emit()

func load_checkpoint() -> void:
    pause_menu.disable()
    var release = await Transition.create_right_bar_transition_out(get_tree().root)

    if get_children().has(pause_menu):
        close_pause_menu()

    wants_to_load_checkpoint.emit()
    release.call_deferred()
    pause_menu.enable()

func restart() -> void:
    pause_menu.disable()
    wants_to_restart.emit()

func quit() -> void:
    pause_menu.disable()
    var release = await Transition.create_right_bar_transition_out(get_tree().root)
    wants_to_quit.emit()
    release.call_deferred()

func disable_load_checkpoint() -> void:
    pause_menu.load_checkpoint_button.disabled = true

func enable_load_checkpoint() -> void:
    pause_menu.load_checkpoint_button.disabled = false

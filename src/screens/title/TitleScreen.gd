class_name TitleScreen
extends Node2D

export var is_pause_screen = false
var settings

onready var settings_container = $CanvasLayer/CenterContainer/ColorRect/SettingsContainer

func _ready():
    settings = get_node("/root/Settings")
    settings_container.get_node("CameraRotation").pressed = settings.camera_rotation
    settings_container.get_node("ParallaxScrolling").pressed = settings.parallax_scrolling
    settings_container.get_node("Sfx").pressed = settings.sfx
    settings_container.get_node("Music").pressed = settings.music
    settings_container.get_node("SkipTutorial").pressed = settings.skip_tutorial

    if is_pause_screen:
        $CanvasLayer/CenterContainer/ColorRect/StartGameButton.text = "Continue game"


func _unhandled_input(event):
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()


func _process(delta):
    if settings.parallax_scrolling:
        $ParallaxBackground/ParallaxBackground.motion_offset += Vector2(0.25, 0.25)
        $ParallaxBackground/ParallaxLayer.motion_offset += Vector2(1, 1)


func _on_StartGameButton_pressed():
    # Persist settings
    Settings.save_settings()

    if is_pause_screen:
        # Continue game (unpause)
        get_tree().paused = false
        queue_free()
    else:
        # Start new game
        get_tree().change_scene("res://screens/main_game/MainGame.tscn")


func _on_CameraRotation_pressed():
    settings.camera_rotation = settings_container.get_node("CameraRotation").pressed


func _on_ParallaxScrolling_pressed():
    settings.parallax_scrolling = settings_container.get_node("ParallaxScrolling").pressed


func _on_Sfx_pressed():
    settings.sfx = settings_container.get_node("Sfx").pressed


func _on_Music_pressed():
    settings.music = settings_container.get_node("Music").pressed


func _on_SkipTutorial_pressed():
    settings.skip_tutorial = settings_container.get_node("SkipTutorial").pressed

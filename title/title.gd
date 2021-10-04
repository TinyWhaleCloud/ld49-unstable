extends Node2D
class_name Title

var settings

onready var settings_container = $CanvasLayer/CenterContainer/ColorRect/SettingsContainer

func _ready():
    settings = get_node("/root/Settings")
    settings_container.get_node("CameraRotation").pressed = settings.camera_rotation
    settings_container.get_node("ParallaxScrolling").pressed = settings.parallax_scrolling
    settings_container.get_node("Sfx").pressed = settings.sfx
    settings_container.get_node("Music").pressed = settings.music
    settings_container.get_node("SkipTutorial").pressed = settings.skip_tutorial



func _process(delta):
    if settings.parallax_scrolling:
        $ParallaxBackground/ParallaxBackground.motion_offset += Vector2(0.25, 0.25)
        $ParallaxBackground/ParallaxLayer.motion_offset += Vector2(1, 1)


func _on_StartGameButton_pressed():
    get_tree().change_scene("res://main_game/main_game.tscn")


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

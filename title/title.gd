extends Node2D
class_name Title

var settings


func _ready():
    $Popup.popup_centered()
    settings = get_node("/root/Settings")
    $Popup/ColorRect/SettingsContainer/CameraRotation.pressed = settings.camera_rotation
    $Popup/ColorRect/SettingsContainer/ParallaxScrolling.pressed = settings.parallax_scrolling
    $Popup/ColorRect/SettingsContainer/Sfx.pressed = settings.sfx
    $Popup/ColorRect/SettingsContainer/Music.pressed = settings.music
    $Popup/ColorRect/SettingsContainer/SkipTutorial.pressed = settings.skip_tutorial



func _process(delta):
    if settings.parallax_scrolling:
        $ParallaxBackground/ParallaxBackground.motion_offset += Vector2(0.25, 0.25)
        $ParallaxBackground/ParallaxLayer.motion_offset += Vector2(1, 1)


func _on_StartGameButton_pressed():
    get_tree().change_scene("res://main_game/main_game.tscn")


func _on_Popup_hide():
    $Popup.popup_centered()


func _on_CameraRotation_pressed():
    settings.camera_rotation = $Popup/ColorRect/SettingsContainer/CameraRotation.pressed


func _on_ParallaxScrolling_pressed():
    settings.parallax_scrolling = $Popup/ColorRect/SettingsContainer/ParallaxScrolling.pressed


func _on_Sfx_pressed():
    settings.sfx = $Popup/ColorRect/SettingsContainer/Sfx.pressed


func _on_Music_pressed():
    settings.music = $Popup/ColorRect/SettingsContainer/Music.pressed


func _on_SkipTutorial_pressed():
    settings.skip_tutorial = $Popup/ColorRect/SettingsContainer/SkipTutorial.pressed

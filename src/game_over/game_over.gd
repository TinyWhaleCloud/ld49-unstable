extends CanvasLayer
class_name GameOver

var to_title = false

func set_stats(cause_of_death:String, passengers_transported: int, balance: float):
    $GameOverPopup/ColorRect/StatGrid/CauseOfDeathValue.text = cause_of_death
    $GameOverPopup/ColorRect/StatGrid/TransportedValue.text = str(passengers_transported)
    $GameOverPopup/ColorRect/StatGrid/BalanceValue.text = str(balance) + " (meaningless)"


func _on_TextureButton_pressed():
    get_tree().reload_current_scene()


func _on_GameOverPopup_popup_hide():
    if !to_title:
        get_tree().reload_current_scene()


func _on_TitleButton_pressed():
    to_title = true
    get_tree().change_scene("res://title/title.tscn")


func _on_GameOverPopup_about_to_show():
    if get_node("/root/Settings").sfx:
        $GameOverSound.play()

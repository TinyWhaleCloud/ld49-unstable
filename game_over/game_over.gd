extends CanvasLayer
class_name GameOver

func set_stats(cause_of_death:String, passengers_transported: int, balance: float):
    $GameOverPopup/ColorRect/StatGrid/CauseOfDeathValue.text = cause_of_death
    $GameOverPopup/ColorRect/StatGrid/TransportedValue.text = str(passengers_transported)
    $GameOverPopup/ColorRect/StatGrid/BalanceValue.text = str(balance) + " (meaningless)"


func _on_TextureButton_pressed():
    get_tree().reload_current_scene()


func _on_GameOverPopup_popup_hide():
    get_tree().reload_current_scene()

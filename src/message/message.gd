extends CanvasLayer


func _on_MessageTimer_timeout():
    $MessageWindow.hide()
    $MessageTimer.stop()

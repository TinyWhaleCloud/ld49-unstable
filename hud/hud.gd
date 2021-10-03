class_name Hud
extends CanvasLayer

signal unpaused

func _ready():
    $AsteroidWarningContainer.visible = false
    $PausedContainer.visible = false

func set_asteroid_warning_visible(visible: bool):
    $AsteroidWarningContainer.visible = visible


func _on_AsteroidSpawner_asteroid_field(visible):
    set_asteroid_warning_visible(visible)


func _process(delta):
    if Input.is_action_just_pressed("pause"):
        if $PausedContainer.visible:
            get_tree().paused = false
            $PausedContainer.visible = false
            emit_signal("unpaused")
        else:
            get_tree().paused = true
            $PausedContainer.visible = true

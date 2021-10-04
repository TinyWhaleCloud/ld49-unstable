class_name ShipEngine
extends ShipBaseModule

# Engine speed
export var thrust = 200
var animation_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
    stop_animation(true)

func reset():
    .reset()
    stop_animation(true)

func play_animation():
    if not animation_running:
        var flame = $ExhaustFlame
        flame.show()
        flame.play()
        flame.frame = randi() % flame.frames.get_frame_count(flame.animation)
        animation_running = true

func stop_animation(always = false):
    if animation_running or always:
        $ExhaustFlame.stop()
        $ExhaustFlame.hide()
        animation_running = false

extends Area2D

# Define signals
signal hit

# Define properties and internal variables
export var speed = 400
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
    hide()


# Initialize player to start a new game
func start(start_pos):
    position = start_pos
    $CollisionShape2D.disabled = false
    show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var velocity = Vector2()
    
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
    
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        # $AnimatedSprite.play()
    # else:
        # $AnimatedSprite.stop()

    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)


# Called when a body collides with the player
func _on_Player_body_entered(body):
    print("body entered: ", body.name)
    emit_signal("hit")
    
    # Destroy asteroid on hit
    if body.has_method("destroy_on_hit"):
        body.destroy_on_hit()

extends CanvasLayer


var current_step_index = 0

onready var steps = [
    TutorialStep.new('Welcome to space!', 'Your objective is to fly passengers from planet to planet.', 0, 3),
    TutorialStep.new('However, you will need to watch out!\nHitting asteroids will damage your ship.', '(your ship is not that stable, sadly)', 0, 3.5),
    TutorialStep.new('But first things first.', 'Press W to accelerate', 1, 0),
    TutorialStep.new('Nicely done!\nIt almost looks like you played a video game before!', 'Press S to decellerate', 1, 1),
    TutorialStep.new('You can also turn your ship!', 'To do so press A or D', 1, 7),
    TutorialStep.new('Alright!\nDid you know you can also strave?', 'Press Q to strave left and E to strave right', 1, 2),
    TutorialStep.new('You have access to a super advanced map.', 'Press [Space] to open it', 1, 6),
    TutorialStep.new('If you hover on a planet, you can see info about it', 'You should be extra careful when getting close to hostile planets.', 0, 5),
    TutorialStep.new('You can also click anywhere on the map\nIf you want to set a waypoint.', 'Press [Space] again to leave the map.', 1, 6),
    TutorialStep.new('If you want to get some of that mappy feeling\nbut don\'t want to pause the game', 'Use the scroll wheel to zoom', 0, 5),
    TutorialStep.new('Looks like you are ready to start you space adventure!', 'Have fun and remember that this game was made in a single weekend.', 0, 5)
   ]

func _ready():
    $NextInfoTimer.start(1)
    render_tutorial_step()

func _process(delta):
    if steps.size() > current_step_index:
        if steps[current_step_index].auto_advance == 1:
            var input_index = steps[current_step_index].auto_advance_data
            # TODO: zoom events don't get caught for some reason, so fix that before using them
            if (Input.is_action_pressed("ui_up") and input_index == 0) \
                or (Input.is_action_pressed("ui_down") and input_index == 1) \
                or (Input.is_action_pressed("ship_thrust_left") and input_index == 2) \
                or (Input.is_action_pressed("ship_thrust_right") and input_index == 3) \
                or (Input.is_action_pressed("zoom_in") and input_index == 4) \
                or (Input.is_action_pressed("zoom_out") and input_index == 5) \
                or (Input.is_action_pressed("pause") and input_index == 6) \
                or (Input.is_action_pressed("ui_left") and input_index == 7):
                advance_tutorial_step()


func render_tutorial_step():
    if steps[current_step_index].auto_advance == 0:
        $NextInfoTimer.start(steps[current_step_index].auto_advance_data)
    else:
        $NextInfoTimer.stop()
    $UpperContainer/UpperLabel.text = steps[current_step_index].upper_text
    $LowerContainer/LowerLabel.text = steps[current_step_index].lower_text

func advance_tutorial_step():
    current_step_index += 1
    if steps.size() > current_step_index:
        render_tutorial_step()
    else:
        queue_free()

func _on_NextInfoTimer_timeout():
    advance_tutorial_step()


class TutorialStep:
    var lower_text: String
    var upper_text: String
    var auto_advance: int
    var auto_advance_data: float

    func _init(upper_text,lower_text, auto_advance, auto_advance_data = 0):
        self.lower_text = lower_text
        self.upper_text = upper_text
        self.auto_advance = auto_advance
        self.auto_advance_data = auto_advance_data

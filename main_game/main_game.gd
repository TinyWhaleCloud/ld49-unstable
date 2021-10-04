extends Node2D

export (PackedScene) var Tut
var settings


# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    $Player/Spaceship.connect("zoomed_out", $Hud, "_on_spaceship_zoomed_out")
    $Player/Spaceship.connect("fuel_changed", $Hud/PlayerInfoPanel, "_on_Spaceship_fuel_changed")
    $Player.connect("capitalism_units_changed", $Hud/PlayerInfoPanel, "_on_Player_capitalism_units_changed")

    settings = get_node("/root/Settings")
    update_settings()

    if !settings.skip_tutorial:
        settings.skip_tutorial = true
        var tuti = Tut.instance()
        self.add_child(tuti)
    # Start game :)
    new_game()


func update_settings():
    $ParallaxBackground/StarOverlay.visible = settings.parallax_scrolling
    $Player/Spaceship/Camera2D.rotating = settings.camera_rotation


func open_pause_menu():
    print("Game paused!")

    # Pause the game
    get_tree().paused = true
    $Hud/PlayerInfoPanel.visible = false

    # Open pause screen
    var pause_screen = preload("res://title/title.tscn").instance()
    pause_screen.is_pause_screen = true
    add_child(pause_screen)

    # Wait until pause screen is closed
    yield(pause_screen, "tree_exited")
    print("Game unpaused!")
    $Hud/PlayerInfoPanel.visible = true
    update_settings()


# Called on input events
func _unhandled_input(event):
    if event.is_action_pressed("ui_cancel"):
        # Change to pause menu
        open_pause_menu()

    # Debug mode: Do stuff with keys
    if OS.is_debug_build():
        handle_debug_keys(event)


# Sets everything up for a new game
func new_game():
    print("new game")
    $Player.start($StartPosition.position)


# Spawns a new asteroid
func spawn_asteroid():
    $AsteroidSpawner.spawn_asteroid()


# Debug mode: Handle special keys that to stuff for debugging
func handle_debug_keys(event):
    if event is InputEventKey and event.pressed:
        # F9: Respawn player at start position
        if event.scancode == KEY_F9:
            print("[Main] Respawning player")
            $Player/Spaceship.reset_modules()
            $Player/Spaceship.reset_position($StartPosition.position)
        elif event.scancode == KEY_F12:
            show_message_alert("debug alert", "this is some debug text", 2)
        # F10: Spawn new asteroid
        elif event.scancode == KEY_F10:
            spawn_asteroid()
        elif event.scancode == KEY_F5:
            show_game_over('Debug')


func _on_BaseDestination_pause(stats, position):
    $DestinationMenu.show(stats, position)


func _on_Goosington_pause(stats, position):
    $DestinationMenu.show(stats, position)


func _on_SuspicousCube_pause(stats, position):
    $DestinationMenu.show(stats, position)


func _on_InhabitableRed_pause(stats, position):
    $DestinationMenu.show(stats, position)


func _on_ShallowSpaceSeven_pause(stats, position):
    $DestinationMenu.show(stats, position)


func _on_Player_earned_capitalism_units(amount, balance, reason):
    if settings.sfx:
        $MessageDialog/CapitalismUnitsEarnedSound.play()
    show_message_alert(reason, "You earned " + str(amount) + " Cu.\nYour new balance is: " + str(balance) + " Cu", 1)


func _on_PurchaseHandler_cannot_afford(price, balance):
    show_message_alert("Item too expensive", "The item you are attempting to purchase costs " + str(price) +  "Cu.\nYou only have" + str(balance) + " Capitalism Units.", 1)


func show_message_alert(title, text, timeout):
    $MessageDialog/MessageWindow/CenterContainer/Label.text = text
    $MessageDialog/MessageWindow.window_title = title
    $MessageDialog/MessageWindow.popup_centered()
    $MessageDialog/MessageWindow.get_close_button().connect("pressed", self, "_on_message_closed")
    $MessageDialog/MessageTimer.start(timeout)


func _on_message_closed():
    $MessageDialog/MessageWindow.hide()


func _on_PurchaseHandler_item_purchased(name, price, balance):
    show_message_alert(name + " purchased", "Purchase successful.\n" + str(price) + " Cu have been withdrawn from your account.\nYou now have " + str(balance) + " Capitalism Units.", 2)


func _on_Player_passenger_dead(passenger):
    show_message_alert("Passenger module destroyed", "Your passenger module was hit.\nThe passenger inside did not survive the impact.\nThe people of " + passenger.end + " aren't happy about this.", 2.5)

func show_game_over(reason):
    $GameOver.set_stats(reason, $Player.passengers_total, $Player.capitalism_units)
    $GameOver/GameOverPopup.popup_centered()


func _on_Player_cockpit_destroyed():
    show_game_over("Cockpit destroyed")


func _on_Player_player_crashed(on):
    show_game_over("Crashed into " + on)

extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Try again, and count your bullets!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func show_next_level(mobs, level):
	show_message("Level " + str(level) + ", " + str(mobs) + " mobs, 30 bullets.")

func update_ammo(ammo):
	$Stats/AmmoLabel.text = "Ammo: " + str(ammo)

func update_mob_counter(left, total):
	$Stats/MobCounter.text = "Mobs: " + str(left) + "/" + str(total)

func update_level_indicator(level):
	$Stats/LevelIndicator.text = "Level " + str(level)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()

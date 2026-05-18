extends Area2D
var texture_red_off = preload("res://asset/TileSet/Other/switchRed_off.png")
var texture_red_on = preload("res://asset/TileSet/Other/switchRed_on.png")
var texture_green_off = preload("res://asset/TileSet/Other/switchGreen_off.png")
var texture_green_on = preload("res://asset/TileSet/Other/switchGreen_on.png")
var is_on = false
var player_in_range = false
var interact_cooldown = 0.2
@export_enum("red", "green") var color = "red"

var text_off = "打开 (E)"
var text_on = "关闭 (E)"

signal switch_toggled(is_on: bool)

func _ready() -> void:
	if color == "red":
		$Sprite2D.texture = texture_red_off
	else:
		$Sprite2D.texture = texture_green_off
	is_on = false
	$Tips.text = text_off

func _physics_process(delta: float) -> void:
	if interact_cooldown > 0:
		interact_cooldown -= delta

	if player_in_range and Input.is_action_just_pressed("interact") and interact_cooldown <= 0:
		is_on = not is_on
		if color == "red":
			$Sprite2D.texture = texture_red_on if is_on else texture_red_off
		else:
			$Sprite2D.texture = texture_green_on if is_on else texture_green_off
		switch_toggled.emit(is_on)
		interact_cooldown = 0.2
		$Tips.text = text_on if is_on else text_off

func _on_sensor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Tips.show()
		player_in_range = true


func _on_sensor_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Tips.hide()
		player_in_range = false

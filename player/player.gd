extends KinematicBody2D

var spike = preload("spike.tscn")

export var WALK_SPEED = 200
export var max_spikes = 3
export var player_number = "1"

var velocity = Vector2()

var player_spikes
var carying_spike

func _ready():
	player_spikes = get_node("/root/level/player_spikes" + player_number)
	carying_spike = get_node("carying_spike")
	
func _physics_process(delta):
	if Input.is_action_pressed("ui_left" + player_number):
		velocity.x = -WALK_SPEED
	if Input.is_action_pressed("ui_right" + player_number):
		velocity.x = WALK_SPEED
	if Input.is_action_pressed("ui_up" + player_number):
		velocity.y = -WALK_SPEED
	if Input.is_action_pressed("ui_down" + player_number):
		velocity.y = WALK_SPEED
	if !Input.is_action_pressed("ui_down" + player_number) && !Input.is_action_pressed("ui_up"+ player_number):
		velocity.y = 0
	if !Input.is_action_pressed("ui_left"+ player_number) && !Input.is_action_pressed("ui_right"+ player_number):
		velocity.x = 0
		
	if Input.is_action_just_pressed("ui_set_spike" + player_number):
		if max_spikes > 0:
			player_spikes.add_child(build_spike())
			max_spikes = max_spikes - 1
			if max_spikes == 0:
				carying_spike.hide()
			
	move_and_slide(velocity, Vector2(0, -1))

func build_spike():
	var new_spike = spike.instance()
	new_spike.position = self.global_position + Vector2(35, 0)
	return new_spike
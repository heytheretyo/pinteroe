extends Node2D

var _strokes = []
var _click_pos : Array = []
var color : Color = Color.GREEN
var mouse_click_start_pos = null
var last_mouse_pos = Vector2()

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var new_brush = {}

	if Input.is_action_pressed("MOUSE_LEFT"):
		if mouse_click_start_pos == null:
			mouse_click_start_pos = mouse_pos

		if mouse_pos.distance_to(last_mouse_pos) >= .75:
			var center_pos = Vector2((mouse_pos.x + mouse_click_start_pos.x) / 2, (mouse_pos.y + mouse_click_start_pos.y) / 2)
			new_brush.brush_pos = mouse_pos
			new_brush.brush_shape_circle_radius = center_pos.distance_to(Vector2(last_mouse_pos.x, mouse_pos.y))

			_click_pos.append(new_brush)
			queue_redraw()

		last_mouse_pos = mouse_pos
	elif Input.is_action_just_released("MOUSE_LEFT"):
		_strokes.append(_click_pos)
		_click_pos = []
		queue_redraw()
		
func _draw():
	for i in range(1, _click_pos.size()):
		var brush_current = _click_pos[i]
		var brush_previous = _click_pos[i - 1]
		draw_line(brush_previous.brush_pos, brush_current.brush_pos, color, 2) 

	for stroke in _strokes:
		for i in range(1, stroke.size()):
			var brush_current = stroke[i]
			var brush_previous = stroke[i - 1]
			draw_line(brush_previous.brush_pos, brush_current.brush_pos, color, 2) 
			draw_circle(stroke[i].brush_pos, 1, color)
		


func _on_color_picker_button_color_changed(new_color):
	color = new_color


func _on_button_pressed():
	_strokes = []

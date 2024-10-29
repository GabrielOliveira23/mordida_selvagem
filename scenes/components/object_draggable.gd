extends Node2D
class_name Draggable

var draggable = false
var is_inside_dropable = false
var body_ref = null
var offset: Vector2
var initialPos: Vector2

func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true

			if is_inside_dropable and body_ref:
				body_ref.occupied_by = ""
				body_ref = null

		elif Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
			
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			var tween = get_tree().create_tween()

			if is_inside_dropable and body_ref and body_ref.occupied_by == "":
				tween.tween_property(self, 'position', body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
				body_ref.occupied_by = self.name
			else:
				tween.tween_property(self, 'global_position', initialPos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered():
	#print(self.name)
	if not global.is_dragging:
		draggable = true
		scale = Vector2(1.2, 1.2)

func _on_area_2d_mouse_exited():
	if not global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)

func _on_area_2d_body_entered(body: StaticBody2D):
	if body.is_in_group('dropable') and body.occupied_by == "":
		is_inside_dropable = true
		body_ref = body

func _on_area_2d_body_exited(body: StaticBody2D):
	if body.is_in_group('dropable') and body == body_ref:
		is_inside_dropable = false
		body_ref = null

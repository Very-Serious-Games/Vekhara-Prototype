extends Node

@export var animation_tree : AnimationTree
@export var player : Player

var on_floor_blend : float = 1
var on_floor_blend_target : float = 1

var tween : Tween

var current_stance_name : String = "upright"
var weapon_name : String = "no_weapon"


func _physics_process(delta):
	on_floor_blend_target = 1 if player.is_on_floor() else 0
	on_floor_blend = lerp(on_floor_blend, on_floor_blend_target, 10 * delta)
	animation_tree["parameters/on_floor_blend/blend_amount"] = on_floor_blend


func _jump(jump_state : JumpState):
	animation_tree["parameters/" + jump_state.animation_name + "/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _on_set_movement_state(_movement_state : MovementState):
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(animation_tree, get_movement_blend_name(), _movement_state.id, 0.25)
	tween.parallel().tween_property(animation_tree, "parameters/movement_anim_speed/scale", _movement_state.animation_speed, 0.7)


func get_movement_blend_name() -> String:
	var value : String
	value = "parameters/" + current_stance_name + "_movement_blend/blend_position"
	return value


func _on_set_stance(_stance : Stance):
	animation_tree["parameters/stance_transition/transition_request"] = _stance.name
	current_stance_name = _stance.name


func _on_switched_weapon(_weapon : Weapon):
	if weapon_name == _weapon.name:
		return
	
	weapon_name = _weapon.weapon_name
	animation_tree["parameters/equip_weapon/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

	for key : String in _weapon.stance_animations.keys():
		var animations : Array = _weapon.stance_animations[key]
		var blend_node : AnimationNodeBlendSpace1D = animation_tree.tree_root.get("nodes/" + key + "_movement_blend/node")
		blend_node.blend_mode = AnimationNodeBlendSpace1D.BLEND_MODE_INTERPOLATED
		
		var id : int = 0
		for animation : StringName in animations:
			blend_node.get_blend_point_node(id).animation = animation
			id += 1



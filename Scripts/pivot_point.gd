class_name PivotPoint extends Node3D

@export var trans_type :Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var ease_type :Tween.EaseType = Tween.EaseType.EASE_IN_OUT

func pivot_around_point(object: Node3D,  axis:Vector3, delta:float):
	#declare axis w syntax of:
	# x_axis = Vector3(1, 0, 0)
	
	var tween = get_tree().create_tween().set_parallel(true).set_trans(trans_type)
	
	
	print("sgp", object.global_position, "pgp", self.global_position)
	var gpivot_radius = ( object.global_position - self.global_position)
	gpivot_radius = gpivot_radius.rotated(axis, deg_to_rad(delta))
	#var gpivot_radius = pivot_point.position
	print("ppb", (gpivot_radius ))
	print("gppb", to_global(gpivot_radius ))
	
	#var pivot_transform = Transform3D(pivot_point.global_transform)
	#print("pt", pivot_transform )
	#print("t ", object.transform)
	
	
	#object.rotate(axis, deg_to_rad(delta))
	
	#object.rotation = object.rotate
	
	 #.rotated(axis, deg_to_rad(delta))
	#
	var FinPos = self.global_position + gpivot_radius
	var FinBasis = object.basis.rotated(axis, deg_to_rad(delta))
	
	const DUR = 1
	tween.tween_property(object, "global_position", FinPos, DUR )
	tween.tween_property(object, "global_basis", FinBasis, DUR )
	
	
	
	

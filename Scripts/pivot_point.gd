extends Node3D

func pivot_around_point(object: Node3D,  axis:Vector3, delta:float):
	#declare axis w syntax of:
	# x_axis = Vector3(1, 0, 0)
	
	
	print("sgp", object.global_position, "pgp", self.global_position)
	var gpivot_radius = ( object.global_position - self.global_position)
	gpivot_radius = gpivot_radius.rotated(axis, deg_to_rad(delta))
	#var gpivot_radius = pivot_point.position
	print("ppb", (gpivot_radius ))
	print("gppb", to_global(gpivot_radius ))
	
	#var pivot_transform = Transform3D(pivot_point.global_transform)
	#print("pt", pivot_transform )
	#print("t ", object.transform)
	object.global_position = self.global_position + gpivot_radius
	object.rotate(axis, deg_to_rad(delta))
	
	
	
	

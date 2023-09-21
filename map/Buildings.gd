extends Node2D
class_name Buildings

const BUILDING_COST: Dictionary = {
	"HQ": 0,
	"Pipe": 1,
	"H Pipe": 1,
	"V Pipe": 1,
	"Habitat": 5,
	"Farm": 5,
	"Air Filter": 5,
	"Mine": 2,
	"Landing Pad": 50,
}

static func query_building(building_position: Vector2, world2d: World2D) -> Building:
	var tile_center = building_position + Vector2(Map.TILE_SIZE / 2.0, Map.TILE_SIZE / 2.0)
	var params = PhysicsPointQueryParameters2D.new()
	params.collision_mask = 0x2
	params.position = tile_center
	
	var intersection = world2d.direct_space_state.intersect_point(params)
	var collider = intersection[0].get("collider") if intersection.size() > 0 else null
	
	if collider != null:
		return collider as Building
	
	return null

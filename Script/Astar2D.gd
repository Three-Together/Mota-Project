extends Node2D

var astar = AStarGrid2D.new()
var map_rect = Rect2i()
@onready var tmap = self

func _ready() -> void:
	var tilemap_size = tmap.get_used_rect().end - tmap.get_used_rect().position
	map_rect = Rect2(Vector2i.ZERO,tilemap_size)
	var tile_size = tmap.tile_set.tile_size
	
	astar.region= map_rect
	astar.cell_size = tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for i in tilemap_size.x :
		for j in tilemap_size.y :
			var coords = Vector2(i,j)
			var tile_data = tmap.get_cell_tile_data(coords)
			if tile_data and tile_data.get_custom_data('type') == 'wall' :
				astar.set_point_solid(coords)

				
func is_point_walkable(map_position : Vector2) -> bool :
	if map_rect.has_point(map_position) and not astar.is_point_solid(map_position) :
		return true
	return false
#

	

extends Node

class_name CornerCorrector

var parent: Node2D

@export var outer_left_ceiling_ray_cast: RayCast2D
@export var inner_left_ceiling_ray_cast: RayCast2D
@export var outer_right_ceiling_ray_cast: RayCast2D
@export var inner_right_ceiling_ray_cast: RayCast2D

const TILE_HALF_SIZE: int = 32
const SAFETY_MARGIN: float = 1.0 # Pixels to ensure complete collision clearance

# DISCLAIMER: This script has been mostly written by a LLM, it may be more complex than needed, but so far it seems to work well

func init(node: Node2D) -> void:
    self.parent = node

# Get the actual collision bounds for a tile at the collision point
func get_collision_bounds(ray_cast: RayCast2D) -> Rect2:
    if !ray_cast.is_colliding():
        return Rect2()
    
    var collider = ray_cast.get_collider()
    if not collider is TileMapLayer:
        return _get_default_tile_bounds(ray_cast.get_collision_point())
    
    var tile_map = collider as TileMapLayer
    var collision_point = ray_cast.get_collision_point()
    var local_point = tile_map.to_local(collision_point)
    var tile_coords = tile_map.local_to_map(local_point)
    
    # Get tile data
    var source_id = tile_map.get_cell_source_id(tile_coords)
    if source_id == -1:
        return _get_default_tile_bounds(collision_point)
    
    var atlas_coords = tile_map.get_cell_atlas_coords(tile_coords)
    var tile_set = tile_map.tile_set
    var source = tile_set.get_source(source_id)
    
    if not source is TileSetAtlasSource:
        return _get_default_tile_bounds(collision_point)
    
    var atlas_source = source as TileSetAtlasSource
    var tile_data = atlas_source.get_tile_data(atlas_coords, 0)
    
    if tile_data == null:
        return _get_default_tile_bounds(collision_point)
    
    # Get the collision polygon for physics layer 0
    var collision_polygon = tile_data.get_collision_polygon_points(0, 0)
    if collision_polygon.size() > 0:
        return _calculate_bounds_from_polygon(collision_polygon, tile_map, tile_coords)
    
    return _get_default_tile_bounds(collision_point)

# Calculate bounds from collision polygon points
func _calculate_bounds_from_polygon(polygon_points: PackedVector2Array, tile_map: TileMapLayer, tile_coords: Vector2i) -> Rect2:
    if polygon_points.size() == 0:
        return _get_default_tile_bounds(tile_map.to_global(tile_map.map_to_local(tile_coords)))
    
    var min_x = polygon_points[0].x
    var max_x = polygon_points[0].x
    var min_y = polygon_points[0].y
    var max_y = polygon_points[0].y
    
    for point in polygon_points:
        min_x = min(min_x, point.x)
        max_x = max(max_x, point.x)
        min_y = min(min_y, point.y)
        max_y = max(max_y, point.y)
    
    # Convert local tile coordinates to global coordinates
    var tile_center = tile_map.to_global(tile_map.map_to_local(tile_coords))
    var global_min = Vector2(tile_center.x + min_x, tile_center.y + min_y)
    var size = Vector2(max_x - min_x, max_y - min_y)
    
    return Rect2(global_min, size)

# Fallback to default tile bounds
func _get_default_tile_bounds(collision_point: Vector2) -> Rect2:
    var tile_size = TILE_HALF_SIZE * 2
    var tile_x = floor(collision_point.x / tile_size) * tile_size
    var tile_y = floor(collision_point.y / tile_size) * tile_size
    return Rect2(tile_x, tile_y, tile_size, tile_size)

# Calculate the precise offset needed to align with collision edge
func calculate_precise_offset(ray_cast: RayCast2D, is_left_side: bool) -> float:
    var collision_bounds = get_collision_bounds(ray_cast)
    
    if collision_bounds.size == Vector2.ZERO:
        # Fallback to original tile-grid-based behavior
        var collision_point = ray_cast.get_collision_point()
        if is_left_side:
            var x = floori(collision_point.x)
            return TILE_HALF_SIZE - (x % TILE_HALF_SIZE) + SAFETY_MARGIN
        else:
            var x = ceili(collision_point.x)
            return x % TILE_HALF_SIZE + SAFETY_MARGIN
    
    # Calculate offset based on actual collision bounds
    var ray_global_pos = ray_cast.global_position
    
    if is_left_side:
        # Move player right until ray clears the right edge
        var right_edge = collision_bounds.position.x + collision_bounds.size.x
        return right_edge - ray_global_pos.x + SAFETY_MARGIN
    else:
        # Move player left until ray clears the left edge
        var left_edge = collision_bounds.position.x
        return left_edge - ray_global_pos.x - SAFETY_MARGIN

func apply_corner_correction() -> void:
    # Left corner correction: outer ray hits but inner doesn't
    if outer_left_ceiling_ray_cast.is_colliding() && !inner_left_ceiling_ray_cast.is_colliding():
        _apply_correction(outer_left_ceiling_ray_cast, true)
    
    # Right corner correction: outer ray hits but inner doesn't
    if outer_right_ceiling_ray_cast.is_colliding() && !inner_right_ceiling_ray_cast.is_colliding():
        _apply_correction(outer_right_ceiling_ray_cast, false)

func _apply_correction(ray_cast: RayCast2D, is_left_side: bool) -> void:
    var offset = calculate_precise_offset(ray_cast, is_left_side)
    # Round to avoid sub-pixel positioning issues
    parent.position.x = round(parent.position.x + offset)

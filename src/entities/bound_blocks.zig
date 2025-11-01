const std = @import("std");
const rl = @import("../rl_import.zig").rl;
const ecs = @import("entt");

const ModelManager = @import("../model_manager.zig");

const ctypes = @import("../components/component_types.zig");

pub fn create_bounds(world: *ecs.Registry) void {
    const entity = world.create();

    world.add(entity, ctypes.RenderableBlock{ .color = rl.RED, .height = 10, .length = 1, .width = 200 });
    world.add(entity, ctypes.Transform{
        .position = .{ .x = -100, .y = 5, .z = 200 },
        .rotation = .{ .x = 0, .y = 0, .z = 0 },
        .scale = .{ .x = 0, .y = 0, .z = 0 },
    });
}

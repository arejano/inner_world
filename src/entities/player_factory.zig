const std = @import("std");
const rl = @import("../rl_import.zig").rl;
const ecs = @import("entt");

const ModelManager = @import("../model_manager.zig");

const ctypes = @import("../components/component_types.zig");

pub fn create_entity_player(world: *ecs.Registry, mm: *ModelManager) void {
    // const model = rl.LoadModel("resources/rubber_duck/RubberDuck_LOD0.obj");
    // const texture = rl.LoadTexture("resources/rubber_duck/texture/RubberDuck_AlbedoTransparency.png");
    // model.materials[0].maps[rl.MATERIAL_MAP_DIFFUSE].texture = texture;

    // const model = mm.getModel("player");

    const entity = world.create();

    if (mm.getModel("player")) |model| {
        world.add(entity, ctypes.Renderable{
            .color = rl.RED,
            .model = model.model,
            .has_model = true,
        });
    }

    world.add(entity, ctypes.Transform{
        .position = .{ .x = 0, .y = 2, .z = 0 },
        .rotation = .{ .x = 0, .y = 0, .z = 0 },
        .scale = .{ .x = 0, .y = 0, .z = 0 },
    });
    world.add(entity, ctypes.Velocity{ .x = 5, .y = 5, .z = 5 });
    world.add(entity, ctypes.Player{});
    world.add(entity, ctypes.CameraTarget{});
    world.add(entity, ctypes.KeyboardController{});
    world.add(entity, ctypes.MouseController{});
    world.add(entity, ctypes.ActionState{ .locomotion = .idle, .interaction = .none, .combat = .none });
    world.add(entity, ctypes.Direction{ .x = 0, .y = 0, .z = 0 });
    world.add(entity, ctypes.Gravity{ .x = 0, .y = 0.98, .z = 0 });
}

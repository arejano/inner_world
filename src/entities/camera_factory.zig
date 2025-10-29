const ecs = @import("entt");
const ctypes = @import("../components/component_types.zig");
const rl = @import("../rl_import.zig").rl;

const Self = @This();

pub fn create_camera(world: *ecs.Registry) void {
    const entity = world.create();
    world.add(entity, ctypes.CameraComponent{
        .camera = .{
            //
            .fovy = 45,
            .position = .{ .x = -10, .y = 4, .z = 10 },
            .target = .{ .x = 0, .y = 0, .z = 0 },
            .projection = rl.CAMERA_PERSPECTIVE,
            .up = .{ .x = 0, .y = 1, .z = 0 },
        },
        .yaw = 0.2,
        .pitch = 0.2,
        .height = 2.0,
        .distance = 15.0,
        .min_pitch = -0.4,
        .max_pitch = 4.0,
    });
    world.add(entity, ctypes.Camera);
}

const std = @import("std");
const ecs = @import("entt");
const rl = @import("../rl_import.zig").rl;
const ct = @import("../components/component_types.zig");

const vec_math = @import("../math_utils.zig");

const ISystem = @import("isystem.zig");

pub const Self = @This();

allocator: std.mem.Allocator,

const vtable = ISystem.VTable{
    .init = initImpl,
    .update = updateImpl,
    .deinit = deinitImpl,
};

pub fn create(allocator: std.mem.Allocator) !*Self {
    const self = try allocator.create(Self);
    self.* = .{
        .allocator = allocator,
    };

    return self;
}

pub fn system(self: *Self) ISystem {
    return .{
        .ctx = self,
        .vtable = &vtable,
    };
}

fn initImpl(_: *anyopaque, _: *ecs.Registry) void {}

fn updateImpl(_: *anyopaque, w: *ecs.Registry, _: f32) void {
    var view = w.view(.{ ct.Player, ct.CameraComponent }, .{});
    var view_iter = view.entityIterator();

    const target: rl.Vector3 = undefined;

    while (view_iter.next()) |entity| {
        var camera = view.get(ct.CameraComponent, entity);

        const whell = rl.GetMouseWheelMove();
        camera.distance -= whell * camera.zoom_speed;
        if (camera.distance < camera.min_zoom) {
            camera.distance = camera.min_zoom;
        }
        if (camera.distance > camera.max_zoom) {
            camera.*.distance = camera.max_zoom;
        }

        if (rl.IsMouseButtonDown(rl.MOUSE_BUTTON_RIGHT)) {
            const delta = rl.GetMouseDelta();

            camera.*.yaw -= delta.x * 0.003;
            camera.*.pitch -= delta.y * 0.003;

            if (camera.pitch < -1.2) {
                camera.pitch = -1.2;
            }
            if (camera.pitch > 1.2) {
                camera.pitch = 1.2;
            }
        }

        const offset = rl.Vector3{
            .x = @sin(camera.yaw) * @cos(camera.pitch) * camera.distance,
            .y = @sin(camera.pitch) * camera.distance,
            .z = @cos(camera.yaw) * @cos(camera.pitch) * camera.distance,
        };

        camera.*.camera.position = vec_math.vec3Add(target, offset);
        // camera.camera.target = target;
    }
}

fn deinitImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    std.debug.print("[RenderSystem] deinit\n", .{});
    self.allocator.destroy(self);
}

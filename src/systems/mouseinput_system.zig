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
    // Camera
    var camera_view = w.basicView(ct.CameraComponent);
    var camera_iter = camera_view.entityIterator();

    var camera_cp: ?*ct.CameraComponent = null;
    while (camera_iter.next()) |e| {
        camera_cp = camera_view.get(e);
    }

    // Player
    var player_view = w.view(.{ ct.CameraTarget, ct.Transform }, .{});
    var player_iter = player_view.entityIterator();

    var player_tf: ?*ct.Transform = null;
    while (player_iter.next()) |e| {
        player_tf = player_view.get(ct.Transform, e);
    }

    if (camera_cp) |camera| {
        const whell = rl.GetMouseWheelMove();
        camera.distance -= whell * camera.zoom_speed;
        if (camera.distance < camera.min_zoom) camera.distance = camera.min_zoom;
        if (camera.distance > camera.max_zoom) camera.distance = camera.max_zoom;

        if (rl.IsMouseButtonDown(rl.MOUSE_BUTTON_RIGHT)) {
            const delta = rl.GetMouseDelta();

            camera.yaw -= delta.x * 0.003;
            camera.pitch -= delta.y * 0.003;

            if (camera.pitch < -1.2) camera.pitch = -1.2;
            if (camera.pitch > 1.2) camera.pitch = 1.2;
        }

        var target = rl.Vector3Zero();
        if (player_tf) |player| {
            target = player.position;
        }

        const offset = rl.Vector3{
            .x = @sin(camera.yaw) * @cos(camera.pitch) * camera.distance,
            .y = @sin(camera.pitch) * camera.distance,
            .z = @cos(camera.yaw) * @cos(camera.pitch) * camera.distance,
        };

        camera.camera.position = vec_math.vec3Add(target, offset);
        camera.camera.target = target;
    }
}

fn deinitImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    std.debug.print("[RenderSystem] deinit\n", .{});
    self.allocator.destroy(self);
}

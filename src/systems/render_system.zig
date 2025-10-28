const rl = @import("../rl_import.zig").rl;
const ecs = @import("entt");

const ct = @import("../components/component_types.zig");

const std = @import("std");
// const GameCamera = @import("../camera3d.zig");

const ISystem = @import("isystem.zig");

pub const Self = @This();

allocator: std.mem.Allocator,
// camera: GameCamera,

const vtable = ISystem.VTable{
    .init = initImpl,
    .update = updateImpl,
    .deinit = deinitImpl,
};

pub fn create(allocator: std.mem.Allocator) !*Self {
    const self = try allocator.create(Self);
    self.* = .{
        .allocator = allocator,
        // .camera = GameCamera.init(),
    };

    return self;
}

pub fn system(self: *Self) ISystem {
    return .{
        .ctx = self,
        .vtable = &vtable,
    };
}

fn initImpl(ptr: *anyopaque, _: *ecs.Registry) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    _ = self;
}

fn updateImpl(ptr: *anyopaque, w: *ecs.Registry, delta: f32) void {
    _ = delta;
    const self: *Self = @ptrCast(@alignCast(ptr));
    _ = self;

    var view = w.view(.{ ct.Renderable, ct.Transform }, .{});

    var camera_view = w.view(.{ct.CameraComponent}, .{});
    var camera_iter = camera_view.entityIterator();

    if (camera_iter.next()) |camera| {
        std.debug.print("Isso nao deveria funcionar\n", .{});
        const camera_component = view.get(ct.CameraComponent, camera);

        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.RAYWHITE);
        rl.BeginMode3D(camera_component.camera);

        rl.DrawGrid(400, 1.0);

        var iter = view.entityIterator();
        while (iter.next()) |e| {
            const transform = view.getConst(ct.Transform, e);
            const renderable = view.getConst(ct.Renderable, e);

            rl.DrawCube(transform.position, transform.block_width, transform.block_height, transform.block_width, renderable.color);
        }

        rl.EndMode3D();
    }
}

fn deinitImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    std.debug.print("[RenderSystem] deinit\n", .{});
    self.allocator.destroy(self);
}

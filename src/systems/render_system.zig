const std = @import("std");
const rl = @import("../rl_import.zig").rl;
const ecs = @import("entt");
const ct = @import("../components/component_types.zig");

const ISystem = @import("isystem.zig");

pub const Self = @This();

allocator: std.mem.Allocator,

has_component: bool = false,
camera_component_entity: ecs.Entity = undefined,

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

fn initImpl(ptr: *anyopaque, _: *ecs.Registry) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    _ = self;
}

fn updateImpl(ptr: *anyopaque, w: *ecs.Registry, delta: f32) void {
    _ = delta;
    const self: *Self = @ptrCast(@alignCast(ptr));

    var camera_view = w.view(.{ct.CameraComponent}, .{});

    if (!self.has_component) {
        var camera_iter = camera_view.entityIterator();

        if (camera_iter.next()) |camera| {
            self.camera_component_entity = camera;
            self.has_component = true;
        }
    }

    var view = w.view(.{ ct.Renderable, ct.Transform }, .{});
    const camera_component = view.get(ct.CameraComponent, self.camera_component_entity);

    rl.BeginDrawing();
    defer rl.EndDrawing();

    rl.ClearBackground(rl.RAYWHITE);
    rl.BeginMode3D(camera_component.camera);

    rl.DrawGrid(400, 1.0);

    var iter = view.entityIterator();
    while (iter.next()) |e| {
        const transform = view.getConst(ct.Transform, e);
        const renderable = view.getConst(ct.Renderable, e);

        if (renderable.has_model) {
            std.debug.print("meshCount = {d}\n", .{renderable.mesh.meshCount});
            rl.DrawModel(renderable.mesh, transform.position, 2, rl.WHITE);
            rl.DrawSphere(transform.position, 0.2, rl.RED);
            const to_x: rl.Vector3 = .{ .x = 0, .y = 1, .z = 0 };
            const scale: rl.Vector3 = .{ .x = 1, .y = 1, .z = 1 };
            rl.DrawModelEx(renderable.mesh, transform.position, to_x, 0.0, scale, rl.WHITE);
        } else {
            rl.DrawCube(transform.position, transform.block_width, transform.block_height, transform.block_width, renderable.color);
        }
    }

    rl.EndMode3D();

    rl.DrawFPS(10, 10);
}

fn deinitImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    std.debug.print("[RenderSystem] deinit\n", .{});
    self.allocator.destroy(self);
}

const rl = @import("../rl_import.zig").rl;
const ecs = @import("entt");

const ct = @import("../components/component_types.zig");

const std = @import("std");

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

fn initImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    _ = self;
}

fn updateImpl(ptr: *anyopaque, w: *ecs.Registry, delta: f32) void {
    _ = ptr;
    // const self: *Self = @ptrCast(@alignCast(ptr));
    // // _ = delta;

    // // Apenas exemplo de iteração
    // for (self.transforms) |*t| {
    //     t.x += 1.0 * delta;
    //     t.y += 0.5 * delta;
    // }

    var view = w.view(.{ ct.Renderable, ct.Transform }, .{});

    var iter = view.entityIterator();
    while (iter.next()) |e| {
        const transform = view.getConst(ct.Transform, e);
        const renderable = view.getConst(ct.Renderable, e);

        rl.DrawCube(transform.position, transform.block_width, transform.block_height, transform.block_width, renderable.color);
    }
    std.debug.print("[MovementSystem] delta_time: {d}\n", .{delta});
}

fn deinitImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    std.debug.print("[MovementSystem] deinit\n", .{});
    self.allocator.destroy(self);
}

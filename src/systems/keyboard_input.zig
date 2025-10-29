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
    // Controllable
    var controlable_view = w.view(.{ ct.KeyboardController, ct.Transform }, .{});
    var controlable_iter = controlable_view.entityIterator();

    var controlable_transform: ?*ct.Transform = null;
    while (controlable_iter.next()) |e| {
        controlable_transform = controlable_view.get(ct.Transform, e);
    }
}

fn deinitImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    std.debug.print("[RenderSystem] deinit\n", .{});
    self.allocator.destroy(self);
}

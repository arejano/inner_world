const std = @import("std");
const ecs = @import("entt");
const ct = @import("../components/component_types.zig");

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

fn initImpl(_: *anyopaque, _: *ecs.Registry) void {
    // var actions_view = w.basicView(ct.ActionState);
    // var actions_iter = actions_view.entityIterator();

    // if (actions_iter.next()) |e| {
    // }
}

fn updateImpl(_: *anyopaque, _: *ecs.Registry, _: f32) void {

    // std.debug.print("[MovementSystem] delta_time: {d}\n", .{delta});
}

fn deinitImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    std.debug.print("[MovementSystem] deinit\n", .{});
    self.allocator.destroy(self);
}

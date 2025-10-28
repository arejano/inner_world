const std = @import("std");
const ecs = @import("entt");

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

fn initImpl(ptr: *anyopaque, _: *ecs.Registry) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    _ = self;
    std.debug.print("[MovementSystem] init\n", .{});
}

fn updateImpl(ptr: *anyopaque, _: *ecs.Registry, delta: f32) void {
    _ = ptr;

    std.debug.print("[MovementSystem] delta_time: {d}\n", .{delta});
}

fn deinitImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    std.debug.print("[MovementSystem] deinit\n", .{});
    self.allocator.destroy(self);
}

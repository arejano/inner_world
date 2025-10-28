const std = @import("std");
const ecs = @import("entt");

const ISystem = @import("isystem.zig");

const create_camera = @import("../entities/camera_factory.zig");

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

fn initImpl(_: *anyopaque, world: *ecs.Registry) void {
    std.debug.print("[CameraSystem] init\n", .{});

    create_camera.create_camera(world);
}

fn updateImpl(_: *anyopaque, _: *ecs.Registry, _: f32) void {}

fn deinitImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    std.debug.print("[CameraSystem] deinit\n", .{});
    self.allocator.destroy(self);
}

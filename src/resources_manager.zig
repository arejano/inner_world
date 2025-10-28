const std = @import("std");

const GameCamera = @import("camera3d.zig");
const SystemManager = @import("systems/system_manager.zig");

const ResourcesEnum = enum {
    Camera,
    SystemManager,
};

const Resources = union {
    Camera: GameCamera,
    SystemManager: SystemManager,
};

const Self = @This();

allocator: std.mem.Allocator,
resources: std.array_list.Managed(Resources),

pub fn init(allocator: std.mem.Allocator) !Self {
    const resources = std.array_list.Managed(Resources).init(allocator);

    return .{
        .allocator = allocator,
        .resources = resources,
    };
}

pub fn deinit(self: *Self) void {
    self.resources.deinit();
}

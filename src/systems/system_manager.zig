const std = @import("std");
const ecs = @import("entt");

const ISystem = @import("isystem.zig");

const Self = @This();

systems: std.array_list.Managed(ISystem),
lookup: std.StringHashMap(usize),
allocator: std.mem.Allocator,

pub fn init(allocator: std.mem.Allocator) Self {
    return .{
        .allocator = allocator,
        .systems = std.array_list.Managed(ISystem).init(allocator),
        .lookup = std.StringHashMap(usize).init(allocator),
    };
}

pub fn get(self: *Self, name: []const u8) ?*ISystem {
    if (self.lookup.get(name)) |idx| {
        return &self.systems.items[idx];
    }
    return null;
}

pub fn add(self: *Self, system: ISystem, name: []const u8) !void {
    const idx = self.systems.items.len;

    try self.lookup.put(name, idx);
    try self.systems.append(system);
}

pub fn updateAll(self: *Self, world: *ecs.Registry, delta: f32) void {
    for (self.systems.items) |*sys| {
        sys.update(world, delta);
    }
}

pub fn deinit(self: *Self) void {
    for (self.systems.items) |*sys| {
        sys.deinit();
    }

    self.systems.deinit();
    self.lookup.deinit();
}

pub fn start(self: *Self, world: *ecs.Registry) void {
    for (self.systems.items) |*sys| {
        sys.init(world);
    }
}

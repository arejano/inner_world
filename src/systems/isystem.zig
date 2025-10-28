const ecs = @import("entt");

pub const ISystem = @This();

ctx: *anyopaque, // ponteiro para dados concretos do sistema
vtable: *const VTable,

pub const VTable = struct {
    init: *const fn (ctx: *anyopaque, world: *ecs.Registry) void,
    update: *const fn (ctx: *anyopaque, world: *ecs.Registry, delta: f32) void,
    deinit: *const fn (ctx: *anyopaque) void,
};

pub fn init(self: *ISystem, world: *ecs.Registry) void {
    self.vtable.init(self.ctx, world);
}

pub fn update(self: *ISystem, world: *ecs.Registry, delta: f32) void {
    self.vtable.update(self.ctx, world, delta);
}

pub fn deinit(self: *ISystem) void {
    self.vtable.deinit(self.ctx);
}

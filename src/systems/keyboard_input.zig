const std = @import("std");
const ecs = @import("entt");
const rl = @import("../rl_import.zig").rl;
const ct = @import("../components/component_types.zig");

const vec_math = @import("../math_utils.zig");

const ISystem = @import("isystem.zig");

pub const Self = @This();

allocator: std.mem.Allocator,
player_entity: ecs.Entity = undefined,
last_dir: rl.Vector3 = .{ .x = 0, .y = 0, .z = 0 },
speed: f32 = 5.0,

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

// fn updateImpl(_: *anyopaque, w: *ecs.Registry, _: f32) void {
//     // Controllable
//     var controlable_view = w.view(.{ ct.KeyboardController, ct.Transform }, .{});
//     var controlable_iter = controlable_view.entityIterator();

//     var controlable_transform: ?*ct.Transform = null;
//     while (controlable_iter.next()) |e| {
//         controlable_transform = controlable_view.get(ct.Transform, e);
//     }

//     var direction:rl.Vector3 = .{.x = 0, .y =0 , .z =0 };

//     if(rl.IsKeyDown(rl.KEY_W)){direction = .{.x = 0, .y = 1, .z = 1}; }
//     if(rl.IsKeyDown(rl.KEY_A)){direction = .{.x = 0, .y = 1, .z = 1}; }
//     if(rl.IsKeyDown(rl.KEY_S)){direction = .{.x = 0, .y = 1, .z = 1}; }
//     if(rl.IsKeyDown(rl.KEY_D)){direction = .{.x = 0, .y = 1, .z = 1}; }
// }

fn updateImpl(ptr: *anyopaque, w: *ecs.Registry, delta: f32) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    var camera_view = w.basicView(ct.CameraComponent);
    var camera_iter = camera_view.entityIterator();

    var camera_cp: ?*ct.CameraComponent = null;
    if (camera_iter.next()) |e| {
        camera_cp = camera_view.get(e);
    }

    var player_view = w.view(.{ ct.Player, ct.Transform }, .{});
    var player_iter = player_view.entityIterator();

    var player_entity: ?ecs.Entity = undefined;
    var player_tf: ?*ct.Transform = null;
    if (player_iter.next()) |e| {
        player_entity = e;
        player_tf = player_view.get(ct.Transform, e);
    }

    if (player_entity) |ent| {
        self.player_entity = ent;
    } else {
        //player nao existe... nao fazer nada
        return;
    }

    const rotating = rl.IsMouseButtonDown(rl.MOUSE_BUTTON_RIGHT);

    var cam_forward_xz: rl.Vector3 = .{ .x = 0, .y = 0, .z = 1 };
    if (camera_cp) |cam| {
        const yaw = cam.yaw;
        cam_forward_xz.x = -@sin(yaw);
        cam_forward_xz.z = -@cos(yaw);
    }

    // --- ler WASD
    var desire: rl.Vector3 = .{ .x = 0, .y = 0, .z = 0 };
    var has_input: bool = false;

    if (rl.IsKeyDown(rl.KEY_W)) {
        desire = vec_math.vec3Add(desire, cam_forward_xz);
        has_input = true;
    }
    if (rl.IsKeyDown(rl.KEY_S)) {
        desire = vec_math.vec3Add(desire, vec_math.vec3Scale(cam_forward_xz, -1.0));
        has_input = true;
    }
    if (rl.IsKeyDown(rl.KEY_D)) {
        // right vector = (forward.z, 0, -forward.x)
        const right = rl.Vector3{ .x = cam_forward_xz.z, .y = 0.0, .z = -cam_forward_xz.x };
        desire = vec_math.vec3Add(desire, vec_math.vec3Scale(right, -1.0));
        has_input = true;
    }
    if (rl.IsKeyDown(rl.KEY_A)) {
        const right = rl.Vector3{ .x = cam_forward_xz.z, .y = 0.0, .z = -cam_forward_xz.x };
        desire = vec_math.vec3Add(desire, right);
        has_input = true;
    }

    if (has_input) {
        desire.y = 0.0;
        const len = @sqrt(desire.x * desire.x + desire.z * desire.z);
        if (len > 0.00001) {
            desire = vec_math.vec3Scale(desire, 1.0 / len);
        } else {
            desire = rl.Vector3{ .x = 0, .y = 0, .z = 0 };
        }
    }

    if (rotating) {
        // keep self.last_dir as-is (player keeps moving in previous dir)
    } else {
        if (has_input) {
            self.last_dir = desire;
        } else {
            // no input -> stop moving
            self.last_dir = rl.Vector3{ .x = 0, .y = 0, .z = 0 };
        }
    }

    if (player_tf) |tf| {
        const move = vec_math.vec3Scale(self.last_dir, self.speed * delta);
        tf.position = vec_math.vec3Add(tf.position, move);
    }
}

fn deinitImpl(ptr: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ptr));
    std.debug.print("[KeyboardInput:deinit]\n", .{});
    self.allocator.destroy(self);
}

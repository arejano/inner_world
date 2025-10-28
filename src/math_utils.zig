const rl = @import("rl_import.zig").rl;

pub fn vec2Add(a: rl.Vector2, b: rl.Vector2) rl.Vector2 {
    return .{ .x = a.x + b.x, .y = a.y + b.y };
}

pub fn vec2Sub(a: rl.Vector2, b: rl.Vector2) rl.Vector2 {
    return .{ .x = a.x - b.x, .y = a.y - b.y };
}

pub fn vec2Opos(a: rl.Vector2) rl.Vector2 {
    return .{ .x = -a.x, .y = -a.y };
}

pub fn vec2Scale(a: rl.Vector2, s: f32) rl.Vector2 {
    return .{
        .x = a.x * s,
        .y = a.y * s,
    };
}

pub fn vec2BDirection(a: rl.Vector2, b: rl.Vector2, speed: f32) rl.Vector2 {
    if (b.x > a.x) {
        return vec2Opos(.{ .x = speed, .y = 0 });
    }

    if (b.x < a.x) {
        return vec2Opos(.{ .x = -speed, .y = 0 });
    }

    if (b.y > a.y) {
        return vec2Opos(.{ .x = 0, .y = speed });
    }

    if (b.y < a.y) {
        return vec2Opos(.{ .x = 0, .y = -speed });
    }

    return .{ .x = 0, .y = 0 };
}

pub fn vec3Add(a: rl.Vector3, b: rl.Vector3) rl.Vector3 {
    return .{ .x = a.x + b.x, .y = a.y + b.y, .z = a.z + b.z };
}

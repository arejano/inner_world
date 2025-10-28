const std = @import("std");
const rl = @import("rl_import.zig").rl;
const vec_math = @import("math_utils.zig");

const Self = @This();

camera: rl.Camera3D,
distance: f32,
height: f32,
yaw: f32,
pitch: f32,
min_pitch: f32,
max_pitch: f32,
mouse_sensitive: f32 = 0.003,
soulder_offset: f32 = 0.6,
mode: c_int = rl.CAMERA_FREE,
zoom_speed: f32 = 0.8,
max_zoom: f32 = 40,
min_zoom: f32 = 1,

pub fn init() Self {
    return .{
        .camera = .{
            //
            .fovy = 45,
            .position = .{ .x = -10, .y = 4, .z = 10 },
            .target = .{ .x = 0, .y = 0, .z = 0 },
            .projection = rl.CAMERA_PERSPECTIVE,
            .up = .{ .x = 0, .y = 1, .z = 0 },
        },
        .yaw = 0.2,
        .pitch = 0.2,
        .height = 2.0,
        .distance = 15.0,
        .min_pitch = -0.4,
        .max_pitch = 4.0,
    };
}

pub fn update(self: *Self, target: rl.Vector3) void {
    self.wow_update(target);
}

pub fn wow_update(self: *Self, target: rl.Vector3) void {
    const whell = rl.GetMouseWheelMove();
    self.distance -= whell * self.zoom_speed;
    if (self.distance < self.min_zoom) {
        self.distance = self.min_zoom;
    }
    if (self.distance > self.max_zoom) {
        self.distance = self.max_zoom;
    }

    if (rl.IsMouseButtonDown(rl.MOUSE_BUTTON_RIGHT)) {
        const delta = rl.GetMouseDelta();

        self.yaw -= delta.x * 0.003;
        self.pitch -= delta.y * 0.003;

        if (self.pitch < -1.2) {
            self.pitch = -1.2;
        }
        if (self.pitch > 1.2) {
            self.pitch = 1.2;
        }
    }

    const offset = rl.Vector3{
        .x = @sin(self.yaw) * @cos(self.pitch) * self.distance,
        .y = @sin(self.pitch) * self.distance,
        .z = @cos(self.yaw) * @cos(self.pitch) * self.distance,
    };

    self.camera.position = vec_math.vec3Add(target, offset);
    self.camera.target = target;
}

pub fn update_camera_mode(self: *Self) void {
    if (rl.IsKeyPressed(rl.KEY_ONE)) {
        self.mode = rl.CAMERA_FREE;
        self.camera.up = .{ .x = 0, .y = 1, .z = 0 };
    }

    if (rl.IsKeyPressed(rl.KEY_TWO)) {
        self.mode = rl.CAMERA_FIRST_PERSON;
        self.camera.up = .{ .x = 0, .y = 1, .z = 0 };
    }

    if (rl.IsKeyPressed(rl.KEY_THREE)) {
        self.mode = rl.CAMERA_THIRD_PERSON;
        self.camera.up = .{ .x = 0, .y = 1, .z = 0 };
    }

    if (rl.IsKeyPressed(rl.KEY_FOUR)) {
        self.mode = rl.CAMERA_ORBITAL;
        self.camera.up = .{ .x = 0, .y = 1, .z = 0 };
    }

    if (rl.IsKeyPressed(rl.KEY_FIVE)) {
        self.mode = rl.CAMERA_ORTHOGRAPHIC;
        self.camera.up = .{ .x = 0, .y = 1, .z = 0 };
    }
}

pub fn update_camera_perspective(self: *Self) void {
    if (rl.IsKeyPressed(rl.KEY_P)) {
        if (self.camera.projection == rl.CAMERA_PERSPECTIVE) {
            self.mode = rl.CAMERA_THIRD_PERSON;
            self.camera.position = .{ .x = 0, .y = 2, .z = -100 };
            self.camera.target = .{
                .x = 0,
                .y = 2,
                .z = 0,
            };
            self.camera.up = .{
                .x = 0,
                .y = 1,
                .z = 0,
            };
            self.camera.projection = rl.CAMERA_ORTHOGRAPHIC;
            self.camera.fovy = 20;
            rl.CameraYaw(&self.camera, -135, true);
            rl.CameraPitch(&self.camera, -45, true, true, false);
        } else if (self.camera.projection == rl.CAMERA_ORTHOGRAPHIC) {
            self.mode = rl.CAMERA_THIRD_PERSON;
            self.camera.position = .{ .x = -10, .y = 4, .z = 10 };
            self.camera.target = .{ .x = 0, .y = 0, .z = 0 };
            self.camera.projection = rl.CAMERA_PERSPECTIVE;
            self.camera.up = .{ .x = 0, .y = 1, .z = 0 };
            self.camera.projection = rl.CAMERA_PERSPECTIVE;
            self.camera.fovy = 45;
        }
    }
}

// const mouse_delta = rl.GetMouseDelta();
// std.debug.print("{any}\n", .{mouse_delta});
// self.yaw -= mouse_delta.x * self.mouse_sensitive;
// self.pitch -= mouse_delta.y * self.mouse_sensitive;

// if (self.pitch < self.min_pitch) {
//     self.pitch = self.min_pitch;
// }

// if (self.pitch > self.max_pitch) {
//     self.pitch = self.max_pitch;
// }

// var dir: rl.Vector3 = .{ .x = 0, .y = 0, .z = 0 };

// if (rl.IsKeyDown(rl.KEY_W)) {
//     dir.x = 2;
// }
// if (rl.IsKeyDown(rl.KEY_A)) {}
// if (rl.IsKeyDown(rl.KEY_S)) {}
// if (rl.IsKeyDown(rl.KEY_D)) {}

// self.camera.position = vec_math.vec3Add(self.camera.position, dir);

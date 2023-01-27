module RayModule

using ..JuliaRayTracing: Vec3, Mat3, Mat4

struct Ray
    start::Vec3
    direction::Vec3
    color::Vec3
end

export Ray
end

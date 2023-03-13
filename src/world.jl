# module EnvironmentModule

# using ..JuliaRayTracing: Vec3, Mat3, Mat4
# using ..RayModule

struct World
    spheres::Vector{Sphere}
    planes::Vector{Plane}
    triangles::Vector{Triangle}
    pointLights::Vector{PointLight}
    sunLights::Vector{SunLight}
    environment::Environment
end


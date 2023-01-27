module EnvironmentModule

using ..JuliaRayTracing: Vec3, Mat3, Mat4
using ..RayModule

struct Environment
    colorZenith::Vec3
    colorHorizon::Vec3
end

function hitEnvironment(environment::Environment, ray::Ray)::Vec3
    return environment.colorZenith * ray.direction[3] +
           environment.colorHorizon * (1 - ray.direction[2])
end

export Environment

end

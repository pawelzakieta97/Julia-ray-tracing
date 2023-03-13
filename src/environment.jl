# module EnvironmentModule

# using ..JuliaRayTracing: Vec3, Mat3, Mat4
# using ..RayModule

struct Environment
    colorZenith::Vec3
    colorHorizon::Vec3
end

function hitEnvironment(environment::Environment, ray::Ray)::Vec3
    if ray.direction[3] < 0
        return Vec3(0,0,0)
    end
    return environment.colorZenith * abs(ray.direction[3]) +
           environment.colorHorizon * (1 - abs(ray.direction[3]))
end

export Environment, hitEnvironment

# end

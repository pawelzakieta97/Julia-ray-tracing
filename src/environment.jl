module EnvironmentModule

include("ray.jl")
using .RayModule
import StaticArrays
using LinearAlgebra
Vec3=StaticArrays.SVector{3,Real}
Mat3=StaticArrays.SMatrix{3,3,Real}
Mat4=StaticArrays.SMatrix{4,4,Real}
struct Environment
    colorZenith:: Vec3
    colorHorizon:: Vec3
end
function hitEnvironment(environment::Environment, ray::Ray)::Vec3
    return environment.colorZenith * ray.direction[3] + environment.colorHorizon * (1-ray.direction[2])
end
export Environment
end
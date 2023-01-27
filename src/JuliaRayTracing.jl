module JuliaRayTracing

using StaticArrays: SVector, SMatrix

const Vec3 = SVector{3,Real}
const Mat3 = SMatrix{3,3,Real}
const Mat4 = SMatrix{4,4,Real}

include("ray.jl")
using .RayModule

include("camera.jl")
using .CameraModule

include("environment.jl")
using .EnvironmentModule

include("renderer.jl")
using .RendererModule

include("transformations.jl")
using .Transformations

export Camera, Environment, Renderer, render, Vec3, Mat3, Mat4
export getRotationMatrixX, getRotationMatrixY, getRotationMatrixZ # from Transformations

end

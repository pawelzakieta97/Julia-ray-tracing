module JuliaRayTracing

using StaticArrays: SVector, SMatrix
using LinearAlgebra:dot, cross


const Vec3 = SVector{3,Real}
const Vec4 = SVector{4,Real}
const Mat3 = SMatrix{3,3,Real}
const Mat4 = SMatrix{4,4,Real}
const Mat34 = SMatrix{3,4,Real}
const Mat43 = SMatrix{4,3,Real}

include("transformations.jl")
# using .Transformations

include("ray.jl")
# using .RayModule

include("camera.jl")
# using .CameraModule

include("environment.jl")
# using .EnvironmentModule

include("object.jl")

include("light.jl")

include("world.jl")

include("renderer.jl")
# using .RendererModule


export getRotationMatrixX, getRotationMatrixY, getRotationMatrixZ, getTranslationMatrix, getRGB, randomUnitVector # from Transformations
export Ray, getDistanceFromRay
export Camera, getPixelIndices, getPixelIndex, generateRaysFor, getCameraPosition, getCameraRotation
export Environment, hitEnvironment
export Sphere, Plane, Triangle, Material, hitSphere, hitPlane, hitTriangle, makeTriangle
export PointLight, SunLight
export World
export rayColor, render
export Vec3, Mat3, Mat4
end

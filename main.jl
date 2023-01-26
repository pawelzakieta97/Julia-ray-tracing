include("ray.jl")
include("camera.jl")
include("renderer.jl")
include("environment.jl")
include("transformations.jl")

import .RayModule
using .CameraModule
import StaticArrays
using LinearAlgebra
using Images, FileIO, ImageView
using .Transformations
using .RendererModule
using .EnvironmentModule

Vec3=StaticArrays.SVector{3,Real}
Mat3=StaticArrays.SMatrix{3,3,Real}
Mat4=StaticArrays.SMatrix{4,4,Real}

pose = StaticArrays.SMatrix{4,4,Float64}(I(4))
pose = pose * getRotationMatrixX(-pi/2)
height = 100
width = 100
f = 60
camera = Camera(pose, f, width, height)
environment = Environment(Vec3([0,0.5,1]), Vec3([1,1,1]))
renderer = Renderer(camera, environment)
renderedImage = render(renderer)
img_path = "image.png"
img = load(img_path)

imshow(renderedImage)
sleep(100)
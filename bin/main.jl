
using StaticArrays
using JuliaRayTracing
using LinearAlgebra: I

pose = StaticArrays.SMatrix{4,4,Float64}(I(4))
pose = pose * getRotationMatrixX(-pi / 2)
height = 100
width = 100
f = 60
camera = Camera(pose, f, width, height)
environment = Environment(Vec3([0, 0.5, 1]), Vec3([1, 1, 1]))
renderer = Renderer(camera, environment)
renderedImage = render(renderer)

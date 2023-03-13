using StaticArrays
using JuliaRayTracing
using LinearAlgebra: I
using Images
using BenchmarkTools

pose = Mat4(I(4))
pose = pose * getRotationMatrixX(-pi / 2 * 1.1)
pose = getTranslationMatrix(Vec3(0,0,5)) * pose
material = Material([0.0,0.0,0.0], 1, [1.0,1.0,1.0])
b = Material([0.1,0.1,0.8], 0, [0.0,0.0,0.0])
r = Material([1.0,0.1,0.1], 0, [0.0,0.0,0.0])
material2 = Material([0.5,0.5,0.5], 0, [0,0,0])
height = 600
width = 600
f = 400
camera = Camera(pose, f, width, height)
environment = Environment(Vec3(0, 0.5, 1), Vec3(1, 1, 1))
sphere1 = Sphere(Vec3(-3,10,2), 2.5, r)
sphere2 = Sphere(Vec3(3,10,2), 2.5, material)
pl = PointLight(Vec3(100,100,100), Vec3(0,12,15000))
sunDirection = Vec3(1.5, 1, -1)
sl = SunLight(Vec3(0.9,0.8,0.7), sunDirection/norm(sunDirection))
plane = Plane(Vec3(0,0,1), 0.0, material2)
triangle = makeTriangle(Vec3(0, 5, 0.1), Vec3(3,8,0.1), Vec3(-3,8,0.1), b)


world = World([sphere1, sphere2],[plane], [triangle], [pl], [sl], environment)
img = render(camera, world, 5)

(color->RGB{N0f8}(min.(max.(color, 0), 1)...)).(img)


# @benchmark generateRaysFor(camera, 1)
module CameraModule
include("ray.jl")

using .RayModule
import StaticArrays
using LinearAlgebra

Vec3=StaticArrays.SVector{3, Real}
Mat3=StaticArrays.SMatrix{3, 3, Real}
Mat4=StaticArrays.SMatrix{4, 4, Real}
struct Camera
    pose::Mat4
    f::Real
    width::Integer
    height::Integer
end
function generateRaysFor(camera:: Camera, samples:: Integer)::Vector{Ray}
    rays = Vector{Ray}()
    start = getCameraPosition(camera)
    for x = -camera.width / 2 + 0.5 : camera.width/2 - 0.5
        for y = - camera.height / 2 + 0.5 : camera.height / 2 - 0.5
            direction = Vec3(x/camera.f, y/camera.f, 1)
            direction = getCameraRotation(camera) * direction
            newRay = Ray(start, direction/norm(direction), Vec3([1,1,1]))
            push!(rays, newRay)
        end
    end
    # px_x = ones(height) * transpose(range(-width/2+0.5, width/2))
    # px_y = range(-width/2+0.5, width/2)
    return rays
end
function getCameraPosition(camera::Camera)::Vec3
    return camera.pose[1:3, 4]
end
function getCameraRotation(camera::Camera)::Mat3
    return camera.pose[1:3, 1:3]
end
function getImage(camera, rays::Vector{Ray})::Matrix
    image = zeros(camera.height, camera.width)
    indices = getPixelIndex.(rays)

end
function getPixelIndex(camera::Camera, ray::Ray)
    relativeDirection = inv(camera.pose[1:3,1:3])*ray.direction
    y_idx = relativeDirection[2] / relativeDirection[3] * camera.f + camera.height/2
    x_idx = relativeDirection[1] / relativeDirection[3] * camera.f + camera.width/2
    return y_idx, x_idx
end
function getPixelIndices(camera::Camera, rays::Vector{Ray})::Tuple{Vector{Int64}}
    function getPixelIndexPartial(ray)
        return getPixelIndex(camera, ray)
    end
    return getPixelIndexPartial.(rays)

end
export Camera
end

# module CameraModule

# using ..JuliaRayTracing: Vec3, Mat3, Mat4
using LinearAlgebra: norm

# using ..RayModule

# export Camera
# export generateRaysFor
struct Camera
    pose::Mat4
    f::Real
    width::Integer
    height::Integer
end

function generateRaysFor(camera::Camera, samples::Integer)::Vector{Ray}
    rays = Vector{Ray}(undef, camera.width * camera.height)
    start = getCameraPosition(camera)
    cameraRotation = getCameraRotation(camera)
    i = 1
    for x = -camera.width/2+0.5:camera.width/2-0.5
        for y = -camera.height/2+0.5:camera.height/2-0.5
            direction = Vec3(x / camera.f, y / camera.f, 1)
            direction = cameraRotation * direction
            newRay = Ray(start, direction / norm(direction), Vec3([1, 1, 1]))
            rays[i] = newRay
            i = i + 1
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
    relativeDirection = inv(camera.pose[1:3, 1:3]) * ray.direction
    y_idx = relativeDirection[2] / relativeDirection[3] * camera.f + camera.height / 2
    x_idx = relativeDirection[1] / relativeDirection[3] * camera.f + camera.width / 2

    # ceil /floor?
    return ceil(Int, y_idx), ceil(Int, x_idx)
end
function getPixelIndices(camera::Camera, rays::Vector{Ray})::Vector{Tuple{Integer, Integer}}
    function getPixelIndexPartial(ray)
        return getPixelIndex(camera, ray)
    end
    return getPixelIndexPartial.(rays)
end


# end

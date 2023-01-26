module RendererModule

include("ray.jl")
include("camera.jl")
include("environment.jl")

using .RayModule
using .CameraModule
using .EnvironmentModule

struct Renderer
    camera::Camera
    environment::Environment
end

function render(renderer::Renderer)::Matrix{Real}
    rays = CameraModule.generateRaysFor(renderer.camera,1)
    colors = rayColor.(rays)
    indices = CameraModule.getPixelIndices(renderer.camera, rays)
    image = zeros((rendrer.camera.height, renderer.camera.width))
    for i=1:size(rays)
        image[indices[i][1], indices[i][2]] = colors[i]
    end
    return image
end
function rayColor(ray::Ray)
    return EnvironmentModule.hitEnvironment(environment, ray)
end 
export Renderer
export render
end
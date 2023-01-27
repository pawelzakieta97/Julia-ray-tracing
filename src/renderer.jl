module RendererModule


using ..JuliaRayTracing: Vec3, Mat3, Mat4
using ..RayModule
using ..CameraModule
using ..EnvironmentModule

struct Renderer
    camera::Camera
    environment::Environment
end

function render(renderer::Renderer)::Matrix{Vec3}
    rays = CameraModule.generateRaysFor(renderer.camera, 1)
    colors = rayColor.(Ref(renderer),rays)
    indices = CameraModule.getPixelIndices(renderer.camera, rays)
    image = zeros(Vec3, (renderer.camera.height, renderer.camera.width))
    for i in 1:length(rays)
        image[indices[i][1], indices[i][2]] = colors[i] #
    end
    return image
end
function rayColor(renderer::Renderer, ray::Ray)
    return EnvironmentModule.hitEnvironment(renderer.environment, ray)
end

export Renderer
export render
end

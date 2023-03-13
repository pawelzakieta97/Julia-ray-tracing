# module RayModule

# using ..JuliaRayTracing: Vec3, Mat3, Mat4

struct Ray
    start::Vec3
    direction::Vec3
    color::Vec3
end

function getDistanceFromRay(ray::Ray, point::Vec3)::Real
    r = point - ray.start
    t = (dot(ray.direction, r)) * ray.direction
    d = r - t
    return norm(d) 
end
    


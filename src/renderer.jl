# module RendererModule


# using ..JuliaRayTracing: Vec3, Mat3, Mat4
# using ..RayModule
# using ..CameraModule
# using ..EnvironmentModule


function render(camera::Camera, world::World, depth=2::Integer)::Matrix{Vec3}
    rays = generateRaysFor(camera, 1)
    colors = rayColor.(Ref(world),rays, Ref(depth))
    indices = getPixelIndices(camera, rays)
    image = zeros(Vec3, (camera.height, camera.width))
    for i in 1:length(rays)
        image[indices[i][1], indices[i][2]] = colors[i] #
    end
    return image
end
function rayColor(world::World, ray::Ray, depth::Integer)::Vec3
    # sphereDistances = hitSphere.(Ref(ray), world.spheres)
    sphereDistances = hitSpheres(ray, world.spheres)
    sphereDistances[sphereDistances .< MIN_DISTANCE] .= MAX_DISTANCE
    planesDistances = hitPlane.(Ref(ray), world.planes)
    planesDistances[planesDistances .< MIN_DISTANCE] .= MAX_DISTANCE
    triangleDistances = hitTriangle.(Ref(ray), world.triangles)
    triangleDistances[triangleDistances .< MIN_DISTANCE] .= MAX_DISTANCE

    minSphereDistance, minSphereIndex = findmin(sphereDistances)
    minPlaneDistance, minPlaneIndex = findmin(planesDistances)
    minTriangleDistance, minTriangleIndex = findmin(triangleDistances)

    minDistance = min(minSphereDistance, minPlaneDistance, minTriangleDistance)
    if minSphereDistance == minDistance && minSphereDistance < MAX_DISTANCE
        hitMaterial = world.spheres[minSphereIndex].material
        hitPoint = Vec3(ray.start + ray.direction * minSphereDistance)
        normal = getSphereNormal(world.spheres[minSphereIndex], hitPoint)
    elseif minPlaneDistance == minDistance && minPlaneDistance < MAX_DISTANCE
        hitMaterial = world.planes[minPlaneIndex].material
        hitPoint = Vec3(ray.start + ray.direction * minPlaneDistance)
        normal = world.planes[minPlaneIndex].normal
    elseif minTriangleDistance  == minDistance && minTriangleDistance < MAX_DISTANCE
        hitMaterial = world.triangles[minTriangleIndex].material
        hitPoint = Vec3(ray.start + ray.direction * minPlaneDistance)
        normal = world.triangles[minTriangleIndex].normal
    else
        return hitEnvironment(world.environment, ray)
    end
    color = Vec3(0,0,0)
    for pointLight in world.pointLights
        # checking line of sight
        if isInLineOfSight(hitPoint, pointLight.position, world)
            lightRay = getPointLightRay(pointLight, hitPoint)
            pc = getPhong(hitMaterial, lightRay, ray, normal)
            # println(pc)
            color = color + pc
        end
    end
    for sunLight in world.sunLights
        # checking line of sight
        if isInLineOfSight(hitPoint, Vec3(hitPoint - sunLight.direction * 0.9 * MAX_DISTANCE), world)
            lightRay = getSunLightRay(sunLight)
            pc = getPhong(hitMaterial, lightRay, ray, normal)
            # println(pc)
            color = color + pc
        end
    end
    if depth > 1
        scatteredRay = scatter(hitMaterial, ray, hitPoint, normal)
        return color + scatteredRay.color .* rayColor(world, scatteredRay, depth-1)
    end
    return color
end


function isInLineOfSight(p1::Vec3, p2::Vec3, world::World)::Bool
    diff = p2 - p1
    distance = norm(diff)
    dir = diff/distance
    ray = Ray(p1, dir, Vec3(0,0,0))
    for sphere in world.spheres
        ds = hitSphere(ray, sphere)
        if ds < distance
            # println(ds)
            return false
        end
    end
    for plane in world.planes
        if hitPlane(ray, plane) < distance
            return false
        end
    end
    return true
end
const MAX_DISTANCE = 999999999.0
const MIN_DISTANCE = 0.0001

struct Material
    diffuse::Vec3
    glossiness::Real
    specular::Vec3
end
function scatter(material::Material, ray::Ray, hitPoint::Vec3, normal::Vec3)::Ray
    diffuseDirection = normal + randomUnitVector();
    diffuseDirection /= norm(diffuseDirection);
    # eventually sample tint color based on hit location / UV coordinates
    reflectedDirection = ray.direction .- 2 * normal * dot(normal, ray.direction)
    scatteredDirection = material.glossiness * reflectedDirection + (1-material.glossiness) * diffuseDirection
    tint = material.diffuse * (1-material.glossiness) + material.specular * material.glossiness
    return Ray(hitPoint, scatteredDirection, tint)
end
struct Sphere
    position::Vec3
    radius::Real
    material::Material
end
struct Plane
    normal::Vec3
    height::Real
    material::Material
end
struct Triangle
    a::Vec3
    b::Vec3
    c::Vec3
    height::Real
    normal::Vec3
    normalA::Vec3
    normalB::Vec3
    normalC::Vec3
    projectionMatrix::Mat34
    material::Material
end
function makeTriangle(a::Vec3, b::Vec3, c::Vec3, material::Material)::Triangle
    normal = cross(a-b, a-c)
    normal = normal / norm(normal)
    height = dot(normal, a)
    M = Mat43([
        1 1 1
        a[1] b[1] c[1]
        a[2] b[2] c[2]
        a[3] b[3] c[3]
    ])

    return Triangle(a, b, c, height, normal, normal, normal, normal, inv(Mat3(transpose(M) * M))*transpose(M), material)
end
function hitSphere(ray::Ray, sphere::Sphere)::Real
    v = ray.start - sphere.position
    # for some reason it was faster for element-wise dot product


    # dx = v[1];
    # dy = v[2];
    # dz = v[3];
    # b = 2 * (ray.direction[1]*dx + ray.direction[2] * dy + ray.direction[3]*dz)
    b = 2 * dot(ray.direction, v)
    # delta = b*b - 4 * (dx*dx + dy*dy + dz*dz - sphere.radius*sphere.radius)
    delta = b*b - 4 * (dot(v, v) - sphere.radius*sphere.radius)
    if delta>0
        sqrtDelta = sqrt(delta)
        distance1 = (-b - sqrtDelta) / 2
        distance2 = (-b + sqrtDelta) / 2
        if (distance2<MIN_DISTANCE)
            return MAX_DISTANCE
        end
        return distance1
    end
    return MAX_DISTANCE
end
# vectorized hitSphere
function hitSpheres(ray::Ray, spheres::Vector{Sphere})::Vector{Real}
    distances = ones(size(spheres)) * MAX_DISTANCE
    radiuses = [s.radius for s in spheres]
    spherePositions = hcat([s.position for s in spheres]...)
    vs = ray.start.-spherePositions

    b = transpose(2 * transpose(ray.direction) * vs)
    deltas = b.*b .- 4 * (sum(vs.*vs, dims=1)[1,:] .- radiuses.*radiuses)
    hitSpheresIndices = deltas .> 0
    sqrtDeltas = zeros(size(spheres)) * MAX_DISTANCE
    distances1 = zeros(size(spheres)) * MAX_DISTANCE
    distances2 = zeros(size(spheres)) * MAX_DISTANCE

    sqrtDeltas[hitSpheresIndices] = sqrt.(deltas[hitSpheresIndices])
    distances1[hitSpheresIndices] = (-b[hitSpheresIndices] .- sqrtDeltas[hitSpheresIndices]) / 2
    distances2[hitSpheresIndices] = (-b[hitSpheresIndices] .+ sqrtDeltas[hitSpheresIndices]) / 2

    hitIndicesFiltered = hitSpheresIndices .&& (distances2.>MIN_DISTANCE)
    distances[hitIndicesFiltered] = distances1[hitIndicesFiltered]
    return distances
end
function hitPlane(ray::Ray, plane::Plane)::Real
    if dot(ray.direction, plane.normal) == 0
        return MAX_DISTANCE
    end
    distance = (plane.height - dot(plane.normal, ray.start))/dot(plane.normal,ray.direction);
    # print(distance)
    if distance > MIN_DISTANCE
        return distance
    end
    return MAX_DISTANCE
end
function hitTriangle(ray::Ray, triangle::Triangle)::Real
    if dot(ray.direction, triangle.normal) == 0
        return MAX_DISTANCE
    end
    distance = (triangle.height - dot(triangle.normal, ray.start))/dot(triangle.normal,ray.direction);
    hitPoint = ray.start + ray.direction * distance
    coordinates = triangle.projectionMatrix * Vec4([1, hitPoint[1], hitPoint[2], hitPoint[3]])
    if any(coordinates .< 0)
        return MAX_DISTANCE
    end
    # print(distance)
    if distance > MIN_DISTANCE
        return distance
    end
    return MAX_DISTANCE
end
function getSphereNormal(sphere::Sphere, hitPoint)::Vec3
    return (hitPoint-sphere.position)/sphere.radius
end
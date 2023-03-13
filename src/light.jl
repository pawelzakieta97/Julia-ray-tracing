struct PointLight
    color::Vec3
    position::Vec3
end
struct SunLight
    color::Vec3
    direction::Vec3
end

function getPointLightRay(pointLight::PointLight, position::Vec3) :: Ray
    diff = position - pointLight.position
    return Ray(pointLight.position, diff, pointLight.color/sum(diff.^2))
end

function getSunLightRay(sunLight::SunLight) :: Ray
    return Ray(Vec3(0,0,0), sunLight.direction, sunLight.color)
end

function getPhong(material::Material, lightRay::Ray, ray::Ray, normal::Vec3)
    phong = Vec3(0,0,0)
    diffuseCosAngle = dot(-lightRay.direction, normal)
    if diffuseCosAngle > 0
        phong += material.diffuse .* lightRay.color * diffuseCosAngle
    end

    # mirrorReflection = ray.direction + 2 * dot(normal, ray.direction) * normal
    # specularCosAngle = dot(mirrorReflection, -lightRay.direction)
    return phong
end
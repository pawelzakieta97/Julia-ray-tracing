# module Transformations

# using StaticArrays: StaticArrays
# using ..JuliaRayTracing: Vec3, Mat3, Mat4

function getRotationMatrixX(angle)::Mat4
    return Mat4([
        1 0 0 0
        0 cos(angle) -sin(angle) 0
        0 sin(angle) cos(angle) 0
        0 0 0 1
    ])
end

function getRotationMatrixY(angle)::Mat4
    return Mat4([
        cos(angle) 0 sin(angle) 0
        0 1 0 0
        -sin(angle) 0 cos(angle) 0
        0 0 0 1
    ])
end

function getRotationMatrixZ(angle)::Mat4
    return Mat4([
        cos(angle) -sin(angle) 0 0
        sin(angle) cos(angle) 0 0
        0 0 1 0
        0 0 0 1
    ])
end
function getRGB(color::Vec3)::RGB{N0f8}
    return RGB{N0f8}(min.(max.(color, 0), 1)...)
end
function getTranslationMatrix(translation::Vec3)
    return Mat4([
        1 0 0 translation[1]
        0 1 0 translation[2]
        0 0 1 translation[3]
        0 0 0 1
    ])
end
function randomUnitVector()
    z = rand() * 2 - 1
    r = sqrt(1-z*z)
    bearing = rand() * 2 * pi
    return Vec3([r*cos(bearing), r*sin(bearing), z])
end
export getRotationMatrixX, getRotationMatrixY, getRotationMatrixZ, getRGB
# end

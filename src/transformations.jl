module Transformations

using StaticArrays: StaticArrays
using ..JuliaRayTracing: Vec3, Mat3, Mat4

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

export getRotationMatrixX, getRotationMatrixY, getRotationMatrixZ
end

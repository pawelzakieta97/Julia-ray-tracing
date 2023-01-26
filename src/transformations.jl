module Transformations
import StaticArrays
using LinearAlgebra

Vec3=StaticArrays.SVector{3,Real}
Mat3=StaticArrays.SMatrix{3,3,Real}
Mat4=StaticArrays.SMatrix{4,4,Real}

function getRotationMatrixX(angle)::Mat4
    return Mat4([1 0            0           0;
                 0 cos(angle)   -sin(angle) 0;
                 0 sin(angle)   cos(angle)  0;
                 0 0            0           1;])
end

function getRotationMatrixY(angle)::Mat4
    return Mat4([cos(angle)     0 sin(angle)    0;
                 0              1 0             0;
                 -sin(angle)    0 cos(angle)    0;
                 0              0 0             1;])
end

function getRotationMatrixZ(angle)::Mat4
    return Mat4([cos(angle) -sin(angle) 0 0;
                 sin(angle) cos(angle)  0 0;
                 0          0           1 0;
                 0          0           0 1;])
end

export getRotationMatrixX
export getRotationMatrixY
export getRotationMatrixZ
end
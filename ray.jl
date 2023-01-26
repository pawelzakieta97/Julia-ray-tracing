module RayModule
using LinearAlgebra
import StaticArrays
Vec3=StaticArrays.SVector{3,Real}
Mat3=StaticArrays.SMatrix{3,3,Real}
Mat4=StaticArrays.SMatrix{4,4,Real}
struct Ray
    start:: Vec3
    direction:: Vec3
    color:: Vec3
end

export Ray
end
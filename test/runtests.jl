using JuliaRayTracing
using Test

@testset "JuliaRayTracing.jl" begin
    include("camera.jl")
    include("ray.jl")
    include("environment.jl")
end
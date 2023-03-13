@testset "camera" begin
    @testset "generate rays" begin
        using LinearAlgebra: I
        pose = Mat4(I(4))
        pose = pose * getRotationMatrixX(-pi / 2)
        height = 100
        width = 100
        f = 60
        camera = Camera(pose, f, width, height)
        rays = generateRaysFor(camera, 1)
    end
end
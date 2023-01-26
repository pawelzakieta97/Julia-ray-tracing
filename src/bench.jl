using BenchmarkTools

size = 500
A = rand(Float64, (size, size))
B = rand(Float64, (size, size))

function multiplyVec(A, B, n)
    for i=1:n
        v = A*B[:, i]
    end
end
res = @benchmark A*B
print(res)
res = @benchmark multiplyVec(A, B, size)
print(res)

    
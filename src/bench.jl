using BenchmarkTools

size = 500
A = rand(Float64, (size, size))
B = rand(Float64, (size, size))

function multiplyVec(A, B, n)
    for i = 1:n
        v = A * B[:, i]
    end
end
res = @benchmark A * B
print(res)
res = @benchmark multiplyVec(A, B, size)
print(res)

struct testStruct
    a::Int32
    b::Float64
end
function increment(n)
    a = 0
    for i=1:n
        ts = testStruct(i, 1/i)
        a += ts.b
    end
end
@benchmark increment(1000000)

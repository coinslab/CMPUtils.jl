using CMPUtils
using Test
X = [-1 -1 1;
    -1 1 1;
    1 -1 1;
    1 1 1]  
R = [1;-1;-1;1]

a = demoperceptron(1.0,50,10,X,R)
@show params(a)
@testset "CMPUtils.jl" begin
    #recodeimage(".",20)
    #recodeaudio("tmp",10)
    #recodetext(".",20)
    #unit_standardize(rand(10) .*10) 
end

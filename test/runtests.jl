
using CMPUtils
using Test
recodeaudio2(".")
@testset "CMPUtils.jl" begin
    #recodeimage(".",20)
    #recodeaudio("tmp",10)
    recodetext(".",20)
    #unit_standardize(rand(10) .*10) 
end
#recodetext(".")
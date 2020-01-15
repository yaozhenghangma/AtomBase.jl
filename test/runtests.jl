using AtomBase
using Test

@testset "Atom.jl" begin
    atom1 = Atom()
    atom2 = Atom("H", [1.0, 0.0, 0.0])
    io = IOBuffer()
    show(io, atom2)
    @test atom2() == ("H", [1.0, 0.0, 0.0])
    @test !(atom1 == atom2)
    @test String(take!(io)) == "H\t[1.0, 0.0, 0.0]"
end

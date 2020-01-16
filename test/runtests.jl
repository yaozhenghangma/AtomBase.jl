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

@testset "Atoms.jl Properties" begin
    property1 = Properties()
    property2 = Properties{Float64}("Force", 1.0)
    property3 = Properties("energy")
    energy1 = Energy()
    energy2 = Energy(1.0)
    energy3 = Energy(2)
    @test eltype(property1) == eltype(property2) == eltype(energy1) == eltype(energy2) == eltype(energy3) == Float64
    @test property2() == 1.0
    @test energy3() == 2.0
    energy1(4.0)
    @test energy1() == 4.0
    io = IOBuffer()
    show(io, property2)
    @test String(take!(io)) == "Force=1.0"
    show(io, energy3)
    @test String(take!(io)) == "energy=2.0"
end

@testset "Atoms.jl Atoms" begin
    atom = Atom("H", [1.0, 0.0, 0.0])
    property = Energy(1.0)
    atoms0 = Atoms()
    atoms1 = Atoms([atom, atom], 2, [property, property])
    atoms2 = Atoms([atom, atom, atom], [property,])
    atoms3 = Atoms([atom,])
    atoms4 = Atoms(atom, [property, ])
    atoms5 = Atoms(atom)
    atoms6 = Atoms([atom, atom], 2, property)
    atoms7 = Atoms([atom, atom], property)
    atoms8 = Atoms(atom, property)
    @test atoms2.number == 3
    addAtom!(atoms2, atom)
    @test atoms2.number == 4
    addProperty!(atoms3, property)
    @test atoms3.properties == [property,]
    @test iterate(atoms2) == (atoms2.atom[1], 2)
    @test iterate(atoms2, 2) == (atoms2.atom[2], 3)
    @test length(atoms2) == 4
    @test getindex(atoms2, 1) == atom
    @test firstindex(atoms2) == 1
    @test lastindex(atoms2) == 4
    @test getindex(atoms2, 1.0) == atom 
    @test getindex(atoms2, [1, 2]) == [atom, atom]
    io = IOBuffer()
    show(io, atoms8)
    @test String(take!(io)) == "1\nenergy=1.0 \nH\t[1.0, 0.0, 0.0]\n"
end

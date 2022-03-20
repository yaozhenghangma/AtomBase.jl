abstract type AbstractCell end

mutable struct Cell <: AbstractCell
    name::String
    lattice::Array{Float64, 2}
    atoms::Array{AbstractAtom, 1}
    numbers::Array{Int32, 1}
    symbols::Array{String, 1}

    # Constructors
    Cell() = Cell("UntitiledCell")
    Cell(name::String) = Cell(name, [1 0 0; 0 1 0; 0 0 1])
    Cell(lattice::Array{T, 2}) where T<:Real = Cell("UntitledCell", lattice)
    Cell(name::String, lattice::Array{T, 2}) where T<:Real = Cell(name, lattice, Array{AbstractAtom, 1}([]), Array{Int, 1}([]), Array{String, 1}([]))
    function Cell(name::String, lattice::Array{T, 2}, atoms::Array{AbstractAtom, 1}, numbers::Array{Int, 1}, symbols::Array{String, 1}) where T<:Real
        if size(lattice) != (3, 3)
            throw("Bravais lattice of cell " * name * " should be a 3×3 matrix.")
        elseif length(numbers) != 0 && length(atoms) != sum(numbers)
            throw("Number of atoms in cell " * name * " should match.")
        elseif length(numbers) != length(symbols)
            throw("Number of kinds of atom in cell " * name * " should match.")
        else
            new(name, Array{Float64, 2}(lattice), atoms, Array{Int32, 1}(numbers), symbols)
        end
    end
end

function (cell::AbstractCell)()
    return cell.name, cell.lattice
end

function Base.:(==)(cell1::AbstractCell, cell2::AbstractCell)
    cell1.lattice == cell2.lattice || return false
    cell1.atoms == cell1.atoms || return false
    return true
end

function Base.show(io::IO, cell::AbstractCell)
    print(io, cell.name, "\n", cell.lattice, "\n", cell.symbols, "\n", cell.numbers, "\n", cell.atoms)
end
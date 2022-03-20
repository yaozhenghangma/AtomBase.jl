abstract type AbstractAtom end

mutable struct Atom <: AbstractAtom
    symbol::String
    position::Array{Float64, 1}

    Atom() = new(" ", [0.0, 0.0, 0.0])
    function Atom(sym::String, pos::Array{T, 1}) where T<:Real
        if length(pos) != 3
            throw("Certesian coordinate of atom " * sym * " should be a 3d vector.")
        else
            new(sym, Array{Float64, 1}(pos))
        end
    end
end

function (atom::AbstractAtom)()
    return atom.symbol, atom.position
end

function Base.:(==)(atom1::AbstractAtom, atom2::AbstractAtom)
    atom1.symbol == atom2.symbol || return false
    atom1.position == atom2.position || return false
    return true
end

function Base.show(io::IO, atom::AbstractAtom)
    print(io, atom.symbol, "\t", atom.position)
end

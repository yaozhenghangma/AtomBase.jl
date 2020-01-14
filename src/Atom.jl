abstract type AbstractAtom end

mutable struct Atom <: AbstractAtom
    symbol::String
    position::Array{Float64, 1}

    Atom() = new(" ", [0.0, 0.0, 0.0])
    function Atom(sym::String, pos::Array{T, 1}) where T<:Real
        if length(pos) != 3
            throw(BoundsError(pos, length(pos)))
        else
            new(sym, Array{Float64, 1}(pos))
        end
    end
end

function (atom::Atom)()
    return atom.symbol, atom.position
end

function Base.:(==)(atom1::AbstractAtom, atom2::AbstractAtom)
    atom1.symbol == atom2.symbol || return false
    atom1.position == atom2.position || return false
    return true
end
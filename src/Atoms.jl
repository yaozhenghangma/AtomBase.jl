abstract type AbstractProperties end

mutable struct Properties{T<:Any}<: AbstractProperties 
    name::String 
    value::T

    Properties() = new{Float64}(" ", 0.0)
    Properties(name::String) = new{Float64}(name, 0.0)
    function Properties{U}(name::String, val::U) where U<:Any
        new{U}(name, val)
    end
end

mutable struct Energy <: AbstractProperties
    name::String
    value::Float64

    Energy() = new("energy", 0.0)
    Energy(val::Float64) = new("energy", val)
    Energy(val::Real) = Energy(Float64(val))
end

function Base.eltype(prop::AbstractProperties)
    return typeof(prop.value)
end

function (prop::AbstractProperties)()
    return prop.value 
end

function (prop::AbstractProperties)(val)
    if typeof(val) != eltype(prop)
        throw(ArgumentError("Wrong type for functor."))
    else
        prop.value = val 
    end
end

function Base.show(io::IO, prop::AbstractProperties)
    print(io, prop.name, "=", prop.value)
end

mutable struct Atoms
    atom::Array{AbstractAtom, 1}
    number::Int64
    properties::Array{AbstractProperties, 1}

    Atoms() = new(Array{Atom, 1}(undef, 0), 0, Array{Properties, 1}(undef, 0))
    function Atoms(atom::Array{T1, 1}, num::Int64, prop::Array{T2, 1}) where T1<:AbstractAtom where T2<:AbstractProperties
        if num == length(atom)
            new(atom, num, prop)
        else
            throw(BoundsError(atom, num))
        end
    end

    function Atoms(atom::Array{T1, 1}, prop::Array{T2, 1}) where T1<:AbstractAtom where T2<:AbstractProperties
        Atoms(atom, length(atom), prop)
    end

    function Atoms(atom::Array{T, 1}) where T<:AbstractAtom
        Atoms(atom, length(atom), Array{Properties, 1}(undef, 0))
    end

    function Atoms(atom::T1, prop::Array{T2, 1}) where T1<:AbstractAtom where T2<:AbstractProperties
        Atoms([atom, ], 1, prop)
    end

    function Atoms(atom::AbstractAtom)
        Atoms([atom, ], 1, Array{Properties, 1}(undef, 0))
    end

    function Atoms(atom::Array{T, 1}, num::Int64, prop::AbstractProperties) where T<:AbstractAtom
        if num == length(atom)
            new(atom, num, [prop, ])
        else
            throw(BoundsError(atom, num))
        end
    end

    function Atoms(atom::Array{T, 1}, prop::AbstractProperties) where T<:AbstractAtom
        Atoms(atom, length(atom), [prop, ])
    end

    function Atoms(atom::AbstractAtom, prop::AbstractProperties)
        Atoms([atom, ], 1, [prop, ])
    end
end

# add new atom
function addAtom!(atoms::Atoms, atom::AbstractAtom)
    push!(atoms.atom, atom)
    atoms.number += 1
end

# add new property
function addProperty!(atoms::Atoms, prop::AbstractProperties)
    push!(atoms.properties, prop)
end

function Base.iterate(atoms::Atoms, state=1) 
    state > atoms.number ? nothing : (atoms.atom[state], state+1)
end

function Base.length(atoms::Atoms)
    atoms.number
end

function Base.getindex(atoms::Atoms, i::Int)
    1 <= i <= atoms.number || throw(BoundsError(atoms, i))
    return atoms.atom[i]
end

Base.firstindex(atoms::Atoms) = 1
Base.lastindex(atoms::Atoms) = length(atoms)
Base.getindex(atoms::Atoms, i::Number) = atoms[convert(Int, i)]
Base.getindex(atoms::Atoms, I) = [atoms[i] for i in I]

function Base.show(io::IO, atoms::Atoms)
    println(io, atoms.number)
    for prop in atoms.properties
        print(io, prop, " ")
    end
    print(io, "\n")
    for atom in atoms
        println(io, atom)
    end
end

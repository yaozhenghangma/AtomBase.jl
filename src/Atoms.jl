abstract type AbstractProperties end

mutable struct Properties{T<:Any}<: AbstractProperties 
    name::String 
    value::T

    Properties() = new{Float64}(" ", 0.0)
    function Properties{U}(name::String, val::U) where U<:Any
        new{U}(name, val)
    end
end

mutable struct Energy <: AbstractProperties
    name::String
    value::Float64

    Energy() = new("Energy", 0.0)
    Energy(val::Float64) = new("Energy", val)
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
    print(prop.name, "=", prop.value)
end

mutable struct Atoms
    atom::Array{AbstractAtom, 1}
    number::Int64
    Properties::Array{AbstractProperties, 1}

    Atoms() = new(Array{Atom, 1}(undef, 0), 0, Array{Properties, 1}(undef, 0))
    function Atoms(atom::Array{Atom, 1}, num::Int64, prop::Array{Properties, 1})
        if num == length(atom)
            new(atom, num, prop)
        else
            throw(BoundsError(atom, num))
        end
    end

    function Atoms(atom::Array{Atom, 1}, prop::Array{Properties, 1})
        Atoms(atom, length(atom), prop)
    end

    function Atoms(atom::Array{Atom, 1})
        Atoms(atom, length(atom), Array{Properties, 1}(undef, 0))
    end

    function Atoms(atom::Atom, prop::Array{Properties, 1})
        Atoms([atom, ], 1, prop)
    end

    function Atoms(atom::Atom)
        Atoms([atom, ], 1, Array{Float64, 1}(undef, 0))
    end

    function Atoms(atom::Array{Atom, 1}, num::Int64, prop::Properties)
        if num == length(Array)
            new(atom, num, [prop, ])
        else
            throw(BoundsError(atom, num))
        end
    end

    function Atoms(atom::Array{Atom, 1}, prop::Properties)
        Atoms(atom, length(atom), [prop, ])
    end

    function Atoms(atom::Atom, prop::Properties)
        Atoms([atom, ], 1, [prop, ])
    end
end
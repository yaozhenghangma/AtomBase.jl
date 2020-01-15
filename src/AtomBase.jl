module AtomBase

include("Atom.jl")
include("Atoms.jl")

export AbstractAtom, Atom, AbstractProperties, Properties, Energy, Atoms
export addAtom!, addProperty!

end
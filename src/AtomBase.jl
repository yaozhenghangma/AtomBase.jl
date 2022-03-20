module AtomBase

include("Atom.jl")
include("Atoms.jl")
include("Cell.jl")

export AbstractAtom, Atom, AbstractProperties, Properties, Energy, Atoms
export AbstractCell, Cell
export addAtom!, addProperty!

end
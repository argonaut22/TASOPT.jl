"""
`structures` is a module that contains all the structural modules
required to size an aircraft
"""

module structures

using ..atmosphere

using Roots
using NLsolve

export surfw, surfdx, fusew, tailpo, tanksize, update_fuse!

include("../misc/index.inc")
include("../misc/constants.jl")
#include fuselage sizing
include("fuseW.jl")

#include sizing of surfaces
include("surfdx.jl")
include("surfw.jl")
include("tailpo.jl")

#Hydrogen tank related code
include("tankWmech.jl")
include("tankWthermal.jl")
include("tanksize.jl")
include("update_fuse.jl")

end

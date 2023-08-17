"""
TASOPT
"""

# Add basic pacakges required by TASOPT
using Base: SignedMultiplicativeInverse
using NLopt: G_MLSL_LDS, GN_MLSL_LDS, GN_CRS2_LM, GN_DIRECT_L

using BenchmarkTools
using Printf

using StaticArrays
using Profile, UnicodePlots
using PyPlot
using Dates

using ForwardDiff
const __TASOPTroot__ = @__DIR__
# Constants and array indices
include(joinpath(__TASOPTroot__, "src/misc/constants.jl"))
include(joinpath(__TASOPTroot__, "src/misc/index.inc"))


#Load modules
include(joinpath(__TASOPTroot__,"src/atmos/atmos.jl"))
include(joinpath(__TASOPTroot__,"src/sizing/wsize.jl"))
include(joinpath(__TASOPTroot__,"src/mission/mission.jl"))
include(joinpath(__TASOPTroot__,"src/mission/takeoff.jl"))
include(joinpath(__TASOPTroot__,"src/aero/aero.jl"))
include(joinpath(__TASOPTroot__,"src/structures/structures.jl"))
include(joinpath(__TASOPTroot__,"src/propsys/propsys.jl"))
include(joinpath(__TASOPTroot__,"src/balance/balance.jl"))
include(joinpath(__TASOPTroot__,"src/engine/engine.jl"))

# Off-design performance via BADA file like output
#  and LTO output for EDB points for use in AEIC
include(joinpath(__TASOPTroot__,"src/mission/odperformance.jl"))
include(joinpath(__TASOPTroot__,"src/mission/woper.jl"))
include(joinpath(__TASOPTroot__,"src/mission/LTO.jl"))
include(joinpath(__TASOPTroot__,"src/mission/AircraftDeck.jl"))

include(joinpath(__TASOPTroot__,"src/fuel/hydrogen.jl"))
include(joinpath(__TASOPTroot__,"src/engine/PT.inc"))

# Input and output functions
include(joinpath(__TASOPTroot__,"src/IO/outputs.jl"))
include(joinpath(__TASOPTroot__,"src/IO/savemodel.jl"))

include(joinpath(__TASOPTroot__,"src/cost/cost_est.jl"))
include(joinpath(__TASOPTroot__,"src/cost/cost_val.jl"))
include(joinpath(__TASOPTroot__,"src/utils/printBADA.jl"))

using .atmosphere
using .aerodynamics
using .structures
using .propsys
using .engine

#------------------------------------------------------
#End imports/loading files
#------------------------------------------------------

# Derived constants
TSL, pSL, ρSL, aSL, μSL = atmos(0.0)
RSL = pSL / (ρSL * TSL)
ρAir = ρSL

# ----------------------
# Sizing function
# ----------------------
time_writing = 0.0
time_run_NPSS = 0.0

initwgt = 0
saveOD = false
track_fig = nothing
opt_iter_counter = 0

function size_aircraft(iter, initwgt, Ldebug, printiter, saveOD)
    global time_writing = 0.0
    global time_run_NPSS = 0.0
    parpt[ipt_time_NPSS] = 0.0
    parpt[ipt_calls_NPSS] = 0
    global opt_iter_counter += 1

    Ldebug && println("Max weight iterations = $iter")
    wsize(pari, parg, parm, view(para, :, :, 1), view(pare, :, :, 1),
        iter, 0.5, 0.9, 0.5, initwgt, 1, 1, Ldebug, printiter, saveOD)

    # global track_fig = stickfig(parg, pari,  parm; ax = track_fig)
    if (opt_iter_counter % 5 == 0) || (opt_iter_counter == 1)
        global track_fig = plot_details(parg, pari, para, parm; ax=track_fig)
    end
end

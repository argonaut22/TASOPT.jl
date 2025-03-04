# Design and evaluation

## [Sizing the aircraft] (@id sizing)

The aircraft is sized via a fixed point iteration for the design mission (`wsize`). The performance of the design can be evaluated for an off-design mission (`fly_off_design!`).

`wsize` is typically the driving script in an analysis, as is the case in the `size_aircraft!` call (as demonstrated in the [first example] (@ref firstexample)). The sizing analysis calls the various performance routines (e.g., `fusebl`, `get_wing_weights`, `cdsum`, `mission`, etc.) as shown in the [TASOPT flowchart](@ref flowchart).

```@docs
TASOPT.wsize(ac)

TASOPT.fly_off_design!(ac, itermax)
```
---

## [Mission evaluation] (@id missionexec)
A sized aircraft's mission performance can be obtained (`mission!`), along with operation constraints via a pitch trim calculation (`balance`) and balanced field length calculation (`takeoff!`).

```@docs
TASOPT.mission!(pari, parg, parm, para, pare, fuse, wing, htail, vtail, Ldebug)

TASOPT.takeoff!(ac; printTO)

TASOPT.balance(pari, parg, para, fuse, wing, htail, vtail, rfuel, rpay, ξpay, itrim)

```


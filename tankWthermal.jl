"""
tankWthermal calculates boil-off rate of LH2

Inputs:

NOTE: Everything is in SI units. MLI: Multi-layer insulation
-Thermal conductivity array k (W/(m*K)) comprising of k value for each MLI layer
-hconvgas (W/m2*K)  is convective coefficient of insulating purged gas (e.g. N2)
-hconvair (W/m2*K) is convective coefficient of ambient air
-Thickness array t_cond (m) corresponds to thickness value of each layer in MLI
-h_LH2 ((W/m2*K) corresponds to LH2 convective coefficient
-Tfuel (K) is fuel temperature
-Tair (K) is ambient temperature
-r_tank (m) is tank outer radius
-h_e (J/kg) is heat of vaporization of liquid hydrogen (from Hydrogen tank design paper)
-lshell is the length of tank (m)
-Time of flight in given segment under analysis time_flight (s)


Outputs:
- m_boiloff (kg) is the boiloff LH2 mass
- mdot_boiloff (kg/s) is the boiloff rate of LH2
"""
function tankWthermal(lshell, hconvgas, h_LH2, Tfuel, Tair, r_tank,
                      h_e, t_cond, k, hconvair, time_flight)

      N = length(t_cond) #Number of layers in MLI
      thickness = sum(t_cond) #total thickness of MLI

#--- Heat flux and resistances

      deltaT = Tair - Tfuel  #Overall temperature drop between ambient and LH2
      Rair_conv = 1 / (hconvair * 2 * pi * r_tank * lshell)  #thermal resistance of ambient air
      r_inner = r_tank - thickness  #inner radius of tank
      #Not needed for MLI. May add later for purged He etc. Rgas = 1 / (hconvgas * 2 * pi * r_inner * lshell)  #thermal resistance of purged gas
      R_LH2 = 1 / (h_LH2 * 2 * pi * r_inner * lshell)  #thermal resistance of LH2

      R_mli = zeros(N)  #size of MLI resistance array (Based on number of layers)
      for n in 1:N
            R_mli[n] = log((r_inner  + t_cond[n])/ (r_inner)) / (2 * pi * lshell * k[n]) #Resistance of each MLI layer
            r_inner = r_inner + t_cond[n]  #Inner layer w.r.t the nth MLI layer being evaluated
      end

      R_mli = sum(R_mli)  #Total thermal resistance of MLI

      #In case we add radiative resistance at some point
      #Rair_rad =  1 / (hradair * 2 * pi * r_tank * lshell)
      #Rair = (Rair_conv * Rair_rad) / (Rair_conv + Rair_rad)
      Req = R_mli + Rair_conv + R_LH2  #Total equivalent resistance of thermal circuit

      q = deltaT / Req  #Heat flux from ambient to LH2
      mdot_boiloff = q / h_e  #Boil-off rate equals the heat flux divided by heat of vaporization
      m_boiloff = mdot_boiloff * time_flight #Boil-off mass calculation

return  m_boiloff, mdot_boiloff
end

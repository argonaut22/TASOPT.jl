# Define a function to check if each value in two structs is equal
function check_struct_equivalence(s1, s2)
    fields_s1 = fieldnames(typeof(s1))
    fields_s2 = fieldnames(typeof(s2))
    
    # Check if both structs have the same fields
    if fields_s1 != fields_s2
        return false
    end
    
    # Check if each field has the same value in both structs
    for field in fields_s1
        val1 = getproperty(s1, field)
        val2 = getproperty(s2, field)
        if typeof(val1) == typeof(val2)
            if typeof(val1) != Float64
                if !check_struct_equivalence(val1, val2)
                    return false
                end
            else
                @test val1 ≈ val2 
            end
        else
            return false
        end
    end
    
    return true
end

@testset "Default sizing" verbose=true begin
    ac = load_default_model()
    
    include(joinpath(TASOPT.__TASOPTroot__, "./misc/index.inc"))

    @test ac.fuselage.layout.radius == 1.9558
    
    include(joinpath(TASOPT.__TASOPTroot__, "../test/default_sized.jl"))
    # Fuselage
    include(joinpath(TASOPT.__TASOPTroot__, "../test/default_fuselage.jl"))

    size_aircraft!(ac; printiter=false);

    @testset "Fuselage" begin
        @test  check_struct_equivalence(ac_test.fuselage, ac.fuselage)
    end

    @testset "Geometry" begin
        for i in eachindex(parg)
            @test parg[i] ≈ ac.parg[i] 
        end
    end

    @testset "Aero" begin
        for i in eachindex(para)
            @test para[i] ≈ ac.para[i] 
        end
    end

    @testset "Propulsion" begin
        for i in eachindex(pare)
            @test pare[i] ≈ ac.pare[i] rtol=1e-6
        end
    end
    
    @test ac.parm[imPFEI] ≈  0.9186795447828657
end

@testset "Wide sizing" verbose=true begin
    ac = read_aircraft_model(joinpath(TASOPT.__TASOPTroot__, "../example/example_widebody.toml"))
    
    include(joinpath(TASOPT.__TASOPTroot__, "./misc/index.inc"))

    @test ac.fuselage.layout.radius ≈ 3.0988
    
    include(joinpath(TASOPT.__TASOPTroot__, "../test/wide_sized.jl"))

    size_aircraft!(ac; printiter=false);

    @testset "Fuselage" begin
        @test  check_struct_equivalence(fuse, ac.fuselage)
    end

    @testset "Geometry" begin
        for i in eachindex(parg)
            @test parg[i] ≈ ac.parg[i]
        end
    end

    @testset "Aero" begin
        for i in eachindex(para)
            @test para[i] ≈ ac.para[i] 
        end
    end

    @testset "Propulsion" begin
        for i in eachindex(pare)
            @test pare[i] ≈ ac.pare[i] rtol=1e-6
        end
    end
    
    @test ac.parm[imPFEI] ≈ 1.1500431956693837

end

@testset "Regional sizing" verbose=true begin
    ac = read_aircraft_model(joinpath(TASOPT.__TASOPTroot__, "../example/example_regional.toml"))
    
    include(joinpath(TASOPT.__TASOPTroot__, "./misc/index.inc"))

    @test ac.fuselage.layout.radius ≈ 1.5113
    
    include(joinpath(TASOPT.__TASOPTroot__, "../test/regional_sized.jl"))

    size_aircraft!(ac; printiter=false);

    @testset "Fuselage" begin
        @test  check_struct_equivalence(fuse, ac.fuselage)
    end
    
    @testset "Geometry" begin
        for i in eachindex(parg)
            @test parg[i] ≈ ac.parg[i]
        end
    end

    @testset "Aero" begin
        for i in eachindex(para)
            @test para[i] ≈ ac.para[i]
        end
    end

    @testset "Propulsion" begin
        for i in eachindex(pare)
            @test pare[i] ≈ ac.pare[i] rtol=1e-6
        end
    end
    
    @test ac.parm[imPFEI] ≈ 0.8131853553294737

end

@testset "Hydrogen sizing" verbose=true begin
    ac = read_aircraft_model(joinpath(TASOPT.__TASOPTroot__, "../example/cryo_input.toml"))
    
    include(joinpath(TASOPT.__TASOPTroot__, "./misc/index.inc"))

    @test ac.fuselage.layout.radius ≈ 2.54
    
    include(joinpath(TASOPT.__TASOPTroot__, "../test/hydrogen_sized.jl"))

    size_aircraft!(ac, iter=50; printiter=false);

    @testset "Fuselage" begin
        @test  check_struct_equivalence(fuse, ac.fuselage)
    end

    @testset "Geometry" begin
        for i in eachindex(parg)
            @test parg[i] ≈ ac.parg[i]
        end
    end

    @testset "Aero" begin
        for i in eachindex(para)
            @test para[i] ≈ ac.para[i]
        end
    end

    @testset "Propulsion" begin
        for i in eachindex(pare)
            @test pare[i] ≈ ac.pare[i] rtol=1e-6
        end
    end
    
    @test ac.parm[imPFEI] ≈ 0.9805703474546061

end
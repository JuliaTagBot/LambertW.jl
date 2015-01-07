@test_throws DomainError lambertw(-2.0,0)
@test_throws DomainError lambertw(-2.0,-1)
@test_throws ErrorException lambertw(-2.0,1)
@test lambertw(0,-1) == lambertw(0.0,-1) == -Inf
@test lambertw(-1/e,0) == lambertw(-1/e,-1) == -1
@test_throws DomainError lambertw(NaN) 

@test lambertw(complex(Inf,1),0) == complex(Inf,1)
@test lambertw(complex(Inf,0),1) == complex(Inf,2pi)
@test lambertw(complex(-Inf,0),1) == complex(Inf,3pi)
@test lambertw(1.0) == lambertw(1.0,0)
@test lambertw(complex(0.0,0.0),-1) == complex(-Inf,0.0)

@test typeof(lambertw(0)) <: FloatingPoint
@test lambertw(0) == 0

@test typeof(lambertw(1)) <: FloatingPoint
@test lambertw(1) == float(ω)
@test lambertw(BigInt(1)) == big(ω)
@test typeof(lambertw(BigInt(0))) == BigFloat
@test typeof(lambertw(BigInt(3))) == BigFloat

for tvals in [ (0,0,0), (complex(0,0),0,0),
              (0.0 + 0 * im ,0,0), (1.0 + 0 * im,0,0.567143290409783873) ]
    (z,k,res) = tvals
    @test_approx_eq  lambertw(z,k) res
end

for tvals in [ (0,0), (complex(0,0),0), (0.0,0), (complex(0.0,0),0) ]
    (z,res) = tvals
    @test_approx_eq  lambertw(z) res
end

for z in [ BigFloat(1),  BigFloat(2), complex(BigFloat(1), BigFloat(1))]
    w = lambertw(z)
    @test abs(z - w * exp(w)) < BigFloat(1)^(-70)
end

# test the expansion about branch point for k=-1,
# by comparing to exact BigFloat calculation.
@test lambertwbp(1e-20,-1) - 1 - lambertw(-BigFloat(1)/big(e)+ BigFloat(1)/BigFloat(10)^BigFloat(20),-1) < 1e-16

# Fails unless we offset the starting point slightly before root finding.
@test abs(lambertw(-1.0/e  + 0im,-1)) == 1

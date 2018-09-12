__precompile__(true)

module TransferEntropy

using Reexport
@reexport using PerronFrobenius
@reexport using StateSpaceReconstruction
using Distributions
using GroupSlices
using Distances
using SpecialFunctions
using NearestNeighbors
import Simplices.childpoint

"""
    TEVars(target_future::Vector{Int}
        target_presentpast::Vector{Int}
        source_presentpast::Vector{Int}
        conditioned_presentpast::Vector{Int})

Which axes of the state space correspond to the future of the target,
the present/past of the target, the present/past of the source, and
the present/past of any conditioned variables? Indices correspond to variables
of the embedding or colums of a `Dataset`.

This information is used by the transfer entropy estimators to ensure
the marginal distributions are computed correctly.
"""
struct TEVars
    target_future::Vector{Int}
    target_presentpast::Vector{Int}
    source_presentpast::Vector{Int}
    conditioned_presentpast::Vector{Int}
end

"""
    TEVars(target_future::Vector{Int},
            target_presentpast::Vector{Int},
            source_presentpast::Vector{Int})

Which axes of the state space correspond to the future of the target,
the present/past of the target, and the present/past of the source?
Indices correspond to variables of the embedding or colums of a `Dataset`.

This information is used by the transfer entropy estimators to ensure
the marginal distributions are computed correctly.

This three-argument constructor assumes there will be no conditional variables.
"""
TEVars(target_future::Vector{Int},
    target_presentpast::Vector{Int},
    source_presentpast::Vector{Int}) =
TEVars(target_future, target_presentpast, source_presentpast, Int[])

"""
    TEVars(;target_future = Int[],
            target_presentpast = Int[],
            source_presentpast = Int[],
            conditioned_presentpast = Int[])

Which axes of the state space correspond to the future of the target,
the present/past of the target, the present/past of the source, and
the present/past of any conditioned variables? Indices correspond to variables
of the embedding or colums of a `Dataset`.

This information is used by the transfer entropy estimators to ensure
the marginal distributions are computed correctly.
"""
TEVars(;target_future::Vector{Int} = Int[],
	    target_presentpast::Vector{Int} = Int[],
	    source_presentpast::Vector{Int} = Int[],
		conditioned_presentpast::Vector{Int} = Int[]) =
	TEVars(target_future, target_presentpast, source_presentpast,
        conditioned_presentpast)

"""
    TEVars(;target_future = Int[],
            target_presentpast = Int[],
            source_presentpast = Int[])

Which axes of the state space correspond to the future of the target,
the present/past of the target, and the present/past of the source?
Indices correspond to variables of the embedding or colums of a `Dataset`.

This information is used by the transfer entropy estimators to ensure
the marginal distributions are computed correctly.

This three-argument constructor assumes there will be no conditional variables.
"""
TEVars(;target_future::Vector{Int} = Int[],
    	target_presentpast::Vector{Int} = Int[],
    	source_presentpast::Vector{Int} = Int[]) =
	TEVars(target_future, target_presentpast, source_presentpast, Int[])

include("area_under_curve.jl")
include("entropy.jl")
include("estimators/transferentropy_kraskov.jl")
include("estimators/transferentropy_visitfreq.jl")
include("estimators/transferentropy_transferoperator.jl")
include("estimators/transferentropy_triangulation.jl")


"""
    install_dependencies()

Clone packages `TransferEntropy.jl` depends on manually from GitHub. This is
a temporary solution until the packages are registered on METADATA.
"""
function install_dependencies()
    - julia -e 'Pkg.add("PyCall")'
    - julia -e 'ENV["PYTHON"] = ""; Pkg.build("PyCall")'
    - julia -e 'using Conda; Conda.add("scipy")'
    Pkg.clone("https://github.com/kahaaga/Simplices.jl")
    Pkg.build("Simplices")
    Pkg.clone("https://github.com/kahaaga/StateSpaceReconstruction.jl")
    Pkg.build("StateSpaceReconstruction")
    Pkg.clone("https://github.com/kahaaga/PerronFrobenius.jl")
    Pkg.build("PerronFrobenius")
end

export
install_dependencies,
entropy,
TEVars,
te_integral, ∫te,
transferentropy_kraskov, tekraskov,
transferentropy_transferoperator_visitfreq, tetofreq,
transferentropy_visitfreq, tefreq,
transferentropy_transferoperator_triang, tetotri

end # module

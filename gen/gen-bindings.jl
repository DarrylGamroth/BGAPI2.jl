using Clang.Generators

cd(@__DIR__)

include_dir = normpath(@__DIR__)

# wrapper generator options
options = load_options(joinpath(@__DIR__, "generator.toml"))

args = get_default_args()
push!(args, "-I$include_dir")

headers = joinpath(include_dir, "bgapi2_genicam.h")

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)

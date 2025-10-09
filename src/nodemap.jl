struct NodeMap
    node_map::Ptr{BGAPI2_NodeMap}
end

function node(nm::NodeMap, name::AbstractString)
    node = Ref{Ptr{BGAPI2_Node}}()
    @check BGAPI2_NodeMap_GetNode(nm.node_map, name, node)
    return Node(node[])
end

function count(nm::NodeMap)
    count = Ref{bo_uint64}()
    @check BGAPI2_NodeMap_GetNodeCount(nm.node_map, count)
    return Int(count[])
end

function node_by_index(nm::NodeMap, index::Int)
    node = Ref{Ptr{BGAPI2_Node}}()
    @check BGAPI2_NodeMap_GetNodeByIndex(nm.node_map, index - 1, node)
    return Node(node[])
end

function is_present(nm::NodeMap, name::AbstractString)
    is_present = Ref{bo_bool}()
    @check BGAPI2_NodeMap_GetNodePresent(nm.node_map, name, is_present)
    return is_present[] != 0
end

Base.length(nm::NodeMap) = count(nm)
Base.eltype(::Type{NodeMap}) = Node

function Base.iterate(nm::NodeMap, state=nothing)
    index = state === nothing ? 1 : state + 1
    if index <= length(nm)
        return (node_by_index(nm, index), index)
    else
        return nothing
    end
end

function Base.getindex(nm::NodeMap, index::Int)
    if index < 1 || index > length(nm)
        throw(BoundsError(nm, index))
    end
    return node_by_index(nm, index)
end

function Base.getindex(nm::NodeMap, name::AbstractString)
    if !is_present(nm, name)
        throw(KeyError(name))
    end
    node(nm, name)
end

Base.getindex(nm::NodeMap, name::Symbol) = node(nm, string(name))

Base.haskey(nm::NodeMap, name::AbstractString) = is_present(nm, name)
Base.haskey(nm::NodeMap, name::Symbol) = is_present(nm, string(name))

function Base.get(nm::NodeMap, name::AbstractString, default)
    haskey(nm, name) ? nm[name] : default
end

function Base.get(nm::NodeMap, name::Symbol, default)
    haskey(nm, name) ? nm[name] : default
end

function Base.keys(nm::NodeMap)
    [name(node_by_index(nm, i)) for i in 1:length(nm)]
end

function Base.values(nm::NodeMap)
    [node_by_index(nm, i) for i in 1:length(nm)]
end

function Base.pairs(nm::NodeMap)
    [name(n) => n for n in nm]
end

Base.in(name::AbstractString, nm::NodeMap) = haskey(nm, name)
Base.in(name::Symbol, nm::NodeMap) = haskey(nm, name)
Base.in(pair::Pair, nm::NodeMap) = haskey(nm, first(pair)) && nm[first(pair)] == last(pair)

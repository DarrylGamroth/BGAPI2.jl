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

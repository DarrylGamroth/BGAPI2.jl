struct System
    system::Ptr{BGAPI2_System}

    function System(file_path::AbstractString)
        system = Ref{Ptr{BGAPI2_System}}()
        @check BGAPI2_LoadSystemFromPath(file_path, system)
        new(system[])
    end

    function System(index::Int)
        system = Ref{Ptr{BGAPI2_System}}()
        @check BGAPI2_GetSystem(index - 1, system)
        new(system[])
    end
end

Base.open(s::System) = @check BGAPI2_System_Open(s.system)
function Base.open(f::Function, s::System)
    open(s)
    try
        f(s)
    finally
        close(s)
    end
end
Base.close(s::System) = @check BGAPI2_System_Close(s.system)
release(s::System) = @check BGAPI2_ReleaseSystem(s.system)

function Base.isopen(system::System)
    is_open = Ref{bo_bool}()
    @check BGAPI2_System_IsOpen(system.system, is_open)
    return is_open[] != 0
end

struct SystemList
    function SystemList()
        system_list = new()
        update(system_list)
        return system_list
    end

    function SystemList(producer_path::AbstractString)
        system_list = new()
        update(system_list, producer_path)
        return system_list
    end
end

update(::SystemList) = @check BGAPI2_UpdateSystemList()
update(::SystemList, producer_path) = @check BGAPI2_UpdateSystemListFromPath(producer_path)

function Base.length(::SystemList)
    count = Ref{bo_uint}()
    @check BGAPI2_GetNumSystems(count)
    return Int(count[])
end

function Base.iterate(s::SystemList, state=nothing)
    index = state === nothing ? 1 : state + 1
    if index <= Base.length(s)
        return (System(index), index)
    else
        return nothing
    end
end

Base.eltype(::Type{SystemList}) = System
Base.getindex(s::SystemList, index::Int) = System(index)

function node(s::System, name::AbstractString)
    node = Ref{Ptr{BGAPI2_Node}}()
    @check BGAPI2_System_GetNode(s.system, name, node)
    return Node(node[])
end

function node_tree(s::System)
    node_tree = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_System_GetNodeTree(s.system, node_tree)
    return NodeMap(node_tree[])
end

function node_list(s::System)
    node_list = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_System_GetNodeList(s.system, node_list)
    return NodeMap(node_list[])
end

function id(s::System)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_System_GetID(s.system, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_System_GetID(s.system, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function vendor(s::System)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_System_GetVendor(s.system, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_System_GetVendor(s.system, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function model(s::System)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_System_GetModel(s.system, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_System_GetModel(s.system, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function version(s::System)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_System_GetVersion(s.system, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_System_GetVersion(s.system, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function tl_type(s::System)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_System_GetTLType(s.system, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_System_GetTLType(s.system, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function file_name(s::System)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_System_GetFileName(s.system, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_System_GetFileName(s.system, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function path_name(s::System)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_System_GetPathName(s.system, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_System_GetPathName(s.system, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function display_name(s::System)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_System_GetDisplayName(s.system, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_System_GetDisplayName(s.system, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function Base.show(io::IO, ::MIME"text/plain", s::System)
    println(io, "System: $(display_name(s))")
    println(io, "  ID: $(id(s))")
    println(io, "  Vendor: $(vendor(s))")
    println(io, "  Model: $(model(s))")
    println(io, "  Version: $(version(s))")
    println(io, "  TL Type: $(tl_type(s))")
    println(io, "  File Name: $(file_name(s))")
    println(io, "  Path Name: $(path_name(s))")
end

struct InterfaceList
    system::System

    function InterfaceList(system::System, timeout::Int64=100)
        interface_list = new(system)
        update(interface_list, timeout)
        return interface_list
    end
end

function update(i::InterfaceList, timeout)
    changed = Ref{bo_bool}()
    @check BGAPI2_System_UpdateInterfaceList(i.system.system, changed, timeout)
    return changed[] != 0
end

function Base.length(i::InterfaceList)
    count = Ref{bo_uint}()
    @check BGAPI2_System_GetNumInterfaces(i.system.system, count)
    return Int(count[])
end

function Base.iterate(i::InterfaceList, state=nothing)
    index = state === nothing ? 1 : state + 1
    if index <= Base.length(i)
        return (Interface(i.system, index), index)
    else
        return nothing
    end
end

Base.eltype(::Type{InterfaceList}) = Interface
Base.getindex(i::InterfaceList, index::Int) = Interface(i.system, index)

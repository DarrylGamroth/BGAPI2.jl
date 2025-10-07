mutable struct Interface
    const interface::Ptr{BGAPI2_Interface}
    const system::System
    on_pnp_event::Tuple{Function,Any}

    function Interface(system::System, index::Int)
        interface = Ref{Ptr{BGAPI2_Interface}}()
        @check BGAPI2_System_GetInterface(system.system, index - 1, interface)

        new(interface[], system, (empty_pnp_event_handler, nothing))
    end
end

Base.open(i::Interface) = @check BGAPI2_Interface_Open(i.interface)
function Base.open(f::Function, i::Interface)
    open(i)
    try
        f(i)
    finally
        close(i)
    end
end
Base.close(i::Interface) = @check BGAPI2_Interface_Close(i.interface)

function Base.isopen(i::Interface)
    is_open = Ref{bo_bool}()
    @check BGAPI2_Interface_IsOpen(i.interface, is_open)
    return is_open[] != 0
end

Base.parent(i::Interface) = i.system

function node(i::Interface, name::AbstractString)
    node = Ref{Ptr{BGAPI2_Node}}()
    @check BGAPI2_Interface_GetNode(i.interface, name, node)
    return Node(node[])
end

function node_tree(i::Interface)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Interface_GetNodeMap(i.interface, node_map)
    return NodeMap(node_map[])
end

function node_list(i::Interface)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Interface_GetNodeList(i.interface, node_map)
    return NodeMap(node_map[])
end

function pnp_event_mode!(i::Interface, mode::EventMode.T)
    @check BGAPI2_Interface_SetPnPEventMode(i.interface, mode)
end

function pnp_event_mode(i::Interface)
    mode = Ref{BGAPI2_EventMode}()
    @check BGAPI2_Interface_GetPnPEventMode(i.interface, mode)
    return convert(EventMode.T, mode[])
end

function pnp_event(i::Interface, p::PnPEvent, timeout::Int64=-1)
    @check BGAPI2_Interface_GetPnPEvent(i.interface, p.pnp_event, reinterpret(UInt64, timeout))
    return p
end

function cancel_pnp_event(i::Interface)
    @check BGAPI2_Interface_CancelPnPEvent(i.interface)
end

empty_pnp_event_handler(_, _) = nothing

function register_pnp_event_handler(callback::Function, i::Interface, userdata=nothing)
    cb = (callback, userdata)
    i.on_pnp_event = cb
    @check BGAPI2_Interface_RegisterPnPEventHandler(i.interface,
        Ref(cb), pnp_event_handler_cfunction(cb))
end

function pnp_event_handler_wrapper((callback, userdata), pnpEvent)
    callback(PnPEvent(pnpEvent), userdata)
    nothing
end

function pnp_event_handler_cfunction(::T) where {T}
    @cfunction(pnp_event_handler_wrapper, Cvoid, (Ref{T}, Ptr{BGAPI2_PnPEvent}))
end

function id(i::Interface)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Interface_GetID(i.interface, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_Interface_GetID(i.interface, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function display_name(i::Interface)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Interface_GetDisplayName(i.interface, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_Interface_GetDisplayName(i.interface, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function tl_type(i::Interface)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Interface_GetTLType(i.interface, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_Interface_GetTLType(i.interface, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function Base.show(io::IO, ::MIME"text/plain", i::Interface)
    println(io, "Interface: $(display_name(i))")
    println(io, "  ID: $(id(i))")
    println(io, "  Display Name: $(display_name(i))")
    println(io, "  TL Type: $(tl_type(i))")
end

struct DeviceList
    interface::Interface

    function DeviceList(interface::Interface, timeout::Int64=100)
        device_list = new(interface)
        update(device_list, timeout)
        return device_list
    end
end

function update(d::DeviceList, timeout)
    changed = Ref{bo_bool}()
    @check BGAPI2_Interface_UpdateDeviceList(d.interface.interface, changed, timeout)
    return changed[] != 0
end

function Base.length(d::DeviceList)
    count = Ref{bo_uint}()
    @check BGAPI2_Interface_GetNumDevices(d.interface.interface, count)
    return Int(count[])
end

function Base.iterate(d::DeviceList, state=nothing)
    index = state === nothing ? 1 : state + 1
    if index <= Base.length(d)
        return (Device(d.interface, index), index)
    else
        return nothing
    end
end

Base.eltype(::Type{DeviceList}) = Device
Base.getindex(d::DeviceList, index::Int) = Device(d.interface, index)

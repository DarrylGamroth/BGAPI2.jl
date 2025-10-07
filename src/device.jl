mutable struct Device
    const device::Ptr{BGAPI2_Device}
    const interface::Interface
    on_device_event::Tuple{Function,Any}

    function Device(interface::Interface, index::Int)
        device = Ref{Ptr{BGAPI2_Device}}()
        @check BGAPI2_Interface_GetDevice(interface.interface, index - 1, device)
        new(device[], interface, (empty_device_event_handler, nothing))
    end
end

function Base.open(d::Device;
    exclusive::Bool=false,
    read_only::Bool=false)

    if exclusive && read_only
        error("Cannot open device in exclusive and read-only mode at the same time.")
    end

    if exclusive
        @check BGAPI2_Device_OpenExclusive(d.device)
    elseif read_only
        @check BGAPI2_Device_OpenReadOnly(d.device)
    else
        @check BGAPI2_Device_Open(d.device)
    end
end

function Base.open(f::Function, d::Device; kwargs...)
    open(d; kwargs...)
    try
        f(d)
    finally
        close(d)
    end
end
Base.close(d::Device) = @check BGAPI2_Device_Close(d.device)

function Base.isopen(d::Device)
    is_open = Ref{bo_bool}()
    @check BGAPI2_Device_IsOpen(d.device, is_open)
    return is_open[] != 0
end

Base.parent(d::Device) = d.interface

function node(d::Device, name::AbstractString)
    node = Ref{Ptr{BGAPI2_Node}}()
    @check BGAPI2_Device_GetNode(d.device, name, node)
    return Node(node[])
end

function node_tree(d::Device)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Device_GetNodeMap(d.device, node_map)
    return NodeMap(node_map[])
end

function node_list(d::Device)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Device_GetNodeList(d.device, node_map)
    return NodeMap(node_map[])
end

function device_event_mode!(d::Device, mode::EventMode.T)
    @check BGAPI2_Device_SetDeviceEventMode(d.device, mode)
end

function device_event_mode(d::Device)
    mode = Ref{BGAPI2_EventMode}()
    @check BGAPI2_Device_GetDeviceEventMode(d.device, mode)
    return convert(EventMode.T, mode[])
end

function device_event(d::Device, e::DeviceEvent, timeout::Int64=-1)
    @check BGAPI2_Device_GetDeviceEvent(d.device, e.device_event, reinterpret(UInt64, timeout))
    return e
end

function payload_size(d::Device)
    payload_size = Ref{bo_uint64}()
    @check BGAPI2_Device_GetPayloadSize(d.device, payload_size)
    return Int(payload_size[])
end

function remote_node(d::Device, name::AbstractString)
    node = Ref{Ptr{BGAPI2_Node}}()
    @check BGAPI2_Device_GetRemoteNode(d.device, name, node)
    return Node(node[])
end

function remote_node_tree(d::Device)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Device_GetRemoteNodeTree(d.device, node_map)
    return NodeMap(node_map[])
end

function remote_node_list(d::Device)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Device_GetRemoteNodeList(d.device, node_map)
    return NodeMap(node_map[])
end

function id(d::Device)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Device_GetID(d.device, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_Device_GetID(d.device, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function vendor(d::Device)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Device_GetVendor(d.device, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_Device_GetVendor(d.device, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function model(d::Device)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Device_GetModel(d.device, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_Device_GetModel(d.device, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function serial_number(d::Device)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Device_GetSerialNumber(d.device, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_Device_GetSerialNumber(d.device, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function tl_type(d::Device)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Device_GetTLType(d.device, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_Device_GetTLType(d.device, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function display_name(d::Device)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Device_GetDisplayName(d.device, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_Device_GetDisplayName(d.device, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function access_status(d::Device)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Device_GetAccessStatus(d.device, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_Device_GetAccessStatus(d.device, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function Base.show(io::IO, ::MIME"text/plain", d::Device)
    println(io, "Device: $(display_name(d))")
    println(io, "  ID: $(id(d))")
    println(io, "  Vendor: $(vendor(d))")
    println(io, "  Model: $(model(d))")
    println(io, "  Serial Number: $(serial_number(d))")
    println(io, "  TL Type: $(tl_type(d))")
    println(io, "  Display Name: $(display_name(d))")
    println(io, "  Access Status: $(access_status(d))")
end

start_stacking(d::Device, replace_mode::Bool=false) = @check BGAPI2_Device_StartStacking(d.device, replace_mode)
write_stack(d::Device) = @check BGAPI2_Device_WriteStack(d.device)
cancel_stack(d::Device) = @check BGAPI2_Device_CancelStack(d.device)

function is_update_mode_available(d::Device)
    is_available = Ref{bo_bool}()
    @check BGAPI2_Device_IsUpdateModeAvailable(d.device, is_available)
    return is_available[] != 0
end

function is_update_mode_active(d::Device)
    is_active = Ref{bo_bool}()
    @check BGAPI2_Device_IsUpdateModeActive(d.device, is_active)
    return is_active[] != 0
end

empty_device_event_handler(_, _) = nothing

function register_device_event_handler(callback::Function, d::Device, userdata=nothing)
    cb = (callback, userdata)
    d.on_device_event = cb
    @check BGAPI2_Device_RegisterDeviceEventHandler(d.device,
        Ref(cb), device_event_handler_cfunction(cb))
end

function device_event_handler_wrapper((callback, userdata), deviceEvent)
    callback(DeviceEvent(deviceEvent), userdata)
    nothing
end

function device_event_handler_cfunction(::T) where {T}
    @cfunction(device_event_handler_wrapper, Cvoid, (Ref{T}, Ptr{BGAPI2_DeviceEvent}))
end

struct DataStreamList
    device::Device
end

function Base.length(d::DataStreamList)
    count = Ref{bo_uint}()
    @check BGAPI2_Device_GetNumDataStreams(d.device.device, count)
    return Int(count[])
end

function Base.iterate(d::DataStreamList, state=nothing)
    index = state === nothing ? 1 : state + 1
    if index <= Base.length(d)
        return (DataStream(d.device, index), index)
    else
        return nothing
    end
end

Base.eltype(::Type{DataStreamList}) = DataStream
function Base.getindex(d::DataStreamList, index::Int)
    if index < 1 || index > Base.length(d)
        throw(BoundsError(d, index))
    end
    return DataStream(d.device, index)
end

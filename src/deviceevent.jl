struct DeviceEvent
    device_event::Ptr{BGAPI2_DeviceEvent}

    function DeviceEvent()
        device_event = Ref{Ptr{BGAPI2_DeviceEvent}}()
        @check BGAPI2_CreateDeviceEvent(device_event)
        new(device_event[])
    end
    function DeviceEvent(d::Ptr{BGAPI2_DeviceEvent})
        new(d)
    end
end

function release(d::DeviceEvent)
    @check BGAPI2_ReleaseDeviceEvent(d.device_event)
end

function node(d::DeviceEvent, name::AbstractString)
    node = Ref{Ptr{BGAPI2_Node}}()
    @check BGAPI2_DeviceEvent_GetNode(d.device_event, name, node)
    return Node(node[])
end

function node_tree(d::DeviceEvent)
    node_tree = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_DeviceEvent_GetNodeTree(d.device_event, node_tree)
    return NodeMap(node_tree[])
end

function node_list(d::DeviceEvent)
    node_list = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_DeviceEvent_GetNodeList(d.device_event, node_list)
    return NodeMap(node_list[])
end

function event_mode!(d::DeviceEvent, mode::EventMode.T)
    @check BGAPI2_DeviceEvent_SetEventMode(d.device_event, mode)
end

function event_mode(d::DeviceEvent)
    mode = Ref{BGAPI2_EventMode}()
    @check BGAPI2_DeviceEvent_GetEventMode(d.device_event, mode)
    return convert(EventMode.T, mode[])
end

function name(d::DeviceEvent)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_DeviceEvent_GetName(d.device_event, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_DeviceEvent_GetName(d.device_event, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function display_name(d::DeviceEvent)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_DeviceEvent_GetDisplayName(d.device_event, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_DeviceEvent_GetDisplayName(d.device_event, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function timestamp(d::DeviceEvent)
    timestamp = Ref{bo_uint64}()
    @check BGAPI2_DeviceEvent_GetTimestamp(d.device_event, timestamp)
    return timestamp[]
end

function id(d::DeviceEvent)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_DeviceEvent_GetID(d.device_event, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_DeviceEvent_GetID(d.device_event, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function mem_ptr(d::DeviceEvent)
    mem_ptr = Ref{Ptr{Cvoid}}()
    @check BGAPI2_DeviceEvent_GetMemPtr(d.device_event, mem_ptr)
    return mem_ptr[]
end

function mem_size(d::DeviceEvent)
    mem_size = Ref{bo_uint64}()
    @check BGAPI2_DeviceEvent_GetMemSize(d.device_event, mem_size)
    return Int64(mem_size[])
end

function mem_buffer(d::DeviceEvent)
    UnsafeArray(convert(Ptr{UInt8}, mem_ptr(d)), (mem_size(d),))
end

function Base.show(io::IO, ::MIME"text/plain", d::DeviceEvent)
    println(io, "DeviceEvent")
    println(io, "  Name: ", name(d))
    println(io, "  Display Name: ", display_name(d))
    println(io, "  ID: ", id(d))
    println(io, "  Timestamp: ", timestamp(d))
    println(io, "  Event Mode: ", event_mode(d))
end

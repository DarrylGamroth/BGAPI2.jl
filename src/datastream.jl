mutable struct DataStream
    const datastream::Ptr{BGAPI2_DataStream}
    const device::Device
    on_new_buffer::Tuple{Function,Any}

    function DataStream(device::Device, index::Int)
        datastream = Ref{Ptr{BGAPI2_DataStream}}()
        @check BGAPI2_Device_GetDataStream(device.device, index - 1, datastream)
        new(datastream[], device, (empty_on_new_buffer_event_handler, nothing))
    end
end

Base.open(d::DataStream) = @check BGAPI2_DataStream_Open(d.datastream)
function Base.open(f::Function, d::DataStream)
    open(d)
    try
        f(d)
    finally
        close(d)
    end
end
Base.close(d::DataStream) = @check BGAPI2_DataStream_Close(d.datastream)

function Base.isopen(d::DataStream)
    is_open = Ref{bo_bool}()
    @check BGAPI2_DataStream_IsOpen(d.datastream, is_open)
    return is_open[] != 0
end

Base.parent(d::DataStream) = d.device

function node(d::DataStream, name::AbstractString)
    node = Ref{Ptr{BGAPI2_Node}}()
    @check BGAPI2_DataStream_GetNode(d.datastream, name, node)
    return Node(node[])
end

function node_tree(d::DataStream)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_DataStream_GetNodeMap(d.datastream, node_map)
    return NodeMap(node_map[])
end

function node_list(d::DataStream)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_DataStream_GetNodeList(d.datastream, node_map)
    return NodeMap(node_map[])
end

function new_buffer_event_mode!(d::DataStream, mode::EventMode.T)
    @check BGAPI2_DataStream_SetNewBufferEventMode(d.datastream, mode)
end

function new_buffer_event_mode(d::DataStream)
    mode = Ref{BGAPI2_EventMode}()
    @check BGAPI2_DataStream_GetNewBufferEventMode(d.datastream, mode)
    return convert(EventMode.T, mode[])
end

function id(d::DataStream)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_DataStream_GetID(d.datastream, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_DataStream_GetID(d.datastream, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function payload_size(d::DataStream)
    size = Ref{bo_uint64}()
    @check BGAPI2_DataStream_GetPayloadSize(d.datastream, size)
    return size[]
end

function is_grabbing(d::DataStream)
    is_grabbing = Ref{bo_bool}()
    @check BGAPI2_DataStream_GetIsGrabbing(d.datastream, is_grabbing)
    return is_grabbing[] != 0
end

function defines_payload_size(d::DataStream)
    defines_payload_size = Ref{bo_bool}()
    @check BGAPI2_DataStream_GetDefinesPayloadSize(d.datastream, defines_payload_size)
    return defines_payload_size[] != 0
end

function tl_type(d::DataStream)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_DataStream_GetTLType(d.datastream, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_DataStream_GetTLType(d.datastream, pointer(buf), string_length)
    return StringView(@view buf[1:string_length[]-1])
end

function start_acquisition(d::DataStream, num_to_acquire::Int)
    @check BGAPI2_DataStream_StartAcquisition(d.datastream, num_to_acquire)
end

function start_acquisition_continuous(d::DataStream)
    @check BGAPI2_DataStream_StartAcquisitionContinuous(d.datastream)
end

function stop_acquisition(d::DataStream)
    @check BGAPI2_DataStream_StopAcquisition(d.datastream)
end

function abort_acquisition(d::DataStream)
    @check BGAPI2_DataStream_AbortAcquisition(d.datastream)
end

function filled_buffer(d::DataStream, timeout::Int64=-1)
    buffer = Ref{Ptr{BGAPI2_Buffer}}()
    @check BGAPI2_DataStream_GetFilledBuffer(d.datastream, buffer, reinterpret(UInt64, timeout))
    user_ptr = Ref{Ptr{Cvoid}}()
    @check BGAPI2_Buffer_GetUserPtr(buffer[], user_ptr)
    unsafe_pointer_to_objref(user_ptr[])::Buffer
end

function filled_buffer_nothrow(d::DataStream, timeout::Int64=-1)
    buffer = Ref{Ptr{BGAPI2_Buffer}}()
    status = BGAPI2_DataStream_GetFilledBuffer(d.datastream, buffer, reinterpret(UInt64, timeout))
    if status == LibBGAPI2.BGAPI2_RESULT_TIMEOUT
        return nothing
    end
    check_status(status)
    user_ptr = Ref{Ptr{Cvoid}}()
    @check BGAPI2_Buffer_GetUserPtr(buffer[], user_ptr)
    unsafe_pointer_to_objref(user_ptr[])::Buffer
end

function cancel_get_filled_buffer(d::DataStream)
    @check BGAPI2_DataStream_CancelGetFilledBuffer(d.datastream)
end

function Base.getindex(d::DataStream, index)
    buffer = Ref{Ptr{BGAPI2_Buffer}}()
    @check BGAPI2_DataStream_GetBufferID(d.datastream, index - 1, buffer)
    user_ptr = Ref{Ptr{Cvoid}}()
    @check BGAPI2_Buffer_GetUserPtr(buffer[], user_ptr)
    unsafe_pointer_to_objref(user_ptr[])::Buffer
end

function Base.show(io::IO, ::MIME"text/plain", d::DataStream)
    println(io, "DataStream: $(id(d))")
    if !isopen(d)
        println(io, "  Is Open: false")
        return
    end
    println(io, "  Is Open: true")
    println(io, "  TL Type: $(tl_type(d))")
    println(io, "  Defines Payload Size: $(defines_payload_size(d))")
    println(io, "  Is Grabbing: $(is_grabbing(d))")
end

empty_on_new_buffer_event_handler(_, _) = nothing

function register_new_buffer_event_handler(callback::Function, d::DataStream, userdata=nothing)
    cb = (callback, userdata)
    d.on_new_buffer = cb
    @check BGAPI2_DataStream_RegisterNewBufferEventHandler(d.datastream,
        Ref(cb), new_buffer_event_handler_cfunction(cb))
end

function new_buffer_event_handler_wrapper((callback, userdata), pBuffer)
    user_ptr = Ref{Ptr{Cvoid}}()
    @check BGAPI2_Buffer_GetUserPtr(pBuffer, user_ptr)
    b = unsafe_pointer_to_objref(user_ptr[])::Buffer
    GC.@preserve b begin
        callback(b, userdata)
    end
    nothing
end

function new_buffer_event_handler_cfunction(::T) where {T}
    @cfunction(new_buffer_event_handler_wrapper, Cvoid, (Ref{T}, Ptr{BGAPI2_Buffer}))
end

struct BufferList
    datastream::DataStream
    buffers::Vector{Buffer}

    function BufferList(datastream::DataStream)
        new(datastream, Buffer[])
    end
end

function Base.push!(bl::BufferList, buffers::Buffer...)
    for b in buffers
        announce_buffer(bl, b)
        push!(bl.buffers, b)
    end
end

function Base.delete!(bl::BufferList, b::Buffer)
    revoke_buffer(bl, b)
    release(b)
    deleteat!(bl.buffers, findfirst(==(b), bl.buffers))
end

function Base.empty!(bl::BufferList)
    for b in bl.buffers
        revoke_buffer(bl, b)
        release(b)
    end
    empty!(bl.buffers)
end

Base.length(bl::BufferList) = length(bl.buffers)
Base.eltype(::Type{BufferList}) = Buffer
Base.iterate(bl::BufferList, i=1) = iterate(bl.buffers, i)

function flush_input_to_output_queue(bl::BufferList)
    @check BGAPI2_DataStream_FlushInputToOutputQueue(bl.datastream.datastream)
end

function flush_all_to_input_queue(bl::BufferList)
    @check BGAPI2_DataStream_FlushAllToInputQueue(bl.datastream.datastream)
end

function flush_unqueued_to_input_queue(bl::BufferList)
    @check BGAPI2_DataStream_FlushUnqueuedToInputQueue(bl.datastream.datastream)
end

function discard_output_buffers(bl::BufferList)
    @check BGAPI2_DataStream_DiscardOutputBuffers(bl.datastream.datastream)
end

function discard_all_buffers(bl::BufferList)
    @check BGAPI2_DataStream_DiscardAllBuffers(bl.datastream.datastream)
end

function announce_buffer(bl::BufferList, buffer::Buffer)
    @check BGAPI2_DataStream_AnnounceBuffer(bl.datastream.datastream, buffer.buffer)
end

function revoke_buffer(bl::BufferList, buffer::Buffer)
    userdata = Ref{Ptr{Cvoid}}()
    @check BGAPI2_DataStream_RevokeBuffer(bl.datastream.datastream, buffer.buffer, userdata)
end

function queue_buffer(bl::BufferList, buffer::Buffer)
    @check BGAPI2_DataStream_QueueBuffer(bl.datastream.datastream, buffer.buffer)
end

function num_delivered(bl::BufferList)
    count = Ref{bo_uint64}()
    @check BGAPI2_DataStream_GetNumDelivered(bl.datastream.datastream, count)
    return count[]
end

function num_underrun(bl::BufferList)
    count = Ref{bo_uint64}()
    @check BGAPI2_DataStream_GetNumUnderrun(bl.datastream.datastream, count)
    return count[]
end

function num_announced(bl::BufferList)
    count = Ref{bo_uint64}()
    @check BGAPI2_DataStream_GetNumAnnounced(bl.datastream.datastream, count)
    return count[]
end

function num_queued(bl::BufferList)
    count = Ref{bo_uint64}()
    @check BGAPI2_DataStream_GetNumQueued(bl.datastream.datastream, count)
    return count[]
end

function num_await_delivery(bl::BufferList)
    count = Ref{bo_uint64}()
    @check BGAPI2_DataStream_GetNumAwaitDelivery(bl.datastream.datastream, count)
    return count[]
end

function num_started(bl::BufferList)
    count = Ref{bo_uint64}()
    @check BGAPI2_DataStream_GetNumStarted(bl.datastream.datastream, count)
    return count[]
end

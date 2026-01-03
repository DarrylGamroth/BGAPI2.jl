mutable struct Buffer
    buffer::Ptr{BGAPI2_Buffer}
    string_buffer::Vector{UInt8}
    user_ref::Union{Nothing, Ref{Buffer}}
    external_buffer::Union{Nothing, AbstractVector}
    Buffer(buffer::Ptr{BGAPI2_Buffer}) = new(buffer, Vector{UInt8}(undef, 64), nothing, nothing)
    function Buffer()
        b = new(C_NULL, Vector{UInt8}(undef, 64), nothing, nothing)
        user_ref = Ref(b)
        buffer = Ref{Ptr{BGAPI2_Buffer}}()
        @check BGAPI2_CreateBufferWithUserPtr(buffer, user_ref)
        b.buffer = buffer[]
        b.user_ref = user_ref
        finalizer(b) do b
            if b.buffer != C_NULL
                user_obj = Ref{Ptr{Cvoid}}()
                BGAPI2_DeleteBuffer(b.buffer, user_obj)
            end
        end
        return b
    end
    function Buffer(user_buffer::StridedVector{T}) where {T}
        isbitstype(T) || throw(ArgumentError("External buffer element type must be isbits"))
        stride(user_buffer, 1) == 1 || throw(ArgumentError("External buffer must be contiguous (stride == 1)"))
        b = new(C_NULL, Vector{UInt8}(undef, 64), nothing, user_buffer)
        user_ref = Ref(b)
        buffer = Ref{Ptr{BGAPI2_Buffer}}()
        GC.@preserve user_buffer begin
            @check BGAPI2_CreateBufferWithExternalMemory(
                buffer,
                pointer(user_buffer),
                sizeof(T) * length(user_buffer),
                user_ref,
            )
        end
        b.buffer = buffer[]
        b.user_ref = user_ref
        finalizer(b) do b
            if b.buffer != C_NULL
                user_obj = Ref{Ptr{Cvoid}}()
                BGAPI2_DeleteBuffer(b.buffer, user_obj)
            end
        end
        return b
    end
    function Buffer(p::Ptr{BGAPI2_Buffer})
        new(p, Vector{UInt8}(undef, 64), nothing, nothing)
    end
end

function release(b::Buffer)
    if b.buffer == C_NULL
        return
    end
    user_obj = Ref{Ptr{Cvoid}}(C_NULL)
    @check BGAPI2_DeleteBuffer(b.buffer, user_obj)
    b.buffer = C_NULL
    b.user_ref = nothing
    b.external_buffer = nothing
end

function node(b::Buffer, name::AbstractString)
    node = Ref{Ptr{BGAPI2_Node}}()
    @check BGAPI2_Buffer_GetNode(b.buffer, name, node)
    return Node(node[])
end

function node_tree(b::Buffer)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Buffer_GetNodeMap(b.buffer, node_map)
    return NodeMap(node_map[])
end

function node_list(b::Buffer)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Buffer_GetNodeList(b.buffer, node_map)
    return NodeMap(node_map[])
end

function chunk_node_list(b::Buffer)
    node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Buffer_GetChunkNodeList(b.buffer, node_map)
    return NodeMap(node_map[])
end

function id(b::Buffer)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetID(b.buffer, C_NULL, string_length)
    resize!(b.string_buffer, string_length[])
    @check BGAPI2_Buffer_GetID(b.buffer, pointer(b.string_buffer), string_length)
    return String(@view b.string_buffer[1:string_length[]-1])
end

function tl_type(b::Buffer)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetTLType(b.buffer, C_NULL, string_length)
    resize!(b.string_buffer, string_length[])
    @check BGAPI2_Buffer_GetTLType(b.buffer, pointer(b.string_buffer), string_length)
    return Symbol(StringView(@view b.string_buffer[1:string_length[]-1]))
end

function mem_ptr(b::Buffer)
    mem_ptr = Ref{Ptr{Cvoid}}()
    @check BGAPI2_Buffer_GetMemPtr(b.buffer, mem_ptr)
    return mem_ptr[]
end

function mem_size(b::Buffer)
    mem_size = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetMemSize(b.buffer, mem_size)
    return Int64(mem_size[])
end

function mem_buffer(b::Buffer)
    UnsafeArray(convert(Ptr{UInt8}, mem_ptr(b)), (mem_size(b),))
end

function image_buffer(b::Buffer)
    is_image_present(b) || throw(ArgumentError("Image not present"))
    return UnsafeArray(convert(Ptr{UInt8}, mem_ptr(b)) + image_offset(b), (image_length(b),))
end

function user_ptr(b::Buffer)
    user_ptr = Ref{Ptr{Cvoid}}()
    @check BGAPI2_Buffer_GetUserPtr(b.buffer, user_ptr)
    return user_ptr[]
end

function timestamp(b::Buffer)
    timestamp = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetTimestamp(b.buffer, timestamp)
    return timestamp[]
end

function host_timestamp(b::Buffer)
    host_timestamp = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetHostTimestamp(b.buffer, host_timestamp)
    return host_timestamp[]
end

function is_new_data(b::Buffer)
    new_data = Ref{bo_bool}()
    @check BGAPI2_Buffer_GetNewData(b.buffer, new_data)
    return new_data[] != 0
end

function is_queued(b::Buffer)
    is_queued = Ref{bo_bool}()
    @check BGAPI2_Buffer_GetIsQueued(b.buffer, is_queued)
    return is_queued[] != 0
end

function is_acquiring(b::Buffer)
    is_acquiring = Ref{bo_bool}()
    @check BGAPI2_Buffer_GetIsAcquiring(b.buffer, is_acquiring)
    return is_acquiring[] != 0
end

function is_incomplete(b::Buffer)
    is_incomplete = Ref{bo_bool}()
    @check BGAPI2_Buffer_GetIsIncomplete(b.buffer, is_incomplete)
    return is_incomplete[] != 0
end

function size_filled(b::Buffer)
    size_filled = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetSizeFilled(b.buffer, size_filled)
    return Int64(size_filled[])
end

function width(b::Buffer)
    width = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetWidth(b.buffer, width)
    return Int64(width[])
end

function height(b::Buffer)
    height = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetHeight(b.buffer, height)
    return Int64(height[])
end

function x_offset(b::Buffer)
    x_offset = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetXOffset(b.buffer, x_offset)
    return Int64(x_offset[])
end

function y_offset(b::Buffer)
    y_offset = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetYOffset(b.buffer, y_offset)
    return Int64(y_offset[])
end

function x_padding(b::Buffer)
    x_padding = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetXPadding(b.buffer, x_padding)
    return Int64(x_padding[])
end

function y_padding(b::Buffer)
    y_padding = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetYPadding(b.buffer, y_padding)
    return Int64(y_padding[])
end

function frame_id(b::Buffer)
    frame_id = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetFrameID(b.buffer, frame_id)
    return frame_id[]
end

function is_image_present(b::Buffer)
    is_image_present = Ref{bo_bool}()
    @check BGAPI2_Buffer_GetImagePresent(b.buffer, is_image_present)
    return is_image_present[] != 0
end

function image_offset(b::Buffer)
    image_offset = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetImageOffset(b.buffer, image_offset)
    return Int64(image_offset[])
end

function image_length(b::Buffer)
    image_length = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetImageLength(b.buffer, image_length)
    return Int64(image_length[])
end

function payload_type(b::Buffer)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetPayloadType(b.buffer, C_NULL, string_length)
    resize!(b.string_buffer, string_length[])
    @check BGAPI2_Buffer_GetPayloadType(b.buffer, pointer(b.string_buffer), string_length)
    return Symbol(StringView(@view b.string_buffer[1:string_length[]-1]))
end

function pixel_format(b::Buffer)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetPixelFormat(b.buffer, C_NULL, string_length)
    resize!(b.string_buffer, string_length[])
    @check BGAPI2_Buffer_GetPixelFormat(b.buffer, pointer(b.string_buffer), string_length)
    return Symbol(StringView(@view b.string_buffer[1:string_length[]-1]))
end

function delivered_height(b::Buffer)
    delivered_height = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetDeliveredHeight(b.buffer, delivered_height)
    return delivered_height[]
end

function delivered_width(b::Buffer)
    delivered_width = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetDeliveredWidth(b.buffer, delivered_width)
    return delivered_width[]
end

function delivered_chunk_payload_size(b::Buffer)
    delivered_chunk_payload_size = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetDeliveredChunkPayloadSize(b.buffer, delivered_chunk_payload_size)
    return delivered_chunk_payload_size[]
end

function contains_chunk(b::Buffer)
    contains_chunk = Ref{bo_bool}()
    @check BGAPI2_Buffer_GetContainsChunk(b.buffer, contains_chunk)
    return contains_chunk[] != 0
end

function chunk_layout_id(b::Buffer)
    chunk_layout_id = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetChunkLayoutID(b.buffer, chunk_layout_id)
    return chunk_layout_id[]
end

function file_name(b::Buffer)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Buffer_GetFileName(b.buffer, C_NULL, string_length)
    resize!(b.string_buffer, string_length[])
    @check BGAPI2_Buffer_GetFileName(b.buffer, pointer(b.string_buffer), string_length)
    return String(@view b.string_buffer[1:string_length[]-1])
end

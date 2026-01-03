mutable struct Node
    const node::Ptr{BGAPI2_Node}
    string_buffer::Vector{UInt8}

    Node(node::Ptr{BGAPI2_Node}) = new(node, Vector{UInt8}(undef, 256))
end

function interface(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetInterface(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetInterface(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function extension(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetExtension(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetExtension(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function tool_tip(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetToolTip(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetToolTip(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function description(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetDescription(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetDescription(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function name(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetName(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetName(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function display_name(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetDisplayname(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetDisplayname(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function visibility(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetVisibility(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetVisibility(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function event_id(n::Node)
    event_id = Ref{bo_int64}()
    @check BGAPI2_Node_GetEventID(n.node, event_id)
    return event_id[]
end

function is_implemented(n::Node)
    is_implemented = Ref{bo_bool}()
    @check BGAPI2_Node_GetImplemented(n.node, is_implemented)
    return is_implemented[] != 0
end

function is_available(n::Node)
    is_available = Ref{bo_bool}()
    @check BGAPI2_Node_GetAvailable(n.node, is_available)
    return is_available[] != 0
end

function is_locked(n::Node)
    is_locked = Ref{bo_bool}()
    @check BGAPI2_Node_GetLocked(n.node, is_locked)
    return is_locked[] != 0
end

function imposed_access_mode(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetImposedAccessMode(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetImposedAccessMode(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function current_access_mode(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetCurrentAccessMode(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetCurrentAccessMode(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function is_readable(n::Node)
    is_readable = Ref{bo_bool}()
    @check BGAPI2_Node_IsReadable(n.node, is_readable)
    return is_readable[] != 0
end

function is_writable(n::Node)
    is_writable = Ref{bo_bool}()
    @check BGAPI2_Node_IsWriteable(n.node, is_writable)
    return is_writable[] != 0
end

function alias(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetAlias(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetAlias(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function value(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetValue(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetValue(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function value!(n::Node, value::AbstractString)
    @check BGAPI2_Node_SetValue(n.node, value)
end

function representation(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetRepresentation(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetRepresentation(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function int_min(n::Node)
    min = Ref{bo_int64}()
    @check BGAPI2_Node_GetIntMin(n.node, min)
    return min[]
end

function int_max(n::Node)
    max = Ref{bo_int64}()
    @check BGAPI2_Node_GetIntMax(n.node, max)
    return max[]
end

function int_inc(n::Node)
    inc = Ref{bo_int64}()
    @check BGAPI2_Node_GetIntInc(n.node, inc)
    return inc[]
end

function int(n::Node)
    value = Ref{bo_int64}()
    @check BGAPI2_Node_GetInt(n.node, value)
    return value[]
end

function int!(n::Node, value::Int64)
    @check BGAPI2_Node_SetInt(n.node, value)
end

function has_unit(n::Node)
    has_unit = Ref{bo_bool}()
    @check BGAPI2_Node_HasUnit(n.node, has_unit)
    return has_unit[] != 0
end

function unit(n::Node)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_Node_GetUnit(n.node, C_NULL, string_length)
    resize!(n.string_buffer, string_length[])
    @check BGAPI2_Node_GetUnit(n.node, pointer(n.string_buffer), string_length)
    return String(@view n.string_buffer[1:string_length[]-1])
end

function double_min(n::Node)
    min = Ref{bo_double}()
    @check BGAPI2_Node_GetDoubleMin(n.node, min)
    return min[]
end

function double_max(n::Node)
    max = Ref{bo_double}()
    @check BGAPI2_Node_GetDoubleMax(n.node, max)
    return max[]
end

function double_inc(n::Node)
    inc = Ref{bo_double}()
    @check BGAPI2_Node_GetDoubleInc(n.node, inc)
    return inc[]
end

function has_inc(n::Node)
    has_inc = Ref{bo_bool}()
    @check BGAPI2_Node_HasInc(n.node, has_inc)
    return has_inc[] != 0
end

function double_precision(n::Node)
    double_precision = Ref{bo_uint64}()
    @check BGAPI2_Node_GetDoublePrecision(n.node, double_precision)
    return double_precision[]
end

function double(n::Node)
    value = Ref{bo_double}()
    @check BGAPI2_Node_GetDouble(n.node, value)
    return value[]
end

function double!(n::Node, value::Float64)
    @check BGAPI2_Node_SetDouble(n.node, value)
end

function max_string_length(n::Node)
    max_string_length = Ref{bo_int64}()
    @check BGAPI2_Node_GetMaxStringLength(n.node, max_string_length)
    return max_string_length[]
end

function enum_mode_list(n::Node)
    enum_node_map = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Node_GetEnumModeList(n.node, enum_node_map)
    return NodeMap(enum_node_map[])
end

function execute(n::Node)
    @check BGAPI2_Node_Execute(n.node)
end

function is_done(n::Node)
    is_done = Ref{bo_bool}()
    @check BGAPI2_Node_IsDone(n.node, is_done)
    return is_done[] != 0
end

function bool(n::Node)
    value = Ref{bo_bool}()
    @check BGAPI2_Node_GetBool(n.node, value)
    return value[] != 0
end

function bool!(n::Node, value::Bool)
    @check BGAPI2_Node_SetBool(n.node, value)
end

function node_tree(n::Node)
    node_tree = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Node_GetNodeTree(n.node, node_tree)
    return NodeMap(node_tree[])
end

function node_list(n::Node)
    node_list = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Node_GetNodeList(n.node, node_list)
    return NodeMap(node_list[])
end

function is_selector(n::Node)
    is_selector = Ref{bo_bool}()
    @check BGAPI2_Node_IsSelector(n.node, is_selector)
    return is_selector[] != 0
end

function selected_features(n::Node)
    selected_features = Ref{Ptr{BGAPI2_NodeMap}}()
    @check BGAPI2_Node_GetSelectedFeatures(n.node, selected_features)
    return NodeMap(selected_features[])
end

function Base.length(n::Node)
    length = Ref{bo_int64}()
    @check BGAPI2_Node_GetLength(n.node, length)
    return length[]
end

function address(n::Node)
    address = Ref{bo_int64}()
    @check BGAPI2_Node_GetAddress(n.node, address)
    return address[]
end

function get(n::Node, length::Int)
    buffer = Vector{UInt8}(undef, length)
    GC.@preserve buffer begin
        @check BGAPI2_Node_Get(n.node, pointer(buffer), length)
    end
    return buffer
end

function get(n::Node, buffer::AbstractVector{UInt8})
    GC.@preserve buffer begin
        @check BGAPI2_Node_Get(n.node, pointer(buffer), length(buffer))
    end
end

function set(n::Node, buffer::AbstractVector{UInt8})
    GC.@preserve buffer begin
        @check BGAPI2_Node_Set(n.node, pointer(buffer), length(buffer))
    end
end

set(n::Node, value::Integer) = int!(n, Int64(value))
set(n::Node, value::AbstractFloat) = double!(n, Float64(value))
set(n::Node, value::AbstractString) = value!(n, value)
set(n::Node, value::Bool) = bool!(n, value)

get(::Type{T}, n::Node) where {T<:Integer} = int(n)
get(::Type{T}, n::Node) where {T<:AbstractFloat} = double(n)
get(::Type{T}, n::Node) where {T<:AbstractString} = value(n)
get(::Type{T}, n::Node) where {T<:Bool} = bool(n)
get(::Type{T}, n::Node, length::Int) where {T<:AbstractVector{UInt8}} = get(n, length)
get(::Type{T}, n::Node, buffer::AbstractVector{UInt8}) where {T<:AbstractVector{UInt8}} = get(n, buffer)

function Base.eltype(n::Node)
    i = interface(n)
    i == BGAPI2_NODEINTERFACE_FLOAT ? Float64 :
    i == BGAPI2_NODEINTERFACE_INTEGER ? Int64 :
    i == BGAPI2_NODEINTERFACE_BOOLEAN ? Bool :
    AbstractString
end

function get(n::Node)
    T = Base.eltype(n)
    get(T, n)
end

function Base.show(io::IO, ::MIME"text/plain", n::Node)
    print(io, "Node: ", name(n), " (", display_name(n), ")")
    print(io, "\n  Interface: ", interface(n))
    print(io, "\n  Extension: ", extension(n))
    print(io, "\n  Description: ", description(n))
    print(io, "\n  Visibility: ", visibility(n))
    print(io, "\n  Is Implemented: ", is_implemented(n))
    print(io, "\n  Is Available: ", is_available(n))
    print(io, "\n  Is Locked: ", is_locked(n))
    print(io, "\n  Imposed Access Mode: ", imposed_access_mode(n))
    print(io, "\n  Current Access Mode: ", current_access_mode(n))
    print(io, "\n  Is Readable: ", is_readable(n))
    print(io, "\n  Is Writable: ", is_writable(n))
    print(io, "\n  Value: ", value(n))
end

struct PnPEvent
    pnp_event::Ptr{BGAPI2_PnPEvent}

    function PnPEvent()
        pnp_event = Ref{Ptr{BGAPI2_PnPEvent}}()
        @check BGAPI2_CreatePnPEvent(pnp_event)
        new(pnp_event[])
    end
    function PnPEvent(p::Ptr{BGAPI2_PnPEvent})
        new(p)
    end
end

function release(p::PnPEvent)
    @check BGAPI2_ReleasePnPEvent(p.pnp_event)
end

function serial_number(p::PnPEvent)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_PnPEvent_GetSerialNumber(p.pnp_event, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_PnPEvent_GetSerialNumber(p.pnp_event, pointer(buf), string_length)
    return String(@view buf[1:string_length[]-1])
end

function type(p::PnPEvent)
    pnp_type = Ref{bo_uint64}()
    @check BGAPI2_PnPEvent_GetType(p.pnp_event, pnp_type)
    return pnp_type[]
end

function id(p::PnPEvent)
    string_length = Ref{bo_uint64}()
    @check BGAPI2_PnPEvent_GetID(p.pnp_event, C_NULL, string_length)
    buf = Vector{UInt8}(undef, string_length[])
    @check BGAPI2_PnPEvent_GetID(p.pnp_event, pointer(buf), string_length)
    return String(@view buf[1:string_length[]-1])
end

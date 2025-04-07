module BGAPI2

include("LibBGAPI2.jl")
using .LibBGAPI2

using EnumX
using StringViews
using UnsafeArrays

@enumx EventMode::UInt32 begin
    UNREGISTERED = Integer(LibBGAPI2.EVENTMODE_UNREGISTERED)
    POLLING = Integer(LibBGAPI2.EVENTMODE_POLLING)
    EVENT_HANDLER = Integer(LibBGAPI2.EVENTMODE_EVENT_HANDLER)
end

Base.convert(::Type{BGAPI2_EventMode}, event_mode::EventMode.T) = BGAPI2_EventMode(Integer(event_mode))
Base.convert(::Type{EventMode.T}, event_mode::BGAPI2_EventMode) = EventMode.T(event_mode)

include("exceptions.jl")
include("buffer.jl")
include("deviceevent.jl")
include("node.jl")
include("nodemap.jl")
include("pnpevent.jl")
include("system.jl")
include("interface.jl")
include("device.jl")
include("datastream.jl")

end # module BGAPI2

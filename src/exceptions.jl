# Base exception type for all BGAPI2 errors
abstract type BGAPI2Exception <: Exception end

# Define concrete exception types for each error code
struct Success <: BGAPI2Exception
    status::Int32
end
struct Error <: BGAPI2Exception
    status::Int32
end
struct NotInitialized <: BGAPI2Exception
    status::Int32
end
struct NotImplemented <: BGAPI2Exception
    status::Int32
end
struct ResourceInUse <: BGAPI2Exception
    status::Int32
end
struct AccessDenied <: BGAPI2Exception
    status::Int32
end
struct InvalidHandle <: BGAPI2Exception
    status::Int32
end
struct InvalidParameter <: BGAPI2Exception
    status::Int32
end
struct NoData <: BGAPI2Exception
    status::Int32
end
struct TimeoutOccurred <: BGAPI2Exception
    status::Int32
end
struct Abort <: BGAPI2Exception
    status::Int32
end
struct InvalidBuffer <: BGAPI2Exception
    status::Int32
end
struct NotAvailable <: BGAPI2Exception
    status::Int32
end
struct ObjectInvalidException <: BGAPI2Exception
    status::Int32
end
struct LowLevelException <: BGAPI2Exception
    status::Int32
end

# Add more specific exception types as needed based on BGAPI2_RESULT_LIST

# Error message functions for each exception type
Base.showerror(io::IO, e::Success) = print(io, "BGAPI2 Success ($(e.status)): Operation completed successfully")
Base.showerror(io::IO, e::Error) = print(io, "BGAPI2 Error ($(e.status)): Generic error")
Base.showerror(io::IO, e::NotInitialized) = print(io, "BGAPI2 Error ($(e.status)): Not initialized")
Base.showerror(io::IO, e::NotImplemented) = print(io, "BGAPI2 Error ($(e.status)): Feature not implemented")
Base.showerror(io::IO, e::ResourceInUse) = print(io, "BGAPI2 Error ($(e.status)): Resource already in use")
Base.showerror(io::IO, e::AccessDenied) = print(io, "BGAPI2 Error ($(e.status)): Access denied")
Base.showerror(io::IO, e::InvalidHandle) = print(io, "BGAPI2 Error ($(e.status)): Invalid handle")
Base.showerror(io::IO, e::InvalidParameter) = print(io, "BGAPI2 Error ($(e.status)): Invalid parameter")
Base.showerror(io::IO, e::NoData) = print(io, "BGAPI2 Error ($(e.status)): No data available")
Base.showerror(io::IO, e::TimeoutOccurred) = print(io, "BGAPI2 Error ($(e.status)): Timeout occurred")
Base.showerror(io::IO, e::Abort) = print(io, "BGAPI2 Error ($(e.status)): Operation aborted")
Base.showerror(io::IO, e::InvalidBuffer) = print(io, "BGAPI2 Error ($(e.status)): Invalid buffer")
Base.showerror(io::IO, e::NotAvailable) = print(io, "BGAPI2 Error ($(e.status)): Feature not available")
Base.showerror(io::IO, e::ObjectInvalidException) = print(io, "BGAPI2 Error ($(e.status)): Object invalid")
Base.showerror(io::IO, e::LowLevelException) = print(io, "BGAPI2 Error ($(e.status)): Low-level error")

# Map BGAPI2 result codes to exception types
const exception_map = Dict{Int32,Type{<:BGAPI2Exception}}(
    BGAPI2_RESULT_SUCCESS => Success,
    BGAPI2_RESULT_ERROR => Error,
    BGAPI2_RESULT_NOT_INITIALIZED => NotInitialized,
    BGAPI2_RESULT_NOT_IMPLEMENTED => NotImplemented,
    BGAPI2_RESULT_RESOURCE_IN_USE => ResourceInUse,
    BGAPI2_RESULT_ACCESS_DENIED => AccessDenied,
    BGAPI2_RESULT_INVALID_HANDLE => InvalidHandle,
    BGAPI2_RESULT_NO_DATA => NoData,
    BGAPI2_RESULT_INVALID_PARAMETER => InvalidParameter,
    BGAPI2_RESULT_TIMEOUT => TimeoutOccurred,
    BGAPI2_RESULT_ABORT => Abort,
    BGAPI2_RESULT_INVALID_BUFFER => InvalidBuffer,
    BGAPI2_RESULT_NOT_AVAILABLE => NotAvailable,
    BGAPI2_RESULT_OBJECT_INVALID => ObjectInvalidException,
    BGAPI2_RESULT_LOWLEVEL_ERROR => LowLevelException
    # Add any other error codes from BGAPI2_RESULT_LIST here
)

"""
    create_exception(status::Int32)

Create the appropriate exception type based on BGAPI2 result code.
"""
function create_exception(status::Int32)
    exception_type = Base.get(exception_map, status, Error)
    return exception_type(status)
end

"""
    check_status(status::BGAPI2_RESULT)

Check the status code from BGAPI2 function calls and throw appropriate exceptions.
Only throw if not SUCCESS.
"""
function check_status(status::BGAPI2_RESULT)
    if status != BGAPI2_RESULT_SUCCESS
        throw(create_exception(Int32(status)))
    end
    return status
end

"""
    @check status_expr

Macro to check status code from an expression and throw appropriate exception if needed.
"""
macro check(status_expr)
    quote
        status = $(esc(status_expr))
        check_status(status)
    end
end

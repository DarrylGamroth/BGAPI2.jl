module LibBGAPI2

using CEnum

@static if Sys.islinux()
    const libbgapi2_genicam = "libbgapi2_genicam.so"
elseif Sys.iswindows()
    const libbgapi2_genicam = "bgapi2_genicam.dll"
else
    error("Unsupported OS")
end

const bo_int64 = Int64

const bo_uint64 = UInt64

const bo_int = Int32

const bo_uint = UInt32

const bo_short = Int16

const bo_ushort = UInt16

const bo_char = Int8

const bo_uchar = UInt8

const bo_string = Cstring

const bo_bool = bo_uchar

const bo_double = Cdouble

"""
    BGAPI2_RESULT_LIST

`    BGAPI2`

An enumeration containing return result codes
"""
@cenum BGAPI2_RESULT_LIST::Int32 begin
    BGAPI2_RESULT_SUCCESS = 0
    BGAPI2_RESULT_ERROR = -1001
    BGAPI2_RESULT_NOT_INITIALIZED = -1002
    BGAPI2_RESULT_NOT_IMPLEMENTED = -1003
    BGAPI2_RESULT_RESOURCE_IN_USE = -1004
    BGAPI2_RESULT_ACCESS_DENIED = -1005
    BGAPI2_RESULT_INVALID_HANDLE = -1006
    BGAPI2_RESULT_NO_DATA = -1008
    BGAPI2_RESULT_INVALID_PARAMETER = -1009
    BGAPI2_RESULT_TIMEOUT = -1011
    BGAPI2_RESULT_ABORT = -1012
    BGAPI2_RESULT_INVALID_BUFFER = -1013
    BGAPI2_RESULT_NOT_AVAILABLE = -1014
    BGAPI2_RESULT_OBJECT_INVALID = -1098
    BGAPI2_RESULT_LOWLEVEL_ERROR = -1099
end

const BGAPI2_RESULT = bo_int

mutable struct BGAPI2_System end

mutable struct BGAPI2_Interface end

mutable struct BGAPI2_Device end

mutable struct BGAPI2_DataStream end

mutable struct BGAPI2_Buffer end

mutable struct BGAPI2_Node end

mutable struct BGAPI2_NodeMap end

mutable struct BGAPI2_Image end

mutable struct BGAPI2_ImageProcessor end

mutable struct BGAPI2_Polarizer end

mutable struct BGAPI2_DeviceEvent end

mutable struct BGAPI2_PnPEvent end

"""
    BGAPI2_EventMode

`    DeviceEvent`

An enumeration containing the string representation of the possible event configurations
"""
@cenum BGAPI2_EventMode::UInt32 begin
    EVENTMODE_UNREGISTERED = 0
    EVENTMODE_POLLING = 1
    EVENTMODE_EVENT_HANDLER = 2
end

# typedef void ( BGAPI2CALL * BGAPI2_PnPEventHandler ) ( void * callBackOwner , BGAPI2_PnPEvent * pnpEvent )
"""
`    Interface`

Declaration for callback functions for [`BGAPI2_PnPEventHandler`](@ref)
"""
const BGAPI2_PnPEventHandler = Ptr{Cvoid}

# typedef void ( BGAPI2CALL * BGAPI2_DevEventHandler ) ( void * callBackOwner , BGAPI2_DeviceEvent * deviceEvent )
"""
`    Device`

Declaration for callback functions for [`BGAPI2_DevEventHandler`](@ref)
"""
const BGAPI2_DevEventHandler = Ptr{Cvoid}

# typedef void ( BGAPI2CALL * BGAPI2_NewBufferEventHandler ) ( void * callBackOwner , BGAPI2_Buffer * pBuffer )
"""
`    Buffer`

Declaration for callback functions for [`BGAPI2_NewBufferEventHandler`](@ref)
"""
const BGAPI2_NewBufferEventHandler = Ptr{Cvoid}

# no prototype is found for this function at bgapi2_genicam.h:179:44, please use with caution
"""
    BGAPI2_UpdateSystemList()

`    System`

Search for GenTL producers in the current directory and in GENICAM\\_GENTLxx\\_PATH

This function creates an System object for each found producer. GenTL producer are files with the .cti extension and are synonymous with the system. After the list of systems is updated, you can use [`BGAPI2_GetNumSystems`](@ref)() function to get the number of producers found and the [`BGAPI2_GetSystem`](@ref)() function to open a specific system to work with it

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR An error

# See also
[`BGAPI2_ReleaseSystem`](@ref), [`BGAPI2_GetSystem`](@ref), [`BGAPI2_System_Open`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_UpdateSystemList();
```
"""
function BGAPI2_UpdateSystemList()
    @ccall libbgapi2_genicam.BGAPI2_UpdateSystemList()::BGAPI2_RESULT
end

"""
    BGAPI2_UpdateSystemListFromPath(producer_path)

`    System`

Search for GenTL producers only in the path specified

This function creates an System object for each found producer. GenTL producer are files with the .cti extension and are synonymous with the system. After the list of systems is updated, you can use [`BGAPI2_GetNumSystems`](@ref)() function to get the number of producers found and the [`BGAPI2_GetSystem`](@ref)() function to open a specific system to work with it

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR An error

# Arguments
* `producer_path`:\\[in\\] Path where producers should be searched
# See also
[`BGAPI2_System_Close`](@ref), [`BGAPI2_ReleaseSystem`](@ref), [`BGAPI2_GetSystem`](@ref), [`BGAPI2_System_Open`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_UpdateSystemListFromPath(const char* producer_path);
```
"""
function BGAPI2_UpdateSystemListFromPath(producer_path)
    @ccall libbgapi2_genicam.BGAPI2_UpdateSystemListFromPath(producer_path::Cstring)::BGAPI2_RESULT
end

"""
    BGAPI2_LoadSystemFromPath(file_path, system)

`    System`

Creates a System (GenTL producer) object, specified by filepath before opening it

This function creates an System object for each found producer. You need to create and open a producer before you can get any information about it. Once a producer is created it will not be counted by subsequent [`BGAPI2_GetNumSystems`](@ref)() calls!

\\retvalBGAPI2_RESULT_SUCCESS No error

# Arguments
* `file_path`:\\[in\\] Path and Filename of the producer to create
* `system`:\\[out\\] Reference to a pointer to the system (producer)
# See also
[`BGAPI2_System_Open`](@ref), [`BGAPI2_System_Close`](@ref), [`BGAPI2_ReleaseSystem`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_LoadSystemFromPath(const char* file_path, BGAPI2_System** system);
```
"""
function BGAPI2_LoadSystemFromPath(file_path, system)
    @ccall libbgapi2_genicam.BGAPI2_LoadSystemFromPath(file_path::Cstring, system::Ptr{Ptr{BGAPI2_System}})::BGAPI2_RESULT
end

"""
    BGAPI2_GetNumSystems(count)

`    System`

Returns the number of systems (GenTL Producers) found by [`BGAPI2_UpdateSystemList`](@ref)()

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `count`:\\[out\\] Count of found GenTL Producer
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_GetNumSystems(bo_uint* count);
```
"""
function BGAPI2_GetNumSystems(count)
    @ccall libbgapi2_genicam.BGAPI2_GetNumSystems(count::Ptr{bo_uint})::BGAPI2_RESULT
end

"""
    BGAPI2_GetSystem(index, system)

`    System`

Get a pointer to the System (GenTL Producer) specified by the index

You need to open a System before you can get any information about it. Once a System is opened it will not be counted by subsequent [`BGAPI2_GetNumSystems`](@ref) calls!

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\retvalBGAPI2_RESULT_RESOURCE_IN_USE Producer already loaded

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Error in producer (functions not found)

# Arguments
* `index`:\\[in\\] Index of the system (producer) to use
* `system`:\\[out\\] Reference to a pointer to the system (producer)
# See also
[`BGAPI2_System_Open`](@ref), [`BGAPI2_System_Close`](@ref), [`BGAPI2_ReleaseSystem`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_GetSystem(bo_uint index, BGAPI2_System** system);
```
"""
function BGAPI2_GetSystem(index, system)
    @ccall libbgapi2_genicam.BGAPI2_GetSystem(index::bo_uint, system::Ptr{Ptr{BGAPI2_System}})::BGAPI2_RESULT
end

"""
    BGAPI2_System_Open(system)

`    System`

Opens a system (GenTL producer) to work with it

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_RESOURCE_IN_USE Already opened

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer) obtained from [`BGAPI2_GetSystem`](@ref)
# See also
[`BGAPI2_GetSystem`](@ref), [`BGAPI2_System_Close`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_Open(BGAPI2_System* system);
```
"""
function BGAPI2_System_Open(system)
    @ccall libbgapi2_genicam.BGAPI2_System_Open(system::Ptr{BGAPI2_System})::BGAPI2_RESULT
end

"""
    BGAPI2_System_IsOpen(system, is_open)

`    System`

Check if the system (GenTL producer) is opened

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `is_open`:\\[out\\] Pointer to the result variable
# See also
[`BGAPI2_System_Open`](@ref), [`BGAPI2_System_Close`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_IsOpen(BGAPI2_System* system, bo_bool* is_open);
```
"""
function BGAPI2_System_IsOpen(system, is_open)
    @ccall libbgapi2_genicam.BGAPI2_System_IsOpen(system::Ptr{BGAPI2_System}, is_open::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_System_UpdateInterfaceList(system, changed, timeout)

`    System`

Updates the list of of accessible interfaces and creates an object for each

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Interface not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `changed`:\\[out\\] Flag if interfaces are changed since last call
* `timeout`:\\[in\\] Maximum time in milliseconds to search for interfaces
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_UpdateInterfaceList( BGAPI2_System* system, bo_bool* changed, bo_uint64 timeout);
```
"""
function BGAPI2_System_UpdateInterfaceList(system, changed, timeout)
    @ccall libbgapi2_genicam.BGAPI2_System_UpdateInterfaceList(system::Ptr{BGAPI2_System}, changed::Ptr{bo_bool}, timeout::bo_uint64)::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetInterface(system, index, iface)

`    System`

Get a pointer to the interface with the specified index.

You need to call [`BGAPI2_System_UpdateInterfaceList`](@ref)() first! A System (GenTL producer) connects devices through a transport layer via an interface. The Interface can be a physical interface such as an ethernet network adapter or a logical interface such as an USB port.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Interface not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `index`:\\[in\\] Index in the interface list
* `iface`:\\[out\\] Device instance
# See also
[`BGAPI2_System_UpdateInterfaceList`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetInterface( BGAPI2_System* system, bo_uint index, BGAPI2_Interface** iface);
```
"""
function BGAPI2_System_GetInterface(system, index, iface)
    @ccall libbgapi2_genicam.BGAPI2_System_GetInterface(system::Ptr{BGAPI2_System}, index::bo_uint, iface::Ptr{Ptr{BGAPI2_Interface}})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetNumInterfaces(system, count_interfaces)

`    System`

Returns the number of accessible interfaces

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Interface not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `count_interfaces`:\\[out\\] Number of interfaces
# See also
[`BGAPI2_System_GetInterface`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetNumInterfaces( BGAPI2_System* system, bo_uint* count_interfaces);
```
"""
function BGAPI2_System_GetNumInterfaces(system, count_interfaces)
    @ccall libbgapi2_genicam.BGAPI2_System_GetNumInterfaces(system::Ptr{BGAPI2_System}, count_interfaces::Ptr{bo_uint})::BGAPI2_RESULT
end

"""
    BGAPI2_System_Close(system)

`    System`

Closes a system (producer), you need to call [`BGAPI2_ReleaseSystem`](@ref) to unload the library

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
# See also
[`BGAPI2_System_Open`](@ref), [`BGAPI2_ReleaseSystem`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_Close(BGAPI2_System* system);
```
"""
function BGAPI2_System_Close(system)
    @ccall libbgapi2_genicam.BGAPI2_System_Close(system::Ptr{BGAPI2_System})::BGAPI2_RESULT
end

"""
    BGAPI2_ReleaseSystem(system)

`    System`

Release a system (GenTL producer) specified. You need to call [`BGAPI2_System_Close`](@ref) first!

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error producer was not loaded

\\retvalBGAPI2_RESULT_ERROR Internal Error (nullptr as system)

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Error on close of producer

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
# See also
[`BGAPI2_System_Open`](@ref), [`BGAPI2_System_Close`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ReleaseSystem(BGAPI2_System* system);
```
"""
function BGAPI2_ReleaseSystem(system)
    @ccall libbgapi2_genicam.BGAPI2_ReleaseSystem(system::Ptr{BGAPI2_System})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetNode(system, name, node)

`    System`

Get the named node (feature) of given map of system

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `name`:\\[in\\] Name of the node to return
* `node`:\\[out\\] Variable for returned node value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetNode( BGAPI2_System* system, const char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_System_GetNode(system, name, node)
    @ccall libbgapi2_genicam.BGAPI2_System_GetNode(system::Ptr{BGAPI2_System}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetNodeTree(system, node_tree)

`    System`

Get a tree of all system nodes (features)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `node_tree`:\\[out\\] Variable for the returned node tree
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetNodeTree( BGAPI2_System* system, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_System_GetNodeTree(system, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_System_GetNodeTree(system::Ptr{BGAPI2_System}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetNodeList(system, node_list)

`    System`

Get a list of all system nodes (features)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `node_list`:\\[out\\] Variable for the returned node map
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetNodeList( BGAPI2_System* system, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_System_GetNodeList(system, node_list)
    @ccall libbgapi2_genicam.BGAPI2_System_GetNodeList(system::Ptr{BGAPI2_System}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetID(system, ID, string_length)

`    System`

Returns the identifier of the system (GenTL producer).

The BGAPI2 C-Interface utilizes a two step process for the retrieval of strings.

\\_\\_1. Get the size of the string:\\_\\_ For the first call to [`BGAPI2_System_GetID`](@ref), you need to supply the function with an null-pointer for the parameter ID. In this case the function will return you the size of the ID. You can now use this size to set up the pointer with the right size.

\\_\\_2. Get the actual ID string:\\_\\_ Now you can supply the function with the right sized pointer you created for the ID. In that case, the function will return the ID into your provided memory pointer.

Alternatively, to save the extra call to get the size, you can supply the function with a larger memory pointer than required (e.g. 1024 byte).

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `ID`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetID( BGAPI2_System* system, char* ID, bo_uint64* string_length);
```
"""
function BGAPI2_System_GetID(system, ID, string_length)
    @ccall libbgapi2_genicam.BGAPI2_System_GetID(system::Ptr{BGAPI2_System}, ID::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetVendor(system, vendor, string_length)

`    System`

Returns the vendor of the system (GenTL producer)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `vendor`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_System_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetVendor( BGAPI2_System* system, char* vendor, bo_uint64* string_length);
```
"""
function BGAPI2_System_GetVendor(system, vendor, string_length)
    @ccall libbgapi2_genicam.BGAPI2_System_GetVendor(system::Ptr{BGAPI2_System}, vendor::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetModel(system, model, string_length)

`    System`

Returns the name (model) of the system (GenTL producer)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `model`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_System_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetModel( BGAPI2_System* system, char* model, bo_uint64* string_length);
```
"""
function BGAPI2_System_GetModel(system, model, string_length)
    @ccall libbgapi2_genicam.BGAPI2_System_GetModel(system::Ptr{BGAPI2_System}, model::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetVersion(system, version, string_length)

`    System`

Returns the version of the system (GenTL producer)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `version`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_System_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetVersion( BGAPI2_System* system, char* version, bo_uint64* string_length);
```
"""
function BGAPI2_System_GetVersion(system, version, string_length)
    @ccall libbgapi2_genicam.BGAPI2_System_GetVersion(system::Ptr{BGAPI2_System}, version::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetTLType(system, tl_type, string_length)

`    System`

Returns the name of the transport layer of the system (GenTL producer)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `tl_type`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_System_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetTLType( BGAPI2_System* system, char* tl_type, bo_uint64* string_length);
```
"""
function BGAPI2_System_GetTLType(system, tl_type, string_length)
    @ccall libbgapi2_genicam.BGAPI2_System_GetTLType(system::Ptr{BGAPI2_System}, tl_type::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetFileName(system, name, string_length)

`    System`

Returns the file name of the system (GenTL producer)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `name`:\\[out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[out\\] Result size, length of name
# See also
[`BGAPI2_System_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetFileName( BGAPI2_System* system, char* name, bo_uint64* string_length);
```
"""
function BGAPI2_System_GetFileName(system, name, string_length)
    @ccall libbgapi2_genicam.BGAPI2_System_GetFileName(system::Ptr{BGAPI2_System}, name::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetPathName(system, path_name, string_length)

`    System`

Returns the complete path name of the system (GenTL producer)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `path_name`:\\[out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[out\\] Result size, length of path name
# See also
[`BGAPI2_System_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetPathName( BGAPI2_System* system, char* path_name, bo_uint64* string_length);
```
"""
function BGAPI2_System_GetPathName(system, path_name, string_length)
    @ccall libbgapi2_genicam.BGAPI2_System_GetPathName(system::Ptr{BGAPI2_System}, path_name::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_System_GetDisplayName(system, display_name, string_length)

`    System`

Returns the "user friendly" display name of the system (GenTL producer)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `system`:\\[in\\] Pointer to the system (producer)
* `display_name`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_System_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_System_GetDisplayName( BGAPI2_System* system, char* display_name, bo_uint64* string_length);
```
"""
function BGAPI2_System_GetDisplayName(system, display_name, string_length)
    @ccall libbgapi2_genicam.BGAPI2_System_GetDisplayName(system::Ptr{BGAPI2_System}, display_name::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_Open(iface)

`    Interface`

Opens an interface

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_RESOURCE_IN_USE Interface is already opened

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface obtained from [`BGAPI2_System_GetInterface`](@ref)()
# See also
[`BGAPI2_System_GetInterface`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_Open(BGAPI2_Interface* iface);
```
"""
function BGAPI2_Interface_Open(iface)
    @ccall libbgapi2_genicam.BGAPI2_Interface_Open(iface::Ptr{BGAPI2_Interface})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_IsOpen(iface, is_open)

`    Interface`

Checks the open state of a interface

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
* `is_open`:\\[out\\] Result variable for open state of interface
# See also
[`BGAPI2_Interface_Open`](@ref), [`BGAPI2_System_GetInterface`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_IsOpen(BGAPI2_Interface* iface, bo_bool* is_open);
```
"""
function BGAPI2_Interface_IsOpen(iface, is_open)
    @ccall libbgapi2_genicam.BGAPI2_Interface_IsOpen(iface::Ptr{BGAPI2_Interface}, is_open::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_UpdateDeviceList(iface, changed, timeout)

`    Interface`

Updates the list of devices on the interface and creates an object for each found device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Interface not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read device infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
* `changed`:\\[out\\] True if devices have changed since last call, otherwise false
* `timeout`:\\[in\\] Maximum time in milliseconds to search for devices
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_UpdateDeviceList( BGAPI2_Interface* iface, bo_bool* changed, bo_uint64 timeout);
```
"""
function BGAPI2_Interface_UpdateDeviceList(iface, changed, timeout)
    @ccall libbgapi2_genicam.BGAPI2_Interface_UpdateDeviceList(iface::Ptr{BGAPI2_Interface}, changed::Ptr{bo_bool}, timeout::bo_uint64)::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetDevice(iface, index, device)

`    Interface`

Get a pointer to the device with supplied index

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Interface not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read device infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
* `index`:\\[in\\] Index in the device list
* `device`:\\[out\\] Device pointer
# See also
[`BGAPI2_Interface_UpdateDeviceList`](@ref), [`BGAPI2_Device_Open`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetDevice( BGAPI2_Interface* iface, bo_uint index, BGAPI2_Device** device);
```
"""
function BGAPI2_Interface_GetDevice(iface, index, device)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetDevice(iface::Ptr{BGAPI2_Interface}, index::bo_uint, device::Ptr{Ptr{BGAPI2_Device}})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetNumDevices(iface, count_devices)

`    Interface`

Returns count of devices on interface

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Interface not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read device infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Instance of interface
* `count_devices`:\\[out\\] Variable for count of devices on interface
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetNumDevices( BGAPI2_Interface* iface, bo_uint* count_devices);
```
"""
function BGAPI2_Interface_GetNumDevices(iface, count_devices)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetNumDevices(iface::Ptr{BGAPI2_Interface}, count_devices::Ptr{bo_uint})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetParent(iface, parent)

`    Interface`

Returns the parent object (GenTL producer) which the interface belongs to

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
* `parent`:\\[out\\] Parent object
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetParent( BGAPI2_Interface* iface, BGAPI2_System** parent);
```
"""
function BGAPI2_Interface_GetParent(iface, parent)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetParent(iface::Ptr{BGAPI2_Interface}, parent::Ptr{Ptr{BGAPI2_System}})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_Close(iface)

`    Interface`

Closes an interfaces

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_Close(BGAPI2_Interface* iface);
```
"""
function BGAPI2_Interface_Close(iface)
    @ccall libbgapi2_genicam.BGAPI2_Interface_Close(iface::Ptr{BGAPI2_Interface})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetNode(iface, name, node)

`    Interface`

Get a named node of the interface

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
* `name`:\\[in\\] Node name
* `node`:\\[out\\] Pointer to store node value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetNode( BGAPI2_Interface* iface, const char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_Interface_GetNode(iface, name, node)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetNode(iface::Ptr{BGAPI2_Interface}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetNodeTree(iface, node_tree)

`    Interface`

Get the node tree of the interface

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
* `node_tree`:\\[out\\] Pointer to store node tree
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetNodeTree( BGAPI2_Interface* iface, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_Interface_GetNodeTree(iface, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetNodeTree(iface::Ptr{BGAPI2_Interface}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetNodeList(iface, node_list)

`    Interface`

Get the node list of the interface

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
* `node_list`:\\[out\\] Pointer to store node list
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetNodeList( BGAPI2_Interface* iface, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_Interface_GetNodeList(iface, node_list)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetNodeList(iface::Ptr{BGAPI2_Interface}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_SetPnPEventMode(iface, event_mode)

`    Interface`

Set the event mode (polling, callback, off)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
* `event_mode`:\\[in\\] Event mode for the PnP events of interface
# See also
[`BGAPI2_EventMode`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_SetPnPEventMode( BGAPI2_Interface* iface, BGAPI2_EventMode event_mode);
```
"""
function BGAPI2_Interface_SetPnPEventMode(iface, event_mode)
    @ccall libbgapi2_genicam.BGAPI2_Interface_SetPnPEventMode(iface::Ptr{BGAPI2_Interface}, event_mode::BGAPI2_EventMode)::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetPnPEventMode(iface, event_mode)

`    Interface`

Returns the current event mode setting

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
* `event_mode`:\\[out\\] Pointer for event mode
# See also
[`BGAPI2_EventMode`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetPnPEventMode( BGAPI2_Interface* iface, BGAPI2_EventMode* event_mode);
```
"""
function BGAPI2_Interface_GetPnPEventMode(iface, event_mode)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetPnPEventMode(iface::Ptr{BGAPI2_Interface}, event_mode::Ptr{BGAPI2_EventMode})::BGAPI2_RESULT
end

"""
    BGAPI2_CreatePnPEvent(pnp_event)

`    Interface`

Creates a structure to store pnp events retrieved via [`BGAPI2_Interface_GetPnPEvent`](@ref)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `pnp_event`:\\[in,out\\] Pointer to a struct which can store events
# See also
[`BGAPI2_Interface_GetPnPEvent`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_CreatePnPEvent(BGAPI2_PnPEvent** pnp_event);
```
"""
function BGAPI2_CreatePnPEvent(pnp_event)
    @ccall libbgapi2_genicam.BGAPI2_CreatePnPEvent(pnp_event::Ptr{Ptr{BGAPI2_PnPEvent}})::BGAPI2_RESULT
end

"""
    BGAPI2_ReleasePnPEvent(pnp_event)

`    Interface`

Destroys a pnp event structure

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `pnp_event`:\\[in\\] Pointer to a event struct
# See also
[`BGAPI2_CreatePnPEvent`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ReleasePnPEvent(BGAPI2_PnPEvent* pnp_event);
```
"""
function BGAPI2_ReleasePnPEvent(pnp_event)
    @ccall libbgapi2_genicam.BGAPI2_ReleasePnPEvent(pnp_event::Ptr{BGAPI2_PnPEvent})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetPnPEvent(iface, pnp_event, timeout)

`    Interface`

Polls for event information until timeout is reached

This function is only used if [`BGAPI2_EventMode`](@ref) is set to `EVENTMODE_POLLING`

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR 

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to interface
* `pnp_event`:\\[in,out\\] Pointer for event structure created with [`BGAPI2_CreatePnPEvent`](@ref)
* `timeout`:\\[in\\] Maximum time to wait for events, if set to -1 wait indefinitely
# See also
[`BGAPI2_EventMode`](@ref), [`BGAPI2_CreatePnPEvent`](@ref), [`BGAPI2_Interface_CancelGetPnPEvent`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetPnPEvent( BGAPI2_Interface* iface, BGAPI2_PnPEvent* pnp_event, bo_uint64 timeout);
```
"""
function BGAPI2_Interface_GetPnPEvent(iface, pnp_event, timeout)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetPnPEvent(iface::Ptr{BGAPI2_Interface}, pnp_event::Ptr{BGAPI2_PnPEvent}, timeout::bo_uint64)::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_CancelGetPnPEvent(iface)

`    Interface`

Cancels an actively running [`BGAPI2_Interface_GetPnPEvent`](@ref)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error (on kill event)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to the interface
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_CancelGetPnPEvent(BGAPI2_Interface* iface);
```
"""
function BGAPI2_Interface_CancelGetPnPEvent(iface)
    @ccall libbgapi2_genicam.BGAPI2_Interface_CancelGetPnPEvent(iface::Ptr{BGAPI2_Interface})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_RegisterPnPEventHandler(iface, callback_owner, pnp_event_handler)

`    Interface`

Register one callback function to handle all pnp events of the interface.

This function is only used if [`BGAPI2_EventMode`](@ref) is set to `EVENTMODE_EVENT_HANDLER`. It starts internal an thread to retrieve and queue events

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Could not start event thread

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\todo check... what is the callback owner???

# Arguments
* `iface`:\\[in\\] Pointer to interface
* `callback_owner`:\\[in\\] Data, context pointer for use in callback function
* `pnp_event_handler`:\\[in\\] Pointer to callback function from type [`BGAPI2_PnPEventHandler`](@ref)
# See also
[`BGAPI2_EventMode`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_RegisterPnPEventHandler( BGAPI2_Interface* iface, void* callback_owner, BGAPI2_PnPEventHandler pnp_event_handler);
```
"""
function BGAPI2_Interface_RegisterPnPEventHandler(iface, callback_owner, pnp_event_handler)
    @ccall libbgapi2_genicam.BGAPI2_Interface_RegisterPnPEventHandler(iface::Ptr{BGAPI2_Interface}, callback_owner::Ptr{Cvoid}, pnp_event_handler::BGAPI2_PnPEventHandler)::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetID(iface, ID, string_length)

`    Interface`

Returns the identifier of the interface

The BGAPI2 C-Interface utilizes a two step process for the retrieval of strings.

\\_\\_1. Get the size of the string:\\_\\_ For the first call to [`BGAPI2_Interface_GetID`](@ref), you need to supply the function with an null-pointer for the parameter ID. In this case the function will return you the size of the ID. You can now use this size to set up the pointer with the right size.

\\_\\_2. Get the actual ID string:\\_\\_ Now you can supply the function with the right sized pointer you created for the ID. In that case, the function will return the ID into your provided memory pointer.

Alternatively, to save the extra call to get the size, you can supply the function with a larger memory pointer than required (e.g. 1024 byte).

\\retvalBGAPI2_RESULT_SUCCESS No error.

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Pointer to interface
* `ID`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetID( BGAPI2_Interface* iface, char* ID, bo_uint64* string_length);
```
"""
function BGAPI2_Interface_GetID(iface, ID, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetID(iface::Ptr{BGAPI2_Interface}, ID::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetDisplayName(iface, display_name, string_length)

`    Interface`

Returns the "user friendly" display name of interface, can be called on an interface which is not open

\\retvalBGAPI2_RESULT_SUCCESS No error.

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Instance of interface
* `display_name`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Interface_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetDisplayName( BGAPI2_Interface* iface, char* display_name, bo_uint64* string_length);
```
"""
function BGAPI2_Interface_GetDisplayName(iface, display_name, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetDisplayName(iface::Ptr{BGAPI2_Interface}, display_name::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Interface_GetTLType(iface, tl_type, string_length)

`    Interface`

Returns the transport layer name of interface, can be called on an interface which is not open

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Interface not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `iface`:\\[in\\] Instance of interface
* `tl_type`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Interface_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Interface_GetTLType( BGAPI2_Interface* iface, char* tl_type, bo_uint64* string_length);
```
"""
function BGAPI2_Interface_GetTLType(iface, tl_type, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Interface_GetTLType(iface::Ptr{BGAPI2_Interface}, tl_type::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_Open(device)

`    Device`

Opens a device for reading and writing

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Interface not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR GenTL producer error

\\retvalBGAPI2_RESULT_RESOURCE_IN_USE Device is already opened

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
# See also
[`BGAPI2_Interface_UpdateDeviceList`](@ref), [`BGAPI2_Interface_GetDevice`](@ref), [`BGAPI2_Device_Close`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_Open(BGAPI2_Device* device);
```
"""
function BGAPI2_Device_Open(device)
    @ccall libbgapi2_genicam.BGAPI2_Device_Open(device::Ptr{BGAPI2_Device})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_OpenExclusive(device)

`    Device`

Opens a device in exclusive mode

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Interface not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR GenTL producer error

\\retvalBGAPI2_RESULT_RESOURCE_IN_USE Device is already opened

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_OpenExclusive(BGAPI2_Device* device);
```
"""
function BGAPI2_Device_OpenExclusive(device)
    @ccall libbgapi2_genicam.BGAPI2_Device_OpenExclusive(device::Ptr{BGAPI2_Device})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_OpenReadOnly(device)

`    Device`

Opens a device in read-only-mode

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Interface not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR GenTL producer error

\\retvalBGAPI2_RESULT_RESOURCE_IN_USE Device is already opened

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_OpenReadOnly(BGAPI2_Device* device);
```
"""
function BGAPI2_Device_OpenReadOnly(device)
    @ccall libbgapi2_genicam.BGAPI2_Device_OpenReadOnly(device::Ptr{BGAPI2_Device})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_IsOpen(device, is_open)

`    Device`

Checks if the device is opened

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `is_open`:\\[out\\] Result variable for open state of device
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_IsOpen(BGAPI2_Device* device, bo_bool* is_open);
```
"""
function BGAPI2_Device_IsOpen(device, is_open)
    @ccall libbgapi2_genicam.BGAPI2_Device_IsOpen(device::Ptr{BGAPI2_Device}, is_open::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetDataStream(device, index, data_stream)

`    Device`

Returns a pointer to the data stream handle identified by index

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `index`:\\[in\\] Index of the data stream
* `data_stream`:\\[out\\] Pointer to the data stream
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetDataStream( BGAPI2_Device* device, bo_uint index, BGAPI2_DataStream** data_stream);
```
"""
function BGAPI2_Device_GetDataStream(device, index, data_stream)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetDataStream(device::Ptr{BGAPI2_Device}, index::bo_uint, data_stream::Ptr{Ptr{BGAPI2_DataStream}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetNumDataStreams(device, count_data_streams)

`    Device`

Returns the number of datastreams of the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `count_data_streams`:\\[out\\] Number of datastreams
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetNumDataStreams( BGAPI2_Device* device, bo_uint* count_data_streams);
```
"""
function BGAPI2_Device_GetNumDataStreams(device, count_data_streams)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetNumDataStreams(device::Ptr{BGAPI2_Device}, count_data_streams::Ptr{bo_uint})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_Close(device)

`    Device`

Closes a device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
# See also
[`BGAPI2_Device_Open`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_Close(BGAPI2_Device* device);
```
"""
function BGAPI2_Device_Close(device)
    @ccall libbgapi2_genicam.BGAPI2_Device_Close(device::Ptr{BGAPI2_Device})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetNode(device, name, node)

`    Device`

Get a named node of the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `name`:\\[in\\] Node name
* `node`:\\[out\\] Pointer to store node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetNode( BGAPI2_Device* device, const char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_Device_GetNode(device, name, node)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetNode(device::Ptr{BGAPI2_Device}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetNodeTree(device, node_tree)

`    Device`

Get the node tree of the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `node_tree`:\\[out\\] Pointer to store node tree
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetNodeTree( BGAPI2_Device* device, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_Device_GetNodeTree(device, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetNodeTree(device::Ptr{BGAPI2_Device}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetNodeList(device, node_list)

`    Device`

Get the node list of the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `node_list`:\\[out\\] Pointer to store node list
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetNodeList( BGAPI2_Device* device, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_Device_GetNodeList(device, node_list)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetNodeList(device::Ptr{BGAPI2_Device}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_SetDeviceEventMode(device, event_mode)

`    Device`

Set the device event mode (polling, callback, off)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `event_mode`:\\[in\\] Event mode for device events
# See also
[`BGAPI2_EventMode`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_SetDeviceEventMode( BGAPI2_Device* device, BGAPI2_EventMode event_mode);
```
"""
function BGAPI2_Device_SetDeviceEventMode(device, event_mode)
    @ccall libbgapi2_genicam.BGAPI2_Device_SetDeviceEventMode(device::Ptr{BGAPI2_Device}, event_mode::BGAPI2_EventMode)::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetDeviceEventMode(device, event_mode)

`    Device`

Get the device event mode (polling, callback, off)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `event_mode`:\\[out\\] Event mode of device events
# See also
[`BGAPI2_EventMode`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetDeviceEventMode( BGAPI2_Device* device, BGAPI2_EventMode* event_mode);
```
"""
function BGAPI2_Device_GetDeviceEventMode(device, event_mode)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetDeviceEventMode(device::Ptr{BGAPI2_Device}, event_mode::Ptr{BGAPI2_EventMode})::BGAPI2_RESULT
end

"""
    BGAPI2_CreateDeviceEvent(device_event)

`    Device`

Creates a structure to store device events retrieved via [`BGAPI2_Device_GetDeviceEvent`](@ref)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device_event`:\\[in,out\\] Pointer to a struct which can store events
# See also
[`BGAPI2_Device_GetDeviceEvent`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_CreateDeviceEvent(BGAPI2_DeviceEvent** device_event);
```
"""
function BGAPI2_CreateDeviceEvent(device_event)
    @ccall libbgapi2_genicam.BGAPI2_CreateDeviceEvent(device_event::Ptr{Ptr{BGAPI2_DeviceEvent}})::BGAPI2_RESULT
end

"""
    BGAPI2_ReleaseDeviceEvent(device_event)

`    Device`

Destroys a device event structure

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device_event`:\\[in\\] Pointer to a event struct
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ReleaseDeviceEvent(BGAPI2_DeviceEvent* device_event);
```
"""
function BGAPI2_ReleaseDeviceEvent(device_event)
    @ccall libbgapi2_genicam.BGAPI2_ReleaseDeviceEvent(device_event::Ptr{BGAPI2_DeviceEvent})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetDeviceEvent(device, device_event, timeout)

`    Device`

Polls for event information until timeout is reached

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR 

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `device_event`:\\[in\\] Pointer for events structure created with [`BGAPI2_CreateDeviceEvent`](@ref)
* `timeout`:\\[in\\] Maximum time to wait for events, if set to -1 wait indefinitely
# See also
[`BGAPI2_EventMode`](@ref), [`BGAPI2_CreateDeviceEvent`](@ref), [`BGAPI2_Device_CancelGetDeviceEvent`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetDeviceEvent( BGAPI2_Device* device, BGAPI2_DeviceEvent* device_event, bo_uint64 timeout);
```
"""
function BGAPI2_Device_GetDeviceEvent(device, device_event, timeout)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetDeviceEvent(device::Ptr{BGAPI2_Device}, device_event::Ptr{BGAPI2_DeviceEvent}, timeout::bo_uint64)::BGAPI2_RESULT
end

"""
    BGAPI2_Device_CancelGetDeviceEvent(device)

`    Device`

Cancels a running [`BGAPI2_Device_GetDeviceEvent`](@ref)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_CancelGetDeviceEvent(BGAPI2_Device* device);
```
"""
function BGAPI2_Device_CancelGetDeviceEvent(device)
    @ccall libbgapi2_genicam.BGAPI2_Device_CancelGetDeviceEvent(device::Ptr{BGAPI2_Device})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_RegisterDeviceEventHandler(device, callback_owner, device_event_handler)

`    Device`

Register one callback function to handle all device events of the interface

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Could not start event thread

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\todo check... what is the callback owner???

# Arguments
* `device`:\\[in\\] Pointer to the device
* `callback_owner`:\\[in\\] Data, context pointer for use in callback function
* `device_event_handler`:\\[in\\] Pointer to callback function from type [`BGAPI2_DevEventHandler`](@ref)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_RegisterDeviceEventHandler( BGAPI2_Device* device, void* callback_owner, BGAPI2_DevEventHandler device_event_handler);
```
"""
function BGAPI2_Device_RegisterDeviceEventHandler(device, callback_owner, device_event_handler)
    @ccall libbgapi2_genicam.BGAPI2_Device_RegisterDeviceEventHandler(device::Ptr{BGAPI2_Device}, callback_owner::Ptr{Cvoid}, device_event_handler::BGAPI2_DevEventHandler)::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetPayloadSize(device, payload_size)

`    Device`

Returns the payload size in bytes, used to allocate image buffers

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `payload_size`:\\[out\\] Pointer to payload size in bytes
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetPayloadSize( BGAPI2_Device* device, bo_uint64* payload_size);
```
"""
function BGAPI2_Device_GetPayloadSize(device, payload_size)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetPayloadSize(device::Ptr{BGAPI2_Device}, payload_size::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetRemoteNode(device, name, node)

`    Device`

Get the named node of given remote device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no node found)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for not opened device

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `name`:\\[in\\] Node name
* `node`:\\[out\\] Pointer to store the node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetRemoteNode( BGAPI2_Device* device, const char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_Device_GetRemoteNode(device, name, node)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetRemoteNode(device::Ptr{BGAPI2_Device}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetRemoteNodeTree(device, node_tree)

`    Device`

Get the update node tree of the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for not opened device

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `node_tree`:\\[out\\] Pointer to store the node tree
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetRemoteNodeTree( BGAPI2_Device* device, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_Device_GetRemoteNodeTree(device, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetRemoteNodeTree(device::Ptr{BGAPI2_Device}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetRemoteNodeList(device, node_list)

`    Device`

Get the update node list of the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for not opened device

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `node_list`:\\[out\\] Pointer to store the node list
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetRemoteNodeList( BGAPI2_Device* device, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_Device_GetRemoteNodeList(device, node_list)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetRemoteNodeList(device::Ptr{BGAPI2_Device}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetID(device, ID, string_length)

`    Device`

Returns the identifier of device, can be called on a device which is not open

The BGAPI2 C-Interface utilizes a two step process for the retrieval of strings.

\\_\\_1. Get the size of the string:\\_\\_ For the first call to [`BGAPI2_Device_GetID`](@ref), you need to supply the function with an null-pointer for the parameter ID. In this case the function will return you the size of the ID. You can now use this size to set up the pointer with the right size.

\\_\\_2. Get the actual ID string:\\_\\_ Now you can supply the function with the right sized pointer you created for the ID. In that case, the function will return the ID into your provided memory pointer.

Alternatively, to save the extra call to get the size, you can supply the function with a larger memory pointer than required (e.g. 1024 byte).

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to device
* `ID`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetID( BGAPI2_Device* device, char* ID, bo_uint64* string_length);
```
"""
function BGAPI2_Device_GetID(device, ID, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetID(device::Ptr{BGAPI2_Device}, ID::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetVendor(device, vendor, string_length)

`    Device`

Returns the vendor of device, can be called on a device which is not open

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `vendor`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Device_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetVendor( BGAPI2_Device* device, char* vendor, bo_uint64* string_length);
```
"""
function BGAPI2_Device_GetVendor(device, vendor, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetVendor(device::Ptr{BGAPI2_Device}, vendor::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetModel(device, model, string_length)

`    Device`

Returns the name (model) of the device, can be called on a device which is not open

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `model`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Device_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetModel( BGAPI2_Device* device, char* model, bo_uint64* string_length);
```
"""
function BGAPI2_Device_GetModel(device, model, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetModel(device::Ptr{BGAPI2_Device}, model::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetSerialNumber(device, serial_number, string_length)

`    Device`

Returns the serial number of device, can be called on a device which is not open

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `serial_number`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Device_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetSerialNumber( BGAPI2_Device* device, char* serial_number, bo_uint64* string_length);
```
"""
function BGAPI2_Device_GetSerialNumber(device, serial_number, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetSerialNumber(device::Ptr{BGAPI2_Device}, serial_number::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetTLType(device, tl_type, string_length)

`    Device`

Returns the transport layer of device, can be called on a device which is not open

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `tl_type`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Device_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetTLType( BGAPI2_Device* device, char* tl_type, bo_uint64* string_length);
```
"""
function BGAPI2_Device_GetTLType(device, tl_type, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetTLType(device::Ptr{BGAPI2_Device}, tl_type::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetDisplayName(device, display_name, string_length)

`    Device`

Returns the "user friendly" display name of device, can be called on a device which is not open

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `display_name`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Device_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetDisplayName( BGAPI2_Device* device, char* display_name, bo_uint64* string_length);
```
"""
function BGAPI2_Device_GetDisplayName(device, display_name, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetDisplayName(device::Ptr{BGAPI2_Device}, display_name::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetAccessStatus(device, access_status, string_length)

`    Device`

Returns the access state of device, can be called on a device which is not open

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `access_status`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of access status string (including string end zero)
# See also
[`BGAPI2_Device_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetAccessStatus( BGAPI2_Device* device, char* access_status, bo_uint64* string_length);
```
"""
function BGAPI2_Device_GetAccessStatus(device, access_status, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetAccessStatus(device::Ptr{BGAPI2_Device}, access_status::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetRemoteConfigurationFile(device, config_file, string_length)

`    Device`

Returns the configuration file (xml) of the remote device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no remote device)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error device not opened

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `config_file`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetRemoteConfigurationFile( BGAPI2_Device* device, char* config_file, bo_uint64* string_length);
```
"""
function BGAPI2_Device_GetRemoteConfigurationFile(device, config_file, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetRemoteConfigurationFile(device::Ptr{BGAPI2_Device}, config_file::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_SetRemoteConfigurationFile(device, config_file)

`    Device`

Sets a configuration file (xml) to use with the attached remote device (camera)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_RESOURCE_IN_USE Error device is opened

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `config_file`:\\[in\\] Configuration file
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_SetRemoteConfigurationFile( BGAPI2_Device* device, const char* config_file);
```
"""
function BGAPI2_Device_SetRemoteConfigurationFile(device, config_file)
    @ccall libbgapi2_genicam.BGAPI2_Device_SetRemoteConfigurationFile(device::Ptr{BGAPI2_Device}, config_file::Cstring)::BGAPI2_RESULT
end

"""
    BGAPI2_Device_StartStacking(device, replace_mode)

`    Device`

Starts a stack of feature writes to the device (caching write operations).

If many features are written to the device, this becomes slow as each write is acknowledged by the device. The feature stacking will send many commands at once and therefore reduces the round trip times

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (remote device not opened)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for not opened device

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `replace_mode`:\\[in\\] True to enable combining of writes to the same register on the device
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_StartStacking( BGAPI2_Device* device, bo_bool replace_mode);
```
"""
function BGAPI2_Device_StartStacking(device, replace_mode)
    @ccall libbgapi2_genicam.BGAPI2_Device_StartStacking(device::Ptr{BGAPI2_Device}, replace_mode::bo_bool)::BGAPI2_RESULT
end

"""
    BGAPI2_Device_WriteStack(device)

`    Device`

End the stacking and write all features to the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (remote device not opened)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for not opened device

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\retvalBGAPI2_RESULT_NO_DATA The stacked mode is not started or stack is empty.

# Arguments
* `device`:\\[in\\] Pointer to the device
# See also
[`BGAPI2_Device_StartStacking`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_WriteStack(BGAPI2_Device* device);
```
"""
function BGAPI2_Device_WriteStack(device)
    @ccall libbgapi2_genicam.BGAPI2_Device_WriteStack(device::Ptr{BGAPI2_Device})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_CancelStack(device)

`    Device`

End the stacking without writing features to the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (remote device not opened)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for not opened device

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
# See also
[`BGAPI2_Device_StartStacking`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_CancelStack(BGAPI2_Device* device);
```
"""
function BGAPI2_Device_CancelStack(device)
    @ccall libbgapi2_genicam.BGAPI2_Device_CancelStack(device::Ptr{BGAPI2_Device})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_IsUpdateModeAvailable(device, is_available)

`    Device`

Checks for availability of update state of device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `is_available`:\\[out\\] Pointer for open state of device
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_IsUpdateModeAvailable( BGAPI2_Device* device, bo_bool* is_available);
```
"""
function BGAPI2_Device_IsUpdateModeAvailable(device, is_available)
    @ccall libbgapi2_genicam.BGAPI2_Device_IsUpdateModeAvailable(device::Ptr{BGAPI2_Device}, is_available::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_IsUpdateModeActive(device, is_active)

`    Device`

Returns the update mode state of device.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `is_active`:\\[out\\] Pointer to get update mode state
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_IsUpdateModeActive( BGAPI2_Device* device, bo_bool* is_active);
```
"""
function BGAPI2_Device_IsUpdateModeActive(device, is_active)
    @ccall libbgapi2_genicam.BGAPI2_Device_IsUpdateModeActive(device::Ptr{BGAPI2_Device}, is_active::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_SetUpdateMode(device, update_mode, custom_key)

`    Device`

Set the update mode state of device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_RESOURCE_IN_USE Update mode is not enabled

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for not opened device

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Update mode is not available

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `update_mode`:\\[in\\] Update mode state to set
* `custom_key`:\\[in\\] Custom key for security
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_SetUpdateMode( BGAPI2_Device* device, bo_bool update_mode, const char* custom_key);
```
"""
function BGAPI2_Device_SetUpdateMode(device, update_mode, custom_key)
    @ccall libbgapi2_genicam.BGAPI2_Device_SetUpdateMode(device::Ptr{BGAPI2_Device}, update_mode::bo_bool, custom_key::Cstring)::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetUpdateNode(device, name, node)

`    Device`

Get the named node of the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no node found)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error update mode is not set

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `name`:\\[in\\] Node name
* `node`:\\[out\\] Pointer to store node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetUpdateNode( BGAPI2_Device* device, const char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_Device_GetUpdateNode(device, name, node)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetUpdateNode(device::Ptr{BGAPI2_Device}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetUpdateNodeTree(device, node_tree)

`    Device`

Get the update node tree of the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED The Device object is not open or the update plugin is not present.

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `node_tree`:\\[out\\] Update node map of device
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetUpdateNodeTree( BGAPI2_Device* device, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_Device_GetUpdateNodeTree(device, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetUpdateNodeTree(device::Ptr{BGAPI2_Device}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetUpdateNodeList(device, node_list)

`    Device`

Get the update node list of the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED The Device object is not open or the update plugin is not present.

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `node_list`:\\[out\\] Update node map of device
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetUpdateNodeList( BGAPI2_Device* device, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_Device_GetUpdateNodeList(device, node_list)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetUpdateNodeList(device::Ptr{BGAPI2_Device}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetUpdateConfigurationFile(device, config_file, string_length)

`    Device`

Returns the configuration file (xml) of the update device.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error update mode is not set

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `config_file`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetUpdateConfigurationFile( BGAPI2_Device* device, char* config_file, bo_uint64* string_length);
```
"""
function BGAPI2_Device_GetUpdateConfigurationFile(device, config_file, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetUpdateConfigurationFile(device::Ptr{BGAPI2_Device}, config_file::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_GetParent(device, parent)

`    Device`

Returns the parent object (interface) of the device

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `parent`:\\[out\\] The parent object
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_GetParent( BGAPI2_Device* device, BGAPI2_Interface** parent);
```
"""
function BGAPI2_Device_GetParent(device, parent)
    @ccall libbgapi2_genicam.BGAPI2_Device_GetParent(device::Ptr{BGAPI2_Device}, parent::Ptr{Ptr{BGAPI2_Interface}})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_WriteMemory(device, address, length, buffer)

`    Device`

Write access to the device register

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error update mode is not set

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `address`:\\[in\\] The start address to write to.
* `length`:\\[in\\] The length to write.
* `buffer`:\\[in\\] The data to write.
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_WriteMemory( BGAPI2_Device* device, bo_uint64 address, bo_uint64 length, void* buffer);
```
"""
function BGAPI2_Device_WriteMemory(device, address, length, buffer)
    @ccall libbgapi2_genicam.BGAPI2_Device_WriteMemory(device::Ptr{BGAPI2_Device}, address::bo_uint64, length::bo_uint64, buffer::Ptr{Cvoid})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_ReadMemory(device, address, length, buffer)

`    Device`

Read access to the device register

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error update mode is not set

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device`:\\[in\\] Pointer to the device
* `address`:\\[in\\] The start address to read from.
* `length`:\\[in\\] The length to read.
* `buffer`:\\[out\\] The data from the device memory.
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Device_ReadMemory( BGAPI2_Device* device, bo_uint64 address, bo_uint64 length, void* buffer);
```
"""
function BGAPI2_Device_ReadMemory(device, address, length, buffer)
    @ccall libbgapi2_genicam.BGAPI2_Device_ReadMemory(device::Ptr{BGAPI2_Device}, address::bo_uint64, length::bo_uint64, buffer::Ptr{Cvoid})::BGAPI2_RESULT
end

"""
    BGAPI2_Device_SetSerialPort(device, uartname, comportname)

`    Device`

made a virtual connection from cam uart port to pc comport

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Missing cam genicam feature(s)

\\retvalBGAPI2_RESULT_NOT_IMPLEMENTED Can't configure serial port

\\retvalBGAPI2_RESULT_OBJECT_INVALID Internal object is invalid

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error on open com port, no device

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Error on configure com port

# Arguments
* `device`:\\[in\\] Pointer to the device
* `uartname`:\\[in\\] enumvalue of boSerialSelector
* `comportname`:\\[in\\] os specific name of pc comport
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2_Device_SetSerialPort( BGAPI2_Device* device, char * uartname, char * comportname);
```
"""
function BGAPI2_Device_SetSerialPort(device, uartname, comportname)
    @ccall libbgapi2_genicam.BGAPI2_Device_SetSerialPort(device::Ptr{BGAPI2_Device}, uartname::Cstring, comportname::Cstring)::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetInterface(node, iface, string_length)

`    Node`

Returns the data type (interface) of the node

The BGAPI2 C-Interface utilizes a two step process for the retrieval of strings.

\\_\\_1. Get the size of the string:\\_\\_ For the first call to [`BGAPI2_Node_GetInterface`](@ref), you need to supply the function with an null-pointer for the parameter interface. In this case the function will return you the size of the interface. You can now use this size to set up the pointer with the right size.

\\_\\_2. Get the actual interface string:\\_\\_ Now you can supply the function with the right sized pointer you created for the interface. In that case, the function will return the interface into your provided memory pointer.

Alternatively, to save the extra call to get the size, you can supply the function with a larger memory pointer than required (e.g. 1024 byte).

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `iface`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetInterface( BGAPI2_Node* node, char* iface, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetInterface(node, iface, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetInterface(node::Ptr{BGAPI2_Node}, iface::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetExtension(node, extension, string_length)

`    Node`

Returns the extension (vendor specific information) of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `extension`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetExtension( BGAPI2_Node* node, char* extension, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetExtension(node, extension, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetExtension(node::Ptr{BGAPI2_Node}, extension::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetToolTip(node, tool_tip, string_length)

`    Node`

Returns the tooltip of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `tool_tip`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetToolTip( BGAPI2_Node* node, char* tool_tip, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetToolTip(node, tool_tip, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetToolTip(node::Ptr{BGAPI2_Node}, tool_tip::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetDescription(node, description, string_length)

`    Node`

Returns the description of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `description`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetDescription( BGAPI2_Node* node, char* description, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetDescription(node, description, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetDescription(node::Ptr{BGAPI2_Node}, description::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetName(node, name, string_length)

`    Node`

Returns the name of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `name`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetName( BGAPI2_Node* node, char* name, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetName(node, name, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetName(node::Ptr{BGAPI2_Node}, name::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetDisplayname(node, display_name, string_length)

`    Node`

Returns the "user friendly" display name of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `display_name`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetDisplayname( BGAPI2_Node* node, char* display_name, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetDisplayname(node, display_name, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetDisplayname(node::Ptr{BGAPI2_Node}, display_name::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetVisibility(node, visibility, string_length)

`    Node`

Returns the visibility of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `visibility`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetVisibility( BGAPI2_Node* node, char* visibility, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetVisibility(node, visibility, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetVisibility(node::Ptr{BGAPI2_Node}, visibility::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetEventID(node, event_id)

`    Node`

Returns the event identifier of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `event_id`:\\[out\\] Pointer to store the event identifier
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetEventID(BGAPI2_Node* node, bo_int64* event_id);
```
"""
function BGAPI2_Node_GetEventID(node, event_id)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetEventID(node::Ptr{BGAPI2_Node}, event_id::Ptr{bo_int64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetImplemented(node, is_implemented)

`    Node`

Returns the implemented state of node.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `is_implemented`:\\[out\\] Pointer to store the implemented state of node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetImplemented(BGAPI2_Node* node, bo_bool* is_implemented);
```
"""
function BGAPI2_Node_GetImplemented(node, is_implemented)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetImplemented(node::Ptr{BGAPI2_Node}, is_implemented::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetAvailable(node, is_available)

`    Node`

Returns the availability state of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `is_available`:\\[out\\] Pointer to store the availability state of node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetAvailable(BGAPI2_Node* node, bo_bool* is_available);
```
"""
function BGAPI2_Node_GetAvailable(node, is_available)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetAvailable(node::Ptr{BGAPI2_Node}, is_available::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetLocked(node, is_locked)

`    Node`

Returns the locked state of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `is_locked`:\\[out\\] Pointer to store the locked state of node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetLocked(BGAPI2_Node* node, bo_bool* is_locked);
```
"""
function BGAPI2_Node_GetLocked(node, is_locked)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetLocked(node::Ptr{BGAPI2_Node}, is_locked::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetImposedAccessMode(node, imposed_access_mode, string_length)

`    Node`

Returns the imposed access mode of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `imposed_access_mode`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetImposedAccessMode( BGAPI2_Node* node, char* imposed_access_mode, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetImposedAccessMode(node, imposed_access_mode, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetImposedAccessMode(node::Ptr{BGAPI2_Node}, imposed_access_mode::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetCurrentAccessMode(node, current_access_mode, string_length)

`    Node`

Returns the current access mode of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `current_access_mode`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetCurrentAccessMode( BGAPI2_Node* node, char* current_access_mode, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetCurrentAccessMode(node, current_access_mode, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetCurrentAccessMode(node::Ptr{BGAPI2_Node}, current_access_mode::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_IsReadable(node, is_readable)

`    Node`

Returns the readability state of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `is_readable`:\\[out\\] Pointer to store the readability state of node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_IsReadable(BGAPI2_Node* node, bo_bool* is_readable);
```
"""
function BGAPI2_Node_IsReadable(node, is_readable)
    @ccall libbgapi2_genicam.BGAPI2_Node_IsReadable(node::Ptr{BGAPI2_Node}, is_readable::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_IsWriteable(node, is_writable)

`    Node`

Returns the writeability state of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `is_writable`:\\[out\\] Pointer to store the writeability state of node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_IsWriteable(BGAPI2_Node* node, bo_bool* is_writable);
```
"""
function BGAPI2_Node_IsWriteable(node, is_writable)
    @ccall libbgapi2_genicam.BGAPI2_Node_IsWriteable(node::Ptr{BGAPI2_Node}, is_writable::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetAlias(node, alias, string_length)

`    Node`

Returns the alias name of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `alias`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetAlias( BGAPI2_Node* node, char* alias, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetAlias(node, alias, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetAlias(node::Ptr{BGAPI2_Node}, alias::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetValue(node, value, string_length)

`    Node`

Returns the value of node as a string

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `value`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetValue( BGAPI2_Node* node, char* value, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetValue(node, value, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetValue(node::Ptr{BGAPI2_Node}, value::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_SetValue(node, value)

`    Node`

Sets a string value to a node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `value`:\\[in\\] Pointer to the value to be written
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_SetValue(BGAPI2_Node* node, const char* value);
```
"""
function BGAPI2_Node_SetValue(node, value)
    @ccall libbgapi2_genicam.BGAPI2_Node_SetValue(node::Ptr{BGAPI2_Node}, value::Cstring)::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetRepresentation(node, representation, string_length)

`    Node`

Returns the representation of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `representation`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetRepresentation( BGAPI2_Node* node, char* representation, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetRepresentation(node, representation, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetRepresentation(node::Ptr{BGAPI2_Node}, representation::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetIntMin(node, min)

`    Node`

Returns the minimal integer value of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `min`:\\[out\\] Pointer to store the minimal integer value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetIntMin(BGAPI2_Node* node, bo_int64* min);
```
"""
function BGAPI2_Node_GetIntMin(node, min)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetIntMin(node::Ptr{BGAPI2_Node}, min::Ptr{bo_int64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetIntMax(node, max)

`    Node`

Returns the maximum integer value of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `max`:\\[out\\] Pointer to store the maximum integer value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetIntMax(BGAPI2_Node* node, bo_int64* max);
```
"""
function BGAPI2_Node_GetIntMax(node, max)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetIntMax(node::Ptr{BGAPI2_Node}, max::Ptr{bo_int64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetIntInc(node, inc)

`    Node`

Returns the integer increment value of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `inc`:\\[out\\] Pointer to store the integer increment value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetIntInc(BGAPI2_Node* node, bo_int64* inc);
```
"""
function BGAPI2_Node_GetIntInc(node, inc)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetIntInc(node::Ptr{BGAPI2_Node}, inc::Ptr{bo_int64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetInt(node, value)

`    Node`

Returns the integer value of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `value`:\\[out\\] Pointer to store the integer value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetInt(BGAPI2_Node* node, bo_int64* value);
```
"""
function BGAPI2_Node_GetInt(node, value)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetInt(node::Ptr{BGAPI2_Node}, value::Ptr{bo_int64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_SetInt(node, value)

`    Node`

Sets the integer value of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `value`:\\[in\\] Integer value for node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_SetInt(BGAPI2_Node* node, bo_int64 value);
```
"""
function BGAPI2_Node_SetInt(node, value)
    @ccall libbgapi2_genicam.BGAPI2_Node_SetInt(node::Ptr{BGAPI2_Node}, value::bo_int64)::BGAPI2_RESULT
end

"""
    BGAPI2_Node_HasUnit(node, has_unit)

`    Node`

Returns the availability of a unit for the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `has_unit`:\\[out\\] Pointer to store the availability of a unit for the node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_HasUnit(BGAPI2_Node* node, bo_bool* has_unit);
```
"""
function BGAPI2_Node_HasUnit(node, has_unit)
    @ccall libbgapi2_genicam.BGAPI2_Node_HasUnit(node::Ptr{BGAPI2_Node}, has_unit::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetUnit(node, unit, string_length)

`    Node`

Returns the unit of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `unit`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetUnit( BGAPI2_Node* node, char* unit, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetUnit(node, unit, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetUnit(node::Ptr{BGAPI2_Node}, unit::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetDoubleMin(node, min)

`    Node`

Returns the minimal double value of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `min`:\\[out\\] Pointer to store the minimal double value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetDoubleMin(BGAPI2_Node* node, bo_double* min);
```
"""
function BGAPI2_Node_GetDoubleMin(node, min)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetDoubleMin(node::Ptr{BGAPI2_Node}, min::Ptr{bo_double})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetDoubleMax(node, max)

`    Node`

Returns the maximum double value of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `max`:\\[out\\] Pointer to store the maximum double value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetDoubleMax(BGAPI2_Node* node, bo_double* max);
```
"""
function BGAPI2_Node_GetDoubleMax(node, max)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetDoubleMax(node::Ptr{BGAPI2_Node}, max::Ptr{bo_double})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetDoubleInc(node, inc)

`    Node`

Returns the double increment value of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `inc`:\\[out\\] Pointer to store the double increment value
# See also
[`BGAPI2_Node_HasInc`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetDoubleInc(BGAPI2_Node* node, bo_double* inc);
```
"""
function BGAPI2_Node_GetDoubleInc(node, inc)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetDoubleInc(node::Ptr{BGAPI2_Node}, inc::Ptr{bo_double})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_HasInc(node, has_inc)

`    Node`

Returns the availability of an increment value of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `has_inc`:\\[out\\] Pointer to store the availability of increment value unit
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_HasInc(BGAPI2_Node* node, bo_bool* has_inc);
```
"""
function BGAPI2_Node_HasInc(node, has_inc)
    @ccall libbgapi2_genicam.BGAPI2_Node_HasInc(node::Ptr{BGAPI2_Node}, has_inc::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetDoublePrecision(node, prec)

`    Node`

Returns the double precision value of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `prec`:\\[out\\] Pointer to store the double precision value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetDoublePrecision(BGAPI2_Node* node, bo_uint64* prec);
```
"""
function BGAPI2_Node_GetDoublePrecision(node, prec)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetDoublePrecision(node::Ptr{BGAPI2_Node}, prec::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetDouble(node, value)

`    Node`

Returns the double value of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `value`:\\[out\\] Pointer to store the double value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetDouble(BGAPI2_Node* node, bo_double* value);
```
"""
function BGAPI2_Node_GetDouble(node, value)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetDouble(node::Ptr{BGAPI2_Node}, value::Ptr{bo_double})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_SetDouble(node, value)

`    Node`

Sets the double value of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `value`:\\[in\\] New double value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_SetDouble(BGAPI2_Node* node, bo_double value);
```
"""
function BGAPI2_Node_SetDouble(node, value)
    @ccall libbgapi2_genicam.BGAPI2_Node_SetDouble(node::Ptr{BGAPI2_Node}, value::bo_double)::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetMaxStringLength(node, max_string_length)

`    Node`

Returns the maximum string length value of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `max_string_length`:\\[out\\] Pointer to store the maximum string length value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetMaxStringLength( BGAPI2_Node* node, bo_int64* max_string_length);
```
"""
function BGAPI2_Node_GetMaxStringLength(node, max_string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetMaxStringLength(node::Ptr{BGAPI2_Node}, max_string_length::Ptr{bo_int64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetString(node, value, string_length)

`    Node`

Returns the string value of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `value`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_Node_GetInterface`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetString( BGAPI2_Node* node, char* value, bo_uint64* string_length);
```
"""
function BGAPI2_Node_GetString(node, value, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetString(node::Ptr{BGAPI2_Node}, value::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_SetString(node, value)

`    Node`

Sets the string value of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `value`:\\[in\\] String value to set
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_SetString(BGAPI2_Node* node, const char* value);
```
"""
function BGAPI2_Node_SetString(node, value)
    @ccall libbgapi2_genicam.BGAPI2_Node_SetString(node::Ptr{BGAPI2_Node}, value::Cstring)::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetEnumNodeList(node, enum_node_map)

`    Node`

Gets the enumeration node map of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `enum_node_map`:\\[out\\] Pointer to store the enumeration node map
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetEnumNodeList( BGAPI2_Node* node, BGAPI2_NodeMap** enum_node_map);
```
"""
function BGAPI2_Node_GetEnumNodeList(node, enum_node_map)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetEnumNodeList(node::Ptr{BGAPI2_Node}, enum_node_map::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_Execute(node)

`    Node`

Executes the selected node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_Execute(BGAPI2_Node* node);
```
"""
function BGAPI2_Node_Execute(node)
    @ccall libbgapi2_genicam.BGAPI2_Node_Execute(node::Ptr{BGAPI2_Node})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_IsDone(node, is_done)

`    Node`

Checks if the execution of node is done

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `is_done`:\\[out\\] Pointer to store the execution done
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_IsDone(BGAPI2_Node* node, bo_bool* is_done);
```
"""
function BGAPI2_Node_IsDone(node, is_done)
    @ccall libbgapi2_genicam.BGAPI2_Node_IsDone(node::Ptr{BGAPI2_Node}, is_done::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetBool(node, value)

`    Node`

Returns the boolean value of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `value`:\\[out\\] Pointer to store the boolean value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetBool(BGAPI2_Node* node, bo_bool* value);
```
"""
function BGAPI2_Node_GetBool(node, value)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetBool(node::Ptr{BGAPI2_Node}, value::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_SetBool(node, value)

`    Node`

Sets the boolean value of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `value`:\\[in\\] A boolean value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_SetBool(BGAPI2_Node* node, bo_bool value);
```
"""
function BGAPI2_Node_SetBool(node, value)
    @ccall libbgapi2_genicam.BGAPI2_Node_SetBool(node::Ptr{BGAPI2_Node}, value::bo_bool)::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetNodeTree(node, node_tree)

`    Node`

Gets the node tree of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `node_tree`:\\[out\\] Pointer to store the node tree
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetNodeTree(BGAPI2_Node* node, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_Node_GetNodeTree(node, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetNodeTree(node::Ptr{BGAPI2_Node}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetNodeList(node, node_list)

`    Node`

Gets the node list of the node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `node_list`:\\[out\\] Pointer to store the node list with node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetNodeList(BGAPI2_Node* node, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_Node_GetNodeList(node, node_list)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetNodeList(node::Ptr{BGAPI2_Node}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_IsSelector(node, is_selector)

`    Node`

Checks if the node is an selector

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `is_selector`:\\[out\\] Pointer to store the is\\_selector value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_IsSelector(BGAPI2_Node* node, bo_bool* is_selector);
```
"""
function BGAPI2_Node_IsSelector(node, is_selector)
    @ccall libbgapi2_genicam.BGAPI2_Node_IsSelector(node::Ptr{BGAPI2_Node}, is_selector::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetSelectedFeatures(node, selected_features)

`    Node`

Returns the selected features of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `selected_features`:\\[out\\] Pointer to store the selected features
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetSelectedFeatures( BGAPI2_Node* node, BGAPI2_NodeMap** selected_features);
```
"""
function BGAPI2_Node_GetSelectedFeatures(node, selected_features)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetSelectedFeatures(node::Ptr{BGAPI2_Node}, selected_features::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetLength(node, length)

`    Node`

Returns the (data) length of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `length`:\\[out\\] Pointer to store the (data) length value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetLength(BGAPI2_Node* node, bo_int64* length);
```
"""
function BGAPI2_Node_GetLength(node, length)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetLength(node::Ptr{BGAPI2_Node}, length::Ptr{bo_int64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_GetAddress(node, address)

`    Node`

Returns the (data) address of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `address`:\\[out\\] Pointer to store the (data) address value
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_GetAddress(BGAPI2_Node* node, bo_int64* address);
```
"""
function BGAPI2_Node_GetAddress(node, address)
    @ccall libbgapi2_genicam.BGAPI2_Node_GetAddress(node::Ptr{BGAPI2_Node}, address::Ptr{bo_int64})::BGAPI2_RESULT
end

"""
    BGAPI2_Node_Get(node, buffer, length)

`    Node`

Returns the data of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `buffer`:\\[out\\] Pointer to store the data
* `length`:\\[in\\] Length of the data
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_Get(BGAPI2_Node* node, void* buffer, bo_int64 length);
```
"""
function BGAPI2_Node_Get(node, buffer, length)
    @ccall libbgapi2_genicam.BGAPI2_Node_Get(node::Ptr{BGAPI2_Node}, buffer::Ptr{Cvoid}, length::bo_int64)::BGAPI2_RESULT
end

"""
    BGAPI2_Node_Set(node, buffer, length)

`    Node`

Sets the data of node

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (no nodemap found)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node`:\\[in\\] Pointer to the node
* `buffer`:\\[in\\] Variable with data
* `length`:\\[in\\] Data length of node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Node_Set(BGAPI2_Node* node, void* buffer, bo_int64 length);
```
"""
function BGAPI2_Node_Set(node, buffer, length)
    @ccall libbgapi2_genicam.BGAPI2_Node_Set(node::Ptr{BGAPI2_Node}, buffer::Ptr{Cvoid}, length::bo_int64)::BGAPI2_RESULT
end

"""
    BGAPI2_NodeMap_GetNode(node_map, name, node)

`    NodeMap`

Gets the named node of given map

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node_map`:\\[in\\] Pointer to the nodemap
* `name`:\\[in\\] Node name
* `node`:\\[out\\] Pointer to store the node
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_NodeMap_GetNode( BGAPI2_NodeMap* node_map, const char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_NodeMap_GetNode(node_map, name, node)
    @ccall libbgapi2_genicam.BGAPI2_NodeMap_GetNode(node_map::Ptr{BGAPI2_NodeMap}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_NodeMap_GetNodeCount(node_map, count)

`    NodeMap`

Returns the number of nodes in nodemap

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node_map`:\\[in\\] Pointer to the nodemap
* `count`:\\[out\\] Pointer to store the node count
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_NodeMap_GetNodeCount(BGAPI2_NodeMap* node_map, bo_uint64* count);
```
"""
function BGAPI2_NodeMap_GetNodeCount(node_map, count)
    @ccall libbgapi2_genicam.BGAPI2_NodeMap_GetNodeCount(node_map::Ptr{BGAPI2_NodeMap}, count::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_NodeMap_GetNodeByIndex(node_map, index, node)

`    NodeMap`

Returns the node with the index

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, node with iIndex not found

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node_map`:\\[in\\] Pointer to the nodemap
* `index`:\\[in\\] Index of the node
* `node`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_NodeMap_GetNodeByIndex( BGAPI2_NodeMap* node_map, bo_uint64 index, BGAPI2_Node** node);
```
"""
function BGAPI2_NodeMap_GetNodeByIndex(node_map, index, node)
    @ccall libbgapi2_genicam.BGAPI2_NodeMap_GetNodeByIndex(node_map::Ptr{BGAPI2_NodeMap}, index::bo_uint64, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_NodeMap_GetNodePresent(node_map, name, is_present)

`    NodeMap`

Checks if node is present in nodemap

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `node_map`:\\[in\\] Pointer to the nodemap
* `name`:\\[in\\] Name of node
* `is_present`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_NodeMap_GetNodePresent( BGAPI2_NodeMap* node_map, const char* name, bo_bool* is_present);
```
"""
function BGAPI2_NodeMap_GetNodePresent(node_map, name, is_present)
    @ccall libbgapi2_genicam.BGAPI2_NodeMap_GetNodePresent(node_map::Ptr{BGAPI2_NodeMap}, name::Cstring, is_present::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_DeviceEvent_GetNode(device_event, name, node)

`    DeviceEvent`

Gets the named node of given map of interface

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device_event`:\\[in\\] Pointer to the device event
* `name`:\\[in\\] Node name
* `node`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DeviceEvent_GetNode( BGAPI2_DeviceEvent* device_event, const char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_DeviceEvent_GetNode(device_event, name, node)
    @ccall libbgapi2_genicam.BGAPI2_DeviceEvent_GetNode(device_event::Ptr{BGAPI2_DeviceEvent}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_DeviceEvent_GetNodeTree(device_event, node_tree)

`    DeviceEvent`

Gets the node map of interface (tree elements)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device_event`:\\[in\\] Pointer to the device event
* `node_tree`:\\[out\\] Pointer to store the node tree
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DeviceEvent_GetNodeTree( BGAPI2_DeviceEvent* device_event, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_DeviceEvent_GetNodeTree(device_event, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_DeviceEvent_GetNodeTree(device_event::Ptr{BGAPI2_DeviceEvent}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_DeviceEvent_GetNodeList(device_event, node_tree)

`    DeviceEvent`

Gets the node map of interface (list of entries)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device_event`:\\[in\\] Pointer to the device event
* `node_tree`:\\[out\\] Pointer to store the node tree
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DeviceEvent_GetNodeList( BGAPI2_DeviceEvent* device_event, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_DeviceEvent_GetNodeList(device_event, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_DeviceEvent_GetNodeList(device_event::Ptr{BGAPI2_DeviceEvent}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_DeviceEvent_GetName(device_event, name, string_length)

`    DeviceEvent`

Returns the name of device event

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_IMPLEMENTED No unit name on device event

\\retvalBGAPI2_RESULT_ERROR Internal error (access denied, invalid parameter, ..)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device_event`:\\[in\\] Pointer to the device event
* `name`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DeviceEvent_GetName( BGAPI2_DeviceEvent* device_event, char* name, bo_uint64* string_length);
```
"""
function BGAPI2_DeviceEvent_GetName(device_event, name, string_length)
    @ccall libbgapi2_genicam.BGAPI2_DeviceEvent_GetName(device_event::Ptr{BGAPI2_DeviceEvent}, name::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DeviceEvent_GetDisplayName(device_event, display_name, string_length)

`    DeviceEvent`

Returns the "user friendly" display name of device event

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE The display name was not included in the XML description of the event

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device_event`:\\[in\\] Pointer to the device event
* `display_name`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DeviceEvent_GetDisplayName( BGAPI2_DeviceEvent* device_event, char* display_name, bo_uint64* string_length);
```
"""
function BGAPI2_DeviceEvent_GetDisplayName(device_event, display_name, string_length)
    @ccall libbgapi2_genicam.BGAPI2_DeviceEvent_GetDisplayName(device_event::Ptr{BGAPI2_DeviceEvent}, display_name::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DeviceEvent_GetTimeStamp(device_event, time_stamp)

`    DeviceEvent`

Returns the timestamp of device event

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE No timestamp on device event of timestamp equal zero

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device_event`:\\[in\\] Pointer to the device event
* `time_stamp`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DeviceEvent_GetTimeStamp( BGAPI2_DeviceEvent* device_event, bo_uint64* time_stamp);
```
"""
function BGAPI2_DeviceEvent_GetTimeStamp(device_event, time_stamp)
    @ccall libbgapi2_genicam.BGAPI2_DeviceEvent_GetTimeStamp(device_event::Ptr{BGAPI2_DeviceEvent}, time_stamp::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DeviceEvent_GetID(device_event, ID, string_length)

`    DeviceEvent`

Returns the identifier of device event

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NO_DATA Internal error

\\retvalBGAPI2_RESULT_INVALID_BUFFER Internal error, destination buffer too small

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device_event`:\\[in\\] Pointer to the device event
* `ID`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DeviceEvent_GetID( BGAPI2_DeviceEvent* device_event, char* ID, bo_uint64* string_length);
```
"""
function BGAPI2_DeviceEvent_GetID(device_event, ID, string_length)
    @ccall libbgapi2_genicam.BGAPI2_DeviceEvent_GetID(device_event::Ptr{BGAPI2_DeviceEvent}, ID::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DeviceEvent_GetEventMemPtr(device_event, mem_ptr)

`    DeviceEvent`

This function delivers a pointer to the memory of the DeviceEvent object.

How this memory is to be interpreted depends mainly on the transport layer used and its version.

It is recommended to use the available event features instead of this function (see [`BGAPI2_DeviceEvent_GetNodeList`](@ref)).

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\retvalBGAPI2_RESULT_NO_DATA The DeviceEvent object includes no event data. Possibly no device event has been received yet.

# Arguments
* `device_event`:\\[in\\] Pointer to the device event
* `mem_ptr`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DeviceEvent_GetEventMemPtr( BGAPI2_DeviceEvent* device_event, void** mem_ptr);
```
"""
function BGAPI2_DeviceEvent_GetEventMemPtr(device_event, mem_ptr)
    @ccall libbgapi2_genicam.BGAPI2_DeviceEvent_GetEventMemPtr(device_event::Ptr{BGAPI2_DeviceEvent}, mem_ptr::Ptr{Ptr{Cvoid}})::BGAPI2_RESULT
end

"""
    BGAPI2_DeviceEvent_GetEventMemSize(device_event, buffer_size)

`    DeviceEvent`

This function delivers the size of the DeviceEvent object. Should be used in conjunction to [`BGAPI2_DeviceEvent_GetEventMemPtr`](@ref).

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `device_event`:\\[in\\] Pointer to the device event
* `buffer_size`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DeviceEvent_GetEventMemSize( BGAPI2_DeviceEvent* device_event, bo_uint64* buffer_size);
```
"""
function BGAPI2_DeviceEvent_GetEventMemSize(device_event, buffer_size)
    @ccall libbgapi2_genicam.BGAPI2_DeviceEvent_GetEventMemSize(device_event::Ptr{BGAPI2_DeviceEvent}, buffer_size::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_PnPEvent_GetSerialNumber(pnp_event, serial_number, string_length)

`    PnPEvent`

Returns the serial number of pnp event

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_BUFFER Internal error, destination buffer too small

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `pnp_event`:\\[in\\] Pointer to the pnp event
* `serial_number`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_PnPEvent_GetSerialNumber( BGAPI2_PnPEvent* pnp_event, char* serial_number, bo_uint64* string_length);
```
"""
function BGAPI2_PnPEvent_GetSerialNumber(pnp_event, serial_number, string_length)
    @ccall libbgapi2_genicam.BGAPI2_PnPEvent_GetSerialNumber(pnp_event::Ptr{BGAPI2_PnPEvent}, serial_number::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_PnPEvent_GetPnPType(pnp_event, pnp_type)

`    PnPEvent`

Returns the type of pnp event

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `pnp_event`:\\[in\\] Pointer to the pnp event
* `pnp_type`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_PnPEvent_GetPnPType( BGAPI2_PnPEvent* pnp_event, bo_uint64* pnp_type);
```
"""
function BGAPI2_PnPEvent_GetPnPType(pnp_event, pnp_type)
    @ccall libbgapi2_genicam.BGAPI2_PnPEvent_GetPnPType(pnp_event::Ptr{BGAPI2_PnPEvent}, pnp_type::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_PnPEvent_GetID(pnp_event, ID, string_length)

`    PnPEvent`

Returns the identifier of pnp event

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error, no identifier available

\\retvalBGAPI2_RESULT_INVALID_BUFFER Internal error, destination buffer too small

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `pnp_event`:\\[in\\] Pointer to the pnp event
* `ID`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_PnPEvent_GetID( BGAPI2_PnPEvent* pnp_event, char* ID, bo_uint64* string_length);
```
"""
function BGAPI2_PnPEvent_GetID(pnp_event, ID, string_length)
    @ccall libbgapi2_genicam.BGAPI2_PnPEvent_GetID(pnp_event::Ptr{BGAPI2_PnPEvent}, ID::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_CreateBuffer(buffer)

`    Buffer`

Returns a new buffer

When using this constructor, the Buffer object takes care of memory management. The required memory for this Buffer object is allocated only when it is queued in the DataStream.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[out\\] Variable for new Buffer object
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_CreateBuffer(BGAPI2_Buffer** buffer);
```
"""
function BGAPI2_CreateBuffer(buffer)
    @ccall libbgapi2_genicam.BGAPI2_CreateBuffer(buffer::Ptr{Ptr{BGAPI2_Buffer}})::BGAPI2_RESULT
end

"""
    BGAPI2_CreateBufferWithUserPtr(buffer, user_obj)

`    Buffer`

Returns a new buffer, initialized with user parameter.

When using this constructor, the Buffer object takes care of memory management. The required memory for this Buffer object is allocated only when it is queued in the DataStream.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[out\\] Variable for new Buffer object
* `user_obj`:\\[in\\] Additional user parameter to store in buffer
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_CreateBufferWithUserPtr(BGAPI2_Buffer** buffer, void* user_obj);
```
"""
function BGAPI2_CreateBufferWithUserPtr(buffer, user_obj)
    @ccall libbgapi2_genicam.BGAPI2_CreateBufferWithUserPtr(buffer::Ptr{Ptr{BGAPI2_Buffer}}, user_obj::Ptr{Cvoid})::BGAPI2_RESULT
end

"""
    BGAPI2_CreateBufferWithOptimizedSize(buffer, user_obj)

`    Buffer`

Returns a new buffer, initialized with user parameter and current payload size when added to the stream.

When using this constructor, the Buffer object takes care of memory management. The required memory for this Buffer object is allocated only when it is queued in the DataStream.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[out\\] Variable for new Buffer object
* `user_obj`:\\[in\\] Additional user parameter to store in buffer
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_CreateBufferWithOptimizedSize( BGAPI2_Buffer** buffer, void* user_obj);
```
"""
function BGAPI2_CreateBufferWithOptimizedSize(buffer, user_obj)
    @ccall libbgapi2_genicam.BGAPI2_CreateBufferWithOptimizedSize(buffer::Ptr{Ptr{BGAPI2_Buffer}}, user_obj::Ptr{Cvoid})::BGAPI2_RESULT
end

"""
    BGAPI2_CreateBufferWithExternalMemory(buffer, user_buffer, user_buffer_size, user_obj)

`    Buffer`

Returns a new buffer, initialized with user parameter and external memory

Function to create a Buffer object. When using this function, the user takes care of allocation of the required memory. To use the actual required memory size the functions [`BGAPI2_Device_GetPayloadSize`](@ref) and [`BGAPI2_DataStream_GetPayloadSize`](@ref) are used respectively. To use the maximum required memory size of a device the maximum of the PayloadSize feature is queried. See [`BGAPI2_Device_GetRemoteNode`](@ref) and [`BGAPI2_Node_GetIntMax`](@ref).

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[out\\] Variable for new Buffer object
* `user_buffer`:\\[in\\] Pointer to a user allocated data buffer.
* `user_buffer_size`:\\[in\\] The size of the user allocated data buffer
* `user_obj`:\\[in\\] Pointer to a user allocated memory
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_CreateBufferWithExternalMemory( BGAPI2_Buffer** buffer, void* user_buffer, bo_uint64 user_buffer_size, void* user_obj);
```
"""
function BGAPI2_CreateBufferWithExternalMemory(buffer, user_buffer, user_buffer_size, user_obj)
    @ccall libbgapi2_genicam.BGAPI2_CreateBufferWithExternalMemory(buffer::Ptr{Ptr{BGAPI2_Buffer}}, user_buffer::Ptr{Cvoid}, user_buffer_size::bo_uint64, user_obj::Ptr{Cvoid})::BGAPI2_RESULT
end

"""
    BGAPI2_DeleteBuffer(buffer, user_obj)

`    Buffer`

Destroys the buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

# Arguments
* `buffer`:\\[in\\] The Buffer object
* `user_obj`:\\[in\\] Pointer to a user allocated memory
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DeleteBuffer(BGAPI2_Buffer* buffer, void** user_obj);
```
"""
function BGAPI2_DeleteBuffer(buffer, user_obj)
    @ccall libbgapi2_genicam.BGAPI2_DeleteBuffer(buffer::Ptr{BGAPI2_Buffer}, user_obj::Ptr{Ptr{Cvoid}})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetNode(buffer, name, node)

`    Buffer`

Gets a node of the buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `name`:\\[in\\] Node name
* `node`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetNode( BGAPI2_Buffer* buffer, char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_Buffer_GetNode(buffer, name, node)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetNode(buffer::Ptr{BGAPI2_Buffer}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetNodeTree(buffer, node_tree)

`    Buffer`

Gets the node tree of the buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `node_tree`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetNodeTree( BGAPI2_Buffer* buffer, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_Buffer_GetNodeTree(buffer, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetNodeTree(buffer::Ptr{BGAPI2_Buffer}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetNodeList(buffer, node_list)

`    Buffer`

Gets the node list of the buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `node_list`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetNodeList( BGAPI2_Buffer* buffer, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_Buffer_GetNodeList(buffer, node_list)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetNodeList(buffer::Ptr{BGAPI2_Buffer}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetChunkNodeList(buffer, node_list)

`    Buffer`

Gets the chunk node list of given buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error, Buffer not in BufferList

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, chunk is not initialized

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `node_list`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetChunkNodeList( BGAPI2_Buffer* buffer, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_Buffer_GetChunkNodeList(buffer, node_list)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetChunkNodeList(buffer::Ptr{BGAPI2_Buffer}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetID(buffer, ID, string_length)

`    Buffer`

Returns the identifier of the buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer device infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `ID`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetID( BGAPI2_Buffer* buffer, char* ID, bo_uint64* string_length);
```
"""
function BGAPI2_Buffer_GetID(buffer, ID, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetID(buffer::Ptr{BGAPI2_Buffer}, ID::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetMemPtr(buffer, mem_ptr)

`    Buffer`

Returns the memory (data) pointer of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE The Buffer object is currently no memory allocated, because it was not queued to the DataStream. This error is returned only when using the internal memory allocation.

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `mem_ptr`:\\[out\\] Pointer to store the result
# See also
[`BGAPI2_CreateBuffer`](@ref), [`BGAPI2_CreateBufferWithUserPtr`](@ref), [`BGAPI2_CreateBufferWithOptimizedSize`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetMemPtr(BGAPI2_Buffer* buffer, void** mem_ptr);
```
"""
function BGAPI2_Buffer_GetMemPtr(buffer, mem_ptr)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetMemPtr(buffer::Ptr{BGAPI2_Buffer}, mem_ptr::Ptr{Ptr{Cvoid}})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetMemSize(buffer, buffer_size)

`    Buffer`

Returns the memory size of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE The Buffer object is currently no memory allocated, because it was not queued to the DataStream. This error is returned only when using the internal memory allocation.

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `buffer_size`:\\[out\\] Pointer to store the result
# See also
[`BGAPI2_CreateBuffer`](@ref), [`BGAPI2_CreateBufferWithUserPtr`](@ref), [`BGAPI2_CreateBufferWithOptimizedSize`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetMemSize(BGAPI2_Buffer* buffer, bo_uint64* buffer_size);
```
"""
function BGAPI2_Buffer_GetMemSize(buffer, buffer_size)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetMemSize(buffer::Ptr{BGAPI2_Buffer}, buffer_size::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetUserPtr(buffer, user)

`    Buffer`

Returns the user pointer of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `user`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetUserPtr(BGAPI2_Buffer* buffer, void** user);
```
"""
function BGAPI2_Buffer_GetUserPtr(buffer, user)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetUserPtr(buffer::Ptr{BGAPI2_Buffer}, user::Ptr{Ptr{Cvoid}})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetTimestamp(buffer, timestamp)

`    Buffer`

Delivers the timestamp of the buffer obtained by the camera

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `timestamp`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetTimestamp(BGAPI2_Buffer* buffer, bo_uint64* timestamp);
```
"""
function BGAPI2_Buffer_GetTimestamp(buffer, timestamp)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetTimestamp(buffer::Ptr{BGAPI2_Buffer}, timestamp::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetHostTimestamp(buffer, host_timestamp)

`    Buffer`

Returns the host time stamp of the first received packet of a new image using a steady clock

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `host_timestamp`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetHostTimestamp( BGAPI2_Buffer* buffer, bo_uint64* host_timestamp);
```
"""
function BGAPI2_Buffer_GetHostTimestamp(buffer, host_timestamp)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetHostTimestamp(buffer::Ptr{BGAPI2_Buffer}, host_timestamp::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetNewData(buffer, new_data)

`    Buffer`

Returns the flag for new data of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `new_data`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetNewData(BGAPI2_Buffer* buffer, bo_bool* new_data);
```
"""
function BGAPI2_Buffer_GetNewData(buffer, new_data)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetNewData(buffer::Ptr{BGAPI2_Buffer}, new_data::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetIsQueued(buffer, is_queued)

`    Buffer`

Returns the flag for queued buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `is_queued`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetIsQueued(BGAPI2_Buffer* buffer, bo_bool* is_queued);
```
"""
function BGAPI2_Buffer_GetIsQueued(buffer, is_queued)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetIsQueued(buffer::Ptr{BGAPI2_Buffer}, is_queued::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetIsAcquiring(buffer, is_acquiring)

`    Buffer`

Returns the flag for acquiring data of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `is_acquiring`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetIsAcquiring(BGAPI2_Buffer* buffer, bo_bool* is_acquiring);
```
"""
function BGAPI2_Buffer_GetIsAcquiring(buffer, is_acquiring)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetIsAcquiring(buffer::Ptr{BGAPI2_Buffer}, is_acquiring::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetIsIncomplete(buffer, is_incomplete)

`    Buffer`

Returns the flag for incomplete data of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `is_incomplete`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetIsIncomplete( BGAPI2_Buffer* buffer, bo_bool* is_incomplete);
```
"""
function BGAPI2_Buffer_GetIsIncomplete(buffer, is_incomplete)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetIsIncomplete(buffer::Ptr{BGAPI2_Buffer}, is_incomplete::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetTLType(buffer, tl_type, string_length)

`    Buffer`

Returns the transport layer of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `tl_type`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetTLType( BGAPI2_Buffer* buffer, char* tl_type, bo_uint64* string_length);
```
"""
function BGAPI2_Buffer_GetTLType(buffer, tl_type, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetTLType(buffer::Ptr{BGAPI2_Buffer}, tl_type::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetSizeFilled(buffer, size_filled)

`    Buffer`

Returns the current size of data of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `size_filled`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetSizeFilled(BGAPI2_Buffer* buffer, bo_uint64* size_filled);
```
"""
function BGAPI2_Buffer_GetSizeFilled(buffer, size_filled)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetSizeFilled(buffer::Ptr{BGAPI2_Buffer}, size_filled::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetWidth(buffer, width)

`    Buffer`

Returns the width (in pixel) of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `width`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetWidth(BGAPI2_Buffer* buffer, bo_uint64* width);
```
"""
function BGAPI2_Buffer_GetWidth(buffer, width)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetWidth(buffer::Ptr{BGAPI2_Buffer}, width::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetHeight(buffer, height)

`    Buffer`

Returns height (in pixel) of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `height`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetHeight(BGAPI2_Buffer* buffer, bo_uint64* height);
```
"""
function BGAPI2_Buffer_GetHeight(buffer, height)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetHeight(buffer::Ptr{BGAPI2_Buffer}, height::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetXOffset(buffer, offset_x)

`    Buffer`

Returns x offset (in pixel) of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `offset_x`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetXOffset(BGAPI2_Buffer* buffer, bo_uint64* offset_x);
```
"""
function BGAPI2_Buffer_GetXOffset(buffer, offset_x)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetXOffset(buffer::Ptr{BGAPI2_Buffer}, offset_x::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetYOffset(buffer, offset_y)

`    Buffer`

Returns y offset (in pixel) of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `offset_y`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetYOffset(BGAPI2_Buffer* buffer, bo_uint64* offset_y);
```
"""
function BGAPI2_Buffer_GetYOffset(buffer, offset_y)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetYOffset(buffer::Ptr{BGAPI2_Buffer}, offset_y::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetXPadding(buffer, padding_x)

`    Buffer`

Returns x padding bytes (number of extra bytes in each line) of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `padding_x`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetXPadding(BGAPI2_Buffer* buffer, bo_uint64* padding_x);
```
"""
function BGAPI2_Buffer_GetXPadding(buffer, padding_x)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetXPadding(buffer::Ptr{BGAPI2_Buffer}, padding_x::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetYPadding(buffer, padding_y)

`    Buffer`

Returns y padding bytes (number of extra bytes at image end) of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `padding_y`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetYPadding(BGAPI2_Buffer* buffer, bo_uint64* padding_y);
```
"""
function BGAPI2_Buffer_GetYPadding(buffer, padding_y)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetYPadding(buffer::Ptr{BGAPI2_Buffer}, padding_y::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetFrameID(buffer, frame_id)

`    Buffer`

Returns the frame identifier of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `frame_id`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetFrameID(BGAPI2_Buffer* buffer, bo_uint64* frame_id);
```
"""
function BGAPI2_Buffer_GetFrameID(buffer, frame_id)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetFrameID(buffer::Ptr{BGAPI2_Buffer}, frame_id::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetImagePresent(buffer, image_present)

`    Buffer`

Returns the flag for available image of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `image_present`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetImagePresent( BGAPI2_Buffer* buffer, bo_bool* image_present);
```
"""
function BGAPI2_Buffer_GetImagePresent(buffer, image_present)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetImagePresent(buffer::Ptr{BGAPI2_Buffer}, image_present::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetImageOffset(buffer, image_offset)

`    Buffer`

Returns the offset into buffer memory to begin of data of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `image_offset`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetImageOffset( BGAPI2_Buffer* buffer, bo_uint64* image_offset);
```
"""
function BGAPI2_Buffer_GetImageOffset(buffer, image_offset)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetImageOffset(buffer::Ptr{BGAPI2_Buffer}, image_offset::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetImageLength(buffer, image_length)

`    Buffer`

This function returns the length of the image in bytes starting at image offset.

Use this function if the Buffer objects contains image data.

This function works, if the Buffer object include Image or Jpeg data, with or without chunk.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE The Buffer object doesn't include Image or Jpeg data.

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetImageLength( BGAPI2_Buffer* buffer, bo_uint64* image_length);
```
"""
function BGAPI2_Buffer_GetImageLength(buffer, image_length)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetImageLength(buffer::Ptr{BGAPI2_Buffer}, image_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetPayloadType(buffer, payload_type, string_length)

`    Buffer`

Returns the payload type of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `payload_type`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetPayloadType( BGAPI2_Buffer* buffer, char* payload_type, bo_uint64* string_length);
```
"""
function BGAPI2_Buffer_GetPayloadType(buffer, payload_type, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetPayloadType(buffer::Ptr{BGAPI2_Buffer}, payload_type::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetPixelFormat(buffer, pixelformat, string_length)

`    Buffer`

Returns the payload type of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `pixelformat`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetPixelFormat( BGAPI2_Buffer* buffer, char* pixelformat, bo_uint64* string_length);
```
"""
function BGAPI2_Buffer_GetPixelFormat(buffer, pixelformat, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetPixelFormat(buffer::Ptr{BGAPI2_Buffer}, pixelformat::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetDeliveredImageHeight(buffer, delivered_image_height)

`    Buffer`

Returns the delivered image height of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `delivered_image_height`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetDeliveredImageHeight( BGAPI2_Buffer* buffer, bo_uint64* delivered_image_height);
```
"""
function BGAPI2_Buffer_GetDeliveredImageHeight(buffer, delivered_image_height)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetDeliveredImageHeight(buffer::Ptr{BGAPI2_Buffer}, delivered_image_height::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetDeliveredChunkPayloadSize(buffer, delivered_chunk_payload_size)

`    Buffer`

Returns the delivered chunk payload size of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `delivered_chunk_payload_size`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetDeliveredChunkPayloadSize( BGAPI2_Buffer* buffer, bo_uint64* delivered_chunk_payload_size);
```
"""
function BGAPI2_Buffer_GetDeliveredChunkPayloadSize(buffer, delivered_chunk_payload_size)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetDeliveredChunkPayloadSize(buffer::Ptr{BGAPI2_Buffer}, delivered_chunk_payload_size::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetContainsChunk(buffer, contains_chunk)

`    Buffer`

Returns the flag to indicating existing chunk of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `contains_chunk`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetContainsChunk( BGAPI2_Buffer* buffer, bo_bool* contains_chunk);
```
"""
function BGAPI2_Buffer_GetContainsChunk(buffer, contains_chunk)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetContainsChunk(buffer::Ptr{BGAPI2_Buffer}, contains_chunk::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetChunkLayoutID(buffer, chunk_layout_id)

`    Buffer`

Returns the chunk layout identifier size of buffer

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `chunk_layout_id`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetChunkLayoutID( BGAPI2_Buffer* buffer, bo_uint64* chunk_layout_id);
```
"""
function BGAPI2_Buffer_GetChunkLayoutID(buffer, chunk_layout_id)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetChunkLayoutID(buffer::Ptr{BGAPI2_Buffer}, chunk_layout_id::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetFileName(buffer, file_name, string_length)

`    Buffer`

Returns the filename of buffer (only for payload type = file)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `file_name`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetFileName( BGAPI2_Buffer* buffer, char* file_name, bo_uint64* string_length);
```
"""
function BGAPI2_Buffer_GetFileName(buffer, file_name, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetFileName(buffer::Ptr{BGAPI2_Buffer}, file_name::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Buffer_GetParent(buffer, parent)

`    Buffer`

Returns the parent object (data stream) which belongs to

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `buffer`:\\[in\\] Pointer to the buffer
* `parent`:\\[out\\] Pointer to store the result. NULL if the buffer was revoked from the data stream.
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Buffer_GetParent( BGAPI2_Buffer* buffer, BGAPI2_DataStream** parent);
```
"""
function BGAPI2_Buffer_GetParent(buffer, parent)
    @ccall libbgapi2_genicam.BGAPI2_Buffer_GetParent(buffer::Ptr{BGAPI2_Buffer}, parent::Ptr{Ptr{BGAPI2_DataStream}})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_Open(data_stream)

`    DataStream`

Opens a datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Can't read producer interface infos

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream created with [`BGAPI2_Device_GetDataStream`](@ref)
# See also
[`BGAPI2_Device_GetDataStream`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_Open(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_Open(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_Open(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_Close(data_stream)

`    DataStream`

Closes a datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error (init failed, data stream not opened)

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_Close(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_Close(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_Close(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_IsOpen(data_stream, is_open)

`    DataStream`

Checks if the data stream is opened

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Producer not initialized

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `is_open`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_IsOpen(BGAPI2_DataStream* data_stream, bo_bool* is_open);
```
"""
function BGAPI2_DataStream_IsOpen(data_stream, is_open)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_IsOpen(data_stream::Ptr{BGAPI2_DataStream}, is_open::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetNode(data_stream, name, node)

`    DataStream`

Gets the named node of given datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `name`:\\[in\\] Node name
* `node`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetNode( BGAPI2_DataStream* data_stream, const char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_DataStream_GetNode(data_stream, name, node)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetNode(data_stream::Ptr{BGAPI2_DataStream}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetNodeTree(data_stream, node_tree)

`    DataStream`

Gets the node tree of given datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `node_tree`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetNodeTree( BGAPI2_DataStream* data_stream, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_DataStream_GetNodeTree(data_stream, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetNodeTree(data_stream::Ptr{BGAPI2_DataStream}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetNodeList(data_stream, node_list)

`    DataStream`

Gets the node list of given datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `node_list`:\\[out\\] Node map
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetNodeList( BGAPI2_DataStream* data_stream, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_DataStream_GetNodeList(data_stream, node_list)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetNodeList(data_stream::Ptr{BGAPI2_DataStream}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_SetNewBufferEventMode(data_stream, event_mode)

`    DataStream`

Sets the new buffer event mode. The event mode is controlled by the event register functions

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `event_mode`:\\[in\\] Event mode for new buffer events of datastream
# See also
[`BGAPI2_EventMode`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_SetNewBufferEventMode( BGAPI2_DataStream* data_stream, BGAPI2_EventMode event_mode);
```
"""
function BGAPI2_DataStream_SetNewBufferEventMode(data_stream, event_mode)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_SetNewBufferEventMode(data_stream::Ptr{BGAPI2_DataStream}, event_mode::BGAPI2_EventMode)::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetNewBufferEventMode(data_stream, event_mode)

`    DataStream`

Returns the new buffer event mode. The event mode is controlled by the event register functions

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `event_mode`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetNewBufferEventMode( BGAPI2_DataStream* data_stream, BGAPI2_EventMode* event_mode);
```
"""
function BGAPI2_DataStream_GetNewBufferEventMode(data_stream, event_mode)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetNewBufferEventMode(data_stream::Ptr{BGAPI2_DataStream}, event_mode::Ptr{BGAPI2_EventMode})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetID(data_stream, ID, string_length)

`    DataStream`

Returns the identifier of datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error, not producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `ID`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetID( BGAPI2_DataStream* data_stream, char* ID, bo_uint64* string_length);
```
"""
function BGAPI2_DataStream_GetID(data_stream, ID, string_length)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetID(data_stream::Ptr{BGAPI2_DataStream}, ID::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetNumDelivered(data_stream, num_delivered)

`    DataStream`

Returns the number of delivered buffer of datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error, not producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `num_delivered`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetNumDelivered( BGAPI2_DataStream* data_stream, bo_uint64* num_delivered);
```
"""
function BGAPI2_DataStream_GetNumDelivered(data_stream, num_delivered)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetNumDelivered(data_stream::Ptr{BGAPI2_DataStream}, num_delivered::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetNumUnderrun(data_stream, num_underrun)

`    DataStream`

Returns the number of under run buffer of datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error, not producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `num_underrun`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetNumUnderrun( BGAPI2_DataStream* data_stream, bo_uint64* num_underrun);
```
"""
function BGAPI2_DataStream_GetNumUnderrun(data_stream, num_underrun)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetNumUnderrun(data_stream::Ptr{BGAPI2_DataStream}, num_underrun::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetNumAnnounced(data_stream, num_announced)

`    DataStream`

Returns the number of announced buffer of datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error, not producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `num_announced`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetNumAnnounced( BGAPI2_DataStream* data_stream, bo_uint64* num_announced);
```
"""
function BGAPI2_DataStream_GetNumAnnounced(data_stream, num_announced)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetNumAnnounced(data_stream::Ptr{BGAPI2_DataStream}, num_announced::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetNumQueued(data_stream, num_queued)

`    DataStream`

Returns the number of queued buffer of datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error, not producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `num_queued`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetNumQueued( BGAPI2_DataStream* data_stream, bo_uint64* num_queued);
```
"""
function BGAPI2_DataStream_GetNumQueued(data_stream, num_queued)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetNumQueued(data_stream::Ptr{BGAPI2_DataStream}, num_queued::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetNumAwaitDelivery(data_stream, num_await_delivery)

`    DataStream`

Returns the number of wait for delivery buffer of datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error, not producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `num_await_delivery`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetNumAwaitDelivery( BGAPI2_DataStream* data_stream, bo_uint64* num_await_delivery);
```
"""
function BGAPI2_DataStream_GetNumAwaitDelivery(data_stream, num_await_delivery)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetNumAwaitDelivery(data_stream::Ptr{BGAPI2_DataStream}, num_await_delivery::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetNumStarted(data_stream, num_started)

`    DataStream`

Returns the number of currently filled buffer of datastream.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error, not producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `num_started`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetNumStarted( BGAPI2_DataStream* data_stream, bo_uint64* num_started);
```
"""
function BGAPI2_DataStream_GetNumStarted(data_stream, num_started)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetNumStarted(data_stream::Ptr{BGAPI2_DataStream}, num_started::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetPayloadSize(data_stream, payload_size)

`    DataStream`

Returns the size of the expected data block of this DataStream object in bytes

Based on the current device settings and including all control data (e.g. chunk header). This function is mainly used for devices which supports several data streams to allow stream based memory allocation

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error, not producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `payload_size`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetPayloadSize( BGAPI2_DataStream* data_stream, bo_uint64* payload_size);
```
"""
function BGAPI2_DataStream_GetPayloadSize(data_stream, payload_size)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetPayloadSize(data_stream::Ptr{BGAPI2_DataStream}, payload_size::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetIsGrabbing(data_stream, is_grabbing)

`    DataStream`

Returns the flag for started datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error, not producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `is_grabbing`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetIsGrabbing( BGAPI2_DataStream* data_stream, bo_bool* is_grabbing);
```
"""
function BGAPI2_DataStream_GetIsGrabbing(data_stream, is_grabbing)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetIsGrabbing(data_stream::Ptr{BGAPI2_DataStream}, is_grabbing::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetDefinesPayloadSize(data_stream, defines_payload_size)

`    DataStream`

Returns the size of the expecting data block of this DataStream object in bytes

Based on the current device settings and including all control data (e.g. chunk header). This function is mainly used for devices which supports several data streams to allow stream based memory allocation

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Internal error, not producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `defines_payload_size`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetDefinesPayloadSize( BGAPI2_DataStream* data_stream, bo_bool* defines_payload_size);
```
"""
function BGAPI2_DataStream_GetDefinesPayloadSize(data_stream, defines_payload_size)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetDefinesPayloadSize(data_stream::Ptr{BGAPI2_DataStream}, defines_payload_size::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetTLType(data_stream, tl_type, string_length)

`    DataStream`

Returns the transport layer of datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `tl_type`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetTLType( BGAPI2_DataStream* data_stream, char* tl_type, bo_uint64* string_length);
```
"""
function BGAPI2_DataStream_GetTLType(data_stream, tl_type, string_length)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetTLType(data_stream::Ptr{BGAPI2_DataStream}, tl_type::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_StartAcquisition(data_stream, num_to_acquire)

`    DataStream`

Acquires a defined number of buffers from datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `num_to_acquire`:\\[in\\] Number of buffer to acquire
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_StartAcquisition( BGAPI2_DataStream* data_stream, bo_uint64 num_to_acquire);
```
"""
function BGAPI2_DataStream_StartAcquisition(data_stream, num_to_acquire)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_StartAcquisition(data_stream::Ptr{BGAPI2_DataStream}, num_to_acquire::bo_uint64)::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_StartAcquisitionContinuous(data_stream)

`    DataStream`

Acquires buffers from datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_StartAcquisitionContinuous(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_StartAcquisitionContinuous(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_StartAcquisitionContinuous(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_StopAcquisition(data_stream)

`    DataStream`

Stop acquiring buffers from datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_StopAcquisition(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_StopAcquisition(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_StopAcquisition(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_AbortAcquisition(data_stream)

`    DataStream`

Stops the DataStream immediately. Active transmissions are aborted.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
# See also
[`BGAPI2_Buffer_GetIsIncomplete`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_AbortAcquisition(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_AbortAcquisition(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_AbortAcquisition(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_FlushInputToOutputQueue(data_stream)

`    DataStream`

Moves all Buffer objects from the input buffer queue to the output buffer queue

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
# See also
BGAPI2\\_Buffer\\_QueueBuffer, [`BGAPI2_DataStream_GetFilledBuffer`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_FlushInputToOutputQueue(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_FlushInputToOutputQueue(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_FlushInputToOutputQueue(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_FlushAllToInputQueue(data_stream)

`    DataStream`

Moves all Buffers of the Buffer list to the input buffer queue even those in the output buffer queue

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
# See also
BGAPI2\\_Buffer\\_QueueBuffer, [`BGAPI2_DataStream_GetFilledBuffer`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_FlushAllToInputQueue(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_FlushAllToInputQueue(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_FlushAllToInputQueue(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_FlushUnqueuedToInputQueue(data_stream)

`    DataStream`

Moves all free (not queued) Buffers of the Buffer list to the input buffer queue

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream is not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
# See also
BGAPI2\\_Buffer\\_QueueBuffer

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_FlushUnqueuedToInputQueue(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_FlushUnqueuedToInputQueue(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_FlushUnqueuedToInputQueue(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_DiscardOutputBuffers(data_stream)

`    DataStream`

Discard all Buffer objects in the output buffer queue. The discarded Buffer objects are freed

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream is not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_DiscardOutputBuffers(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_DiscardOutputBuffers(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_DiscardOutputBuffers(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_DiscardAllBuffers(data_stream)

`    DataStream`

Discard all Buffer objects in the input buffer queue and output buffer queue

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream is not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_DiscardAllBuffers(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_DiscardAllBuffers(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_DiscardAllBuffers(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_AnnounceBuffer(data_stream, buffer)

`    DataStream`

Adds the Buffer objects to the datastream

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream is not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `buffer`:\\[in\\] Pointer to buffer to announce
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_AnnounceBuffer( BGAPI2_DataStream* data_stream, BGAPI2_Buffer* buffer);
```
"""
function BGAPI2_DataStream_AnnounceBuffer(data_stream, buffer)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_AnnounceBuffer(data_stream::Ptr{BGAPI2_DataStream}, buffer::Ptr{BGAPI2_Buffer})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_RevokeBuffer(data_stream, buffer, user_obj)

`    DataStream`

Removes a Buffer object from the buffer list

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream is not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `buffer`:\\[in\\] Pointer to buffer to revoke
* `user_obj`:\\[out\\]
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_RevokeBuffer( BGAPI2_DataStream* data_stream, BGAPI2_Buffer* buffer, void** user_obj);
```
"""
function BGAPI2_DataStream_RevokeBuffer(data_stream, buffer, user_obj)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_RevokeBuffer(data_stream::Ptr{BGAPI2_DataStream}, buffer::Ptr{BGAPI2_Buffer}, user_obj::Ptr{Ptr{Cvoid}})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_QueueBuffer(data_stream, buffer)

`    DataStream`

Moves a Buffer object into the input buffer queue and make it available for the image acquisition

If the image acquisition is done the filled Buffer object is moved into the output buffer queue and is fetched with function [`BGAPI2_DataStream_GetFilledBuffer`](@ref). See also the functions of the BufferList, to move the Buffer object between the internal lists

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream is not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `buffer`:\\[in\\] Pointer to buffer to queue
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_QueueBuffer( BGAPI2_DataStream* data_stream, BGAPI2_Buffer* buffer);
```
"""
function BGAPI2_DataStream_QueueBuffer(data_stream, buffer)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_QueueBuffer(data_stream::Ptr{BGAPI2_DataStream}, buffer::Ptr{BGAPI2_Buffer})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetFilledBuffer(data_stream, buffer, timeout)

`    DataStream`

Fetches a new image from the DataStream object and removes it from the output buffer queue

If the output buffer queue is empty after the timeout, the function delivers NULL

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_TIMEOUT No buffer filled in iTimeout

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream is not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `buffer`:\\[in\\] Pointer to buffer to queue
* `timeout`:\\[in\\] Timeout to stop if no image is delivered from the camera, -1 means indefinitely
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetFilledBuffer( BGAPI2_DataStream* data_stream, BGAPI2_Buffer** buffer, bo_uint64 timeout);
```
"""
function BGAPI2_DataStream_GetFilledBuffer(data_stream, buffer, timeout)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetFilledBuffer(data_stream::Ptr{BGAPI2_DataStream}, buffer::Ptr{Ptr{BGAPI2_Buffer}}, timeout::bo_uint64)::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_CancelGetFilledBuffer(data_stream)

`    DataStream`

Cancels a currently running [`BGAPI2_DataStream_GetFilledBuffer`](@ref)

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream is not initialized

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_CancelGetFilledBuffer(BGAPI2_DataStream* data_stream);
```
"""
function BGAPI2_DataStream_CancelGetFilledBuffer(data_stream)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_CancelGetFilledBuffer(data_stream::Ptr{BGAPI2_DataStream})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetBufferID(data_stream, index, buffer)

`    DataStream`

Returns buffer from datastream with index number

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream is not initialized

\\retvalBGAPI2_RESULT_LOWLEVEL_ERROR Internal error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `index`:\\[in\\] The ID for the buffer to be returned
* `buffer`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetBufferID( BGAPI2_DataStream* data_stream, bo_uint index, BGAPI2_Buffer** buffer);
```
"""
function BGAPI2_DataStream_GetBufferID(data_stream, index, buffer)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetBufferID(data_stream::Ptr{BGAPI2_DataStream}, index::bo_uint, buffer::Ptr{Ptr{BGAPI2_Buffer}})::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_RegisterNewBufferEventHandler(data_stream, callback_owner, buffer_event_handler)

`    DataStream`

Register a callback for datastream new buffer events

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error, no producer loaded

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error, datastream is not initialized

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\todo What is that???

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `callback_owner`:\\[in\\] Data, context pointer for use in callback function
* `buffer_event_handler`:\\[in\\] Address of function from type [`BGAPI2_NewBufferEventHandler`](@ref)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_RegisterNewBufferEventHandler( BGAPI2_DataStream* data_stream, void* callback_owner, BGAPI2_NewBufferEventHandler buffer_event_handler);
```
"""
function BGAPI2_DataStream_RegisterNewBufferEventHandler(data_stream, callback_owner, buffer_event_handler)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_RegisterNewBufferEventHandler(data_stream::Ptr{BGAPI2_DataStream}, callback_owner::Ptr{Cvoid}, buffer_event_handler::BGAPI2_NewBufferEventHandler)::BGAPI2_RESULT
end

"""
    BGAPI2_DataStream_GetParent(data_stream, parent)

`    DataStream`

Returns the parent object (device) which belongs to

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `data_stream`:\\[in\\] Pointer to the DataStream
* `parent`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_DataStream_GetParent( BGAPI2_DataStream* data_stream, BGAPI2_Device** parent);
```
"""
function BGAPI2_DataStream_GetParent(data_stream, parent)
    @ccall libbgapi2_genicam.BGAPI2_DataStream_GetParent(data_stream::Ptr{BGAPI2_DataStream}, parent::Ptr{Ptr{BGAPI2_Device}})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_GetWidth(image, width)

`    Image`

Get the image width from given image

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `width`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_GetWidth(BGAPI2_Image* image, bo_uint* width);
```
"""
function BGAPI2_Image_GetWidth(image, width)
    @ccall libbgapi2_genicam.BGAPI2_Image_GetWidth(image::Ptr{BGAPI2_Image}, width::Ptr{bo_uint})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_GetHeight(image, height)

`    Image`

Get the image height from given image

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `height`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_GetHeight(BGAPI2_Image* image, bo_uint* height);
```
"""
function BGAPI2_Image_GetHeight(image, height)
    @ccall libbgapi2_genicam.BGAPI2_Image_GetHeight(image::Ptr{BGAPI2_Image}, height::Ptr{bo_uint})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_GetLength(image, length)

`    Image`

Get the image data size from given image in byte

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `length`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_GetLength(BGAPI2_Image* image, bo_uint64* length);
```
"""
function BGAPI2_Image_GetLength(image, length)
    @ccall libbgapi2_genicam.BGAPI2_Image_GetLength(image::Ptr{BGAPI2_Image}, length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_GetPixelformat(image, pixelformat, string_length)

`    Image`

Get the image pixelformat from given image

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_BUFFER If given destination buffer is too small for pixelformat string

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `pixelformat`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_GetPixelformat( BGAPI2_Image* image, char* pixelformat, bo_uint64* string_length);
```
"""
function BGAPI2_Image_GetPixelformat(image, pixelformat, string_length)
    @ccall libbgapi2_genicam.BGAPI2_Image_GetPixelformat(image::Ptr{BGAPI2_Image}, pixelformat::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_GetBuffer(image, buffer)

`    Image`

Get the image pixel buffer from given image

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Image has no buffer (ppBuffer results NULL)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `buffer`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_GetBuffer(BGAPI2_Image* image, void** buffer);
```
"""
function BGAPI2_Image_GetBuffer(image, buffer)
    @ccall libbgapi2_genicam.BGAPI2_Image_GetBuffer(image::Ptr{BGAPI2_Image}, buffer::Ptr{Ptr{Cvoid}})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_GetTransformBufferLength(image, pixelformat, buffer_size)

`    Image`

Get the required image buffer size for new pixelformat of given image

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR If required buffer size is NULL (*buffer\\_size == NULL)

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `pixelformat`:\\[in\\] New pixelformat string
* `buffer_size`:\\[out\\] Required size of buffer for new pixelformat
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_GetTransformBufferLength( BGAPI2_Image* image, const char* pixelformat, bo_uint* buffer_size);
```
"""
function BGAPI2_Image_GetTransformBufferLength(image, pixelformat, buffer_size)
    @ccall libbgapi2_genicam.BGAPI2_Image_GetTransformBufferLength(image::Ptr{BGAPI2_Image}, pixelformat::Cstring, buffer_size::Ptr{bo_uint})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_Release(image)

`    Image`

Release (delete) a given image

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_Release(BGAPI2_Image* image);
```
"""
function BGAPI2_Image_Release(image)
    @ccall libbgapi2_genicam.BGAPI2_Image_Release(image::Ptr{BGAPI2_Image})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_Init(image, width, height, pixelformat, buffer, buffer_size)

`    Image`

Initialize a given image with parameters

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR If required buffer size is NULL common init error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `width`:\\[in\\] Image width
* `height`:\\[in\\] Image height
* `pixelformat`:\\[in\\] Image pixelformat
* `buffer`:\\[in\\] Buffer pointer
* `buffer_size`:\\[in\\] Size of buffer (must match to pixelformat!)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_Init( BGAPI2_Image* image, bo_uint width, bo_uint height, const char* pixelformat, void* buffer, bo_uint64 buffer_size);
```
"""
function BGAPI2_Image_Init(image, width, height, pixelformat, buffer, buffer_size)
    @ccall libbgapi2_genicam.BGAPI2_Image_Init(image::Ptr{BGAPI2_Image}, width::bo_uint, height::bo_uint, pixelformat::Cstring, buffer::Ptr{Cvoid}, buffer_size::bo_uint64)::BGAPI2_RESULT
end

"""
    BGAPI2_Image_InitFromBuffer(image, buffer)

`    Image`

Initialize a given image with parameters

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR If required buffer size is NULL common init error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `buffer`:\\[in\\] Pointer to the buffer
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_InitFromBuffer(BGAPI2_Image* image, BGAPI2_Buffer* buffer);
```
"""
function BGAPI2_Image_InitFromBuffer(image, buffer)
    @ccall libbgapi2_genicam.BGAPI2_Image_InitFromBuffer(image::Ptr{BGAPI2_Image}, buffer::Ptr{BGAPI2_Buffer})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_Scale(img_src, img_dst, scaling_factor_x, scaling_factor_y)

`    Image`

This function scale an Image object according to the scaling factors.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error for invalid image or unsupported pixel format

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `img_src`:\\[in\\] Pointer to the source image
* `img_src`:\\[in\\] Pointer to the destination image
* `scaling_factor_x`:\\[in\\] The scaling factor parameter for x direction. range 0.5 to 2.0
* `scaling_factor_y`:\\[in\\] The scaling factor parameter for y direction. range 0.5 to 2.0
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_Scale( BGAPI2_Image* img_src, BGAPI2_Image* img_dst, double scaling_factor_x, double scaling_factor_y);
```
"""
function BGAPI2_Image_Scale(img_src, img_dst, scaling_factor_x, scaling_factor_y)
    @ccall libbgapi2_genicam.BGAPI2_Image_Scale(img_src::Ptr{BGAPI2_Image}, img_dst::Ptr{BGAPI2_Image}, scaling_factor_x::Cdouble, scaling_factor_y::Cdouble)::BGAPI2_RESULT
end

"""
    BGAPI2_Image_GetNode(image, name, node)

`    Image`

Get the named node of given map of image

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `name`:\\[in\\] Node name
* `node`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_GetNode( BGAPI2_Image* image, const char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_Image_GetNode(image, name, node)
    @ccall libbgapi2_genicam.BGAPI2_Image_GetNode(image::Ptr{BGAPI2_Image}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_GetNodeTree(image, node_tree)

`    Image`

Get the node tree of the image

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `node_tree`:\\[out\\] Node map of image
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_GetNodeTree(BGAPI2_Image* image, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_Image_GetNodeTree(image, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_Image_GetNodeTree(image::Ptr{BGAPI2_Image}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_Image_GetNodeList(image, node_list)

`    Image`

Get the node list of the image

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `image`:\\[in\\] Pointer to the image
* `node_list`:\\[out\\] Node map of image
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Image_GetNodeList(BGAPI2_Image* image, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_Image_GetNodeList(image, node_list)
    @ccall libbgapi2_genicam.BGAPI2_Image_GetNodeList(image::Ptr{BGAPI2_Image}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_CreateImageProcessor(img_proc)

`    ImgProc`

Creates an image processor

\\retvalBGAPI2_RESULT_SUCCESS No error

# Arguments
* `img_proc`:\\[out\\] Pointer on image processor
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_CreateImageProcessor(BGAPI2_ImageProcessor** img_proc);
```
"""
function BGAPI2_CreateImageProcessor(img_proc)
    @ccall libbgapi2_genicam.BGAPI2_CreateImageProcessor(img_proc::Ptr{Ptr{BGAPI2_ImageProcessor}})::BGAPI2_RESULT
end

"""
    BGAPI2_ReleaseImageProcessor(img_proc)

`    ImgProc`

Release an image processor

\\retvalBGAPI2_RESULT_SUCCESS No error

# Arguments
* `img_proc`:\\[in\\] Pointer on image processor
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ReleaseImageProcessor(BGAPI2_ImageProcessor* img_proc);
```
"""
function BGAPI2_ReleaseImageProcessor(img_proc)
    @ccall libbgapi2_genicam.BGAPI2_ReleaseImageProcessor(img_proc::Ptr{BGAPI2_ImageProcessor})::BGAPI2_RESULT
end

"""
    BGAPI2_ImageProcessor_GetVersion(img_proc, version, string_length)

`    ImgProc`

Get the version string of image processor

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Could not stop event thread

\\retvalBGAPI2_RESULT_INVALID_BUFFER Given pVersion is too small

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\todo check params in,out

# Arguments
* `img_proc`:\\[in\\] Pointer to the image processor
* `version`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of string (including string end zero)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ImageProcessor_GetVersion( BGAPI2_ImageProcessor* img_proc, char* version, bo_uint64* string_length);
```
"""
function BGAPI2_ImageProcessor_GetVersion(img_proc, version, string_length)
    @ccall libbgapi2_genicam.BGAPI2_ImageProcessor_GetVersion(img_proc::Ptr{BGAPI2_ImageProcessor}, version::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_ImageProcessor_CreateEmptyImage(img_proc, image)

`    ImgProc`

Creates an empty image by image processor

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Some internal errors

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Image processor parts not available, not initialized

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `img_proc`:\\[in\\] Pointer to the image processor
* `image`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ImageProcessor_CreateEmptyImage( BGAPI2_ImageProcessor* img_proc, BGAPI2_Image** image);
```
"""
function BGAPI2_ImageProcessor_CreateEmptyImage(img_proc, image)
    @ccall libbgapi2_genicam.BGAPI2_ImageProcessor_CreateEmptyImage(img_proc::Ptr{BGAPI2_ImageProcessor}, image::Ptr{Ptr{BGAPI2_Image}})::BGAPI2_RESULT
end

"""
    BGAPI2_ImageProcessor_CreateImage(img_proc, width, height, pixelformat, buffer, buffer_size, image)

`    ImgProc`

Creates an image by image processor

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Some internal errors

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Image processor parts not available, not initialized

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `img_proc`:\\[in\\] Pointer to the image processor
* `width`:\\[in\\] Width of image in pixel
* `height`:\\[in\\] Height of image in pixel
* `pixelformat`:\\[in\\] Name of pixelformat to use in image
* `buffer`:\\[in\\] Pointer to raw image data buffer
* `buffer_size`:\\[in\\] (maximum) size of raw image data buffer
* `image`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ImageProcessor_CreateImage( BGAPI2_ImageProcessor* img_proc, bo_uint width, bo_uint height, const char* pixelformat, void* buffer, bo_uint64 buffer_size, BGAPI2_Image** image);
```
"""
function BGAPI2_ImageProcessor_CreateImage(img_proc, width, height, pixelformat, buffer, buffer_size, image)
    @ccall libbgapi2_genicam.BGAPI2_ImageProcessor_CreateImage(img_proc::Ptr{BGAPI2_ImageProcessor}, width::bo_uint, height::bo_uint, pixelformat::Cstring, buffer::Ptr{Cvoid}, buffer_size::bo_uint64, image::Ptr{Ptr{BGAPI2_Image}})::BGAPI2_RESULT
end

"""
    BGAPI2_ImageProcessor_CreateTransformedImage(img_proc, image_input, pixelformat, image_result)

`    ImgProc`

Transforms an given image using the pixelformat using the image processor

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `img_proc`:\\[in\\] Pointer to the image processor
* `image_input`:\\[in\\] Pointer to the given image
* `pixelformat`:\\[in\\] Name of new pixelformat to use in image
* `image_result`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ImageProcessor_CreateTransformedImage( BGAPI2_ImageProcessor* img_proc, BGAPI2_Image* image_input, const char* pixelformat, BGAPI2_Image** image_result);
```
"""
function BGAPI2_ImageProcessor_CreateTransformedImage(img_proc, image_input, pixelformat, image_result)
    @ccall libbgapi2_genicam.BGAPI2_ImageProcessor_CreateTransformedImage(img_proc::Ptr{BGAPI2_ImageProcessor}, image_input::Ptr{BGAPI2_Image}, pixelformat::Cstring, image_result::Ptr{Ptr{BGAPI2_Image}})::BGAPI2_RESULT
end

"""
    BGAPI2_ImageProcessor_TransformImageToBuffer(img_proc, image, pixelformat, buffer, buffer_size)

`       ImgProc`

Creates an new image based on given image with new pixelformat by image processor

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error on image transformation

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `img_proc`:\\[in\\] Pointer to the image processor
* `image`:\\[in\\] Pointer to the given image
* `pixelformat`:\\[in\\] Name of new pixelformat for the result buffer
* `buffer`:\\[in,out\\] Destination buffer for new image with new pixelformat
* `buffer_size`:\\[in\\] Buffer size for image with new pixelformat
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ImageProcessor_TransformImageToBuffer( BGAPI2_ImageProcessor* img_proc, BGAPI2_Image* image, const char* pixelformat, void* buffer, bo_uint64 buffer_size);
```
"""
function BGAPI2_ImageProcessor_TransformImageToBuffer(img_proc, image, pixelformat, buffer, buffer_size)
    @ccall libbgapi2_genicam.BGAPI2_ImageProcessor_TransformImageToBuffer(img_proc::Ptr{BGAPI2_ImageProcessor}, image::Ptr{BGAPI2_Image}, pixelformat::Cstring, buffer::Ptr{Cvoid}, buffer_size::bo_uint64)::BGAPI2_RESULT
end

"""
    BGAPI2_ImageProcessor_GetNode(img_proc, name, node)

`    ImgProc`

Get the named node of given map of image processor

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `img_proc`:\\[in\\] Pointer to the image processor
* `name`:\\[in\\] Node name
* `node`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ImageProcessor_GetNode( BGAPI2_ImageProcessor* img_proc, const char* name, BGAPI2_Node** node);
```
"""
function BGAPI2_ImageProcessor_GetNode(img_proc, name, node)
    @ccall libbgapi2_genicam.BGAPI2_ImageProcessor_GetNode(img_proc::Ptr{BGAPI2_ImageProcessor}, name::Cstring, node::Ptr{Ptr{BGAPI2_Node}})::BGAPI2_RESULT
end

"""
    BGAPI2_ImageProcessor_GetNodeTree(img_proc, node_tree)

`    ImgProc`

Get the node map of image processor as a tree

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `img_proc`:\\[in\\] Pointer to the image processor
* `node_tree`:\\[out\\] Pointer to store the result
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ImageProcessor_GetNodeTree( BGAPI2_ImageProcessor* img_proc, BGAPI2_NodeMap** node_tree);
```
"""
function BGAPI2_ImageProcessor_GetNodeTree(img_proc, node_tree)
    @ccall libbgapi2_genicam.BGAPI2_ImageProcessor_GetNodeTree(img_proc::Ptr{BGAPI2_ImageProcessor}, node_tree::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_ImageProcessor_GetNodeList(img_proc, node_list)

`    ImgProc`

Get the node map of image processor as a list

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_NOT_INITIALIZED Error for missing root node

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `img_proc`:\\[in\\] Pointer to the image processor
* `node_list`:\\[out\\] Node map of image processor
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_ImageProcessor_GetNodeList( BGAPI2_ImageProcessor* img_proc, BGAPI2_NodeMap** node_list);
```
"""
function BGAPI2_ImageProcessor_GetNodeList(img_proc, node_list)
    @ccall libbgapi2_genicam.BGAPI2_ImageProcessor_GetNodeList(img_proc::Ptr{BGAPI2_ImageProcessor}, node_list::Ptr{Ptr{BGAPI2_NodeMap}})::BGAPI2_RESULT
end

"""
    BGAPI2_POLARIZER_FORMATS

`    Polarizer`

Enumeration containing the string representation of the possible polarization formats.
"""
@cenum BGAPI2_POLARIZER_FORMATS::UInt32 begin
    BGAPI2_POLARIZER_AOP = 0
    BGAPI2_POLARIZER_DOLP = 1
    BGAPI2_POLARIZER_ADOLP = 2
    BGAPI2_POLARIZER_INTENSITY = 3
    BGAPI2_POLARIZER_POL0_DEG = 4
    BGAPI2_POLARIZER_POL45_DEG = 5
    BGAPI2_POLARIZER_POL90_DEG = 6
    BGAPI2_POLARIZER_POL135_DEG = 7
    BGAPI2_POLARIZER_REFLECTION_MIN = 8
    BGAPI2_POLARIZER_REFLECTION_MAX = 9
    BGAPI2_POLARIZER_POL = 10
    BGAPI2_POLARIZER_UNPOL = 11
    BGAPI2_POLARIZER_AOP_R = 256
    BGAPI2_POLARIZER_DOLP_R = 257
    BGAPI2_POLARIZER_ADOLP_R = 258
    BGAPI2_POLARIZER_INTENSITY_R = 259
    BGAPI2_POLARIZER_POL0_DEG_R = 260
    BGAPI2_POLARIZER_POL45_DEG_R = 261
    BGAPI2_POLARIZER_POL90_DEG_R = 262
    BGAPI2_POLARIZER_POL135_DEG_R = 263
    BGAPI2_POLARIZER_REFLECTION_MIN_R = 264
    BGAPI2_POLARIZER_REFLECTION_MAX_R = 265
    BGAPI2_POLARIZER_POL_R = 266
    BGAPI2_POLARIZER_UNPOL_R = 267
    BGAPI2_POLARIZER_AOP_G = 512
    BGAPI2_POLARIZER_DOLP_G = 513
    BGAPI2_POLARIZER_ADOLP_G = 514
    BGAPI2_POLARIZER_INTENSITY_G = 515
    BGAPI2_POLARIZER_POL0_DEG_G = 516
    BGAPI2_POLARIZER_POL45_DEG_G = 517
    BGAPI2_POLARIZER_POL90_DEG_G = 518
    BGAPI2_POLARIZER_POL135_DEG_G = 519
    BGAPI2_POLARIZER_REFLECTION_MIN_G = 520
    BGAPI2_POLARIZER_REFLECTION_MAX_G = 521
    BGAPI2_POLARIZER_POL_G = 522
    BGAPI2_POLARIZER_UNPOL_G = 523
    BGAPI2_POLARIZER_AOP_B = 768
    BGAPI2_POLARIZER_DOLP_B = 769
    BGAPI2_POLARIZER_ADOLP_B = 770
    BGAPI2_POLARIZER_INTENSITY_B = 771
    BGAPI2_POLARIZER_POL0_DEG_B = 772
    BGAPI2_POLARIZER_POL45_DEG_B = 773
    BGAPI2_POLARIZER_POL90_DEG_B = 774
    BGAPI2_POLARIZER_POL135_DEG_B = 775
    BGAPI2_POLARIZER_REFLECTION_MIN_B = 776
    BGAPI2_POLARIZER_REFLECTION_MAX_B = 777
    BGAPI2_POLARIZER_POL_B = 778
    BGAPI2_POLARIZER_UNPOL_B = 779
end

"""
    BGAPI2_Polarizer_Create(polarizer)

`    Polarizer`

Creates a Polarizer object

\\retvalBGAPI2_RESULT_SUCCESS No error

# Arguments
* `polarizer`:\\[out\\] Pointer on Polarizer object
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_Create(BGAPI2_Polarizer** polarizer);
```
"""
function BGAPI2_Polarizer_Create(polarizer)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_Create(polarizer::Ptr{Ptr{BGAPI2_Polarizer}})::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_Release(polarizer)

`    Polarizer`

Release a Polarizer object

\\retvalBGAPI2_RESULT_SUCCESS No error

# Arguments
* `polarizer`:\\[in\\] Pointer to the Polarizer object
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_Release(BGAPI2_Polarizer* polarizer);
```
"""
function BGAPI2_Polarizer_Release(polarizer)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_Release(polarizer::Ptr{BGAPI2_Polarizer})::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_IsPolarized(device, is_polarized, is_color)

Check for polarization camera.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\retvalBGAPI2_RESULT_ERROR Internal error

# Arguments
* `device`:\\[in\\] The [`BGAPI2_Device`](@ref)* pointer to an opened polarization camera (it must be able to read features from the camera)
* `is_polarized`:\\[out\\] If true, the Device is a polarization camera.
* `is_color`:\\[out\\] If true, the Device is a color polarization camera otherwise a mono polarization camera.
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_IsPolarized( BGAPI2_Device* device, bo_bool* is_polarized, bo_bool* is_color);
```
"""
function BGAPI2_Polarizer_IsPolarized(device, is_polarized, is_color)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_IsPolarized(device::Ptr{BGAPI2_Device}, is_polarized::Ptr{bo_bool}, is_color::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_Initialize(polarizer, buffer)

`    Polarizer`

Initialize the Polarizer and provide the buffer with the raw polarized data for calculations

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\retvalBGAPI2_RESULT_ERROR Internal error

# Arguments
* `polarizer`:\\[in\\] Instance of polarizer.
* `buffer`:\\[in\\] A valid buffer with polarized data acquired by a Baumer camera
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_Initialize( BGAPI2_Polarizer* polarizer, BGAPI2_Buffer* buffer);
```
"""
function BGAPI2_Polarizer_Initialize(polarizer, buffer)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_Initialize(polarizer::Ptr{BGAPI2_Polarizer}, buffer::Ptr{BGAPI2_Buffer})::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_ReadCalibrationData(polarizer, device)

`    Polarizer`

Get the calibration data and angle offset from the camera

Reads the calibration matrix and the configured polarization angle offset from the camera device to enhance the calculation of different polarization formats.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\retvalBGAPI2_RESULT_NOT_INITIALIZED The is not open.

# Arguments
* `polarizer`:\\[in\\] Instance of polarizer.
* `device`:\\[in\\] The polarization camera (opened, must be able to read features from the camera)
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_ReadCalibrationData( BGAPI2_Polarizer* polarizer, BGAPI2_Device* device);
```
"""
function BGAPI2_Polarizer_ReadCalibrationData(polarizer, device)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_ReadCalibrationData(polarizer::Ptr{BGAPI2_Polarizer}, device::Ptr{BGAPI2_Device})::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_EnableInterpolation(polarizer, interpolate)

`    Polarizer`

Keep output image the same size as the input buffer. The default is disabled.

If enabled, the calculated images will be interpolated to have the same size as the raw image buffer provided

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `polarizer`:\\[in\\] Instance of polarizer
* `interpolate`:\\[in\\] If set to true the result images will be interpolated
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_EnableInterpolation( BGAPI2_Polarizer* polarizer, bo_bool interpolate);
```
"""
function BGAPI2_Polarizer_EnableInterpolation(polarizer, interpolate)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_EnableInterpolation(polarizer::Ptr{BGAPI2_Polarizer}, interpolate::bo_bool)::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_EnableSingleFormat(polarizer, format)

`    Polarizer`

Each component to be calculated must be enabled first

To speed up the calculation of the different components it is necessary to enable them first. This allows for the calculation to re-use and combine some of the necessary calculations

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `polarizer`:\\[in\\] Instance of polarizer
* `format`:\\[in\\] The format to enable. All other formats are disabled
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_EnableSingleFormat( BGAPI2_Polarizer* polarizer, BGAPI2_POLARIZER_FORMATS format);
```
"""
function BGAPI2_Polarizer_EnableSingleFormat(polarizer, format)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_EnableSingleFormat(polarizer::Ptr{BGAPI2_Polarizer}, format::BGAPI2_POLARIZER_FORMATS)::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_Enable(polarizer, format, enable)

`    Polarizer`

Each component to be calculated must be enabled first

To speed up the calculation of the different components it is necessary to enable them first. This allows for the calculation to re-use and combine some of the necessary calculations

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `polarizer`:\\[in\\] Instance of polarizer
* `format`:\\[in\\] The format to enable or disable
* `enable`:\\[in\\] Set to true to enable or false to disable
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_Enable( BGAPI2_Polarizer* polarizer, BGAPI2_POLARIZER_FORMATS format, bo_bool enable);
```
"""
function BGAPI2_Polarizer_Enable(polarizer, format, enable)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_Enable(polarizer::Ptr{BGAPI2_Polarizer}, format::BGAPI2_POLARIZER_FORMATS, enable::bo_bool)::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_Get(polarizer, format, image)

`    Polarizer`

Get the calculated component (BGAPI\\_POLARIZER\\_AOP, etc.) from the buffer. If the Image object doesn't fit the resulting data, the Polarizer will reinitialize it accordingly.

For performance reasons when handling more than one component, a component must first be enabled via the [`BGAPI2_Polarizer_Enable`](@ref)() methods

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Polarizer result not available

\\retvalBGAPI2_RESULT_ERROR Internal error

# Arguments
* `polarizer`:\\[in\\] Instance of polarizer
* `format`:\\[in\\] The format to enable or disable
* `image`:\\[in,out\\] [`BGAPI2_Image`](@ref) to store the result of the calculation
# See also
[`BGAPI2_POLARIZER_FORMATS`](@ref), [`BGAPI2_Polarizer_Initialize`](@ref)(), [`BGAPI2_ImageProcessor_CreateImage`](@ref)()

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_Get( BGAPI2_Polarizer* polarizer, BGAPI2_POLARIZER_FORMATS format, BGAPI2_Image* image);
```
"""
function BGAPI2_Polarizer_Get(polarizer, format, image)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_Get(polarizer::Ptr{BGAPI2_Polarizer}, format::BGAPI2_POLARIZER_FORMATS, image::Ptr{BGAPI2_Image})::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_GetByPredefinedImage(polarizer, format, image)

`       Polarizer`

Get the calculated component (BGAPI\\_POLARIZER\\_AOP, etc.) from the buffer. The passed Image object is fully predefined (width, height, pixel format, buffer and buffer size) and the polarization data are transformed to desired pixel format.

For performance reasons when handling more than one component, a component must first be enabled via the [`BGAPI2_Polarizer_Enable`](@ref)() methods.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\retvalBGAPI2_RESULT_NOT_AVAILABLE Polarizer result not available

\\retvalBGAPI2_RESULT_ERROR Internal error

# Arguments
* `polarizer`:\\[in\\] Instance of polarizer
* `format`:\\[in\\] The format to retrieve.
* `image`:\\[in\\] A Image to store the result of the calculation. The passed Image object is fully predefined (width, height, pixel format, buffer and buffer size) and the polarization data are transformed to desired pixel format.
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_GetByPredefinedImage( BGAPI2_Polarizer* polarizer, BGAPI2_POLARIZER_FORMATS format, BGAPI2_Image* image);
```
"""
function BGAPI2_Polarizer_GetByPredefinedImage(polarizer, format, image)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_GetByPredefinedImage(polarizer::Ptr{BGAPI2_Polarizer}, format::BGAPI2_POLARIZER_FORMATS, image::Ptr{BGAPI2_Image})::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_GetFormatString(format, format_string, size)

`    Polarizer`

Get the string of the polarization format

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `format`:\\[in\\] The polarization format
* `format_string`:\\[out\\] The buffer of the polarization format
* `size`:\\[in,out\\] The buffer size (in) / The format string size (out)
# See also
[`BGAPI2_POLARIZER_FORMATS`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_GetFormatString( BGAPI2_POLARIZER_FORMATS format, char* format_string, bo_uint64* size);
```
"""
function BGAPI2_Polarizer_GetFormatString(format, format_string, size)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_GetFormatString(format::BGAPI2_POLARIZER_FORMATS, format_string::Cstring, size::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_IsFormatAvailable(format, color, is_available)

`    Polarizer`

Check the availability of the polarization format.

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

# Arguments
* `format`:\\[in\\] The polarization format
* `color`:\\[in\\] Perform check for mono or color camera.
* `is_available`:\\[out\\] The availabity result
# See also
[`BGAPI2_POLARIZER_FORMATS`](@ref)

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_IsFormatAvailable( BGAPI2_POLARIZER_FORMATS format, bo_bool color, bo_bool* is_available);
```
"""
function BGAPI2_Polarizer_IsFormatAvailable(format, color, is_available)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_IsFormatAvailable(format::BGAPI2_POLARIZER_FORMATS, color::bo_bool, is_available::Ptr{bo_bool})::BGAPI2_RESULT
end

"""
    BGAPI2_Polarizer_SetMaxThreads(polarizer, number)

`    Polarizer`

Set the number of threads the Polarizer can use for calculations

To speed up the calculation of components more than one thread can be used internally. The default is 4 threads on processors which have 8 or more logical cores, otherwise half of the logical cores are used. Depending on your application you can change this here

\\retvalBGAPI2_RESULT_INVALID_PARAMETER Error for invalid parameters

\\retvalBGAPI2_RESULT_SUCCESS No error

# Arguments
* `polarizer`:\\[in\\] Instance of polarizer
* `number`:\\[in\\] The amount of threads used internally
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_Polarizer_SetMaxThreads( BGAPI2_Polarizer* polarizer, bo_uint number);
```
"""
function BGAPI2_Polarizer_SetMaxThreads(polarizer, number)
    @ccall libbgapi2_genicam.BGAPI2_Polarizer_SetMaxThreads(polarizer::Ptr{BGAPI2_Polarizer}, number::bo_uint)::BGAPI2_RESULT
end

"""
    BGAPI2_TraceEnable(benable)

`    Trace`

Enable the BGAPI Trace

# Arguments
* `benable`:\\[in\\] True to enable trace otherwise false
### Prototype
```c
BGAPI2_C_DECL void BGAPI2CALL BGAPI2_TraceEnable(bo_bool benable);
```
"""
function BGAPI2_TraceEnable(benable)
    @ccall libbgapi2_genicam.BGAPI2_TraceEnable(benable::bo_bool)::Cvoid
end

# no prototype is found for this function at bgapi2_genicam.h:4029:38, please use with caution
"""
    BGAPI2_TraceIsEnabled()

`    Trace`

This function delivers the current state of the trace.

# Returns
true if the trace is enabled, otherwise false.
### Prototype
```c
BGAPI2_C_DECL bo_bool BGAPI2CALL BGAPI2_TraceIsEnabled();
```
"""
function BGAPI2_TraceIsEnabled()
    @ccall libbgapi2_genicam.BGAPI2_TraceIsEnabled()::bo_bool
end

"""
    BGAPI2_TraceActivateOutputToFile(bactive, tracefilename)

`    Trace`

Activate the tracing to an output file

# Arguments
* `bactive`:\\[in\\] True to enable trace otherwise false
* `tracefilename`:\\[in\\] The output file including the path
### Prototype
```c
BGAPI2_C_DECL void BGAPI2CALL BGAPI2_TraceActivateOutputToFile(bo_bool bactive, const char* tracefilename);
```
"""
function BGAPI2_TraceActivateOutputToFile(bactive, tracefilename)
    @ccall libbgapi2_genicam.BGAPI2_TraceActivateOutputToFile(bactive::bo_bool, tracefilename::Cstring)::Cvoid
end

"""
    BGAPI2_TraceActivateOutputToDebugger(bactive)

`    Trace`

Activate the tracing to the debugger

# Arguments
* `bactive`:\\[in\\] True to enable trace otherwise false
### Prototype
```c
BGAPI2_C_DECL void BGAPI2CALL BGAPI2_TraceActivateOutputToDebugger(bo_bool bactive);
```
"""
function BGAPI2_TraceActivateOutputToDebugger(bactive)
    @ccall libbgapi2_genicam.BGAPI2_TraceActivateOutputToDebugger(bactive::bo_bool)::Cvoid
end

"""
    BGAPI2_TraceActivateMaskError(bactive)

`    Trace`

Trace errors

# Arguments
* `bactive`:\\[in\\] True to enable trace otherwise false
### Prototype
```c
BGAPI2_C_DECL void BGAPI2CALL BGAPI2_TraceActivateMaskError(bo_bool bactive);
```
"""
function BGAPI2_TraceActivateMaskError(bactive)
    @ccall libbgapi2_genicam.BGAPI2_TraceActivateMaskError(bactive::bo_bool)::Cvoid
end

"""
    BGAPI2_TraceActivateMaskWarning(bactive)

`    Trace`

Trace warnings

# Arguments
* `bactive`:\\[in\\] True to enable trace otherwise false
### Prototype
```c
BGAPI2_C_DECL void BGAPI2CALL BGAPI2_TraceActivateMaskWarning(bo_bool bactive);
```
"""
function BGAPI2_TraceActivateMaskWarning(bactive)
    @ccall libbgapi2_genicam.BGAPI2_TraceActivateMaskWarning(bactive::bo_bool)::Cvoid
end

"""
    BGAPI2_TraceActivateMaskInformation(bactive)

`    Trace`

Trace infos

# Arguments
* `bactive`:\\[in\\] True to enable trace otherwise false
### Prototype
```c
BGAPI2_C_DECL void BGAPI2CALL BGAPI2_TraceActivateMaskInformation(bo_bool bactive);
```
"""
function BGAPI2_TraceActivateMaskInformation(bactive)
    @ccall libbgapi2_genicam.BGAPI2_TraceActivateMaskInformation(bactive::bo_bool)::Cvoid
end

"""
    BGAPI2_TraceActivateOutputOptionTimestamp(bactive)

`    Trace`

Trace Timestamps

# Arguments
* `bactive`:\\[in\\] True to enable trace otherwise false
### Prototype
```c
BGAPI2_C_DECL void BGAPI2CALL BGAPI2_TraceActivateOutputOptionTimestamp(bo_bool bactive);
```
"""
function BGAPI2_TraceActivateOutputOptionTimestamp(bactive)
    @ccall libbgapi2_genicam.BGAPI2_TraceActivateOutputOptionTimestamp(bactive::bo_bool)::Cvoid
end

"""
    BGAPI2_TraceActivateOutputOptionTimestampDiff(bactive)

`    Trace`

Trace Timestamp differences. This function only takes effect, if the timestamp is activated at all (see [`BGAPI2_TraceActivateOutputOptionTimestamp`](@ref)).

# Arguments
* `bactive`:\\[in\\] True to enable trace otherwise false
### Prototype
```c
BGAPI2_C_DECL void BGAPI2CALL BGAPI2_TraceActivateOutputOptionTimestampDiff(bo_bool bactive);
```
"""
function BGAPI2_TraceActivateOutputOptionTimestampDiff(bactive)
    @ccall libbgapi2_genicam.BGAPI2_TraceActivateOutputOptionTimestampDiff(bactive::bo_bool)::Cvoid
end

"""
    BGAPI2_TraceActivateOutputOptionThreadID(bactive)

`    Trace`

Trace the thread ID

# Arguments
* `bactive`:\\[in\\] True to enable trace otherwise false
### Prototype
```c
BGAPI2_C_DECL void BGAPI2CALL BGAPI2_TraceActivateOutputOptionThreadID(bo_bool bactive);
```
"""
function BGAPI2_TraceActivateOutputOptionThreadID(bactive)
    @ccall libbgapi2_genicam.BGAPI2_TraceActivateOutputOptionThreadID(bactive::bo_bool)::Cvoid
end

"""
    BGAPI2_TraceActivateOutputOptionPrefix(bactive)

`    Trace`



# Arguments
* `bactive`:\\[in\\] True to enable trace otherwise false
### Prototype
```c
BGAPI2_C_DECL void BGAPI2CALL BGAPI2_TraceActivateOutputOptionPrefix(bo_bool bactive);
```
"""
function BGAPI2_TraceActivateOutputOptionPrefix(bactive)
    @ccall libbgapi2_genicam.BGAPI2_TraceActivateOutputOptionPrefix(bactive::bo_bool)::Cvoid
end

"""
    BGAPI2_SetEnv(producer_path)

`    BGAPI2`

Sets the GENICAM\\_GENTL\\_PATHxx environment variable with given value

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error on setting environment variable

# Arguments
* `producer_path`:\\[in\\] New path for searching GenTL producers
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_SetEnv(const char* producer_path);
```
"""
function BGAPI2_SetEnv(producer_path)
    @ccall libbgapi2_genicam.BGAPI2_SetEnv(producer_path::Cstring)::BGAPI2_RESULT
end

"""
    BGAPI2_GetEnv(producer_path, string_length)

`    BGAPI2`

Get the value of the GENICAM\\_GENTL\\_PATHxx environment variable

\\retvalBGAPI2_RESULT_SUCCESS No error

\\retvalBGAPI2_RESULT_ERROR Error on getting environment variable

# Arguments
* `producer_path`:\\[in,out\\] Nullptr to get string length or pointer to store result
* `string_length`:\\[in,out\\] Result size, length of version string (including string end zero)
# See also
[`BGAPI2_System_GetID`](@ref) for detail how to retrieve strings with unknown size

### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_GetEnv(char* producer_path, bo_uint64* string_length);
```
"""
function BGAPI2_GetEnv(producer_path, string_length)
    @ccall libbgapi2_genicam.BGAPI2_GetEnv(producer_path::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

"""
    BGAPI2_GetLastError(error_code, error_text, string_length)

`    BGAPI2`

Returns a description of the last occurred error

\\retvalBGAPI2_RESULT_SUCCESS No error

\\todo Check Module

# Arguments
* `error_code`:\\[out\\] Last error code
* `error_text`:\\[out\\] Last error string
* `string_length`:\\[out\\] Size of last error string
### Prototype
```c
BGAPI2_C_DECL BGAPI2_RESULT BGAPI2CALL BGAPI2_GetLastError(BGAPI2_RESULT* error_code, char* error_text, bo_uint64* string_length);
```
"""
function BGAPI2_GetLastError(error_code, error_text, string_length)
    @ccall libbgapi2_genicam.BGAPI2_GetLastError(error_code::Ptr{BGAPI2_RESULT}, error_text::Cstring, string_length::Ptr{bo_uint64})::BGAPI2_RESULT
end

# Skipping MacroDefinition: BGAPI2_DECL __attribute__ ( ( visibility ( "default" ) ) )

# Skipping MacroDefinition: BGAPI2_C_DECL __attribute__ ( ( visibility ( "default" ) ) )

const BGAPI2_PAYLOADTYPE_UNKNOWN = "Unknown"

const BGAPI2_PAYLOADTYPE_IMAGE = "Image"

const BGAPI2_PAYLOADTYPE_RAW_DATA = "RawData"

const BGAPI2_PAYLOADTYPE_FILE = "File"

const BGAPI2_PAYLOADTYPE_CHUNK_DATA = "ChunkData"

const BGAPI2_PAYLOADTYPE_CUSTOM_ID = "CustomID_1000"

const BGAPI2_PAYLOADTYPE_JPEG = "Jpeg"

const BGAPI2_PAYLOADTYPE_JPEG2000 = "Jpeg2000"

const BGAPI2_PAYLOADTYPE_H264 = "H264"

const BGAPI2_PAYLOADTYPE_CHUNK_ONLY = "ChunkOnly"

const BGAPI2_PAYLOADTYPE_DEVICE_SPECIFIC = "DeviceSpecific"

const BGAPI2_PAYLOADTYPE_MULTI_PART = "Multipart"

const BGAPI2_PAYLOADTYPE_GENDC = "GenDC"

const BGAPI2_NODEINTERFACE_CATEGORY = "ICategory"

const BGAPI2_NODEINTERFACE_INTEGER = "IInteger"

const BGAPI2_NODEINTERFACE_REGISTER = "IRegister"

const BGAPI2_NODEINTERFACE_BOOLEAN = "IBoolean"

const BGAPI2_NODEINTERFACE_COMMAND = "ICommand"

const BGAPI2_NODEINTERFACE_FLOAT = "IFloat"

const BGAPI2_NODEINTERFACE_ENUMERATION = "IEnumeration"

const BGAPI2_NODEINTERFACE_STRING = "IString"

const BGAPI2_NODEINTERFACE_PORT = "IPort"

const BGAPI2_NODEVISIBILITY_BEGINNER = "Beginner"

const BGAPI2_NODEVISIBILITY_EXPERT = "Expert"

const BGAPI2_NODEVISIBILITY_GURU = "Guru"

const BGAPI2_NODEVISIBILITY_INVISIBLE = "Invisible"

const BGAPI2_NODEACCESS_READWRITE = "RW"

const BGAPI2_NODEACCESS_READONLY = "RO"

const BGAPI2_NODEACCESS_WRITEONLY = "WO"

const BGAPI2_NODEACCESS_NOTAVAILABLE = "NA"

const BGAPI2_NODEACCESS_NOTIMPLEMENTED = "NI"

const BGAPI2_NODEREPRESENTATION_LINEAR = "Linear"

const BGAPI2_NODEREPRESENTATION_LOGARITHMIC = "Logarithmic"

const BGAPI2_NODEREPRESENTATION_PURENUMBER = "PureNumber"

const BGAPI2_NODEREPRESENTATION_BOOLEAN = "Boolean"

const BGAPI2_NODEREPRESENTATION_HEXNUMBER = "HexNumber"

const BGAPI2_NODEREPRESENTATION_IPV4ADDRESS = "IPV4Address"

const BGAPI2_NODEREPRESENTATION_MACADDRESS = "MACAddress"

const SFNCVERSION = 1.5

const SFNC_DEVICECONTROL = "DeviceControl"

const SFNC_DEVICE_VENDORNAME = "DeviceVendorName"

const SFNC_DEVICE_MODELNAME = "DeviceModelName"

const SFNC_DEVICE_MANUFACTURERINFO = "DeviceManufacturerInfo"

const SFNC_DEVICE_VERSION = "DeviceVersion"

const SFNC_DEVICE_FIRMWAREVERSION = "DeviceFirmwareVersion"

const SFNC_DEVICE_SFNCVERSIONMAJOR = "DeviceSFNCVersionMajor"

const SFNC_DEVICE_SFNCVERSIONMINOR = "DeviceSFNCVersionMinor"

const SFNC_DEVICE_SFNCVERSIONSUBMINOR = "DeviceSFNCVersionSubMinor"

const SFNC_DEVICE_MANIFESTENTRYSELECTOR = "DeviceManifestEntrySelector"

const SFNC_DEVICE_MANIFESTXMLMAJORVERSION = "DeviceManifestXMLMajorVersion"

const SFNC_DEVICE_MANIFESTXMLMINORVERSION = "DeviceManifestXMLMinorVersion"

const SFNC_DEVICE_MANIFESTXMLSUBMINORVERSION = "DeviceManifestXMLSubMinorVersion"

const SFNC_DEVICE_MANIFESTSCHEMAMAJORVERSION = "DeviceManifestSchemaMajorVersion"

const SFNC_DEVICE_MANIFESTSCHEMAMINORVERSION = "DeviceManifestSchemaMinorVersion"

const SFNC_DEVICE_MANIFESTPRIMARYURL = "DeviceManifestPrimaryURL"

const SFNC_DEVICE_MANIFESTSECONDARYURL = "DeviceManifestSecondaryURL"

const SFNC_DEVICE_ID = "DeviceID"

const SFNC_DEVICE_SERIALNUMBER = "DeviceSerialNumber"

const SFNC_DEVICE_USERID = "DeviceUserID"

const SFNC_DEVICE_RESET = "DeviceReset"

const SFNC_DEVICE_REGISTERSSTREAMINGSTART = "DeviceRegistersStreamingStart"

const SFNC_DEVICE_REGISTERSSTREAMINGEND = "DeviceRegistersStreamingEnd"

const SFNC_DEVICE_REGISTERSCHECK = "DeviceRegistersCheck"

const SFNC_DEVICE_REGISTERSVALID = "DeviceRegistersValid"

const SFNC_DEVICE_MAXTHROUGHPUT = "DeviceMaxThroughput"

const SFNC_DEVICE_TEMPERATURESELECTOR = "DeviceTemperatureSelector"

const SFNC_DEVICE_TEMPERATURE = "DeviceTemperature"

const SFNC_DEVICE_CLOCKSELECTOR = "DeviceClockSelector"

const SFNC_DEVICE_CLOCKFREQUENCY = "DeviceClockFrequency"

const SFNC_DEVICE_SERIALPORTSELECTOR = "DeviceSerialPortSelector"

const SFNC_IMAGEFORMATCONTROL = "ImageFormatControl"

const SFNC_SENSORWIDTH = "SensorWidth"

const SFNC_SENSORHEIGHT = "SensorHeight"

const SFNC_SENSORTABS = "SensorTaps"

const SFNC_SENSORDIGITIZATIONTABS = "SensorDigitizationTaps"

const SFNC_WIDTHMAX = "WidthMax"

const SFNC_HEIGHTMAX = "HeightMax"

const SFNC_WIDTH = "Width"

const SFNC_HEIGHT = "Height"

const SFNC_OFFSETX = "OffsetX"

const SFNC_OFFSETY = "OffsetY"

const SFNC_LINEPITCH = "LinePitch"

const SFNC_BINNINGHORIZONTAL = "BinningHorizontal"

const SFNC_BINNINGVERTICAL = "BinningVertical"

const SFNC_DECIMATIONHORIZONTAL = "DecimationHorizontal"

const SFNC_DECIMATIONVERTICAL = "DecimationVertical"

const SFNC_REVERSEX = "ReverseX"

const SFNC_REVERSEY = "ReverseY"

const SFNC_PIXELFORMAT = "PixelFormat"

const SFNC_PIXELCODING = "PixelCoding"

const SFNC_PIXELSIZE = "PixelSize"

const SFNC_PIXELCOLORFILTER = "PixelColorFilter"

const SFNC_PIXELDYNAMICRANGEMIN = "PixelDynamicRangeMin"

const SFNC_PIXELDYNAMICRANGEMAX = "PixelDynamicRangeMax"

const SFNC_TESTIMAGESELECTOR = "TestImageSelector"

const SFNC_ACQUISITIONCONTROL = "AcquisitionControl"

const SFNC_ACQUISITION_MODE = "AcquisitionMode"

const SFNC_ACQUISITION_START = "AcquisitionStart"

const SFNC_ACQUISITION_STOP = "AcquisitionStop"

const SFNC_ACQUISITION_ABORT = "AcquisitionAbort"

const SFNC_ACQUISITION_ARM = "AcquisitionArm"

const SFNC_ACQUISITION_FRAMECOUNT = "AcquisitionFrameCount"

const SFNC_ACQUISITION_FRAMERATE = "AcquisitionFrameRate"

const SFNC_ACQUISITION_FRAMERATEABS = "AcquisitionFrameRateAbs"

const SFNC_ACQUISITION_FRAMERATERAW = "AcquisitionFrameRateRaw"

const SFNC_ACQUISITION_LINERATE = "AcquisitionLineRate"

const SFNC_ACQUISITION_LINERATEABS = "AcquisitionLineRateAbs"

const SFNC_ACQUISITION_LINERATERAW = "AcquisitionLineRateRaw"

const SFNC_ACQUISITION_STATUSSELECTOR = "AcquisitionStatusSelector"

const SFNC_ACQUISITION_STATUS = "AcquisitionStatus"

const SFNC_TRIGGERSELECTOR = "TriggerSelector"

const SFNC_TRIGGERMODE = "TriggerMode"

const SFNC_TRIGGERSOFTWARE = "TriggerSoftware"

const SFNC_TRIGGERSOURCE = "TriggerSource"

const SFNC_TRIGGERACTIVATION = "TriggerActivation"

const SFNC_TRIGGEROVERLAP = "TriggerOverlap"

const SFNC_TRIGGERDELAY = "TriggerDelay"

const SFNC_TRIGGERDELAYABS = "TriggerDelayAbs"

const SFNC_TRIGGERDELAYRAW = "TriggerDelayRaw"

const SFNC_TRIGGERDIVIDER = "TriggerDivider"

const SFNC_TRIGGERMULTIPLIER = "TriggerMultiplier"

const SFNC_EXPOSUREMODE = "ExposureMode"

const SFNC_EXPOSURETIME = "ExposureTime"

const SFNC_EXPOSURETIMEABS = "ExposureTimeAbs"

const SFNC_EXPOSURETIMERAW = "ExposureTimeRaw"

const SFNC_EXPOSUREAUTO = "ExposureAuto"

const SFNC_DIGITALIOCONTROL = "DigitalIOControl"

const SFNC_LINESELECTOR = "LineSelector"

const SFNC_LINEMODE = "LineMode"

const SFNC_LINEINVERTER = "LineInverter"

const SFNC_LINESTATUS = "LineStatus"

const SFNC_LINESTATUSALL = "LineStatusAll"

const SFNC_LINESOURCE = "LineSource"

const SFNC_LINEFORMAT = "LineFormat"

const SFNC_USEROUTPUTSELECTOR = "UserOutputSelector"

const SFNC_USEROUTPUTVALUE = "UserOutputValue"

const SFNC_USEROUTPUTVALUEALL = "UserOutputValueAll"

const SFNC_USEROUTPUTVALUEALLMASK = "UserOutputValueAllMask"

const SFNC_COUNTERANDTIMERCONTROL = "CounterAndTimerControl"

const SFNC_COUNTERSELECTOR = "CounterSelector"

const SFNC_COUNTEREVENTSOURCE = "CounterEventSource"

const SFNC_COUNTEREVENTACTIVATION = "CounterEventActivation"

const SFNC_COUNTERRESETSOURCE = "CounterResetSource"

const SFNC_COUNTERRESETACTIVATION = "CounterResetActivation"

const SFNC_COUNTERRESET = "CounterReset"

const SFNC_COUNTERVALUE = "CounterValue"

const SFNC_COUNTERVALUEATRESET = "CounterValueAtReset"

const SFNC_COUNTERDURATION = "CounterDuration"

const SFNC_COUNTERSTATUS = "CounterStatus"

const SFNC_COUNTERTRIGGERSOURCE = "CounterTriggerSource"

const SFNC_COUNTERTRIGGERACTIVATION = "CounterTriggerActivation"

const SFNC_TIMERSELECTOR = "TimerSelector"

const SFNC_TIMERDURATION = "TimerDuration"

const SFNC_TIMERDURATIONABS = "TimerDurationAbs"

const SFNC_TIMERDURATIONRAW = "TimerDurationRaw"

const SFNC_TIMERDELAY = "TimerDelay"

const SFNC_TIMERDELAYABS = "TimerDelayAbs"

const SFNC_TIMERDELAYRAW = "TimerDelayRaw"

const SFNC_TIMERRESET = "TimerReset"

const SFNC_TIMERVALUE = "TimerValue"

const SFNC_TIMERVALUEABS = "TimerValueAbs"

const SFNC_TIMERVALUERAW = "TimerValueRaw"

const SFNC_TIMERSTATUS = "TimerStatus"

const SFNC_TIMERTRIGGERSOURCE = "TimerTriggerSource"

const SFNC_TIMERTRIGGERACTIVATION = "TimerTriggerActivation"

const SFNC_EVENTCONTROL = "EventControl"

const SFNC_EVENTSELECTOR = "EventSelector"

const SFNC_EVENTNOTIFICATION = "EventNotification"

const SFNC_EVENT_FRAMETRIGGERDATA = "EventFrameTriggerData"

const SFNC_EVENT_FRAMETRIGGER = "EventFrameTrigger"

const SFNC_EVENT_FRAMETRIGGERTIMESTAMP = "EventFrameTriggerTimestamp"

const SFNC_EVENT_FRAMETRIGGERFRAMEID = "EventFrameTriggerFrameID"

const SFNC_EVENT_EXPOSUREENDDATA = "EventExposureEndData"

const SFNC_EVENT_EXPOSUREEND = "EventExposureEnd"

const SFNC_EVENT_EXPOSUREENDTIMESTAMP = "EventExposureEndTimestamp"

const SFNC_EVENT_EXPOSUREENDFRAMEID = "EventExposureEndFrameID"

const SFNC_EVENT_ERRORDATA = "EventErrorData"

const SFNC_EVENT_ERROR = "EventError"

const SFNC_EVENT_ERRORTIMESTAMP = "EventErrorTimestamp"

const SFNC_EVENT_ERRORFRAMEID = "EventErrorFrameID"

const SFNC_EVENT_ERRORCODE = "EventErrorCode"

const SFNC_ANALOGCONTROL = "AnalogControl"

const SFNC_GAINSELECTOR = "GainSelector"

const SFNC_GAIN = "Gain"

const SFNC_GAINRAW = "GainRaw"

const SFNC_GAINABS = "GainAbs"

const SFNC_GAINAUTO = "GainAuto"

const SFNC_GAINAUTOBALANCE = "GainAutoBalance"

const SFNC_BLACKLEVELSELECTOR = "BlackLevelSelector"

const SFNC_BLACKLEVEL = "BlackLevel"

const SFNC_BLACKLEVELRAW = "BlackLevelRaw"

const SFNC_BLACKLEVELABS = "BlackLevelAbs"

const SFNC_BLACKLEVELAUTO = "BlackLevelAuto"

const SFNC_BLACKLEVELAUTOBALANCE = "BlackLevelAutoBalance"

const SFNC_WHITECLIPSELECTOR = "WhiteClipSelector"

const SFNC_WHITECLIP = "WhiteClip"

const SFNC_WHITECLIPRAW = "WhiteClipRaw"

const SFNC_WHITECLIPABS = "WhiteClipAbs"

const SFNC_BALANCERATIOSELECTOR = "BalanceRatioSelector"

const SFNC_BALANCERATIO = "BalanceRatio"

const SFNC_BALANCERATIOABS = "BalanceRatioAbs"

const SFNC_BALANCEWHITEAUTO = "BalanceWhiteAuto"

const SFNC_GAMMA = "Gamma"

const SFNC_LUTCONTROL = "LUTControl"

const SFNC_LUTSELECTOR = "LUTSelector"

const SFNC_LUTENABLE = "LUTEnable"

const SFNC_LUTINDEX = "LUTIndex"

const SFNC_LUTVALUE = "LUTValue"

const SFNC_LUTVALUEALL = "LUTValueAll"

const SFNC_ROOT = "Root"

const SFNC_DEVICE = "Device"

const SFNC_TLPARAMSLOCKED = "TLParamsLocked"

const SFNC_TRANSPORTLAYERCONTROL = "TransportLayerControl"

const SFNC_PAYLOADSIZE = "PayloadSize"

const SFNC_GEV_VERSIONMAJOR = "GevVersionMajor"

const SFNC_GEV_VERSIONMINOR = "GevVersionMinor"

const SFNC_GEV_DEVICEMODEISBIGENDIAN = "GevDeviceModeIsBigEndian"

const SFNC_GEV_DEVICECALSS = "GevDeviceClass"

const SFNC_GEV_DEVICEMODECHARACTERSET = "GevDeviceModeCharacterSet"

const SFNC_GEV_INTERFACESELECTOR = "GevInterfaceSelector"

const SFNC_GEV_MACADDRESS = "GevMACAddress"

const SFNC_GEV_SUPPORTEDOPTIONSELECTOR = "GevSupportedOptionSelector"

const SFNC_GEV_SUPPORTEDOPTION = "GevSupportedOption"

const SFNC_GEV_SUPPORTEDIPCONFIGURATIONLLA = "GevSupportedIPConfigurationLLA"

const SFNC_GEV_SUPPORTEDIPCONFIGURATIONDHCP = "GevSupportedIPConfigurationDHCP"

const SFNC_GEV_SUPPORTEDIPCONFIGURATIONPERSISTENTIP = "GevSupportedIPConfigurationPersistentIP"

const SFNC_GEV_CURRENTIPCONFIGURATION = "GevCurrentIPConfiguration"

const SFNC_GEV_CURRENTIPCONFIGURATIONLLA = "GevCurrentIPConfigurationLLA"

const SFNC_GEV_CURRENTIPCONFIGURATIONDHCP = "GevCurrentIPConfigurationDHCP"

const SFNC_GEV_CURRENTIPCONFIGURATIONPERSISTENTIP = "GevCurrentIPConfigurationPersistentIP"

const SFNC_GEV_CURRENTIPADDRESS = "GevCurrentIPAddress"

const SFNC_GEV_CURRENTSUBNETMASK = "GevCurrentSubnetMask"

const SFNC_GEV_CURRENTDEFAULTGATEWAY = "GevCurrentDefaultGateway"

const SFNC_GEV_IPCONFIGURATIONSTATUS = "GevIPConfigurationStatus"

const SFNC_GEV_FIRSTURL = "GevFirstURL"

const SFNC_GEV_SECONDURL = "GevSecondURL"

const SFNC_GEV_NUMBEROFINTERFACES = "GevNumberOfInterfaces"

const SFNC_GEV_PERSISTENTIPADDRESS = "GevPersistentIPAddress"

const SFNC_GEV_PERSISTENTSUBNETMASK = "GevPersistentSubnetMask"

const SFNC_GEV_PERSISTENTDEFAULTGATEWAY = "GevPersistentDefaultGateway"

const SFNC_GEV_GEVLINKSPEED = "GevLinkSpeed"

const SFNC_GEV_MESSAGECHANNELCOUNT = "GevMessageChannelCount"

const SFNC_GEV_STREAMCHANNELCOUNT = "GevStreamChannelCount"

const SFNC_GEV_SUPPORTEDOPTIONALCOMMANDSUSERDEFINEDNAME = "GevSupportedOptionalCommandsUserDefinedName"

const SFNC_GEV_SUPPORTEDOPTIONALCOMMANDSSERIALNUMBER = "GevSupportedOptionalCommandsSerialNumber"

const SFNC_GEV_SUPPORTEDOPTIONALCOMMANDSEVENTDATA = "GevSupportedOptionalCommandsEVENTDATA"

const SFNC_GEV_SUPPORTEDOPTIONALCOMMANDSEVENT = "GevSupportedOptionalCommandsEVENT"

const SFNC_GEV_SUPPORTEDOPTIONALCOMMANDSPACKETRESEND = "GevSupportedOptionalCommandsPACKETRESEND"

const SFNC_GEV_SUPPORTEDOPTIONALCOMMANDSWRITEMEM = "GevSupportedOptionalCommandsWRITEMEM"

const SFNC_GEV_SUPPORTEDOPTIONALCOMMANDSCONCATENATION = "GevSupportedOptionalCommandsConcatenation"

const SFNC_GEV_HEARTBEATTIMEOUT = "GevHeartbeatTimeout"

const SFNC_GEV_TIMESTAMPTICKFREQUENCY = "GevTimestampTickFrequency"

const SFNC_GEV_TIMESTAMPCONTROLLATCH = "GevTimestampControlLatch"

const SFNC_GEV_TIMESTAMPCONTROLRESET = "GevTimestampControlReset"

const SFNC_GEV_TIMESTAMPVALUE = "GevTimestampValue"

const SFNC_GEV_DISCOVERYACKDELAY = "GevDiscoveryAckDelay"

const SFNC_GEV_GVCPEXTENDEDSTATUSCODES = "GevGVCPExtendedStatusCodes"

const SFNC_GEV_GVCPPENDINGACK = "GevGVCPPendingAck"

const SFNC_GEV_GVCPHEARTBEATDISABLE = "GevGVCPHeartbeatDisable"

const SFNC_GEV_GVCPPENDINGTIMEOUT = "GevGVCPPendingTimeout"

const SFNC_GEV_PRIMARYAPPLICATIONSWITCHOVERKEY = "GevPrimaryApplicationSwitchoverKey"

const SFNC_GEV_CCP = "GevCCP"

const SFNC_GEV_PRIMARYAPPLICATIONSOCKET = "GevPrimaryApplicationSocket"

const SFNC_GEV_PRIMARYAPPLICATIONIPADDRESS = "GevPrimaryApplicationIPAddress"

const SFNC_GEV_MCPHOSTPORT = "GevMCPHostPort"

const SFNC_GEV_MCDA = "GevMCDA"

const SFNC_GEV_MCTT = "GevMCTT"

const SFNC_GEV_MCRC = "GevMCRC"

const SFNC_GEV_MCSP = "GevMCSP"

const SFNC_GEV_STREAMCHANNELSELECTOR = "GevStreamChannelSelector"

const SFNC_GEV_SCCFGUNCONDITIONALSTREAMING = "GevSCCFGUnconditionalStreaming"

const SFNC_GEV_SCCFGEXTENDEDCHUNKDATA = "GevSCCFGExtendedChunkData"

const SFNC_GEV_SCPDIRECTION = "GevSCPDirection"

const SFNC_GEV_SCPINTERFACEINDEX = "GevSCPInterfaceIndex"

const SFNC_GEV_SCPHOSTPORT = "GevSCPHostPort"

const SFNC_GEV_SCPSFIRETESTPACKET = "GevSCPSFireTestPacket"

const SFNC_GEV_SCPSDONOTFRAGMENT = "GevSCPSDoNotFragment"

const SFNC_GEV_SCPSBIGENDIAN = "GevSCPSBigEndian"

const SFNC_GEV_SCPSPACKETSIZE = "GevSCPSPacketSize"

const SFNC_GEV_SCPD = "GevSCPD"

const SFNC_GEV_SCDA = "GevSCDA"

const SFNC_GEV_SCSP = "GevSCSP"

const SFNC_GEV_MANIFESTENTRYSELECTOR = "GevManifestEntrySelector"

const SFNC_GEV_MANIFESTXMLMAJORVERSION = "GevManifestXMLMajorVersion"

const SFNC_GEV_MANIFESTXMLMINORVERSION = "GevManifestXMLMinorVersion"

const SFNC_GEV_MANIFESTXMLSUBMINORVERSION = "GevManifestXMLSubMinorVersion"

const SFNC_GEV_MANIFESTSCHEMAMAJORVERSION = "GevManifestSchemaMajorVersion"

const SFNC_GEV_MANIFESTSCHEMAMINORVERSION = "GevManifestSchemaMinorVersion"

const SFNC_GEV_MANIFESTPRIMARYURL = "GevManifestPrimaryURL"

const SFNC_GEV_MANIFESTSECONDARYURL = "GevManifestSecondaryURL"

const SFNC_CL_CONFIGURATION = "ClConfiguration"

const SFNC_CL_TIMESLOTSCOUNT = "ClTimeSlotsCount"

const SFNC_DEVICETAPGEOMETRY = "DeviceTapGeometry"

const SFNC_USERSETCONTROL = "UserSetControl"

const SFNC_USERSETSELECTOR = "UserSetSelector"

const SFNC_USERSETLOAD = "UserSetLoad"

const SFNC_USERSETSAVE = "UserSetSave"

const SFNC_USERSETDEFAULTSELECTOR = "UserSetDefaultSelector"

const SFNC_CHUNKDATACONTROL = "ChunkDataControl"

const SFNC_CHUNKMODEACTIVE = "ChunkModeActive"

const SFNC_CHUNKSELECTOR = "ChunkSelector"

const SFNC_CHUNKENABLE = "ChunkEnable"

const SFNC_CHUNKIMAGE = "ChunkImage"

const SFNC_CHUNKOFFSETX = "ChunkOffsetX"

const SFNC_CHUNKOFFSETY = "ChunkOffsetY"

const SFNC_CHUNKWIDTH = "ChunkWidth"

const SFNC_CHUNKHEIGHT = "ChunkHeight"

const SFNC_CHUNKPIXELFORMAT = "ChunkPixelFormat"

const SFNC_CHUNKSOURCEIDVALUE = "ChunkSourceIDValue"

const SFNC_CHUNKREGIONIDVALUE = "ChunkRegionIDValue"

const SFNC_CHUNKGROUPIDVALUE = "ChunkGroupIDValue"

const SFNC_CHUNKPIXELDYNAMICRANGEMIN = "ChunkPixelDynamicRangeMin"

const SFNC_CHUNKPIXELDYNAMICRANGEMAX = "ChunkPixelDynamicRangeMax"

const SFNC_CHUNKDYNAMICRANGEMIN = "ChunkDynamicRangeMin"

const SFNC_CHUNKDYNAMICRANGEMAX = "ChunkDynamicRangeMax"

const SFNC_CHUNKTIMESTAMP = "ChunkTimestamp"

const SFNC_CHUNKLINESTATUSALL = "ChunkLineStatusAll"

const SFNC_CHUNKCOUNTERSELECTOR = "ChunkCounterSelector"

const SFNC_CHUNKCOUNTERVALUE = "ChunkCounterValue"

const SFNC_CHUNKCOUNTER = "ChunkCounter"

const SFNC_CHUNKTIMERSELECTOR = "ChunkTimerSelector"

const SFNC_CHUNKTIMERVALUE = "ChunkTimerValue"

const SFNC_CHUNKTIMER = "ChunkTimer"

const SFNC_CHUNKEXPOSURETIME = "ChunkExposureTime"

const SFNC_CHUNKGAINSELECTOR = "ChunkGainSelector"

const SFNC_CHUNKGAIN = "ChunkGain"

const SFNC_CHUNKBLACKLEVELSELECTOR = "ChunkBlackLevelSelector"

const SFNC_CHUNKBLACKLEVEL = "ChunkBlackLevel"

const SFNC_CHUNKLINEPITCH = "ChunkLinePitch"

const SFNC_CHUNKFRAMEID = "ChunkFrameID"

const SFNC_CHUNKBINNINGVERTICALID = "ChunkBinningVertical"

const SFNC_CHUNKBINNINGHORIZONTALID = "ChunkBinningHorizontal"

const SFNC_FILEACCESSCONTROL = "FileAccessControl"

const SFNC_FILESELECTOR = "FileSelector"

const SFNC_FILEOPERATIONSELECTOR = "FileOperationSelector"

const SFNC_FILEOPERATIONEXECUTE = "FileOperationExecute"

const SFNC_FILEOPENMODE = "FileOpenMode"

const SFNC_FILEACCESSBUFFER = "FileAccessBuffer"

const SFNC_FILEACCESSOFFSET = "FileAccessOffset"

const SFNC_FILEACCESSLENGTH = "FileAccessLength"

const SFNC_FILEOPERATIONSTATUS = "FileOperationStatus"

const SFNC_FILEOPERATIONRESULT = "FileOperationResult"

const SFNC_FILESIZE = "FileSize"

const SFNC_COLORTRANSFORMATIONCONTROL = "ColorTransformationControl"

const SFNC_COLORTRANSFORMATIONSELECTOR = "ColorTransformationSelector"

const SFNC_COLORTRANSFORMATIONENABLE = "ColorTransformationEnable"

const SFNC_COLORTRANSFORMATIONVALUESELECTOR = "ColorTransformationValueSelector"

const SFNC_COLORTRANSFORMATIONVALUE = "ColorTransformationValue"

const SFNC_ACTIONCONTROL = "ActionControl"

const SFNC_ACTIONDEVICEKEY = "ActionDeviceKey"

const SFNC_ACTIONSELECTOR = "ActionSelector"

const SFNC_ACTIONGROUPMASK = "ActionGroupMask"

const SFNC_ACTIONGROUPKEY = "ActionGroupKey"

const GENTL_SFNC_TLPORT = "TLPort"

const GENTL_SFNC_TLVENDORNAME = "TLVendorName"

const GENTL_SFNC_TLMODELNAME = "TLModelName"

const GENTL_SFNC_TLID = "TLID"

const GENTL_SFNC_TLVERSION = "TLVersion"

const GENTL_SFNC_TLPATH = "TLPath"

const GENTL_SFNC_TLTYPE = "TLType"

const GENTL_SFNC_GENTLVERSIONMAJOR = "GenTLVersionMajor"

const GENTL_SFNC_GENTLVERSIONMINOR = "GenTLVersionMinor"

const GENTL_SFNC_GENTLINTERFACEUPDATELIST = "InterfaceUpdateList"

const GENTL_SFNC_GENTLINTERFACESELECTOR = "InterfaceSelector"

const GENTL_SFNC_GENTLINTERFACEID = "InterfaceID"

const GENTL_SFNC_GEVVERSIONMAJOR = "GevVersionMajor"

const GENTL_SFNC_GEVVERSIONMINOR = "GevVersionMinor"

const GENTL_SFNC_GEVINTERFACEMACADDRESS = "GevInterfaceMACAddress"

const GENTL_SFNC_GEVINTERFACEDEFAULTIPADDRESS = "GevInterfaceDefaultIPAddress"

const GENTL_SFNC_GEVINTERFACEDEFAULTSUBNETMASK = "GevInterfaceDefaultSubnetMask"

const GENTL_SFNC_GEVINTERFACEDEFAULTGATEWAY = "GevInterfaceDefaultGateway"

const GENTL_SFNC_INTERFACEPORT = "InterfacePort"

const GENTL_SFNC_INTERFACEID = "InterfaceID"

const GENTL_SFNC_INTERFACETYPE = "InterfaceType"

const GENTL_SFNC_DEVICEUPDATELIST = "DeviceUpdateList"

const GENTL_SFNC_DEVICESELECTOR = "DeviceSelector"

const GENTL_SFNC_DEVICEID = "DeviceID"

const GENTL_SFNC_DEVICEVENDORNAME = "DeviceVendorName"

const GENTL_SFNC_DEVICEMODELNAME = "DeviceModelName"

const GENTL_SFNC_DEVICEACCESSSTATUS = "DeviceAccessStatus"

const GENTL_SFNC_GEVINTERFACEGATEWAYSELECTOR = "GevInterfaceGatewaySelector"

const GENTL_SFNC_GEVINTERFACEGATEWAY = "GevInterfaceGateway"

const GENTL_SFNC_GEVINTERFACESUBNETSELECTOR = "GevInterfaceSubnetSelector"

const GENTL_SFNC_GEVINTERFACESUBNETIPADDRESS = "GevInterfaceSubnetIPAddress"

const GENTL_SFNC_GEVINTERFACESUBNETMASK = "GevInterfaceSubnetMask"

const GENTL_SFNC_DEVICEPORT = "DevicePort"

const GENTL_SFNC_DEVICETYPE = "DeviceType"

const GENTL_SFNC_STREAMSELECTOR = "StreamSelector"

const GENTL_SFNC_STREAMID = "StreamID"

const GENTL_SFNC_GEVDEVICEIPADDRESS = "GevDeviceIPAddress"

const GENTL_SFNC_GEVDEVICESUBNETMASK = "GevDeviceSubnetMask"

const GENTL_SFNC_GEVDEVICEMACADDRESS = "GevDeviceMACAddress"

const GENTL_SFNC_GEVDEVICEGATEWAY = "GevDeviceGateway"

const GENTL_SFNC_DEVICEENDIANESSMECHANISM = "DeviceEndianessMechanism"

const GENTL_SFNC_STREAMPORT = "StreamPort"

const GENTL_SFNC_STREAMANNOUNCEDBUFFERCOUNT = "StreamAnnouncedBufferCount"

const GENTL_SFNC_STREAMACQUISITIONMODESELECTOR = "StreamAcquisitionModeSelector"

const GENTL_SFNC_STREAMANNOUNCEBUFFERMINIMUM = "StreamAnnounceBufferMinimum"

const GENTL_SFNC_STREAMTYPE = "StreamType"

const GENTL_SFNC_BUFFERPORT = "BufferPort"

const GENTL_SFNC_BUFFERDATA = "BufferData"

const GENTL_SFNC_BUFFERUSERDATA = "BufferUserData"

const GENTL_SFNC_BUFFER_CUSTOM_HOSTTIMESTAMP = "HostTimestamp"

const SFNC_CHUNKSELECTORVALUE_IMAGE = "Image"

const SFNC_CHUNKSELECTORVALUE_OFFSETX = "OffsetX"

const SFNC_CHUNKSELECTORVALUE_OFFSETY = "OffsetY"

const SFNC_CHUNKSELECTORVALUE_WIDTH = "Width"

const SFNC_CHUNKSELECTORVALUE_HEIGHT = "Height"

const SFNC_CHUNKSELECTORVALUE_PIXELFORMAT = "PixelFormat"

const SFNC_CHUNKSELECTORVALUE_DYNAMICRANGEMAX = "DynamicRangeMax"

const SFNC_CHUNKSELECTORVALUE_DYNAMICRANGEMIN = "DynamicRangeMin"

const SFNC_CHUNKSELECTORVALUE_PIXELDYNAMICRANGEMAX = "PixelDynamicRangeMax"

const SFNC_CHUNKSELECTORVALUE_PIXELDYNAMICRANGEMIN = "PixelDynamicRangeMin"

const SFNC_CHUNKSELECTORVALUE_TIMESTAMP = "Timestamp"

const SFNC_CHUNKSELECTORVALUE_LINESTATUSALL = "LineStatusAll"

const SFNC_CHUNKSELECTORVALUE_COUNTERVALUE = "CounterValue"

const SFNC_CHUNKSELECTORVALUE_TIMERVALUE = "TimerValue"

const SFNC_CHUNKSELECTORVALUE_EXPOSURETIME = "ExposureTime"

const SFNC_CHUNKSELECTORVALUE_GAIN = "Gain"

const SFNC_CHUNKSELECTORVALUE_BLACKLEVEL = "BlackLevel"

const SFNC_CHUNKSELECTORVALUE_LINEPITCH = "LinePitch"

const SFNC_CHUNKSELECTORVALUE_FRAMEID = "FrameID"

const SFNC_DEVICE_TEMPERATURESELECTORVALUE_SENSOR = "Sensor"

const SFNC_DEVICE_TEMPERATURESELECTORVALUE_MAINBOARD = "Mainboard"

const SFNC_DEVICE_CLOCKSELECTORVALUE_SENSOR = "Sensor"

const SFNC_DEVICE_CLOCKSELECTORVALUE_SENSORDIGITIZATION = "SensorDigitization"

const SFNC_DEVICE_CLOCKSELECTORVALUE_CAMERALINK = "CameraLink"

const SFNC_DEVICE_SERIALPORTSELECTORVALUE_CAMERALINK = "CameraLink"

const SFNC_TESTIMAGESELECTORVALUE_OFF = "Off"

const SFNC_TESTIMAGESELECTORVALUE_BLACK = "Black"

const SFNC_TESTIMAGESELECTORVALUE_WHITE = "White"

const SFNC_TESTIMAGESELECTORVALUE_GREYHORIZONTALRAMP = "GreyHorizontalRamp"

const SFNC_TESTIMAGESELECTORVALUE_GREYVERTICALRAMP = "GreyVerticalRamp"

const SFNC_TESTIMAGESELECTORVALUE_GREYHORIZONTALRAMPMOVING = "GreyHorizontalRampMoving"

const SFNC_TESTIMAGESELECTORVALUE_GREYVERTICALRAMPMOVING = "GreyVerticalRampMoving"

const SFNC_TESTIMAGESELECTORVALUE_HORIZONTALLINEMOVING = "HorzontalLineMoving"

const SFNC_TESTIMAGESELECTORVALUE_VERTICALLINEMOVING = "VerticalLineMoving"

const SFNC_TESTIMAGESELECTORVALUE_COLORBAR = "ColorBar"

const SFNC_TESTIMAGESELECTORVALUE_FRAMECOUNTER = "FrameCounter"

const SFNC_ACQUISITION_STATUSSELECTORVALUE_ACQUISITIONTRIGGERWAIT = "AcquisitionTriggerWait"

const SFNC_ACQUISITION_STATUSSELECTORVALUE_ACQUISITIONACTIVE = "AcquisitionActive"

const SFNC_ACQUISITION_STATUSSELECTORVALUE_ACQUISITIONTRANSFER = "AcquisitionTransfer"

const SFNC_ACQUISITION_STATUSSELECTORVALUE_FRAMETRIGGERWAIT = "FrameTriggerWait"

const SFNC_ACQUISITION_STATUSSELECTORVALUE_FRAMEACTIVE = "FrameActive"

const SFNC_ACQUISITION_STATUSSELECTORVALUE_FRAMETRANSFER = "FrameTransfer"

const SFNC_ACQUISITION_STATUSSELECTORVALUE_EXPOSUREACTIVE = "ExposureActive"

const SFNC_TRIGGERSELECTORVALUE_ACQUISITIONSTART = "AcquisitionStart"

const SFNC_TRIGGERSELECTORVALUE_ACQUISITIONEND = "AcquisitionEnd"

const SFNC_TRIGGERSELECTORVALUE_ACQUISITIONACTIVE = "AcquisitionActive"

const SFNC_TRIGGERSELECTORVALUE_FRAMESTART = "FrameStart"

const SFNC_TRIGGERSELECTORVALUE_FRAMEEND = "FrameEnd"

const SFNC_TRIGGERSELECTORVALUE_FRAMEACTIVE = "FrameActive"

const SFNC_TRIGGERSELECTORVALUE_FRAMEBURSTSTART = "FrameBurstStart"

const SFNC_TRIGGERSELECTORVALUE_FRAMEBURSTEND = "FrameBurstEnd"

const SFNC_TRIGGERSELECTORVALUE_FRAMEBURSTACTIVE = "FrameBurstActive"

const SFNC_TRIGGERSELECTORVALUE_LINESTART = "LineStart"

const SFNC_TRIGGERSELECTORVALUE_EXPOSURESTART = "ExposureStart"

const SFNC_TRIGGERSELECTORVALUE_EXPOSUREEND = "ExposureEnd"

const SFNC_TRIGGERSELECTORVALUE_EXPOSUREACTIVE = "ExposureActive"

const SFNC_LINESELECTORVALUE_LINE0 = "Line0"

const SFNC_LINESELECTORVALUE_LINE1 = "Line1"

const SFNC_LINESELECTORVALUE_LINE2 = "Line2"

const SFNC_LINESELECTORVALUE_LINE3 = "Line3"

const SFNC_LINESELECTORVALUE_LINE4 = "Line4"

const SFNC_LINESELECTORVALUE_LINE5 = "Line5"

const SFNC_LINESELECTORVALUE_LINE6 = "Line6"

const SFNC_LINESELECTORVALUE_LINE7 = "Line7"

const SFNC_LINESELECTORVALUE_CC1 = "CC1"

const SFNC_LINESELECTORVALUE_CC2 = "CC2"

const SFNC_LINESELECTORVALUE_CC3 = "CC3"

const SFNC_LINESELECTORVALUE_CC4 = "CC4"

const SFNC_USEROUTPUTSELECTORVALUE_USEROUTPUT0 = "UserOutput0"

const SFNC_USEROUTPUTSELECTORVALUE_USEROUTPUT1 = "UserOutput1"

const SFNC_USEROUTPUTSELECTORVALUE_USEROUTPUT2 = "UserOutput2"

const SFNC_USEROUTPUTSELECTORVALUE_USEROUTPUT3 = "UserOutput3"

const SFNC_COUNTERSELECTORVALUE_COUNTER1 = "Counter1"

const SFNC_COUNTERSELECTORVALUE_COUNTER2 = "Counter2"

const SFNC_COUNTERSELECTORVALUE_COUNTER3 = "Counter3"

const SFNC_COUNTERSELECTORVALUE_COUNTER4 = "Counter4"

const SFNC_COUNTERSELECTORVALUE_COUNTER5 = "Counter5"

const SFNC_COUNTERSELECTORVALUE_COUNTER6 = "Counter6"

const SFNC_COUNTERSELECTORVALUE_COUNTER7 = "Counter7"

const SFNC_COUNTERSELECTORVALUE_COUNTER8 = "Counter8"

const SFNC_TIMERSELECTORVALUE_TIMER1 = "Timer1"

const SFNC_TIMERSELECTORVALUE_TIMER2 = "Timer2"

const SFNC_TIMERSELECTORVALUE_TIMER3 = "Timer3"

const SFNC_TIMERSELECTORVALUE_TIMER4 = "Timer4"

const SFNC_TIMERSELECTORVALUE_TIMER5 = "Timer5"

const SFNC_TIMERSELECTORVALUE_TIMER6 = "Timer6"

const SFNC_TIMERSELECTORVALUE_TIMER7 = "Timer7"

const SFNC_TIMERSELECTORVALUE_TIMER8 = "Timer8"

const SFNC_EVENTSELECTORVALUE_ACQUISITIONTRIGGER = "AcquisitionTrigger"

const SFNC_EVENTSELECTORVALUE_ACQUISITIONSTART = "AcquisitionStart"

const SFNC_EVENTSELECTORVALUE_ACQUISITIONEND = "AcquisitionEnd"

const SFNC_EVENTSELECTORVALUE_ACQUISITIONTRANSFERSTART = "AcquisitionTransferStart"

const SFNC_EVENTSELECTORVALUE_ACQUISITIONTRANSFEREND = "AcquisitionTransferEnd"

const SFNC_EVENTSELECTORVALUE_ACQUISITIONERROR = "AcquisitionError"

const SFNC_EVENTSELECTORVALUE_FRAMETRIGGER = "FrameTrigger"

const SFNC_EVENTSELECTORVALUE_FRAMESTART = "FrameStart"

const SFNC_EVENTSELECTORVALUE_FRAMEEND = "FrameEnd"

const SFNC_EVENTSELECTORVALUE_FRAMEBURSTSTART = "FrameBurstStart"

const SFNC_EVENTSELECTORVALUE_FRAMEBURSTEND = "FrameBurstEnd"

const SFNC_EVENTSELECTORVALUE_FRAMETRANSFERSTART = "FrameTransferStart"

const SFNC_EVENTSELECTORVALUE_FRAMETRANSFEREND = "FrameTransferEnd"

const SFNC_EVENTSELECTORVALUE_EXPOSURESTART = "ExposureStart"

const SFNC_EVENTSELECTORVALUE_EXPOSUREEND = "ExposureEnd"

const SFNC_EVENTSELECTORVALUE_COUNTER1START = "Counter1Start"

const SFNC_EVENTSELECTORVALUE_COUNTER2START = "Counter2Start"

const SFNC_EVENTSELECTORVALUE_COUNTER3START = "Counter3Start"

const SFNC_EVENTSELECTORVALUE_COUNTER4START = "Counter4Start"

const SFNC_EVENTSELECTORVALUE_COUNTER5START = "Counter5Start"

const SFNC_EVENTSELECTORVALUE_COUNTER6START = "Counter6Start"

const SFNC_EVENTSELECTORVALUE_COUNTER7START = "Counter7Start"

const SFNC_EVENTSELECTORVALUE_COUNTER8START = "Counter8Start"

const SFNC_EVENTSELECTORVALUE_COUNTER1END = "Counter1End"

const SFNC_EVENTSELECTORVALUE_COUNTER2END = "Counter2End"

const SFNC_EVENTSELECTORVALUE_COUNTER3END = "Counter3End"

const SFNC_EVENTSELECTORVALUE_COUNTER4END = "Counter4End"

const SFNC_EVENTSELECTORVALUE_COUNTER5END = "Counter5End"

const SFNC_EVENTSELECTORVALUE_COUNTER6END = "Counter6End"

const SFNC_EVENTSELECTORVALUE_COUNTER7END = "Counter7End"

const SFNC_EVENTSELECTORVALUE_COUNTER8END = "Counter8End"

const SFNC_EVENTSELECTORVALUE_TIMER1START = "Timer1Start"

const SFNC_EVENTSELECTORVALUE_TIMER2START = "Timer2Start"

const SFNC_EVENTSELECTORVALUE_TIMER3START = "Timer3Start"

const SFNC_EVENTSELECTORVALUE_TIMER4START = "Timer4Start"

const SFNC_EVENTSELECTORVALUE_TIMER5START = "Timer5Start"

const SFNC_EVENTSELECTORVALUE_TIMER6START = "Timer6Start"

const SFNC_EVENTSELECTORVALUE_TIMER7START = "Timer7Start"

const SFNC_EVENTSELECTORVALUE_TIMER8START = "Timer8Start"

const SFNC_EVENTSELECTORVALUE_TIMER1END = "Timer1End"

const SFNC_EVENTSELECTORVALUE_TIMER2END = "Timer2End"

const SFNC_EVENTSELECTORVALUE_TIMER3END = "Timer3End"

const SFNC_EVENTSELECTORVALUE_TIMER4END = "Timer4End"

const SFNC_EVENTSELECTORVALUE_TIMER5END = "Timer5End"

const SFNC_EVENTSELECTORVALUE_TIMER6END = "Timer6End"

const SFNC_EVENTSELECTORVALUE_TIMER7END = "Timer7End"

const SFNC_EVENTSELECTORVALUE_TIMER8END = "Timer8End"

const SFNC_EVENTSELECTORVALUE_LINE0RISINGEDGE = "Line0RisingEdge"

const SFNC_EVENTSELECTORVALUE_LINE1RISINGEDGE = "Line1RisingEdge"

const SFNC_EVENTSELECTORVALUE_LINE2RISINGEDGE = "Line2RisingEdge"

const SFNC_EVENTSELECTORVALUE_LINE3RISINGEDGE = "Line3RisingEdge"

const SFNC_EVENTSELECTORVALUE_LINE4RISINGEDGE = "Line4RisingEdge"

const SFNC_EVENTSELECTORVALUE_LINE5RISINGEDGE = "Line5RisingEdge"

const SFNC_EVENTSELECTORVALUE_LINE6RISINGEDGE = "Line6RisingEdge"

const SFNC_EVENTSELECTORVALUE_LINE7RISINGEDGE = "Line7RisingEdge"

const SFNC_EVENTSELECTORVALUE_LINE0FALLINGEDGE = "Line0FallingEdge"

const SFNC_EVENTSELECTORVALUE_LINE1FALLINGEDGE = "Line1FallingEdge"

const SFNC_EVENTSELECTORVALUE_LINE2FALLINGEDGE = "Line2FallingEdge"

const SFNC_EVENTSELECTORVALUE_LINE3FALLINGEDGE = "Line3FallingEdge"

const SFNC_EVENTSELECTORVALUE_LINE4FALLINGEDGE = "Line4FallingEdge"

const SFNC_EVENTSELECTORVALUE_LINE5FALLINGEDGE = "Line5FallingEdge"

const SFNC_EVENTSELECTORVALUE_LINE6FALLINGEDGE = "Line6FallingEdge"

const SFNC_EVENTSELECTORVALUE_LINE7FALLINGEDGE = "Line7FallingEdge"

const SFNC_EVENTSELECTORVALUE_LINE0ANYEDGE = "Line0AnyEdge"

const SFNC_EVENTSELECTORVALUE_LINE1ANYEDGE = "Line1AnyEdge"

const SFNC_EVENTSELECTORVALUE_LINE2ANYEDGE = "Line2AnyEdge"

const SFNC_EVENTSELECTORVALUE_LINE3ANYEDGE = "Line3AnyEdge"

const SFNC_EVENTSELECTORVALUE_LINE4ANYEDGE = "Line4AnyEdge"

const SFNC_EVENTSELECTORVALUE_LINE5ANYEDGE = "Line5AnyEdge"

const SFNC_EVENTSELECTORVALUE_LINE6ANYEDGE = "Line6AnyEdge"

const SFNC_EVENTSELECTORVALUE_LINE7ANYEDGE = "Line7AnyEdge"

const SFNC_EVENTSELECTORVALUE_ERROR = "Error"

const SFNC_EVENTSELECTORVALUE_ERRORS = "Errors"

const SFNC_GAINSELECTORVALUE_ALL = "All"

const SFNC_GAINSELECTORVALUE_RED = "Red"

const SFNC_GAINSELECTORVALUE_GREEN = "Green"

const SFNC_GAINSELECTORVALUE_BLUE = "Blue"

const SFNC_GAINSELECTORVALUE_Y = "Y"

const SFNC_GAINSELECTORVALUE_U = "U"

const SFNC_GAINSELECTORVALUE_V = "V"

const SFNC_GAINSELECTORVALUE_TAP1 = "Tap1"

const SFNC_GAINSELECTORVALUE_TAP2 = "Tap2"

const SFNC_GAINSELECTORVALUE_TAP3 = "Tap3"

const SFNC_GAINSELECTORVALUE_TAP4 = "Tap4"

const SFNC_GAINSELECTORVALUE_TAP5 = "Tap5"

const SFNC_GAINSELECTORVALUE_TAP6 = "Tap6"

const SFNC_GAINSELECTORVALUE_TAP7 = "Tap7"

const SFNC_GAINSELECTORVALUE_TAP8 = "Tap8"

const SFNC_GAINSELECTORVALUE_ANALOGALL = "AnalogAll"

const SFNC_GAINSELECTORVALUE_ANALOGRED = "AnalogRed"

const SFNC_GAINSELECTORVALUE_ANALOGGREEN = "AnalogGreen"

const SFNC_GAINSELECTORVALUE_ANALOGBLUE = "AnalogBlue"

const SFNC_GAINSELECTORVALUE_ANALOGY = "AnalogY"

const SFNC_GAINSELECTORVALUE_ANALOGU = "AnalogU"

const SFNC_GAINSELECTORVALUE_ANALOGV = "AnalogV"

const SFNC_GAINSELECTORVALUE_ANALOGTAP1 = "AnalogTap1"

const SFNC_GAINSELECTORVALUE_ANALOGTAP2 = "AnalogTap2"

const SFNC_GAINSELECTORVALUE_ANALOGTAP3 = "AnalogTap3"

const SFNC_GAINSELECTORVALUE_ANALOGTAP4 = "AnalogTap4"

const SFNC_GAINSELECTORVALUE_ANALOGTAP5 = "AnalogTap5"

const SFNC_GAINSELECTORVALUE_ANALOGTAP6 = "AnalogTap6"

const SFNC_GAINSELECTORVALUE_ANALOGTAP7 = "AnalogTap7"

const SFNC_GAINSELECTORVALUE_ANALOGTAP8 = "AnalogTap8"

const SFNC_GAINSELECTORVALUE_DIGITALALL = "DigitalAll"

const SFNC_GAINSELECTORVALUE_DIGITALRED = "DigitalRed"

const SFNC_GAINSELECTORVALUE_DIGITALGREEN = "DigitalGreen"

const SFNC_GAINSELECTORVALUE_DIGITALBLUE = "DigitalBlue"

const SFNC_GAINSELECTORVALUE_DIGITALY = "DigitalY"

const SFNC_GAINSELECTORVALUE_DIGITALU = "DigitalU"

const SFNC_GAINSELECTORVALUE_DIGITALV = "DigitalV"

const SFNC_GAINSELECTORVALUE_DIGITALTAP1 = "DigitalTap1"

const SFNC_GAINSELECTORVALUE_DIGITALTAP2 = "DigitalTap2"

const SFNC_GAINSELECTORVALUE_DIGITALTAP3 = "DigitalTap3"

const SFNC_GAINSELECTORVALUE_DIGITALTAP4 = "DigitalTap4"

const SFNC_GAINSELECTORVALUE_DIGITALTAP5 = "DigitalTap5"

const SFNC_GAINSELECTORVALUE_DIGITALTAP6 = "DigitalTap6"

const SFNC_GAINSELECTORVALUE_DIGITALTAP7 = "DigitalTap7"

const SFNC_GAINSELECTORVALUE_DIGITALTAP8 = "DigitalTap8"

const SFNC_BLACKLEVELSELECTORVALUE_ALL = "All"

const SFNC_BLACKLEVELSELECTORVALUE_RED = "Red"

const SFNC_BLACKLEVELSELECTORVALUE_GREEN = "Green"

const SFNC_BLACKLEVELSELECTORVALUE_BLUE = "Blue"

const SFNC_BLACKLEVELSELECTORVALUE_Y = "Y"

const SFNC_BLACKLEVELSELECTORVALUE_U = "U"

const SFNC_BLACKLEVELSELECTORVALUE_V = "V"

const SFNC_BLACKLEVELSELECTORVALUE_TAP1 = "Tap1"

const SFNC_BLACKLEVELSELECTORVALUE_TAP2 = "Tap2"

const SFNC_BLACKLEVELSELECTORVALUE_TAP3 = "Tap3"

const SFNC_BLACKLEVELSELECTORVALUE_TAP4 = "Tap4"

const SFNC_BLACKLEVELSELECTORVALUE_TAP5 = "Tap5"

const SFNC_BLACKLEVELSELECTORVALUE_TAP6 = "Tap6"

const SFNC_BLACKLEVELSELECTORVALUE_TAP7 = "Tap7"

const SFNC_BLACKLEVELSELECTORVALUE_TAP8 = "Tap8"

const SFNC_WHITECLIPSELECTORVALUE_ALL = "All"

const SFNC_WHITECLIPSELECTORVALUE_RED = "Red"

const SFNC_WHITECLIPSELECTORVALUE_GREEN = "Green"

const SFNC_WHITECLIPSELECTORVALUE_BLUE = "Blue"

const SFNC_WHITECLIPSELECTORVALUE_Y = "Y"

const SFNC_WHITECLIPSELECTORVALUE_U = "U"

const SFNC_WHITECLIPSELECTORVALUE_V = "V"

const SFNC_WHITECLIPSELECTORVALUE_TAP1 = "Tap1"

const SFNC_WHITECLIPSELECTORVALUE_TAP2 = "Tap2"

const SFNC_WHITECLIPSELECTORVALUE_TAP3 = "Tap3"

const SFNC_WHITECLIPSELECTORVALUE_TAP4 = "Tap4"

const SFNC_WHITECLIPSELECTORVALUE_TAP5 = "Tap5"

const SFNC_WHITECLIPSELECTORVALUE_TAP6 = "Tap6"

const SFNC_WHITECLIPSELECTORVALUE_TAP7 = "Tap7"

const SFNC_WHITECLIPSELECTORVALUE_TAP8 = "Tap8"

const SFNC_BALANCERATIOSELECTORVALUE_ALL = "All"

const SFNC_BALANCERATIOSELECTORVALUE_RED = "Red"

const SFNC_BALANCERATIOSELECTORVALUE_GREEN = "Green"

const SFNC_BALANCERATIOSELECTORVALUE_BLUE = "Blue"

const SFNC_BALANCERATIOSELECTORVALUE_Y = "Y"

const SFNC_BALANCERATIOSELECTORVALUE_U = "U"

const SFNC_BALANCERATIOSELECTORVALUE_V = "V"

const SFNC_BALANCERATIOSELECTORVALUE_TAP1 = "Tap1"

const SFNC_BALANCERATIOSELECTORVALUE_TAP2 = "Tap2"

const SFNC_BALANCERATIOSELECTORVALUE_TAP3 = "Tap3"

const SFNC_BALANCERATIOSELECTORVALUE_TAP4 = "Tap4"

const SFNC_BALANCERATIOSELECTORVALUE_TAP5 = "Tap5"

const SFNC_BALANCERATIOSELECTORVALUE_TAP6 = "Tap6"

const SFNC_BALANCERATIOSELECTORVALUE_TAP7 = "Tap7"

const SFNC_BALANCERATIOSELECTORVALUE_TAP8 = "Tap8"

const SFNC_LUTSELECTORVALUE_LUMINANCE = "Luminance"

const SFNC_LUTSELECTORVALUE_RED = "Red"

const SFNC_LUTSELECTORVALUE_GREEN = "Green"

const SFNC_LUTSELECTORVALUE_BLUE = "Blue"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_IPCONFIGURATIONLLA = "IPConfigurationLLA"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_IPCONFIGURATIONDHCP = "IPConfigurationDHCP"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_IPCONFIGURATIONPERSISTENTIP = "IPConfigurationPersistentIP"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNELSOURCESOCKET = "StreamChannelSourceSocket"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_MESSAGECHANNELSOURCESOCKET = "MessageChannelSourceSocket"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_COMMANDSCONCATENATION = "CommandsConcatenation"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_WRITEMEM = "WriteMem"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_PACKETRESEND = "PacketResend"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_EVENT = "Event"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_EVENTDATA = "EventData"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_PENDINGACK = "PendingAck"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_ACTION = "Action"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_PRIMARYAPPLICATIONSWITCHOVER = "PrimaryApplicationSwitchover"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_EXTENDEDSTATUSCODES = "ExtendedStatusCodes"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_DISCOVERYACKDELAY = "DiscoveryAckDelay"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_DISCOVERYACKDELAYWRITABLE = "DiscoveryAckDelayWritable"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_TESTDATA = "TestData"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_MANIFESTTABLE = "ManifestTable"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_CCPAPPLICATIONSOCKET = "CCPApplicationSocket"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_LINKSPEED = "LinkSpeed"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_HEARTBEATDISABLE = "HeartbeatDisable"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_SERIALNUMBER = "SerialNumber"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_USERDEFINEDNAME = "UserDefinedName"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL0BIGANDLITTLEENDIAN = "StreamChannel0BigAndLittleEndian"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL0IPREASSEMBLY = "StreamChannel0IPReassembly"

# Skipping MacroDefinition: SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL0UNCONDITIONALSTREAMING \
#"StreamChannel0UnconditionalStreaming"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL0EXTENDEDCHUNKDATA = "StreamChannel0ExtendedChunkData"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL1BIGANDLITTLEENDIAN = "StreamChannel1BigAndLittleEndian"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL1IPREASSEMBLY = "StreamChannel1IPReassembly"

# Skipping MacroDefinition: SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL1UNCONDITIONALSTREAMING \
#"StreamChannel1UnconditionalStreaming"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL1EXTENDEDCHUNKDATA = "StreamChannel1ExtendedChunkData"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL2BIGANDLITTLEENDIAN = "StreamChannel2BigAndLittleEndian"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL2IPREASSEMBLY = "StreamChannel2IPReassembly"

# Skipping MacroDefinition: SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL2UNCONDITIONALSTREAMING \
#"StreamChannel2UnconditionalStreaming"

const SFNC_GEV_SUPPORTEDOPTIONSELECTORVALUE_STREAMCHANNEL2EXTENDEDCHUNKDATA = "StreamChannel2ExtendedChunkData"

const SFNC_USERSETSELECTORVALUE_DEFAULT = "Default"

const SFNC_USERSETSELECTORVALUE_USERSET1 = "UserSet1"

const SFNC_USERSETSELECTORVALUE_USERSET2 = "UserSet2"

const SFNC_USERSETSELECTORVALUE_USERSET3 = "UserSet3"

const SFNC_USERSETSELECTORVALUE_USERSET4 = "UserSet4"

const SFNC_USERSETDEFAULTSELECTORVALUE_DEFAULT = "Default"

const SFNC_USERSETDEFAULTSELECTORVALUE_USERSET1 = "UserSet1"

const SFNC_USERSETDEFAULTSELECTORVALUE_USERSET2 = "UserSet2"

const SFNC_USERSETDEFAULTSELECTORVALUE_USERSET3 = "UserSet3"

const SFNC_USERSETDEFAULTSELECTORVALUE_USERSET4 = "UserSet4"

const SFNC_CHUNKCOUNTERSELECTORVALUE_COUNTER1 = "Counter1"

const SFNC_CHUNKCOUNTERSELECTORVALUE_COUNTER2 = "Counter2"

const SFNC_CHUNKCOUNTERSELECTORVALUE_COUNTER3 = "Counter3"

const SFNC_CHUNKCOUNTERSELECTORVALUE_COUNTER4 = "Counter4"

const SFNC_CHUNKCOUNTERSELECTORVALUE_COUNTER5 = "Counter5"

const SFNC_CHUNKCOUNTERSELECTORVALUE_COUNTER6 = "Counter6"

const SFNC_CHUNKCOUNTERSELECTORVALUE_COUNTER7 = "Counter7"

const SFNC_CHUNKCOUNTERSELECTORVALUE_COUNTER8 = "Counter8"

const SFNC_CHUNKTIMERSELECTORVALUE_TIMER1 = "Timer1"

const SFNC_CHUNKTIMERSELECTORVALUE_TIMER2 = "Timer2"

const SFNC_CHUNKTIMERSELECTORVALUE_TIMER3 = "Timer3"

const SFNC_CHUNKTIMERSELECTORVALUE_TIMER4 = "Timer4"

const SFNC_CHUNKTIMERSELECTORVALUE_TIMER5 = "Timer5"

const SFNC_CHUNKTIMERSELECTORVALUE_TIMER6 = "Timer6"

const SFNC_CHUNKTIMERSELECTORVALUE_TIMER7 = "Timer7"

const SFNC_CHUNKTIMERSELECTORVALUE_TIMER8 = "Timer8"

const SFNC_CHUNKGAINSELECTORVALUE_ALL = "All"

const SFNC_CHUNKGAINSELECTORVALUE_RED = "Red"

const SFNC_CHUNKGAINSELECTORVALUE_GREEN = "Green"

const SFNC_CHUNKGAINSELECTORVALUE_BLUE = "Blue"

const SFNC_CHUNKGAINSELECTORVALUE_Y = "Y"

const SFNC_CHUNKGAINSELECTORVALUE_U = "U"

const SFNC_CHUNKGAINSELECTORVALUE_V = "V"

const SFNC_CHUNKGAINSELECTORVALUE_TAP1 = "Tap1"

const SFNC_CHUNKGAINSELECTORVALUE_TAP2 = "Tap2"

const SFNC_CHUNKGAINSELECTORVALUE_TAP3 = "Tap3"

const SFNC_CHUNKGAINSELECTORVALUE_TAP4 = "Tap4"

const SFNC_CHUNKGAINSELECTORVALUE_TAP5 = "Tap5"

const SFNC_CHUNKGAINSELECTORVALUE_TAP6 = "Tap6"

const SFNC_CHUNKGAINSELECTORVALUE_TAP7 = "Tap7"

const SFNC_CHUNKGAINSELECTORVALUE_TAP8 = "Tap8"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGALL = "AnalogAll"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGRED = "AnalogRed"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGGREEN = "AnalogGreen"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGBLUE = "AnalogBlue"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGY = "AnalogY"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGU = "AnalogU"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGV = "AnalogV"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGTAP1 = "AnalogTap1"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGTAP2 = "AnalogTap2"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGTAP3 = "AnalogTap3"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGTAP4 = "AnalogTap4"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGTAP5 = "AnalogTap5"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGTAP6 = "AnalogTap6"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGTAP7 = "AnalogTap7"

const SFNC_CHUNKGAINSELECTORVALUE_ANALOGTAP8 = "AnalogTap8"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALALL = "DigitalAll"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALRED = "DigitalRed"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALGREEN = "DigitalGreen"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALBLUE = "DigitalBlue"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALY = "DigitalY"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALU = "DigitalU"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALV = "DigitalV"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALTAP1 = "DigitalTap1"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALTAP2 = "DigitalTap2"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALTAP3 = "DigitalTap3"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALTAP4 = "DigitalTap4"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALTAP5 = "DigitalTap5"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALTAP6 = "DigitalTap6"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALTAP7 = "DigitalTap7"

const SFNC_CHUNKGAINSELECTORVALUE_DIGITALTAP8 = "DigitalTap8"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_ALL = "All"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_RED = "Red"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_GREEN = "Green"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_BLUE = "Blue"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_Y = "Y"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_U = "U"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_V = "V"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_TAP1 = "Tap1"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_TAP2 = "Tap2"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_TAP3 = "Tap3"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_TAP4 = "Tap4"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_TAP5 = "Tap5"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_TAP6 = "Tap6"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_TAP7 = "Tap7"

const SFNC_CHUNKBLACKLEVELSELECTORVALUE_TAP8 = "Tap8"

const SFNC_FILESELECTORVALUE_USERSETDEFAULT = "UserSetDefault"

const SFNC_FILESELECTORVALUE_USERSET1 = "UserSet1"

const SFNC_FILESELECTORVALUE_USERSET2 = "UserSet2"

const SFNC_FILESELECTORVALUE_USERSET3 = "UserSet3"

const SFNC_FILESELECTORVALUE_USERSET4 = "UserSet4"

const SFNC_FILESELECTORVALUE_LUTLUMINANCE = "LUTLuminance"

const SFNC_FILESELECTORVALUE_LUTRED = "LUTRed"

const SFNC_FILESELECTORVALUE_LUTGREEN = "LUTGreen"

const SFNC_FILESELECTORVALUE_LUTBLUE = "LUTBlue"

const SFNC_FILEOPERATIONSELECTORVALUE_OPEN = "Open"

const SFNC_FILEOPERATIONSELECTORVALUE_CLOSE = "Close"

const SFNC_FILEOPERATIONSELECTORVALUE_READ = "Read"

const SFNC_FILEOPERATIONSELECTORVALUE_WRITE = "Write"

const SFNC_FILEOPERATIONSELECTORVALUE_DELETE = "Delete"

const SFNC_COLORTRANSFORMATIONSELECTORVALUE_RGBTORGB = "RGBtoRGB"

const SFNC_COLORTRANSFORMATIONSELECTORVALUE_RGBTOYUV = "RGBtoYUV"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Gain00 = "Gain00"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Gain01 = "Gain01"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Gain02 = "Gain02"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Gain10 = "Gain10"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Gain11 = "Gain11"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Gain12 = "Gain12"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Gain20 = "Gain20"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Gain21 = "Gain21"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Gain22 = "Gain22"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Offset0 = "Offset0"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Offset1 = "Offset1"

const SFNC_COLORTRANSFORMATIONVALUESELECTORVALUE_Offset2 = "Offset2"

# exports
const PREFIXES = ["BGAPI2_", "SFNC_", "GENTL_", "bo_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module

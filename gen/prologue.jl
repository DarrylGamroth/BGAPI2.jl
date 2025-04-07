@static if Sys.islinux()
    const libbgapi2_genicam = "libbgapi2_genicam.so"
elseif Sys.iswindows()
    const libbgapi2_genicam = "bgapi2_genicam.dll"
else
    error("Unsupported OS")
end
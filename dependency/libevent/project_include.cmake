add_compile_options(
    -fstack-protector-all 
    $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,STATIC_LIBRARY>:-fPIC> 
    $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:-fPIE>
) 
add_link_options(
    -Wl,-z,now 
    -Wl,-z,relro 
    -Wl,-z,noexecstack 
    -Wl,--disable-new-dtags
    $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:-pie>
)
set(CMAKE_SKIP_RPATH TRUE)

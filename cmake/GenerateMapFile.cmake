
include(CheckCCompilerFlag)

# This function can be used to generate a linker map file on an executable target
# in a compiler-agnostic way (currently supports GCC and Clang compiler families)
function(generate_map_file target)
  check_c_compiler_flag("-Wl,-Map,test.map" _Map1)
  if("${_Map1}")
    set(GEN_MAP_FILE "-Wl,-Map,")
  else()
    check_c_compiler_flag("-Wl,-map,test.map" _Map2)
    if("${_Map2}")
      set(GEN_MAP_FILE "-Wl,-map,")
    else()
      message("[WARNING] ${CMAKE_C_COMPILER_ID} does not have a defined linker map argument.")
      return()
    endif()
  endif()

  get_target_property(map_dir ${target} BINARY_DIR)
  target_link_options(${target} PRIVATE ${GEN_MAP_FILE}${map_dir}/${target}.map)
  set_target_properties(${target} PROPERTIES
    ADDITIONAL_CLEAN_FILES ${target}.map)
endfunction()

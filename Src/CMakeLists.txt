#####################
# Blinky executable #
#####################

add_executable(Blinky)
target_sources(Blinky PRIVATE
	startup_stm32l476rgtx.s
	system_stm32l4xx.c
	main.c
)
target_include_directories(Blinky PRIVATE
	"${CMAKE_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32L4xx/Include"
	"${CMAKE_SOURCE_DIR}/Drivers/CMSIS/Include"
)
target_compile_definitions(Blinky PRIVATE
	STM32L476xx
)
generate_map_file(Blinky)
convert_to_hex(Blinky)

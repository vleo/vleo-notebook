find_package (Qt5Widgets)

#set(CMAKE_COLOR_MAKEFILE off)
#set(CMAKE_VERBOSE_MAKEFILE on)

message(CRM="${CMAKE_RULE_MESSAGES}")
get_property(RMV GLOBAL PROPERTY RULE_MESSAGES)
message("RMV=${RMV}")


add_executable(testQt test.cpp)	

target_link_libraries(testQt Qt5::Widgets)

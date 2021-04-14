# Install the packages, also make it known to the system

# Cellular Network
add_subdirectory(cellularnetwork)


add_subdirectory(theme)
add_subdirectory(time)

# Power
# needs porting to C++ / QML KCM api or a rewrite
add_subdirectory(powermanagement)

# Info
add_subdirectory(info)

#add_subdirectory(wifi)
add_subdirectory(display)
add_subdirectory(sound)
add_subdirectory(password)
add_subdirectory(battery)
add_subdirectory(storage)


# Virtual Keyboard (maliit)
# add_subdirectory(virtualkeyboard)



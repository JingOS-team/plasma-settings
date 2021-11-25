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
add_subdirectory(location)
#add_subdirectory(vpn)

add_subdirectory(wallpaper)
add_subdirectory(keyboard)
add_subdirectory(loading)

# Virtual Keyboard (maliit)
# add_subdirectory(virtualkeyboard)



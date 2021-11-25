set(battery_SRCS # Specify source files for the library
    battery.cpp
    batteryutil.cpp
)

add_library(kcm_battery MODULE ${battery_SRCS})

target_link_libraries(kcm_battery
    Qt5::Core
    Qt5::DBus
    KF5::CoreAddons
    KF5::I18n
    KF5::QuickAddons
    KF5::ConfigCore
)

kcoreaddons_desktop_to_json(kcm_battery "battery.desktop") # Convert our desktop file to json

install(TARGETS kcm_battery DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms) # Install the library to the kcm location
install(FILES battery.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR}) # Install the desktop file
kpackage_install_package(package kcm_battery kcms) # Finally install our QML kpackage.


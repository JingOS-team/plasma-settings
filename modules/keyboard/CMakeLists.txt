set(keyboard_SRCS # Specify source files for the library
    keyboard.cpp
    keyboardmodel.cpp
)

add_library(kcm_keyboard MODULE ${keyboard_SRCS})

target_link_libraries(kcm_keyboard
    Qt5::Core
    Qt5::DBus
    KF5::CoreAddons
    KF5::I18n
    KF5::QuickAddons
    KF5::ConfigCore
)

kcoreaddons_desktop_to_json(kcm_keyboard "keyboard.desktop") # Convert our desktop file to json

install(TARGETS kcm_keyboard DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms) # Install the library to the kcm keyboard
install(FILES keyboard.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR}) # Install the desktop file
kpackage_install_package(package kcm_keyboard kcms) # Finally install our QML kpackage.


set(sound_SRCS # Specify source files for the library
    sound.cpp
)

add_library(kcm_sound MODULE ${sound_SRCS})

target_link_libraries(kcm_sound
    Qt5::Core
    KF5::CoreAddons
    KF5::I18n
    KF5::QuickAddons
    KF5::ConfigCore
)

kcoreaddons_desktop_to_json(kcm_sound "sound.desktop") # Convert our desktop file to json

install(TARGETS kcm_sound DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms) # Install the library to the kcm location
install(FILES sound.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR}) # Install the desktop file
kpackage_install_package(package kcm_sound kcms) # Finally install our QML kpackage.


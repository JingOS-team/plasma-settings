find_package(Qt5 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS DBus)

set(wallpaper_SRCS # Specify source files for the library
    wallpaper.cpp
    listimageprovider.cpp
    resources.qrc
)

add_library(kcm_wallpaper MODULE ${wallpaper_SRCS})

target_link_libraries(kcm_wallpaper
    Qt5::Core
    Qt5::DBus
    KF5::CoreAddons
    KF5::I18n
    KF5::QuickAddons
    KF5::ConfigCore
    KF5::GuiAddons
)

kcoreaddons_desktop_to_json(kcm_wallpaper "wallpaper.desktop") # Convert our desktop file to json

install(TARGETS kcm_wallpaper DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms) # Install the library to the kcm location
install(FILES wallpaper.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR}) # Install the desktop file
kpackage_install_package(package kcm_wallpaper kcms) # Finally install our QML kpackage.


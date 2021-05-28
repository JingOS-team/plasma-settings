set(location_SRCS # Specify source files for the library
    location.cpp
)

add_library(kcm_location MODULE ${location_SRCS})

target_link_libraries(kcm_location
    Qt5::Core
    KF5::CoreAddons
    KF5::I18n
    KF5::QuickAddons
    KF5::ConfigCore
)

kcoreaddons_desktop_to_json(kcm_location "location.desktop") # Convert our desktop file to json

install(TARGETS kcm_location DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms) # Install the library to the kcm location
install(FILES location.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR}) # Install the desktop file
kpackage_install_package(package kcm_location kcms) # Finally install our QML kpackage.


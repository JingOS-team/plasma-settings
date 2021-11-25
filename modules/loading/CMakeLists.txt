set(loading_SRCS # Specify source files for the library
    loading.cpp
)

add_library(kcm_loading MODULE ${loading_SRCS})

target_link_libraries(kcm_loading
    Qt5::Core
    KF5::CoreAddons
    KF5::I18n
    KF5::QuickAddons
    KF5::ConfigCore
)

kcoreaddons_desktop_to_json(kcm_loading "loading.desktop") # Convert our desktop file to json

install(TARGETS kcm_loading DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms) # Install the library to the kcm location
install(FILES loading.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR}) # Install the desktop file
kpackage_install_package(package kcm_loading kcms) # Finally install our QML kpackage.


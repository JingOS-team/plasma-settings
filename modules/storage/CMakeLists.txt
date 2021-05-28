set(storage_SRCS # Specify source files for the library
    storage.cpp
    storagemodel.cpp
)

add_library(kcm_storage MODULE ${storage_SRCS})

target_link_libraries(kcm_storage
    Qt5::Core
    KF5::CoreAddons
    KF5::Solid
    KF5::I18n
    KF5::QuickAddons
    KF5::ConfigCore
)

kcoreaddons_desktop_to_json(kcm_storage "storage.desktop") # Convert our desktop file to json

install(TARGETS kcm_storage DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms) # Install the library to the kcm location
install(FILES storage.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR}) # Install the desktop file
kpackage_install_package(package kcm_storage kcms) # Finally install our QML kpackage.


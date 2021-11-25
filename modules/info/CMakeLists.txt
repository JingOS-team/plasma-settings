set(info_SRCS # Specify source files for the library
    info.cpp
    distroinfo.cpp
    softwareinfo.cpp
    hardwareinfo.cpp
    updatetool.cpp
    mynetworkobject.cpp
    resources.qrc
)
set(factory_helper_SRCS Helper.cpp)

add_executable(factory_helper ${factory_helper_SRCS})

add_library(kcm_mobile_info MODULE ${info_SRCS})
find_package(LibKWorkspace CONFIG REQUIRED)

target_compile_definitions(kcm_mobile_info PRIVATE -DCMAKE_INSTALL_FULL_LIBEXECDIR_KF5=\"${CMAKE_INSTALL_FULL_LIBEXECDIR_KF5}\")
target_link_libraries(kcm_mobile_info
    Qt5::Core
    KF5::CoreAddons
    KF5::I18n
    KF5::QuickAddons
    KF5::ConfigCore
    KF5::Solid
    KF5::BluezQt 
    KF5::DBusAddons
    KF5::AuthCore
    KF5::Auth
    PW::KWorkspace
    PK::packagekitqt5
)

target_link_libraries(factory_helper 
                      Qt5::DBus Qt5::Xml KF5::AuthCore)

# kcoreaddons_desktop_to_json(kcm_mobile_info "info.desktop") # Convert our desktop file to json
kcoreaddons_desktop_to_json(kcm_mobile_info "info.desktop") # Convert our desktop file to json

install(TARGETS factory_helper DESTINATION ${KAUTH_HELPER_INSTALL_DIR})

install(TARGETS kcm_mobile_info DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms) # Install the library to the kcm location
install (FILES qmldir DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms)
install(FILES info.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR}) # Install the desktop file
kpackage_install_package(package kcm_mobile_info kcms) # Finally install our QML kpackage.

kauth_install_helper_files(factory_helper org.kde.factoryreset root)
kauth_install_actions(org.kde.factoryreset factoryreset.actions)


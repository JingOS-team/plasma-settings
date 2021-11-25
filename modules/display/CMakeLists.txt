set(kcm_display_SRCS 
        display.cpp  
        displaymodel.cpp
        fontmodel.cpp
        resources.qrc
)

#display.cpp displaymodel.cpp

kconfig_add_kcfg_files(kcm_display_SRCS fontssettings.kcfgc fontsaasettingsbase.kcfgc GENERATE_MOC)

add_library(kcm_display MODULE ${kcm_display_SRCS})
find_package(LibKWorkspace CONFIG REQUIRED)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS 
    KDELibs4Support)
find_package(KF5Service)

target_link_libraries(kcm_display
    Qt5::Gui
    Qt5::Qml
    Qt5::DBus
    KF5::CoreAddons
    KF5::QuickAddons
    KF5::I18n
    KF5::Service
    KF5::Plasma
    KF5::ConfigCore
    KF5::ConfigGui
    KF5::KDELibs4Support
    crypt
    PW::KWorkspace
    )
    
kcoreaddons_desktop_to_json(kcm_display "package/metadata.desktop")

#install(FILES fontssettings.kcfg DESTINATION ${KDE_INSTALL_KCFGDIR})
install(FILES package/metadata.desktop RENAME kcm_display.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR})
install(TARGETS kcm_display DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms)
kpackage_install_package(package kcm_display kcms)

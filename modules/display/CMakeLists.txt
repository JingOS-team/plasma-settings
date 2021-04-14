set(kcm_display_SRCS 
        display.cpp  
        displaymodel.cpp
)

#display.cpp displaymodel.cpp

add_library(kcm_display MODULE ${kcm_display_SRCS})

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
    crypt
    )
kcoreaddons_desktop_to_json(kcm_display "package/metadata.desktop")

install(FILES package/metadata.desktop RENAME kcm_display.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR})
install(TARGETS kcm_display DESTINATION ${KDE_INSTALL_PLUGINDIR}/kcms)
kpackage_install_package(package kcm_display kcms)

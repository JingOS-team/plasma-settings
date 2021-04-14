set(kcm_mobile_power_SRCS package/power.cpp)

add_library(kcm_mobile_power MODULE ${kcm_mobile_power_SRCS})

target_link_libraries(kcm_mobile_power
    Qt5::Gui
    Qt5::Qml
    Qt5::DBus
    KF5::CoreAddons
    KF5::QuickAddons
    KF5::I18n
    
    crypt
    )
kcoreaddons_desktop_to_json(kcm_mobile_power "package/metadata.desktop")


install(FILES powermanagement.desktop DESTINATION ${KDE_INSTALL_KSERVICES5DIR})
kpackage_install_package(package kcm_mobile_power kcms)

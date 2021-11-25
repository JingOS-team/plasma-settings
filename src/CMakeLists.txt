set(plasma-settings_SRCS
    main.cpp
    settingsapp.cpp
    modulesmodel.cpp
    module.cpp
    config.cpp
    networkstatus.cpp
)

qt5_add_resources(RESOURCES resources.qrc)
add_executable(plasma-settings ${plasma-settings_SRCS} ${RESOURCES})

target_link_libraries(plasma-settings
    Qt5::Quick
    Qt5::Gui
    Qt5::Widgets
    KF5::Package
    KF5::DBusAddons
    KF5::QuickAddons
    KF5::I18n
    KF5::Declarative
    KF5::Crash
    KF5::NetworkManagerQt
    jappcoreqt
)

install( TARGETS plasma-settings ${INSTALL_TARGETS_DEFAULT_ARGS} )

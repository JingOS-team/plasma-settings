# Jingos Settings

Settings application for Jingos system device , which is based on `Plasma-settings` .

With beautify the interface of the application, in line with the design language of Jingos , and added a lot of features adapted to jingos



## v0.9 change log:

### Features:

- Fonts settings

- Wallpaper

- Complex password 

- Language 

- Time zone 

- Virtual keyboard

  

### Bug Fixed: 

- Partial interface optimization
- System Sleep 
- Storage  info 
- Mouse info 
- Touchpad Function



## Plasma-settings Configuration modules

Our aim for configuration modules is to work on multiple form factors.
To archieve this, their user interface should be based on the new
[KQuickAddons::ConfigModule API](https://api.kde.org/frameworks/kdeclarative/html/classKQuickAddons_1_1ConfigModule.html)
and Kirigami.
You can find documentation on creating such configuration modules on
[docs.plasma-mobile.org/PlasmaSettings.html](https://docs.plasma-mobile.org/PlasmaSettings.html)

Modules only useful on mobile can be added to the `modules` directory of this
repository, but if they are useful for devices of multiple form factors,
they should go into the plasma-workspace repository.

## Build and run from source

This project uses `cmake` to find the dependencies and build the project.

```sh
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=${PWD}/install
cmake --build build --target install -j4
```

## Links

* Plasma-settings page: https://invent.kde.org/plasma-mobile/plasma-settings

* Home page: https://www.jingos.com/

* Project page: https://github.com/JingOS-team/settings

* Issues: https://github.com/JingOS-team/settings/issues

* Development channel: https://forum.jingos.com/


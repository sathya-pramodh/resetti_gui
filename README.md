# resetti_gui
A Julti-style GUI for configuring and operating resetti, a Linux compatible resetting macro.

# Installation
- No distribution specific packages are available for now.
- Download the binary and the .desktop file from the [releases](https://github.com/sathya-pramodh/resetti_gui/releases) tab.
- Edit the .desktop file to point to the path where you downloaded the binary.
- Drop the .desktop file to `~/.local/share/applications/` in your system.
- The application should then be available in your app launcher.

# Usage
- All configurations of the macro can be done from the front-end.
- The configuration options should be self-explanatory.
- Once you install the app, make sure to open all your instances and go into `Instance Utilities...` and `Redetect Instances`.
- It should create a new `conf.json` in `~/.config/resetti_gui/`.
- Make sure to also setup `Profile` options under the `Options` tab.

# Issues
- If you face any issues, report them [here](https://github.com/sathya-pramodh/resetti_gui/issues).

# Thanks
- Tesselslate for creating the [macro](https://github.com/tesselslate/resetti).
- Duncan for creating [Julti](https://github.com/duncanruns/julti).

<img height="128" src="https://open-store.io/icons/translate.walking-octopus/translate.walking-octopus-1.0.1.png" align="left"/>

# Translate

A native translation app for Ubuntu Touch.
_____________________________________________

<img src="https://open-store.io/screenshots/translate.walking-octopus-screenshot-6e864923-1162-4932-8562-97cbb8423303.png" alt="Screenshot" width="200" />

[![OpenStore](https://open-store.io/badges/en_US.png)](https://open-store.io/app/translate.walking-octopus)

## Features:
 - Convergence: It looks good on all screens.
 - Native UI: This isn't a crappy web app! It means you get a fast, reliable, and consistent experience.
 - Anonymization: It uses [Lingva Translate API](https://github.com/TheDavidDelta/lingva-translate), so you get Google Translate results with a degree of privacy

## Building 

### Dependencies
- Docker
- Android tools (for adb)
- Python3 / pip3
- Clickable (get it from [here](https://clickable-ut.dev/en/latest/index.html))

Use Clickable to build and package Translate as a Click package ready to be installed on Ubuntu Touch

### Build instructions
Make sure you clone the project with
`git clone https://github.com/walking-octopus/translate-ut.git`.

To test the build on your workstation:
```
$  clickable desktop
```

To run on a device over SSH:
```
$  clickable --ssh [device IP address]
```

To build for a different architecture:
```
$  clickable -a [arch] build
```
where `arch` is one of: `amd64`, `arm64` or `armhf`.

For more information on the several options see the Clickable [documentation](https://clickable-ut.dev/en/latest/index.html)

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

### Translations

*Translate* has already been translated into some languages (see the [translations directory](https://github.com/walking-octopus/translate-ut/tree/main/po)). Please help translate it by following [these instructions](https://github.com/walking-octopus/translate-ut/tree/main/po/README.md).

## License
The project is licensed under the [GPL-3.0](https://opensource.org/licenses/GPL-3.0).

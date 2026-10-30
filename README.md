# Libbluray
[![License: LGPL v2.1+](https://img.shields.io/badge/license-LGPL--2.1--or--later-blue.svg)](COPYING)
[![NuGet build](https://github.com/yartat/libbluray/actions/workflows/nuget.yml/badge.svg)](https://github.com/yartat/libbluray/actions/workflows/nuget.yml)
[![NuGet](https://img.shields.io/nuget/v/MediaPortal.libbluray?logo=nuget&label=MediaPortal.libbluray)](https://www.nuget.org/packages/MediaPortal.libbluray)
[![NuGet downloads](https://img.shields.io/nuget/dt/MediaPortal.libbluray?logo=nuget)](https://www.nuget.org/packages/MediaPortal.libbluray)
[![Latest release](https://img.shields.io/github/v/release/yartat/libbluray?display_name=tag)](https://github.com/yartat/libbluray/releases/latest)

**Libbluray** is an open-source **lib**rary designed for **Blu-Ray** Discs playback for media players, like **VLC** or **MPlayer**.



## Goals and features

This research project is developed by an **international team** of developers from **Doom9** and **VideoLAN**.

The library integrates navigation, playlist parsing, menus and BD-J menus.

Most commercial Blu-Ray are protected by **AACS** or **BD+** technologies and this library is not enough to playback those discs.

People interested in AACS technologies should have a look at [libaacs](https://code.videolan.org/videolan/libaacs).

People interested in BD+ technologies should have a look at [libbdplus](https://code.videolan.org/videolan/libbdplus).

## MediaPortal fork

This repository is the libbluray fork used by [MediaPortal 1](https://github.com/MediaPortal/MediaPortal-1)
(BDReader). It follows upstream releases and adds a few MediaPortal patches. The binaries are published as the NuGet
package [`MediaPortal.libbluray`](https://www.nuget.org/packages/MediaPortal.libbluray): `bluray.dll` for x86 and x64,
the BD-J jars and the headers.

```powershell
nuget install MediaPortal.libbluray
```

- [Release notes](docs/RELEASE-NOTES.md) and the upstream [ChangeLog](ChangeLog)
- [Building and releasing](docs/BUILD.md)
- [Attribution and third-party licenses](docs/ATTRIBUTION.md)
- [Privacy](PRIVACY.md)


## License

**Libbluray** is released under a Free Software license, LGPL, ensuring it will stay free.
A copy of LGPL is available [here](https://code.videolan.org/videolan/libbluray/-/blob/master/COPYING)

## CoC

The [VideoLAN Code of Conduct](https://wiki.videolan.org/CoC) applies to this project.

## Disclaimer

This library is written for the purpose of playing Blu-ray movies. It is
intended for software that want to support Blu-ray playback (such as VLC and
MPlayer). We, the authors of this library, do not condone nor endorse piracy.

This library is simply a tool for playback of Blu-ray movies. Like any tool, the
use of this tool can also be abused. There are already numerous laws in
different countries and juridictions all over the world that protect copyrighted
material, such as Blu-ray movies. With that said, it would have been
inappropriate for us to distribute this library with terms such as "you cannot
use this library for piracy". Instead, we present to everyone this disclaimer.

As a reminder, here is also the disclaimer found at the beginning of any movie
in relation to copyrights.

## ATTENTION

International agreement and national laws protect copyrighted motion pictures,
videotapes, and sound recordings.

UNAUTHORIZED REPRODUCTION, EXHIBITION OR DISTRIBUTION OF COPYRIGHTED MOTION
PICTURES CAN RESULT IN SEVERE CRIMINAL AND CIVIL PENALTIES UNDER THE LAWS OF
YOUR COUNTRY.


The International Criminal Police Organization - INTERPOL, has expressed its
concern about motion picture and sound recording piracy to all of its member
national police forces. (Resolution adopted at INTERPOL General Assembly,
Stockholm, Sweden, September 8, 1977.)


## Mailing list

You can discuss about libbluray on the [libbluray-devel mailing list](https://mailman.videolan.org/listinfo/libbluray-devel).

## Documentation and support

For support or more informations, look [here](https://www.videolan.org/developers/libbluray.html)

All documentation about libbluray is available [here](https://videolan.videolan.me/libbluray/)


# Compile

1. Install [Meson](https://mesonbuild.com/) (0.60 or higher), [Ninja](https://ninja-build.org/)
2. Install libxml2-dev, freetype2-dev, fontconfig-dev *(on Unixes)*
3. Install Java JDK and releated pacakges to activate BD-J menus
4. Run `mkdir build && cd build` to create a build directory and enter it
5. Run `meson setup ..` to configure meson, add `--default-library=static` if static linking is desired
6. Run `ninja` to compile


# Building and releasing the MediaPortal fork

This file covers the Windows build that produces the NuGet package `MediaPortal.libbluray`. For other platforms see
the "Compile" section of [README.md](../README.md).

## What you get

- `bluray.dll` for x86 and x64 (release, freetype linked statically);
- `libbluray-j2se-<version>.jar` and `libbluray-awt-j2se-<version>.jar` (BD-J);
- the headers that BDReader needs;
- `COPYING` and `docs/ATTRIBUTION.md`.

Meson names the library `bluray-4.dll` (`4` is the soname version). `pack.ps1` renames it to `bluray.dll`, which is
the name MediaPortal loads.

## Requirements

| Tool | Notes |
|---|---|
| Visual Studio 2022 or later (C++ build tools) | Run Meson from a "x64 Native Tools" or "x86 Native Tools" prompt. |
| Python 3 with `meson` and `ninja` | `pip install meson ninja`. Meson 0.60 or newer. |
| JDK and Apache Ant | For the BD-J jars. CI uses Temurin 17. The jars are built for Java 1.8. |
| vcpkg | For freetype: `vcpkg install freetype:<arch>-windows-static-md`. |
| pkg-config | `pkgconfiglite` from Chocolatey, or `pkgconf` from vcpkg. Meson finds freetype with it. |
| NuGet CLI | Only for packing. |

## Build one architecture

From the matching Native Tools prompt, in the repository root (use `x86` in the triplet for 32-bit):

```powershell
vcpkg install freetype:x64-windows-static-md --x-install-root=C:\vcpkg_bd
$env:PKG_CONFIG_PATH = 'C:\vcpkg_bd\x64-windows-static-md\lib\pkgconfig'
meson setup build-x64 -Dbuildtype=release -Ddefault_library=shared -Dbdj_jar=enabled "-Djdk_home=$env:JAVA_HOME" -Dfontconfig=disabled -Dfreetype=enabled -Dlibxml2=disabled
meson compile -C build-x64
```

Outputs:

- `build-x64\src\bluray-4.dll`
- `build-x64\src\libbluray\bluray-version.h`
- `build-x64\src\libbluray\bdj\libbluray-j2se-<version>.jar`, `libbluray-awt-j2se-<version>.jar`
- `build-x64\src\tools\bd_info.exe` and `bd_list_titles.exe` (put `build-x64\src` on `PATH` to run them)

The directories `build*/` are ignored by git. Without `-Dbdj_jar=enabled` the build has no BD-J.

## Pack the NuGet package

After building both architectures:

```powershell
.\package\nuget\pack.ps1 -X64Build build-x64\src -X86Build build-x86\src -Version 1.5.1 -Out nupkg
```

The jars and `bluray-version.h` are taken from the x64 build. The script puts the matching section of
[RELEASE-NOTES.md](RELEASE-NOTES.md) into the package as `releaseNotes`; add `-RequireNotes` to fail when the
section is missing.

Package layout:

```text
build/MediaPortal.libbluray.props      include directories for MSBuild projects
build/MediaPortal.libbluray.targets
build/lib/includes/util/attributes.h
build/lib/libbluray/*.h                bluray.h, keys.h, player_settings.h, bluray-version.h, decoders/overlay.h
references/runtimes/x86/bluray.dll
references/runtimes/x64/bluray.dll
references/runtimes/libbluray-j2se-<version>.jar
references/runtimes/libbluray-awt-j2se-<version>.jar
COPYING
docs/ATTRIBUTION.md
```

## Use in MediaPortal 1

- `DirectShowFilters\BDReader\packages.config` and `BDReader.vcxproj` reference `MediaPortal.libbluray` by version.
- `mediaportal\MediaPortal.Application\PostBuild.bat` copies `bluray.dll` for the target architecture and both jars
  next to `MediaPortal.exe`. Keep the two jars together.

## CI and releases

Workflow: [.github/workflows/nuget.yml](../.github/workflows/nuget.yml).

| Event | What runs |
|---|---|
| Pull request that touches `package/nuget`, `docs/RELEASE-NOTES.md` or the workflow | build x86 and x64, pack (version `0.0.0-ci.<run>`), no publishing |
| Push of a tag `v<version>` | build, pack, publish to nuget.org, create the GitHub release |
| Manual run | like a pull request |

The packed `.nupkg` and the extracted release notes are kept as workflow artifacts (`nupkg`).

### One-time setup

1. nuget.org: add a Trusted Publishing policy for the repository `yartat/libbluray`, workflow file `nuget.yml`,
   environment `nuget`. The package id `MediaPortal.libbluray` must belong to your nuget.org account.
2. GitHub, Settings → Environments: create the environment `nuget`.
3. GitHub, Settings → Secrets and variables → Actions → Variables: add `NUGET_USER` with your nuget.org user name
   (not the e-mail address).

No long-lived API key is stored; `NuGet/login` exchanges the workflow's OIDC token for a short-lived key.

### Release steps

1. Move the entries from `## [Unreleased]` in [RELEASE-NOTES.md](RELEASE-NOTES.md) to a new `## [<version>] - <date>`
   section.
2. Merge to `master`.
3. Tag and push: `git tag v<version>` and `git push origin v<version>`.
4. Check the run on the Actions tab. A tag without a matching release notes section fails in the `pack` job, before
   anything is published.

A tag whose publish step failed before the upload can be moved: delete the tag locally and on `origin`, tag the fixed
commit again and push. Do this only if the package was not published (nuget.org never allows replacing a version).

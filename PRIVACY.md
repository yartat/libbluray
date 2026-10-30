# Privacy

This is the privacy statement for the MediaPortal fork of libbluray (`bluray.dll`, the BD-J jars and the NuGet
package `MediaPortal.libbluray`). It describes what the code in this repository does. It is not legal advice.

## What the library collects

Nothing. libbluray has no telemetry, no analytics, no crash reporting and no update check. The code of the library
and of the package does not contact any server on its own and does not send any data.

## What the library reads and writes

- It reads the disc or the disc image that the host application opens (for example MediaPortal), including the
  files `index.bdmv`, playlists, clip information and, for BD-J discs, the Java archives and BD-J objects.
- BD-J persistent storage and cache are written to disk. On Windows the default location is under the application
  data folder of the user (`%APPDATA%`, with `%PROGRAMDATA%` as the common location). The environment variables
  `LIBBLURAY_PERSISTENT_ROOT` and `LIBBLURAY_CACHE_ROOT` change these folders. This data comes from the disc's own
  BD-J applications and stays on the machine.
- Log output goes to the host application's log or to the debug output; its content is chosen by the host.

## BD-J applications

BD-J discs carry Java applications that run inside the Java runtime next to libbluray. They are code from the disc
publisher, not from this project. The BD-J runtime contains networking classes (for example `java.net` use in the
media classes and `javax.microedition.io.ServerSocketConnection`), so a disc application may be able to use the
network. We did not audit what such applications do. If this matters, do not use BD-J, or run the host application
without network access. Menus can be turned off by building with `-Dbdj_jar=disabled` or by not shipping the jars.

The environment variable `BDJ_JVM_DEBUG` starts the Java debugger and opens a debug socket (port 8000). It is off by
default. Do not set it on a machine you care about.

## Encrypted discs

libbluray loads `libaacs` and `libbdplus` dynamically if they are installed. They are not part of this repository or
of the NuGet package and have their own privacy statements and legal conditions.

## Where this project is hosted

The source is on GitHub and the package is on nuget.org. These services process data about visitors and downloads
under their own policies:

- <https://docs.github.com/site-policy/privacy-policies/github-general-privacy-statement>
- <https://www.nuget.org/policies/Privacy>

## Questions

Open an issue at <https://github.com/yartat/libbluray/issues>.

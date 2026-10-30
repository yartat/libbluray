# Attribution

The NuGet package `MediaPortal.libbluray` contains software from several authors. This file lists them and their
licenses. It ships in the package next to `COPYING`.

## libbluray

- Copyright: VideoLAN and the libbluray authors (see the headers of the source files, the `COPYING` file and
  <https://code.videolan.org/videolan/libbluray>).
- License: GNU Lesser General Public License, version 2.1 or later ([COPYING](../COPYING)).
- Upstream version of this fork: 1.5.1 (tag `1.5.1`).

## Changes in the MediaPortal fork

The fork is <https://github.com/yartat/libbluray>. Its changes on top of upstream are LGPL-2.1-or-later as well.

| Change | Origin |
|---|---|
| `bd_get_clip_infos`, `index_parse` for indexes without titles, optimized file I/O | Hendrik Leppkes (LAV Filters fork of libbluray) |
| BD-J for MediaPortal (based on the LAV fork and patches by Tourettes) | Sebastiii, Azzuro and the MediaPortal team |
| win32 file I/O: paths up to 4096 characters, 60 KB read buffer; port to 1.5.1; NuGet packaging and CI | Yaroslav V Tatarenko |

The history is in `git log`.

## Components inside the binaries

| Component | Where | License |
|---|---|---|
| libudfread (VideoLAN), 1.2.0 or later | `contrib/libudfread`, linked into `bluray.dll` | LGPL-2.1-or-later |
| FreeType | linked statically into `bluray.dll`, taken from vcpkg | FreeType License (FTL) or GPL-2.0-only, at your choice. This product includes software developed by the FreeType Project (<https://www.freetype.org>). |
| ASM 5.0.4 (INRIA, France Telecom), core | `contrib/asm`, compiled into the BD-J jars | BSD 3-Clause, see `contrib/asm/LICENSE.txt` |
| BD-J class libraries (`org.videolan`, `org.bluray`, `org.dvb`, `org.havi`, `javax.*`, `com.aacsla.*` stubs) | `src/libbluray/bdj`, compiled into the BD-J jars | libbluray license, LGPL-2.1-or-later; the file headers name the authors |

FreeType's own dependencies (zlib, libpng, bzip2, brotli) come with the vcpkg port of the same version when they are
enabled there. Their licenses are in the vcpkg port folders.

## Trademarks

"Blu-ray Disc", "Java" and "MediaPortal" are trademarks of their owners. This project is not affiliated with or
endorsed by them. The disclaimer about copyrighted material in [README.md](../README.md) applies.

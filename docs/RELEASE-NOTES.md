# Release notes

Release notes of the MediaPortal fork of libbluray (NuGet package `MediaPortal.libbluray`).
Upstream changes are listed in [ChangeLog](../ChangeLog).

The CI reads this file: the section `## [<version>]` that matches the pushed tag `v<version>` becomes the
`releaseNotes` of the NuGet package and the body of the GitHub release. A tag without a matching section fails the
build, so add the section before tagging. Builds without a tag use `## [Unreleased]`.
Format: [Keep a Changelog](https://keepachangelog.com/). Versions follow the upstream libbluray version; a further
MediaPortal-only revision of the same upstream version gets a fourth number (`1.5.1.1`).

## [Unreleased]

## [1.5.1] - 2026-10-30

First release based on upstream libbluray 1.5.1. The previous MediaPortal package was based on 1.1.2.

### Changed

- Upstream: libbluray 1.1.2 → 1.5.1. The build system is Meson/Ninja. Upstream fixes include out-of-bounds write in
  the graphics processor, buffer overread in the m2ts demuxer, NULL dereference in the playlist subpath cleanup,
  stricter CLPI and RLE parsing and seek/read failure detection. See [ChangeLog](../ChangeLog).
- Shared library version 4: the import library and `bluray.dll` of 1.1.2 are not compatible. Rebuild everything that
  links against the package (BDReader).
- Package layout: `references/runtimes/<x86|x64>/bluray.dll` and the headers in `build/lib`. The `Release/`
  folder of 1.1.2 is gone.
- BD-J: both jars (`libbluray-j2se-1.5.1.jar`, `libbluray-awt-j2se-1.5.1.jar`) must stay in the same folder.
  libbluray finds the AWT jar by name next to the main jar, so the `awt\` subfolder of the old MediaPortal layout
  must not be used.
- freetype is linked into `bluray.dll` statically; no `freetype.dll` is shipped.

### Added

- MediaPortal patches ported to 1.5.1:
  - `bd_get_clip_infos` (used by BDReader);
  - `index_parse`: an index without explicitly signaled titles is accepted;
  - win32 file I/O: paths up to 4096 characters, 60 KB read buffer.
- GitHub Actions workflow that builds x86 and x64, packs `MediaPortal.libbluray` and publishes it to nuget.org on a
  `v*` tag (Trusted Publishing).
- Documentation: `docs/BUILD.md`, `docs/ATTRIBUTION.md`, `PRIVACY.md`.

### Verified

- `bd_info` and `bd_get_clip_infos` on a real HDMV disc.
- MediaPortal BDReader (x86 and x64): loads the disc, lists titles, plays the sample disc until samples with time
  stamps arrive at every output pin.

### Known issues

- BD-J is built and packaged but was not tested on a real BD-J disc.
- Not ported from the 1.1.2 fork: `bd_get_title_mpls`, export of the clip id in `BLURAY_CLIP_INFO`, offset sequence
  id from `STN_table_SS` (3D).
- BDReader in a bare test graph makes libbluray log `bd_seek_time(...) failed: invalid timestamp`. Playback is not
  affected; the cause was not investigated.
- AACS and BD+ protected discs are not supported (libbluray needs libaacs/libbdplus for them, and BDReader rejects
  encrypted discs).

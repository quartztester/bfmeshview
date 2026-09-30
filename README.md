# BfMeshView — Battlefield Mesh Viewer (archived)

> **Preservation archive.** This repository reconstructs the release history of the
> original freeware tool. See [ARCHIVE-NOTES.md](ARCHIVE-NOTES.md) for what this is
> and isn't. Original author: **Martijn** (bytehazard.com).

BfMeshView is a 3D model viewer for the Battlefield series, and has evolved to provide many useful editing features for modding. It supports virtually all BF1942, BF2, BF2142, BFH and BFP4F mesh files.

BfMeshView is Free Open Source software! The source code is included in the download. Keep in mind that this program is a work in progress; new versions may include experimental features that are unfinished and not thoroughly tested.

## Feature highlights

* Viewer for BF1942, BF2, BF2142, BFH and BFP4F mesh files
  (`.staticmesh`, `.bundledmesh`, `.skinnedmesh`, `.collisionmesh`, BF1942 `.sm`/`.tm`,
  plus OBJ and `.samples`).
* Texture loading from configurable search paths, DDS/TGA, suffixed texture loading,
  uncompressed DDS.
* GLSL shader emulation for BF2 materials; bump/normal-map lighting, env maps.
* BF2 animation playback (skinnedmesh + `.ske` skeleton + `.baf` animation), 1P preview.
* Editing tools accumulated over the releases: material editor, UV editor,
  sample generator/fixer, mesh edit mode (vertex/face/element selection),
  vertex normal weld/flatten, tangents fix/generate, texture bake & mass-rename.
* Workspace (`.bfmv`) files that bind a mesh + skeleton + animation together.
* Runs on Linux via Wine.

## Usage

* **Viewing** — run BfMeshView and use *File > Open*, or enable file-type association
  under *Options > Preferences* to open files (and meshes inside ZIPs) by double-clicking
  them in Explorer. Drag-and-drop is supported for all file types.
* **Textures** — add your mod directory to the texture path list under
  *Options > Preferences*. Since 2.2.0, suffixed texture loading is supported;
  edit `config.ini` to add suffixes and toggle them via *Options > Texture Suffix*.
* **Animation** — load a player model (`.skinnedmesh`), drag the skeleton (`.ske`)
  onto the window, then the animation (`.baf`).
* **Workspace files** — create a `.bfmv` text file to bind mesh/skeleton/animation:

  ```ini
  ; BFMESHVIEW WORKSPACE FILE
  ske=flag_setup.ske
  mesh=flag_us.skinnedmesh
  anim=flag_idle.baf
  ; END OF FILE
  ```

  Both relative (to the workspace file) and absolute paths are supported.
* **On Linux** — runs under Wine and is fully functional; install/update your GPU
  drivers for GLSL shading, and disable v-sync if you see viewport corruption when
  resizing. If the app won't start, drop the bundled (or `docs/runtimes.zip`) DLL/OCX
  runtimes next to the executable.

## Release history

| Version | Date | Summary | Tag |
|---|---|---|---|
| 1.0.0 | 2008-02-09 | First public release: loads most BF2 `.staticmesh`/`.bundledmesh` files with same-folder DDS textures. | [`v1.0.0`](../../releases/tag/v1.0.0) |
| 1.1.0 | 2008-02-15 | More robust mesh loaders; texture search paths and a config file. | [`v1.1.0`](../../releases/tag/v1.1.0) |
| 1.2.0 | 2008-05-17 | BF1942 `.sm` support, experimental collisionmesh/OBJ export, anisotropic filtering. | [`v1.2.0`](../../releases/tag/v1.2.0) |
| 1.3.0 | 2008-10-09 | Fuller `.collisionmesh` loader and an object->tangent-space normal map converter. | [`v1.3.0`](../../releases/tag/v1.3.0) |
| 1.4.0 | 2008-10-28 | Hierarchy tree view and richer geometry info in the status bar. | [`v1.4.0`](../../releases/tag/v1.4.0) |
| 1.5.0 | 2008-12-04 | Vertex-order coloring, proper BF2 textures, approximate BF2 shader rendering. | [`v1.5.0`](../../releases/tag/v1.5.0) |
| 1.6.0 | 2009-04-17 | BF2 vehicle/weapon collisionmesh support and new file loaders. | [`v1.6.0`](../../releases/tag/v1.6.0) |
| 1.7.0 | 2009-04-19 | Full skinnedmesh support and 'version 4' BF2 mesh fixes. | [`v1.7.0`](../../releases/tag/v1.7.0) |
| 1.8.0 | 2009-08-14 | Texture reload tool, session view memory, `.obj`/`.samples` info display. | [`v1.8.0`](../../releases/tag/v1.8.0) |
| 1.9.0 | 2010-08-06 | Major update: material editing, UV editor, and a sample generator. | [`v1.9.0`](../../releases/tag/v1.9.0) |
| 2.0.0 | 2011-03-14 | BF2 animation playback, workspace files, overdraw viz, debug console. | [`v2.0.0`](../../releases/tag/v2.0.0) |
| 2.1.0 | 2011-05-15 | Battlefield Play4Free mesh support plus stability fixes. | [`v2.1.0`](../../releases/tag/v2.1.0) |
| 2.2.0 | 2012-10-04 | Full BF2 shader emulation, suffixed textures, integrated animation tools. | [`v2.2.0`](../../releases/tag/v2.2.0) |
| 2.3.2 | 2017-01-11 | UV-channel copy tool, OBJ export options, quality-of-life fixes. | [`v2.3.2`](../../releases/tag/v2.3.2) |
| 2.4.0 | 2018-02-12 | Large beta: BF2 mesh editing tools, toolbar, tangent/normal tools, UV tools. | [`v2.4.0`](../../releases/tag/v2.4.0) |
| 2.5.3 | 2019-02-02 | Bug-fix release: F12 screenshots, locale warning, GDI overlay toggle. | [`v2.5.3`](../../releases/tag/v2.5.3) |

Tag `vX.Y.Z` reproduces the exact shipped files of that original release
(see [ARCHIVE-NOTES.md](ARCHIVE-NOTES.md)).

## Building from source

BfMeshView is a **Visual Basic 6** project, **Windows-only**.

* The VB6 project is **`source/bfmeshview.vbp`** (plus `bfmeshview.vbw`), shipped
  inside `source.zip` in the [v2.5.3 release](../../releases/tag/v2.5.3). Extract
  `source.zip` and open the `.vbp` in the VB6 IDE.
* The release zips also bundle the runtime DLLs/OCXs the compiled exe needs
  (`msvbvm60.dll`, `comctl32.dll`/`COMCTL32.OCX`, `comdlg32.dll`/`COMDLG32.OCX`,
  `glext.dll`). `docs/runtimes.zip` holds the additional system runtimes.
* The viewport uses OpenGL via `glext.dll` + GLSL shader sources under `shaders/`.

## Attribution & original home

* Author: **Martijn** — martijn@bytehazard.com
* Original project page & downloads: <http://www.bytehazard.com/bfstuff/bfmeshview/>
* This is an unofficial, community-run preservation archive; no affiliation is implied.

# Map Merge 2

**Map Merge 2** is an improvement over previous map merging scripts, with
better merge-conflict prevention, multi-Z support, and automatic handling of
key overflow. For up-to-date tips and tricks, also visit the [Map Merger] wiki article.

## What Map Merging Is

The "map merge" operation describes the process of rewriting a map file written
by the DreamMaker map editor to A) use a format more amenable to Git's conflict
resolution and B) differ in the least amount textually from the previous
version of the map while maintaining all the actual changes. It requires an old
version of the map to use as a reference and a new version of the map which
contains the desired changes.

## Installation

First things first, locate and install Python 3.6. Python 3.7 or newer will not
work with the dependency installer. Ensure Python 3.6 is added to your system's
path variable.

To install Python dependencies, run `requirements-install.bat`, or run
`python -m pip install -r requirements.txt` directly. See the [Git hooks]
documentation to install the Git pre-commit hook which runs the map merger
automatically, or use `tools/mapmerge/Prepare Maps.bat` to save backups before
running `mapmerge.bat`.

For up-to-date installation and detailed troubleshooting instructions, visit
the [Map Merger] wiki article.

## Code Structure

Frontend scripts are meant to be run directly. They obey the environment
variables `TGM` to set whether files are saved in TGM (1) or DMM (0) format,
and `MAPROOT` to determine where maps are kept. By default, TGM is used and
the map root is autodetected. Each script may either prompt for the desired map
or be run with command-line parameters indicating which maps to act on. The
scripts include:

* `convert.py` for converting maps to and from the TGM format. Used by
  `tgm2dmm.bat` and `dmm2tgm.bat`.
* `mapmerge.py` for running the map merge on map backups saved by
  `Prepare Maps.bat`. Used by `mapmerge.bat`

Implementation modules:

* `dmm.py` includes the map reader and writer.
* `mapmerge.py` includes the implementation of the map merge operation.
* `frontend.py` includes the common code for the frontend scripts.

`precommit.py` is run by the [Git hooks] if installed, and merges the new
version of any map saved in the index (`git add`ed) with the old version stored
in Git when run.

## How to Use, for the Layman

It is recommended that you run `dmm2tgm.bat` before you make any changes.
This will convert your map to the TGM format (see *'What Map Merging Is'*, above)
if it isn't already. If it has already been converted, this won't do anything.

Before you make any changes to the map whatsoever, you will need to take a
backup of your map. This can be done quickly and easily by running 
`Prepare Maps.bat`.

After you make your changes, you should run `mapmerge.bat` to merge the new
and original versions together, to minimize changed parts of the map. This
makes it easier for us to look through your changes and also makes it more
likely for Github's merge conflict resolution to successfully pass.

After the map is merged and in TGM format, commit and pull-request as normal.
You will be able to tell if the map is in TGM format if you open the map in a
text editor and see the following on the first line:

```
//MAP CONVERTED BY dmm2tgm.py THIS HEADER COMMENT PREVENTS RECONVERSION, DO NOT REMOVE
```

[Map Merger]: https://tgstation13.org/wiki/Map_Merger
[Git hooks]: ../hooks/README.md

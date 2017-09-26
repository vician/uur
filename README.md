## File structure

- `/opt/uur-src` - source codes of packages
- `/opt/uur-bin` - binary packages - unarchived (AppImage, etc.)

## Types

Global variables:

- depends (for apt install)
- insidedir (dir inside downloaded an unarchived files, default='.')
Computed variables
- dir (computed from uurfilename) where downloaded files are stored
- srcdir: dir+insidedir

Global functions:

- build()
- package()
- uninstall()

### Git repository

Variables:

- url (of git repository)
- tag (optional)
- branch (optional)

### Release archive
Variables:

- url (of release archive)
- ext (what is the extension of the file - necessery of untar/unzip)
- version 

Computed:

- file (computed from dir uurfilename version ext)

### AppImage or bin file

Variables:

- url (of AppImage)
- ext (of archive if it's archived)
- file


## TODO

- verify sha checksums
- verify signs
- how to check update? (server requiered?)
	- check against github specific file?
- define ubuntu version
- tests with Vagrant for different Ubuntu releases
- fix uurfilename in computing file variable
- remove name variable
- add unzip
- create default build() package() uninstall() functions?
- create install of uur itself
- how to do file structure
- added parametr to ./uur.sh (build, uninstall, ...)
- put packages to special directory
- download uur from server
	- check if there is local file (if yes, do update)
	- try to download the file from github => separate it to different repository?! not yet!
- install depends first
- add edit PKGBUILD

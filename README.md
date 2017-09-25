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
- file


## TODO

- verify sha checksums
- verify signs
- how to check update? (server requiered?)
- define ubuntu version
- tests with Vagrant for different Ubuntu releases
- fix uurfilename in computing file variable
- remove name variable
- add unzip
- create default build() package() uninstall() functions?
- create install of uur itself
- how to do file structure
- added parametr to ./uur.sh (build, uninstall, ...)

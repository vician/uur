## Download
```
git clone https://github.com/segler-alex/Pidgin-GPG 
```
## Build
```
    autoreconf -i;
    ./configure;
    make
```
## Install
```
    mkdir -p ~/.purple/plugins;
    cp src/.libs/pidgin_gpg.so ~/.purple/plugins/
```

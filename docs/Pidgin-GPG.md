## Download
```bash
git clone https://github.com/segler-alex/Pidgin-GPG /tmp/uur/Pidgin-GPG/
```
## Build
```bash
cd /tmp/uur/Pidgin-GPG/./
autoreconf -i;
./configure;
make
```
## Install
```bash
cd /tmp/uur/Pidgin-GPG/./
mkdir -p ~/.purple/plugins;
cp src/.libs/pidgin_gpg.so ~/.purple/plugins/
```

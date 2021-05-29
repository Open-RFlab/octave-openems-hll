[![Package Debian](https://img.shields.io/github/workflow/status/Open-RFlab/octave-openems-hll/Release%20Debian?label=package&logo=debian)](https://software.opensuse.org/download.html?project=home:thomaslepoix:open-rflab&package=octave-openems-hll)

# OpenEMS High-level layer

## Debian packaging

Here are the instructions to build and install a debian package from upstream sources :

```sh
sudo apt install dpkg-dev

git clone https://github.com/Open-RFlab/octave-openems-hll
git clone https://github.com/Open-RFlab/octave-openems-hll -b debian debian --depth 1

cd octave-openems-hll
sed -i DESCRIPTION -e "s/Version: .*$/Version: $(git describe --tags)/g"

git archive \
	--format=tar.gz \
	-o ../octave-openems-hll_$(git describe --tags).orig.tar.gz \
	--prefix=octave-openems-hll-$(git describe --tags)/ \
	$(git stash create)

mv ../debian/debian .
sed -i debian/changelog -e "1i \
octave-openems-hll ($(git describe --tags)-1) unstable; urgency=medium\n\n\
  * Package from upstream sources\n\n\
 -- Thomas Lepoix <thomas.lepoix@protonmail.ch>  $(date -R)\n\
"

dpkg-buildpackage -b -us -uc

sudo apt install ../octave-openems-hll_*.deb
```

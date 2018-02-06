This repo records what's needed for a RIPE NCC data lab machine setup

# data analysis tools needed

python
python modules:
 - ripe.atlas.tools
 - ripe.atlas.sagan
 - ripe.atlas.cousteau
ixp-country-jedi code + dependencies
tags.py
gnuplot
caida bgpstream
libbgpstream

atlas-streaming-example
ris-streaming-example

(TODO create a vagrant/ansible virtual machine build that installs all this)


# data needed

a weeks worth of RIPE Atlas results from: https://ftp.ripe.net/ripe/atlas/data/
atlas ftp metadata
ixp-country-jedi results : http://sg-pub.ripe.net/emile/ixp-country-jedi/ixp-country-jedi-confs.tgz
OpenIPMap https://ftp.ripe.net/ripe/openipmap/   ftp://ftp.ripe.net/ripe/openipmap/geolocations-latest
RIS : 
ripestat  ?? ask CT
atlas-disconnects-grouped-by-country 

(TODO create a data download script for all this)

This repo records what's needed for a RIPE NCC data lab machine setup

# virtual machine setup

This is recorded/documented in the directory  _virtual-machine-setup_

# data disk creation

The script _pull-data.sh_ pulls a days worth of data from various RIPE NCC datasets.
Note that the downloading of this data takes quite a while. 
For a data-lab in low-bandwidth places it is advisable to take a physical disk with you.
Even for higher-bandwidth places this is quite advisable, due to data download speed throttling.
 
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

# data needed

a wish-list:
 - a weeks worth of RIPE Atlas results from: https://ftp.ripe.net/ripe/atlas/data/
 - atlas ftp metadata
 - ixp-country-jedi results : http://sg-pub.ripe.net/emile/ixp-country-jedi/ixp-country-jedi-confs.tgz
 - OpenIPMap https://ftp.ripe.net/ripe/openipmap/   ftp://ftp.ripe.net/ripe/openipmap/geolocations-latest
 - RIS:
  - ripestat  ?? ask CT
  - atlas-disconnects-grouped-by-country
  

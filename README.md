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

 - a weeks worth of RIPE Atlas results from: https://ftp.ripe.net/ripe/atlas/data/
 - atlas ftp metadata
 - ixp-country-jedi results : http://sg-pub.ripe.net/emile/ixp-country-jedi/ixp-country-jedi-confs.tgz
 - OpenIPMap https://ftp.ripe.net/ripe/openipmap/   ftp://ftp.ripe.net/ripe/openipmap/geolocations-latest
 - RIS:
  - ripestat  ?? ask CT
  - atlas-disconnects-grouped-by-country

(TODO create a data download script for all this)

# Virtual Machine Specification
```
$ hostnamectl 
   Static hostname: localhost.localdomain
         Icon name: computer-vm
           Chassis: vm
        Machine ID: ca0f29a5720c46358e97046257fa3794
           Boot ID: a0ae0d45f6ed4de0a5400ac5e5b7cacd
    Virtualization: kvm
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-693.el7.x86_64
      Architecture: x86-64
```

# Installation of Data Analysis Tools

## Anaconda Python
```
wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
chmod +x Anaconda3-5.0.1-Linux-x86_64.sh
./Anaconda3-5.0.1-Linux-x86_64.sh
```

## RIPE Atlas Tools
```
sudo yum install epel-release
sudo yum install gcc libffi-devel openssl-devel
sudo yum install python-virtualenv python-pip
pip install ripe.atlas.tools
```
## RIPE Community Contributions
```
git clone https://github.com/RIPE-Atlas-Community/ripe-atlas-community-contrib.git
```

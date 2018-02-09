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

## RIPE Atlas Tools and Dependencies
```          
yum install epel-release
yum install python-setuptools python-devel
yum install git gnuplot jq nginx
yum install zip unzip 
yum install gcc autoconf automake
yum install gcc libffi-devel openssl-devel
yum install python-virtualenv python-pip
pip install virtualenv
pip install ripe.atlas.tools
```

## RIPE Community Contributions
```
git clone https://github.com/RIPE-Atlas-Community/ripe-atlas-community-contrib.git
git clone https://github.com/emileaben/ixp-country-jedi
git clone https://github.com/sdstrowes/atlas-scripts
git clone https://github.com/emileaben/resource-gnuplotter
```

IXP Country Jedi requirements: 
```
cd ixp-country-jedi/
pip install -r requirements.txt
```

## BGP Tools
### libBGPdump
```
yum install bzip2-devel
wget https://bitbucket.org/ripencc/bgpdump/get/94a0e724b335.zip
unzip 94a0e724b335.zip
cd ripencc-bgpdump-94a0e724b335/
./bootstrap.sh
make all
```

### BGPStream
Install dependencies:
```
yum install zlib-devel bzip2-devel libcurl-devel
curl -O https://research.wand.net.nz/software/wandio/wandio-1.0.4.tar.gz
tar zxf wandio-1.0.4.tar.gz
cd wandio-1.0.4/
 ./configure
make
sudo make install
sudo ldconfig
```

Link libraries:
```
sudo sh -c 'echo /usr/local/lib > /etc/ld.so.conf.d/usrlocal.conf'
sudo ldconfig
```

Install BGPStream:
```
curl -O http://bgpstream.caida.org/bundles/caidabgpstreamwebhomepage/dists/bgpstream-1.1.0.tar.gz
tar zxf bgpstream-1.1.0.tar.gz
cd bgpstream-1.1.0/
./configure
make
make check
sudo make install
sudo ldconfig
```

Install PyBGPStream (python2.7 only):
```
curl -O http://bgpstream.caida.org/bundles/caidabgpstreamwebhomepage/dists/pybgpstream-1.1.0.tar.gz
tar zxf pybgpstream-1.1.0.tar.gz
cd pybgpstream-1.1.0
python2.7 setup.py build_ext
sudo python2.7 setup.py install
```

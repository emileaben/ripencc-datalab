This directory records setting up a virtual machine for a RIPE NCC data lab

# data analysis tools wish-list

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

# automation

This directory has 2 attempts for setting up a virtual machine automatically.
In case we'd need to provision these machines in a more automated fashion they could
be used/integrated.

# Example manual setup

This is the setup as used in the data analysis workshop in Beirut, Lebanon ESIB-USJ 2018-02-15

## Virtual Machine Specification
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

## Installation of Data Analysis Tools

### Python Tools

Anaconda distribution:
```
wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
chmod +x Anaconda3-5.0.1-Linux-x86_64.sh
./Anaconda3-5.0.1-Linux-x86_64.sh
```

Visualization:
```
pip install mplleaflet
pip install folium
```

### RIPE Atlas Tools and Dependencies
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

### RIPE Community Contributions
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

### BGP Tools
#### libBGPdump
```
yum install bzip2-devel
wget https://bitbucket.org/ripencc/bgpdump/get/94a0e724b335.zip
unzip 94a0e724b335.zip
cd ripencc-bgpdump-94a0e724b335/
./bootstrap.sh
make all
```

#### BGPStream
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

#### Collaboration Server Setup With Jupyter Notebook

This allows people to work together on data processing and sharing.

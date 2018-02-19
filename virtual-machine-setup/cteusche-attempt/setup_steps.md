# Setup Steps

Applies to Centos 7 and Python 3.

## Ansible

Basic setup as root:
ansible-playbook --ask-pass -i inventory.txt playbook_init

Additional setup as operational user :
ansible-playbook -i inventory.txt playbook_setup --ask-sudo-pass


## Jupyter Notebook Setup

openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /mydir/conf/mycert.pem -out /mydir/conf/mycert.pem

sudo ipython3 profile create nbserver; sudo jupyter-notebook password

cd /mydir/code; sudo jupyter notebook --certfile='../conf/mycert.pem' --no-browser --ip='*' --port=443 --allow-root


## Enable PHP in Jupyter Notebook

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum install php70w-cli php70w-opcache php70-devel php70w-pear

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"

yum install zeromq

pecl install zmq-beta

update /etc/php.ini 
  with "extension=zmq.so"

yum install wget
wget https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar
chmod +x jupyter-php-installer.phar
./jupyter-php-installer.phar install

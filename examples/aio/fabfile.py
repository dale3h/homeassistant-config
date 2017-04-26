########################################
# Fabfile to:
#    - deploy supporting HA components
#    - deploy HA
########################################

# Import Fabric's API module
from fabric.api import *
import fabric.contrib.files
import time
import os


env.hosts = ['localhost']
env.user = "pi"
env.password = "raspberry"
env.warn_only = True
pi_hardware = os.uname()[4]

#######################
## Core server setup ##
#######################

def install_start():
    """ Notify of install start """
    print("""
    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,,,,,,,,, ,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,,,,,,,,   ,,,,,,,,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,,,,,,,     ,,,,,,,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,,,,,,       ,,,,,,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,,,,,         ,,,,,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,,,,           ,,,,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,,,             ,,,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,,               ,,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,       ,,,,,     ,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,       ,,,,,,,     ,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,       ,,,,,,,,,     ,,,     ,,,,,,,,,,
    ,,,,,,,,,,,,,,,,        ,,,   ,,,      ,,     ,,,,,,,,,,
    ,,,,,,,,,,,,,,,         ,,,   ,,,       ,     ,,,,,,,,,,
    ,,,,,,,,,,,,,,          ,,,   ,,,             ,,,,,,,,,,
    ,,,,,,,,,,,,,            ,,,,,,,              ,,,,,,,,,,
    ,,,,,,,,,,,,              ,,,,,               ,,,,,,,,,,
    ,,,,,,,,,,,                ,,,                ,,,,,,,,,,
    ,,,,,,,,,,                 ,,,                 ,,,,,,,,,
    ,,,,,,,,,        ,,,       ,,,       ,,,        ,,,,,,,,
    ,,,,,,,,       ,,,,,,,     ,,,     ,,,,,,,       ,,,,,,,
    ,,,,,,,       ,,,,,,,,,    ,,,    ,,,,,,,,,       ,,,,,,
    ,,,,,,        ,,,   ,,,    ,,,    ,,,   ,,,        ,,,,,
    ,,,,,         ,,,   ,,,    ,,,    ,,,   ,,,         ,,,,
    ,,,,,,,,,,,   ,,,   ,,,    ,,,    ,,,   ,,,   ,,,,,,,,,,
    ,,,,,,,,,,,    ,,,,,,,,    ,,,    ,,,,,,,,    ,,,,,,,,,,
    ,,,,,,,,,,,      ,,,,,,    ,,,    ,,,,,,      ,,,,,,,,,,
    ,,,,,,,,,,,        ,,,,,   ,,,   ,,,,,        ,,,,,,,,,,
    ,,,,,,,,,,,          ,,,, ,,,, ,,,,,          ,,,,,,,,,,
    ,,,,,,,,,,,           ,,,, ,,, ,,,,           ,,,,,,,,,,
    ,,,,,,,,,,,            ,,,,,,,,,,,            ,,,,,,,,,,
    ,,,,,,,,,,,             ,,,,,,,,,             ,,,,,,,,,,
    ,,,,,,,,,,,              ,,,,,,,              ,,,,,,,,,,
    ,,,,,,,,,,,               ,,,,,               ,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    ,,,,,,,,,,,                                   ,,,,,,,,,,
    ,,,,,,,,,,,   Welcome to the Home Assistant   ,,,,,,,,,,
    ,,,,,,,,,,, Raspberry Pi All-In-One Installer ,,,,,,,,,,
    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    """)
    print("* Warning *")
    print("""The primary use of this installer is for a new, unconfigured Home Assistant deployment.
          Running the installer command straight from the Getting Started guide found on Github, will overwrite any existing configs.
          Additional commands for upgrading should be run seperately. Please see the Github page for useage instructions""")
    time.sleep(10)
    print("Installer is starting...")
    print("Your Raspberry Pi will reboot when the installer is complete.")
    time.sleep(5)



def update_upgrade():
    """ Update OS """
    sudo("apt-get update")
    sudo("apt-get upgrade -y")


def setup_dirs():
    """ Create all needed directories and change ownership """
    with cd("/srv"):
        sudo("mkdir homeassistant")
        sudo("chown homeassistant:homeassistant homeassistant")
        with cd("homeassistant"):
            sudo("mkdir -p src")
            sudo("chown homeassistant:homeassistant src")
    with cd("/home"):
        sudo("mkdir -p homeassistant")
        sudo("mkdir -p /home/homeassistant/.homeassistant")
        sudo("chown homeassistant:homeassistant homeassistant")
    with cd("/var/lib/"):
        sudo("mkdir mosquitto")
        sudo("chown mosquitto:mosquitto mosquitto")


def new_user(admin_username, admin_password):
    env.user = 'root'

    # Create the admin group and add it to the sudoers file
    admin_group = 'admin'
    runcmd('addgroup {group}'.format(group=admin_group))
    runcmd('echo "%{group} ALL=(ALL) ALL" >> /etc/sudoers'.format(
        group=admin_group))

    # Create the new admin user (default group=username); add to admin group
    runcmd('adduser {username} --disabled-password --gecos ""'.format(
        username=pi))
    runcmd('adduser {username} {group}'.format(
        username=admin_username,
        group=admin_group))

    # Set the password for the new admin user
    runcmd('echo "{username}:{password}" | chpasswd'.format(
        username=admin_username,
        password=admin_password))


def setup_users():
    """ Create service users, etc """
    sudo("useradd mosquitto")
    sudo("useradd --system homeassistant")
    sudo("usermod -G dialout -a homeassistant")
    sudo("usermod -G gpio -a homeassistant")
    sudo("usermod -G video -a homeassistant")
    sudo("usermod -d /home/homeassistant homeassistant")

def install_syscore():
    """ Download and install Host Dependencies. """
    sudo("apt-get install -y build-essential")
    sudo("apt-get install -y python-pip")
    sudo("apt-get install -y python-dev")
    sudo("apt-get install -y python3")
    sudo("apt-get install -y python3-dev")
    sudo("apt-get install -y python3-pip")
    sudo("apt-get install -y python3-sphinx")
    sudo("apt-get install -y python3-setuptools")
    sudo("apt-get install -y git")
    sudo("apt-get install -y libssl-dev")
    sudo("apt-get install -y cmake")
    sudo("apt-get install -y libc-ares-dev")
    sudo("apt-get install -y uuid-dev")
    sudo("apt-get install -y daemon")
    sudo("apt-get install -y curl")
    sudo("apt-get install -y libgnutls28-dev")
    sudo("apt-get install -y libgnutlsxx28")
    sudo("apt-get install -y libgnutls-dev")
    sudo("apt-get install -y nmap")
    sudo("apt-get install -y net-tools")
    sudo("apt-get install -y sudo")
    sudo("apt-get install -y libglib2.0-dev")
    sudo("apt-get install -y cython3")
    sudo("apt-get install -y libudev-dev")
    sudo("apt-get install -y libxrandr-dev")
    sudo("apt-get install -y swig")

def install_pycore():
    """ Download and install VirtualEnv """
    sudo("pip3 install --upgrade pip")
    sudo("pip3 install virtualenv")

def create_venv():
    """ Create home-assistant VirtualEnv """
    sudo("virtualenv -p python3 /srv/homeassistant", user="homeassistant")


#######################################################
## Build and Install Applications without VirtualEnv ##
#######################################################

def setup_homeassistant_novenv():
    """ Install Home-Assistant """
    sudo("pip3 install --upgrade pip", user="homeassistant")
    sudo("pip3 install homeassistant", user="homeassistant")

def setup_openzwave_novenv():
    """ Install python-openzwave """
    sudo("pip3 install --upgrade cython==0.24.1", user="homeassistant")
    with cd("/srv/homeassistant/src"):
        sudo("git clone https://github.com/OpenZWave/python-openzwave.git", user="homeassistant")
        with cd("python-openzwave"):
            sudo("git checkout python3", user="homeassistant")
            sudo("make build", user="homeassistant")
            sudo("make install", user="homeassistant")

def setup_services_novenv():
    """ Enable applications to start at boot via systemd """
    hacfg="""
mqtt:
  broker: 127.0.0.1
  port: 1883
  client_id: home-assistant-1
  username: pi
  password: raspberry
"""
    with cd("/etc/systemd/system/"):
        put("home-assistant_novenv.service", "home-assistant_novenv.service", use_sudo=True)
    with settings(sudo_user='homeassistant'):
        sudo("/srv/homeassistant/bin/hass --script ensure_config --config /home/homeassistant/.homeassistant")

    fabric.contrib.files.append("/home/homeassistant/.homeassistant/configuration.yaml", hacfg, use_sudo=True)
    sudo("systemctl enable home-assistant_novenv.service")
    sudo("systemctl daemon-reload")

def setup_libcec_novenv():
    """ Install libcec according to https://github.com/Pulse-Eight/libcec/blob/master/docs/README.raspberrypi.md """
    with cd("/srv/homeassistant/src"):
        sudo("git clone https://github.com/Pulse-Eight/platform.git", user="homeassistant")
        sudo("mkdir platform/build", user="homeassistant")
        with cd("platform/build"):
            sudo("cmake ..", user="homeassistant")
            sudo("make", user="homeassistant")
            sudo("make install")
        sudo("git clone https://github.com/Pulse-Eight/libcec.git", user="homeassistant")
        sudo("mkdir libcec/build", user="homeassistant")
        with cd("libcec/build"):
            sudo("cmake -DRPI_INCLUDE_DIR=/opt/vc/include -DRPI_LIB_DIR=/opt/vc/lib ..", user="homeassistant")
            sudo("make -j4", user="homeassistant")
            sudo("make install")
            sudo("ldconfig")

####################################
## Build and Install Applications ##
####################################

def setup_mosquitto():
    """ Install Mosquitto w/ websockets"""
    with cd("/srv/homeassistant/src"):
        sudo("curl -O http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key")
        sudo("apt-key add mosquitto-repo.gpg.key")
        with cd("/etc/apt/sources.list.d/"):
            sudo("curl -O http://repo.mosquitto.org/debian/mosquitto-jessie.list")
            sudo("apt-get update")
            sudo("apt-cache search mosquitto")
            sudo("apt-get install -y mosquitto mosquitto-clients")
            with cd("/etc/mosquitto"):
                put("mosquitto.conf", "mosquitto.conf", use_sudo=True)
                sudo("touch pwfile")
                sudo("chown mosquitto: pwfile")
                sudo("chmod 0600 pwfile")
                sudo("sudo mosquitto_passwd -b pwfile pi raspberry")
                sudo("sudo chown mosquitto: mosquitto.conf")

def setup_homeassistant():
    """ Activate Virtualenv, Install Home-Assistant """
    sudo("source /srv/homeassistant/bin/activate && pip3 install homeassistant", user="homeassistant")
    with cd("/home/homeassistant/"):
        sudo("chown -R homeassistant:homeassistant /home/homeassistant/")

def setup_openzwave():
    """ Activate Virtualenv, Install python-openzwave"""
    sudo("source /srv/homeassistant/bin/activate && pip3 install --upgrade cython==0.24.1", user="homeassistant")
    with cd("/srv/homeassistant/src"):
        sudo("git clone --branch v0.3.1 https://github.com/OpenZWave/python-openzwave.git", user="homeassistant")
        with cd("python-openzwave"):
            sudo("git checkout python3", user="homeassistant")
            sudo("source /srv/homeassistant/bin/activate && make build", user="homeassistant")
            sudo("source /srv/homeassistant/bin/activate && make install", user="homeassistant")

def setup_libcec():
    setup_libcec_novenv()
    sudo("ln -s /usr/local/lib/python3.4/dist-packages/cec /srv/homeassistant/lib/python3.4/site-packages", user="homeassistant")

def setup_libmicrohttpd():
    """ Build and install libmicrohttpd """
    with cd("/srv/homeassistant/src"):
        sudo("mkdir libmicrohttpd")
        sudo("chown homeassistant:homeassistant libmicrohttpd")
        sudo("curl -O ftp://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.19.tar.gz", user="homeassistant")
        sudo("tar zxvf libmicrohttpd-0.9.19.tar.gz")
        with cd("libmicrohttpd-0.9.19"):
            sudo("./configure")
            sudo("make")
            sudo("make install")

def setup_openzwave_controlpanel():
    """ Build and Install open-zwave-control-panel """
    with cd("/srv/homeassistant/src"):
        sudo("git clone https://github.com/OpenZWave/open-zwave-control-panel.git", user="homeassistant")
        with cd("open-zwave-control-panel"):
            put("Makefile", "Makefile", use_sudo=True)
            sudo("make")
            if pi_hardware == "armv7l":
                sudo("ln -sd /srv/homeassistant/lib/python3.4/site-packages/libopenzwave-0.3.3-py3.4-linux-armv7l.egg/config")
            else:
                sudo("ln -sd /srv/homeassistant/lib/python3.4/site-packages/libopenzwave-0.3.3-py3.4-linux-armv**6**l.egg/config")
        sudo("chown -R homeassistant:homeassistant /srv/homeassistant/src/open-zwave-control-panel")

def setup_services():
    """ Enable applications to start at boot via systemd """
    with cd("/etc/systemd/system/"):
        put("home-assistant.service", "home-assistant.service", use_sudo=True)
    with settings(sudo_user='homeassistant'):
        sudo("/srv/homeassistant/bin/hass --script ensure_config --config /home/homeassistant/.homeassistant")


    hacfg="""
mqtt:
  broker: 127.0.0.1
  port: 1883
  client_id: home-assistant-1
  username: pi
  password: raspberry
"""


    fabric.contrib.files.append("/home/homeassistant/.homeassistant/configuration.yaml", hacfg, use_sudo=True)
    sudo("systemctl enable home-assistant.service")
    sudo("systemctl daemon-reload")
    sudo("systemctl start home-assistant.service")
def upgrade_homeassistant():
    """ Activate Venv, and upgrade Home Assistant to latest version """
    sudo("source /srv/homeassistant/bin/activate && pip3 install homeassistant --upgrade", user="homeassistant")

#############
## Deploy! ##
#############

def deploy():

    ## Install Start ##
    install_start()

    ## Initial Update and Upgrade ##
    update_upgrade()

    ## Setup service accounts ##
    setup_users()

    ## Setup directories ##
    setup_dirs()

    ## Install dependencies ##
    install_syscore()
    install_pycore()

    ## Create VirtualEnv ##
    create_venv()

    ## Build and Install Mosquitto ##
    setup_mosquitto()

    ## Activate venv, install Home-Assistant ##
    setup_homeassistant()

    ## Make apps start at boot ##
    setup_services()

    ## Activate venv, build and install python-openzwave ##
    setup_openzwave()

    ## Build and install libmicrohttpd ##
    setup_libmicrohttpd()

    ## Build and install open-zwave-control-panel ##
    setup_openzwave_controlpanel()

    ## Build and install libcec ##
    setup_libcec()

    ## Reboot the system ##
    reboot()




def deploy_novenv():

    ## Install Start ##
    install_start()

    ## Initial Update and Upgrade ##
    update_upgrade()

    ## Setup service accounts ##
    setup_users()

    ## Setup directories ##
    setup_dirs()

    ## Install dependencies ##
    install_syscore()

    ## Build and Install Mosquitto ##
    setup_mosquitto()

    ## Activate venv, install Home-Assistant ##
    setup_homeassistant_novenv()

    ## Make apps start at boot ##
    setup_services_novenv()

    ## Activate venv, build and install python-openzwave ##
    setup_openzwave_novenv()

    ## Build and install libmicrohttpd ##
    setup_libmicrohttpd()

    ## Build and install open-zwave-control-panel ##
    setup_openzwave_controlpanel()

    ## Build and install libcec ##
    setup_libcec_novenv()

    ## Reboot the system ##
    reboot()

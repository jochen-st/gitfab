
# Terraform code

fuer Version 0.13 und Azure

# Docker lokal installieren

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"

apt install docker-ce docker-ce-cli containerd.io

curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Git URLs

## in Oberflaeche angegeben

~~~
git@gitlab:jst/wiki.git
~~~

hier muss der lokale Hostname gitlab durch den oeffentlichen ersetzt werden

## Standard SSH URLs

mit Port 2022 (forwarded)

~~~
ssh://git@public_ip:2022/jst/wiki.git
~~~

bei hinterlegtem Key

# nuetzliche Links

- https://docs.gitlab.com/ee/user/packages/maven_repository/

- https://docs.gitlab.com/ee/ci/examples/artifactory_and_gitlab/index.html

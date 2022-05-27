# Kubernetes

In this lab, we will achieve the CI/CD for a "Hello Kubernetes" NodeJS App using

  - Jenkins
  - Docker
  - DockerHub
  - Kubernetes
  - Helm package Manager

    ![alt text](img/Arch.jpg "Pipeline")



### Prepare Jenkins VM

  Install Java

    $ sudo apt update -y
    $ sudo apt upgrade -y
    $ sudo apt-get install default-jre -y

  Install Jenkins

    $ wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    $ sudo echo "deb https://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
    $ sudo apt-get update
    $ sudo apt-get install jenkins -y

  Start /Enable Jenkins on next Boot

    $ systemctl start jenkins
    $ systemctl enable jenkins
    $ cat /var/lib/jenkins/secrets/initialAdminPassword

    On your browser Jenkins-IP:8080, paste the previous password and select "Install suggested plugins"


  Installing Docker  

    $ curl -fsSL https://get.docker.com -o get-docker.sh
    $ sudo sh get-docker.sh

  Add User Jenkins to Docker Group

    $ sudo usermod -aG docker jenkins

  Installing the helm client

    - Download your desired version https://github.com/helm/helm/releases

    - Unpack it (tar -zxvf helm-v2.0.0-linux-amd64.tgz)

    - Find the helm binary in the unpacked directory, and move it to its desired destination (mv linux-amd64/helm /usr/local/bin/helm)

          $ wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz

          $ tar -xzvf helm-v2.11.0-linux-amd64.tar.gz

          $ sudo mv linux-amd64/helm /usr/local/bin/

          $ helm version

            Client: &version.Version{SemVer:"v2.11.0", GitCommit:"2e55dbe1fdb5fdb96b75ff144a339489417b146b", GitTreeState:"clean"}






### Creating a pipeline

  Create a Github and DockerHub creds Id "git, dockerhub"

    Go to jenkins-IP:8080/credentials/store/system/domain/ to add your git access with id

  ![alt text](img/01-weekly-jenkins.png "Github Creds")

  Create "New Item" with "Pipeline" type, then copy the content under "jenkinsfiles/nodejs/Jenkinsfile" to the Pipeline and replace
  - the 2nd line with your repo
  - the 3rd line with dockerhub-username/repo-name
### Add Changes to the Code

  - under the repository, navigate "app/routes/root.js", change the "background-color" to red

  - run Jenkins pipline

  - Open your browser IP:30333

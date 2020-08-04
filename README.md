# docker_knowledge
Gitbook for .md knowledge over docker
Set gitbook version in gitbook/Dockerfile

## Usage

### Install docker and docker-compose
#### Docker engine installation 
[Official link](https://docs.docker.com/engine/install/)
Ubuntu/Debian installation
```shell script
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
```
ssh relogin
#### Configure Docker to start on boot
```shell script
sudo systemctl enable docker
```

#### Docker-compose installation
[Official link](https://docs.docker.com/compose/install/)
```shell script
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
``` 

### Plugins
Add plugins in gitbook/book.json
[List of plugins](https://github.com/swapagarwal/awesome-gitbook-plugins)

### CSS customize
edit gitbook/custom_style.css

### Config
create .env file with content
```shell script
# path for repository with md files
KNOWLEDGE_PATH=/path/to/knowledge_repo/
```
### Navigation
Generate navigation in left side
```shell script
npm install -g gitbook-summary
cd /path/to/knowledge_repo/
book sm g
```

### Ports open
Default port is 4100 for http and 4106 for https
Open port via ufw
```shell script
sudo ufw allow 4100
sudo ufw allow 4106
``` 

### Start
```shell script
bash run.sh 
```
Start as daemon
```shell script
bash run.sh --env "daemon" 
```

PS
docker system info | Select-Object




export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="$PATH:/mnt/c/Program\ Files/Docker/Docker/resources/bin"
alias docker=docker.exe
alias docker-compose=docker-compose.exe


sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce

export DOCKER_HOST='tcp://10.0.1.103:2376'
export DOCKER_CERT_PATH=/mnt/c/Users/Jean-MichelGirard/.minikube/
export DOCKER_TLS_VERIFY=1

echo >> ~/.bashrc <<EOF
# Connect to Docker on Windows
export DOCKER_HOST='tcp://10.0.1.103:2376'
export DOCKER_CERT_PATH=/mnt/c/Users/Jean-MichelGirard/.minikube/
export DOCKER_TLS_VERIFY=1

EOF
source ~/.bashrc

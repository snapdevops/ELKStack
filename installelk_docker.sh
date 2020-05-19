#  INSTALL SINGLE NODE ELASTIC SEARCH On AWS EC2 Instance - Ubuntu 16 with free tier account , 1 cpu & 8 GB

# Increase SWAP space ELK looking for this as it may encounter with memory issue 
free -m
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# RUN Elastic Search on Docker Container
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.7.0
docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.7.0




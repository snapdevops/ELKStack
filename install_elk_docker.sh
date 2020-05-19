#  INSTALL SINGLE NODE ELASTIC SEARCH On AWS EC2 Instance - Ubuntu 16 with free tier account , 1 cpu & 1 GB

# Increase SWAP space ELK looking for this as it may encounter with memory issue 
free -m
sudo fallocate -l 2G /swapspace
sudo chmod 600 /swapspace
sudo mkswap /swapspace
sudo swapon /swapspace
# install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# RUN Elastic Search on Docker Container
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.7.0
docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.7.0
# test with http://<systemIP>>:9200/_cluster/health/?pretty or with localhost IP 

# RUN Logstash Search on Docker Container
free -m
sudo fallocate -l 1G /swapspace
sudo chmod 600 /swapspace
sudo mkswap /swapspace
sudo swapon /swapspace
docker pull docker.elastic.co/logstash/logstash:7.7.0
mkdir -p /usr/share/logstash/pipeline/logstash
cat <<EOF >/usr/share/logstash/pipeline/logstash/logstash.conf

input { stdin { } }

filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
  date {
    match => [ "timestamp" , "dd/MMM/yyyy:HH:mm:ss Z" ]
  }
}

output {
  elasticsearch { hosts => ["ip-172-31-14-154.us-east-2.compute.internal:9200"] }
  stdout { codec => rubydebug }
}
EOF
docker run -d --rm -it -v ~/pipeline/:/usr/share/logstash/pipeline/ docker.elastic.co/logstash/logstash:7.7.0



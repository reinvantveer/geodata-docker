FROM mdillon/postgis:9.6

# ADD https://data.nlextract.nl/bag/postgis/bag-laatst.backup ./bag.backup
RUN apt-get update && apt-get install -y curl
RUN curl -L -o ./bag.backup https://data.nlextract.nl/bag/postgis/bag-laatst.backup
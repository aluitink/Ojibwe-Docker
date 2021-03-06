FROM microsoft/aspnet:1.0.0-beta8

RUN apt-get update && apt-get -qqy install apt-utils && apt-get -qqy install git && apt-get -y clean && rm -rf /var/lib/apt/lists/*

RUN rm -rf /opt/ojibwe
RUN mkdir -p /opt/ojibwe
RUN cd /opt/ojibwe
RUN git clone https://github.com/aluitink/Ojibwe.git /opt/ojibwe

WORKDIR /opt/ojibwe/Common/Ojibwe.Common.Configuration
RUN ["dnu", "restore"]

WORKDIR /opt/ojibwe/Common/Ojibwe.Common.RestClient
RUN ["dnu", "restore"]

WORKDIR /opt/ojibwe/Public/Ojibwe.Public.Sdk
RUN ["dnu", "restore"]

WORKDIR /opt/ojibwe/DataAccess/Ojibwe.DataAccess.Cassandra
RUN ["dnu", "restore"]

WORKDIR /opt/ojibwe/StorageAdapter/Ojibwe.StorageAdapter.FileSystem
RUN ["dnu", "restore"]

WORKDIR /opt/ojibwe/Public/Ojibwe.Public.Api
RUN ["dnu", "restore"]

EXPOSE 5004

ENTRYPOINT dnx -p project.json --configuration Release kestrel
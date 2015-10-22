FROM microsoft/aspnet:1.0.0-beta6

ADD src/cassandra.sources.list /etc/apt/sources.list.d/cassandra.sources.list

RUN curl -L http://debian.datastax.com/debian/repo_key | apt-key add -

RUN apt-get update && apt-get -y install \
	apt-utils \
	supervisor \
	openjdk-7-jre-headless \
	dsc22=2.2.2-1 cassandra=2.2.2 \
	git && \
	apt-get -y clean all && \
	rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/security/limits.d/cassandra.conf

RUN rm -rf /opt/ojibwe && \
	mkdir -p /opt/ojibwe

RUN cd /opt && git clone https://github.com/aluitink/Ojibwe.git /opt/ojibwe
RUN cd /opt/ojibwe && git pull

WORKDIR /opt/ojibwe/Ojibwe.Public.Api
RUN dnu restore

RUN xbuild /p:Configuration=Release /opt/ojibwe/Ojibwe.Common.Configuration/Ojibwe.Common.Configuration.csproj 

RUN mono /opt/ojibwe/.nuget/NuGet.exe restore /opt/ojibwe/Ojibwe.Common.RestClient/packages.config -OutputDirectory /opt/ojibwe/packages 
RUN xbuild /p:Configuration=Release /opt/ojibwe/Ojibwe.Common.RestClient/Ojibwe.Common.RestClient.csproj 

RUN mono /opt/ojibwe/.nuget/NuGet.exe restore /opt/ojibwe/Ojibwe.Public.Sdk/packages.config -OutputDirectory /opt/ojibwe/packages 
RUN xbuild /p:Configuration=Release /opt/ojibwe/Ojibwe.Public.Sdk/Ojibwe.Public.Sdk.csproj 

RUN mono /opt/ojibwe/.nuget/NuGet.exe restore /opt/ojibwe/Ojibwe.DataAccess.Cassandra/packages.config -OutputDirectory /opt/ojibwe/packages 
RUN xbuild /p:Configuration=Release /opt/ojibwe/Ojibwe.DataAccess.Cassandra/Ojibwe.DataAccess.Cassandra.csproj 


RUN mono /opt/ojibwe/.nuget/NuGet.exe restore /opt/ojibwe/Ojibwe.StorageAdapter.AmazonS3/packages.config -OutputDirectory /opt/ojibwe/packages 
RUN xbuild /p:Configuration=Release /opt/ojibwe/Ojibwe.StorageAdapter.AmazonS3/Ojibwe.StorageAdapter.AmazonS3.csproj 
RUN xbuild /p:Configuration=Release /opt/ojibwe/Ojibwe.StorageAdapter.NtfsFileSystem/Ojibwe.StorageAdapter.NtfsFileSystem.csproj 


RUN mkdir -p /var/lib/ojibwe/data
RUN mkdir -p /var/log/ojibwe
RUN mkdir -p /var/log/supervisor

ADD src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD src/start.sh /usr/local/bin/start
RUN chmod 755 /usr/local/bin/start

ENV CassandraEndpoints 127.0.0.1
ENV CassandraDatabase ojibwe
ENV StorageAdapter Ojibwe.StorageAdapter.NtfsFileSystem
ENV StorageAdapterConnectionString DATA=/var/lib/ojibwe/data
ENV StorageBlobChunkSize 1048576
ENV SecureEncryptionPassword n-BpGknFDTn9Fehk9NCB+4e
ENV SecureEncryptionSalt Jz6!P^6-*!2nV6M=L%Y_#Q!
ENV LoggingDirectory /var/log/ojibwe

EXPOSE 7199 7000 7001 9160 9042

EXPOSE 5004

CMD start
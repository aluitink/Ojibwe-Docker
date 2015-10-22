FROM microsoft/aspnet:1.0.0-beta6

RUN apt-get -qqy install apt-utils && apt-get -qqy install git && apt-get -y clean && rm -rf /var/lib/apt/lists/*

RUN rm -rf /opt/ojibwe
RUN mkdir -p /opt/ojibwe
RUN cd /opt/ojibwe
RUN git clone https://github.com/aluitink/Ojibwe.git /opt/ojibwe

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


EXPOSE 5004

ENTRYPOINT dnx project.json --configuration Release kestrel
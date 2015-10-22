FROM microsoft/aspnet:1.0.0-beta6

RUN apt-get -qqy install apt-utils && apt-get -qqy install git && apt-get -y clean && rm -rf /var/lib/apt/lists/*

RUN rm -rf /opt/ojibwe
RUN mkdir -p /opt/ojibwe
RUN cd /opt/ojibwe
RUN git clone https://github.com/aluitink/Ojibwe.git /opt/ojibwe

WORKDIR /opt/ojibwe/Public/Ojibwe.Public.Api
RUN dnu restore


EXPOSE 5004

ENTRYPOINT dnx -p project.json --configuration Release kestrel
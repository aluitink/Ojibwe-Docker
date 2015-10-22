# Ojibwe Docker Container

## What is Ojibwe?
Ojibwe is an encrypted storage abstraction layer designed to provide high security key management and blob storage.

The REST API is written in C# for ASP.NET 5 (vNext). The web service can be hosted on Windows/Linux/Mac using DNX.

- https://github.com/aluitink/Ojibwe.git

## Configuration
Configuration is provided through environmental variables.
The application is configured to serve on port **5004**, this can be mapped on the Docker host as needed.
The application utilizes an Apache Cassandra database for key management. If the database does not exist, the application will initialize it upon the first request.
The default Admin user is **Admin** and password is **Password01**.

The SDK requires the services base url, for example: http://ojibwe/.
The API can be tested by accessing, http://ojibwe/api/users.

Currently Ojibwe only supports Basic authentication.

Full API documentation to come...

Environmental Variables
-------------

* `CassandraEndpoints` A collection of Cassandra database addresses, the Cassandra adapter will manage node balancing and dead node removal.
* `CassandraDatabase` The name of the database to store schema data.
* `SecureEncryptionPassword` and `SecureEncryptionSalt` The system is a trusted user and will generate/host its own public/private keys, the `SecureEncryptionPassword` along with the `SecureEncryptionSalt` will be used to protect the data.
* `StorageAdapter` When a blob is stored the storage adatper DLL will be loaded dynamically, this should be the absolute path. Available adapters include: Ojibwe.StorageAdapter.FileSystem or Ojibwe.StorageAdapter.AmazonS3
* `StorageAdapterConnectionString` FileSystem: DATA=/mnt/ojibweData or AmazonS3: bucket={bucket name};id={AmazonS3 ID};key={AmazonS3 Key}
* `StorageBlobChunkSize` To ensure compatibility with more storage system, you can choose the max file size in **bytes**, files will be chunked when uploading.
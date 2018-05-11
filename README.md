
# protoc-docker

Bundle latest version of protoc for grpc into a docker.

The protoc-docker auto-detect the protoc plugin for grpc based on the --XX_out argument

## See

https://github.com/grpc/grpc
https://github.com/google/protobuf


## Usage

```
protoc-docker --php_out=DIR --grpc_out=DIR schema.proto
```
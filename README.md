# Api proto entity

Shared gRPC API definitions for the Auth Platform.

auth-api contains Protocol Buffers (.proto) definitions and generated Go code used for communication between services.

The repository serves as a single source of truth for the platform's gRPC contracts.

## Overview

The Auth Platform consists of multiple independent services that communicate with each other using gRPC.

Instead of defining service contracts inside each individual service, all protobuf definitions are stored in auth-api.

## Responsibilities

auth-api is responsible for:

Defining gRPC service contracts
Defining protobuf messages
Defining request and response structures
Generating Go gRPC clients
Generating Go gRPC servers
Maintaining a consistent API between services

The repository does not contain business logic.

## Protocol Buffers

Service contracts are defined using Protocol Buffers.

A simplified example:

```proto
service AccessService {
    rpc CreateRole (Role) returns (Success) {};
    rpc GetRoles (UserID) returns (Roles) {};
    rpc CreatePermission (PermissionReq) returns (Success) {};
    rpc GetFullPermissions (UserID) returns (FullPermissions) {};
    rpc GetPermissionsByUserID (UserID) returns (Permissions) {};
    rpc GetPermissionsByRoleName (RoleName) returns (Permissions) {};
    rpc AddUserRole(UserIDRoleName) returns (Success) {};
    rpc BindUserRole(UserID) returns (Success) {};
    rpc ReplaceUserRole(UpdateUserRoleReq) returns (Success) {};
    rpc DeleteUserRole(UserIDRoleName) returns (Success) {};
}
```

Messages are defined alongside the service:

```proto
message Role {
    string ID = 1;
    string name = 2;
    string description = 3;
    bool is_default = 4;
    google.protobuf.Timestamp created_at = 5;
    google.protobuf.Timestamp updated_at = 6;
}

```

## Usage

A service imports the generated package from auth-api.

For example:

```go
import (
api "github.com/GroVlAn/auth-api/access"
)
```

A client can then use the generated gRPC client:

```go
client := api.NewAccessServiceClient(conn)
```

The server implements the generated server interface:

```go
type AccessServer struct {
api.UnimplementedAccessServiceServer
}
```

This keeps the communication contract independent from the implementation of the service.

## API Compatibility

When changing a protobuf definition, special attention should be paid to backward compatibility.

For example, existing protobuf field numbers should not be reused.

Prefer adding new fields:

```go
message User {
string id = 1;
string email = 2;
string username = 3;
}
```

rather than changing the meaning of existing field numbers.

Breaking API changes should be introduced through a new API version when necessary.

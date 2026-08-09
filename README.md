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

## Generating Code:

All `.proto` files are compiled using a `Makefile` target. Simply run:

```bash
make gen
```

This command executes:

```bash
protoc -I=proto \
  --go_out=. --go_opt=paths=import \
  --go-grpc_out=. --go-grpc_opt=paths=import \
  proto/user.proto proto/auth.proto proto/access.proto
```

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

## Repository Structure

```text
auth-api/
├── proto/                  # Protocol Buffer definitions
│   ├── auth.proto          # Auth service contracts
│   ├── user.proto          # User service contracts
│   └── access.proto        # Access service (RBAC) contracts
├── auth/                   # Generated Go code for auth service
├── user/                   # Generated Go code for user service
├── access/                 # Generated Go code for access service
├── go.mod
├── go.sum
└── Makefile
```

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

You are free to use, modify, distribute, and sublicense the code for both commercial and non‑commercial purposes, provided that the original copyright notice and permission notice are included in all copies or substantial portions of the software.

For more information, see the full [MIT License](https://opensource.org/licenses/MIT).

.PHONY:

.DEFAULT_GOAL := gen

gen:
	protoc -I=proto \
	--go_out=. --go_opt=paths=import \
	--go-grpc_out=. --go-grpc_opt=paths=import \
	proto/user.proto proto/auth.proto proto/access.proto
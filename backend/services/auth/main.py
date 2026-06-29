from concurrent import futures
import logging
import grpc

from generated import auth_pb2
from generated import auth_pb2_grpc
from services.auth.logic import (
    fake_users_db,
    get_password_hash,
    verify_password,
    create_access_token,
    decode_access_token,
    timedelta,
    ACCESS_TOKEN_EXPIRE_MINUTES,
)

class AuthServicer(auth_pb2_grpc.AuthServiceServicer):
    def Register(self, request, context):
        if request.username in fake_users_db:
            return auth_pb2.AuthResponse(success=False, message="User already exists", token="")
        
        hashed_password = get_password_hash(request.password)
        fake_users_db[request.username] = {
            "username": request.username,
            "hashed_password": hashed_password
        }
        
        access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": request.username}, expires_delta=access_token_expires
        )
        return auth_pb2.AuthResponse(success=True, message="User registered successfully", token=access_token)

    def Login(self, request, context):
        user = fake_users_db.get(request.username)
        if not user or not verify_password(request.password, user["hashed_password"]):
            return auth_pb2.AuthResponse(success=False, message="Invalid username or password", token="")
            
        access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": request.username}, expires_delta=access_token_expires
        )
        return auth_pb2.AuthResponse(success=True, message="Login successful", token=access_token)

    def ValidateToken(self, request, context):
        payload = decode_access_token(request.token)
        if payload is None:
            return auth_pb2.ValidateResponse(valid=False, username="")
        
        username = payload.get("sub")
        if not username:
            return auth_pb2.ValidateResponse(valid=False, username="")
            
        return auth_pb2.ValidateResponse(valid=True, username=username)

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    auth_pb2_grpc.add_AuthServiceServicer_to_server(AuthServicer(), server)
    server.add_insecure_port('[::]:50052')
    logging.info("Auth gRPC server started, listening on 50052")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    serve()
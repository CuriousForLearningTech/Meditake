import grpc
import logging

logger = logging.getLogger(__name__)
from generated import auth_pb2
from generated import auth_pb2_grpc

class AuthGRPCClient:
    """
    A gRPC client for communicating with the Auth service.
    """
    def __init__(self, host='localhost', port=50052):
        self.target = f'{host}:{port}'
        self.channel = grpc.insecure_channel(self.target)
        self.stub = auth_pb2_grpc.AuthServiceStub(self.channel)

    def register(self, username, password):
        request = auth_pb2.RegisterRequest(username=username, password=password)
        try:
            return self.stub.Register(request)
        except grpc.RpcError as e:
            logger.error(f"gRPC Register call failed: {e.code()} - {e.details()}")
        return None

    def login(self, username, password):
        request = auth_pb2.LoginRequest(username=username, password=password)
        try:
            return self.stub.Login(request)
        except grpc.RpcError as e:
            logger.error(f"gRPC Login call failed: {e.code()} - {e.details()}")
            return None

    def validate_token(self, token):
        request = auth_pb2.ValidateRequest(token=token)
        try:
            return self.stub.ValidateToken(request)
        except grpc.RpcError as e:
            logger.error(f"gRPC ValidateToken call failed: {e.code()} - {e.details()}")
            return None

    def close(self):
        self.channel.close()

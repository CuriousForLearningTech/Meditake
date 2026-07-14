from concurrent import futures
import logging
import grpc

from common.logging import setup_logging
setup_logging()
logger = logging.getLogger(__name__)

from generated import notification_pb2
from generated import notification_pb2_grpc

class NotificationServicer(notification_pb2_grpc.NotificationServiceServicer):
    def SendNotification(self, request, context):
        # Dummy implementation
        logger.info(f"Sending notification to user {request.user_id}: {request.message}")
        return notification_pb2.NotificationResponse(success=True)

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    notification_pb2_grpc.add_NotificationServiceServicer_to_server(NotificationServicer(), server)
    server.add_insecure_port('[::]:50054')
    logger.info("Notification gRPC server started, listening on 50054")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    serve()

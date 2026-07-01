from concurrent import futures
import logging
import grpc

from common.logging import setup_logging
setup_logging()
logger = logging.getLogger(__name__)

from generated import reminder_pb2
from generated import reminder_pb2_grpc

class ReminderServicer(reminder_pb2_grpc.ReminderServiceServicer):
    def SetReminder(self, request, context):
        # Dummy implementation
        logger.info(f"Setting reminder for prescription {request.prescription_id} at {request.time}")
        return reminder_pb2.ReminderResponse(success=True, reminder_id="rem_123")

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    reminder_pb2_grpc.add_ReminderServiceServicer_to_server(ReminderServicer(), server)
    server.add_insecure_port('[::]:50056')
    logger.info("Reminder gRPC server started, listening on 50056")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    serve()

from concurrent import futures
import logging
import grpc

from common.logging import setup_logging
setup_logging()
logger = logging.getLogger(__name__)

from generated import prescription_pb2
from generated import prescription_pb2_grpc

class PrescriptionServicer(prescription_pb2_grpc.PrescriptionServiceServicer):
    def GetPrescription(self, request, context):
        # Dummy implementation
        return prescription_pb2.PrescriptionResponse(
            id=request.id,
            user_id="user_123",
            medicine_id="med_456",
            dosage="Take 1 pill every 8 hours"
        )

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    prescription_pb2_grpc.add_PrescriptionServiceServicer_to_server(PrescriptionServicer(), server)
    server.add_insecure_port('[::]:50055')
    logger.info("Prescription gRPC server started, listening on 50055")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    serve()

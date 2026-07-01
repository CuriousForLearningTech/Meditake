from concurrent import futures
import logging
import grpc

from common.logging import setup_logging
setup_logging()
logger = logging.getLogger(__name__)

from generated import medicine_pb2
from generated import medicine_pb2_grpc

class MedicineServicer(medicine_pb2_grpc.MedicineServiceServicer):
    def GetMedicineInfo(self, request, context):
        # Dummy implementation
        return medicine_pb2.MedicineResponse(
            id=request.id,
            name="Aspirin",
            description="Pain reliever"
        )
    
    def ListMedicines(self, request, context):
        # Dummy implementation
        meds = [
            medicine_pb2.MedicineResponse(id="1", name="Aspirin", description="Pain reliever"),
            medicine_pb2.MedicineResponse(id="2", name="Ibuprofen", description="Anti-inflammatory")
        ]
        return medicine_pb2.MedicineListResponse(medicines=meds)

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    medicine_pb2_grpc.add_MedicineServiceServicer_to_server(MedicineServicer(), server)
    server.add_insecure_port('[::]:50053')
    logger.info("Medicine gRPC server started, listening on 50053")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    serve()

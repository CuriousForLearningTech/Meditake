import grpc
from concurrent import futures
import logging

from services.grpc_generated import reminder_pb2
from services.grpc_generated import reminder_pb2_grpc

class ReminderServiceServicer(reminder_pb2_grpc.ReminderServiceServicer):
    """
    gRPC Servicer for the Reminder Service.
    
    This service is designed to be called during off-peak hours to trigger
    the scheduling algorithm for reminders. It decoupled the scheduling 
    workload from the user-facing API.
    """
    
    def TriggerScheduling(self, request, context):
        """
        Endpoint to trigger the scheduling algorithm for a specific date.
        """
        target_date = request.target_date
        logging.info(f"Received request to trigger scheduling for date: {target_date}")
        
        # Here we would typically invoke the scheduling logic
        # scheduling_logic.run_for_date(target_date)
        
        # Returning a mock successful response for demonstration
        return reminder_pb2.TriggerResponse(
            success=True,
            message=f"Successfully triggered scheduling for {target_date}",
            scheduled_jobs_count=5 # Mock number
        )

def serve(port=50051):
    """
    Starts the gRPC server for the Reminder service.
    """
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    reminder_pb2_grpc.add_ReminderServiceServicer_to_server(ReminderServiceServicer(), server)
    
    listen_addr = f'[::]:{port}'
    server.add_insecure_port(listen_addr)
    
    logging.info(f"Starting Reminder gRPC server on {listen_addr}...")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    serve()

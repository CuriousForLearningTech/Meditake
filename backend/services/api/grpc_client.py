import grpc
import logging

from services.grpc_generated import reminder_pb2
from services.grpc_generated import reminder_pb2_grpc

class ReminderGRPCClient:
    """
    A simple client for communicating with the Reminder gRPC service.
    
    This client is meant to be used by other services (like the API Gateway
    or a dedicated scheduled task runner) to trigger off-peak reminder scheduling.
    """
    
    def __init__(self, host='localhost', port=50051):
        self.target = f'{host}:{port}'
        # Create an insecure channel. For production, secure channels with TLS should be used.
        self.channel = grpc.insecure_channel(self.target)
        self.stub = reminder_pb2_grpc.ReminderServiceStub(self.channel)

    def trigger_scheduling(self, target_date: str):
        """
        Sends a RPC to the Reminder service to trigger scheduling.
        """
        logging.info(f"Sending TriggerScheduling request for date: {target_date}")
        request = reminder_pb2.TriggerRequest(target_date=target_date)
        
        try:
            response = self.stub.TriggerScheduling(request)
            logging.info(f"Received response: success={response.success}, message='{response.message}', count={response.scheduled_jobs_count}")
            return response
        except grpc.RpcError as e:
            logging.error(f"gRPC call failed: {e.code()} - {e.details()}")
            return None
            
    def close(self):
        self.channel.close()

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    
    client = ReminderGRPCClient()
    # Trigger scheduling for today as a test
    client.trigger_scheduling('2026-06-29')
    client.close()

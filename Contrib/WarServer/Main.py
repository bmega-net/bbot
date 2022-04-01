import pdb
import sys
from Server import *

SERVER_IP = "0.0.0.0"
SERVER_PORT = 6000
SERVER_NAME = "Custom Server"
SERVER_STATUS_TICK = 500
if len(sys.argv) >= 4:
    SERVER_IP = sys.argv[1]
    SERVER_PORT = int(sys.argv[2])
    SERVER_NAME = sys.argv[3]
    if len(sys.argv) == 5:
        if sys.argv[4] == "DEBUG":
            pdb.set_trace()

Server(SERVER_NAME, SERVER_IP, SERVER_PORT, SERVER_STATUS_TICK).Run()

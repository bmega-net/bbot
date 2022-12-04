import time
import socket
from Packet import *
import traceback


class ClientBase:
    def __init__(self, server):
        self.server = server
        self.connection = None

    def recv(self, data):
        pass

    def close(self):
        pass

    def send(self, packet):
        self.connection.send(packet)

    def setConnection(self, connection):
        self.connection = connection


CONNECTION_TIMEOUT = 10


class Connection:
    def __init__(self, server, adr, sock):
        self.adr = adr
        self.sock = sock
        print('[Connection] Create(%s:%d)' % self.adr)
        self.server = server
        self.client = None
        self.lastRecv = time.time()

    def setClient(self, client):
        self.client = client
        self.client.setConnection(self)

    def close(self):
        print('[Connection] Close(%s:%d)' % self.adr)
        self.sock.close()

    def send(self, packet):
        pck = Packet()
        pck.add(Packet.U16, len(packet.buffer))
        pck.add(Packet.U16, Fletcher16(packet.buffer))
        pck.addBuffer(packet.buffer)
        try:
            self.sock.send(pck.buffer)
        except socket.error as msg:
            print('[Connection] Error(%s:%d) %s' % (self.adr[0], self.adr[1], str(msg)))
            traceback.format_exc()
            self.close()


    def recv(self):
        try:
            bHeader = self.sock.recv(4)
            if bHeader:
                pHeader = Packet(bHeader)
                l = pHeader.read(Packet.U16)
                c = pHeader.read(Packet.U16)
                bData = self.sock.recv(l)
                if bData and Fletcher16(bData) == c:
                    self.lastRecv = time.time()
                    self.client.recv(Packet(bData))
        except socket.error as msg:
            print('[Connection] Error(%s:%d) %s' % (self.adr[0], self.adr[1], str(msg)))
            traceback.format_exc()
            self.close()

    def timeout(self):
        return time.time() - self.lastRecv > CONNECTION_TIMEOUT

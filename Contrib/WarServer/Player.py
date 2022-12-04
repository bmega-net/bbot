import time
from Protocol import *
from Packet import *
from Connection import ClientBase
import Room

class Player(ClientBase):
    def __init__(self, server, leader, name, room):
        ClientBase.__init__(self, server)
        self.name = name
        self.leader = leader
        self.room = room
        self.lastRecv = time.time()
        self.room.addPlayer(self)

    def recv(self, packet):
        self.lastRecv = time.time()
        cmd = packet.read(Packet.U8)
        if cmd == CMD_CLIENT_STATUS:
            self.recvStatus(packet)
        elif cmd == CMD_CLIENT_COMBO_TARGET:
            self.recvComboTarget(packet)
        elif cmd == CMD_CLIENT_COMBO_POS:
            self.recvComboPos(packet)
        elif cmd == CMD_CLIENT_SIGNAL:
            self.recvSignal(packet)

    def recvStatus(self, packet):
        print('[Player] %s: status' % self.name)
        pck = Packet()
        pck.add(Packet.S8, CMD_SERVER_STATUS)
        pck.addBuffer(packet.buffer[1:])
        pck.add(Packet.S8, 1 if self.leader else 0)
        self.room.broadcast(self, pck)
        pck = Packet()
        pck.add(Packet.U8, CMD_SERVER_STATUS_RECEIVED)
        self.send(pck)

    def recvComboTarget(self, packet):
        if self.leader:
            print('[Player] %s: combo target' % self.name)
            pck = Packet()
            pck.add(Packet.S8, CMD_SERVER_COMBO_TARGET)
            pck.addBuffer(packet.buffer[1:])
            self.room.broadcast(self, pck)

    def recvComboPos(self, packet):
        if self.leader:
            print('[Player] %s: combo position' % self.name)
            pck = Packet()
            pck.add(Packet.S8, CMD_SERVER_COMBO_POS)
            pck.addBuffer(packet.buffer[1:])
            self.room.broadcast(self, pck)

    def recvSignal(self, packet):
        print('[Player] %s: signal' % self.name)
        pck = Packet()
        pck.add(Packet.S8, CMD_SERVER_SIGNAL)
        pck.addBuffer(packet.buffer[1:])
        self.room.broadcast(self, pck)

import time
from Connection import ClientBase
from Protocol import *
from Packet import *
from Player import Player


class IncomingClient(ClientBase):
    def __init__(self, server):
        self.helloSents = 0
        ClientBase.__init__(self, server)

    def recv(self, packet):
        packet.show()
        cmd = packet.read(Packet.U8)
        if cmd == CMD_CLIENT_ROOM_JOIN:
            self.recvJoin(packet)
        elif cmd == CMD_CLIENT_ROOM_CREATE:
            self.recvCreate(packet)
        else:
            self.sendHello()

    def setConnection(self, connection):
        self.connection = connection
        self.sendHello()

    def sendHello(self):
        self.helloSents += 1
        if self.helloSents > 3:
            self.connection.close()
        else:
            pck = Packet()
            pck.add(Packet.U8, CMD_SERVER_HELLO)
            self.send(pck)

    def recvJoin(self, packet):
        roomName = packet.read(Packet.STR16)
        playerName = packet.read(Packet.STR16)
        password = packet.read(Packet.STR16)
        print('[IncomingClient] recvJoin(%s, %s, %s)' % (roomName, playerName, password))
        if not self.server.roomManager.validName(roomName):
            print('[IncomingClient] invalid room name')
            pck = Packet()
            pck.add(Packet.U8, CMD_SERVER_ROOM_INVALID_NAME)
            self.send(pck)
            return
        room = self.server.roomManager.getRoom(roomName)
        if room is None:
            print('[IncomingClient] room not found')
            pck = Packet()
            pck.add(Packet.U8, CMD_SERVER_ROOM_NOT_FOUND)
            self.send(pck)
        else:
            if room.password != password and room.leaderPassword != password:
                print('[IncomingClient] wrong password')
                pck = Packet()
                pck.add(Packet.U8, CMD_SERVER_ROOM_WRONG_PASSWORD)
                self.send(pck)
            else:
                print('[IncomingClient] room joined')
                isLeader = (room.leaderPassword == password)
                if isLeader:
                    print('[IncomingClient] IsLeader')
                pck = Packet()
                pck.add(Packet.U8, CMD_SERVER_ROOM_JOINED)
                pck.add(Packet.U8, 1 if isLeader else 0)
                pck.add(Packet.U32, self.server.status_tick)
                self.send(pck)
                p = Player(self.server, isLeader, playerName, room)
                self.connection.setClient(p)

    def recvCreate(self, packet):
        roomName = packet.read(Packet.STR16)
        playerName = packet.read(Packet.STR16)
        password = packet.read(Packet.STR16)
        leaderPassword = packet.read(Packet.STR16)
        print('[IncomingClient] recvCreate(%s, %s, %s, %s)' % (roomName, playerName, password, leaderPassword))
        if not self.server.roomManager.validName(roomName):
            print('[IncomingClient] invalid room name')
            pck = Packet()
            pck.add(Packet.U8, CMD_SERVER_ROOM_INVALID_NAME)
            self.send(pck)
        else:
            room = self.server.roomManager.getRoom(roomName)
            if room is not None:
                print('[IncomingClient] room already exists')
                pck = Packet()
                pck.add(Packet.U8, CMD_SERVER_ROOM_UNAVAILABLE)
                self.send(pck)
            else:
                print('[IncomingClient] room created')
                pck = Packet()
                pck.add(Packet.U8, CMD_SERVER_ROOM_CREATED)
                pck.add(Packet.U32, self.server.status_tick)
                self.send(pck)
                room = self.server.roomManager.addRoom(roomName, password, leaderPassword)
                p = Player(self.server, True, playerName, room)
                self.connection.setClient(p)

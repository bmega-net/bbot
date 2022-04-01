from Packet import *
from Protocol import *


class Room:
    def __init__(self, roomManager, name, playerPassword, leaderPassword):
        print('[Room] %s pw: %s lpw: %s' % (name, playerPassword, leaderPassword))
        self.name = name
        self.password = playerPassword
        self.leaderPassword = leaderPassword
        self.roomManager = roomManager
        self.players = []

    def removePlayer(self, player):
        print('[Room] %s player left %s' % (self.name, player.name))
        self.players.remove(player)
        pck = Packet()
        pck.add(Packet.U8, CMD_SERVER_REMOVE)
        pck.add(Packet.STR16, player.name)
        self.broadcast(player, pck)

    def addPlayer(self, player):
        print('[Room] %s player entered %s' % (self.name, player.name))
        self.players.append(player)
        pck = Packet()
        pck.add(Packet.U8, CMD_SERVER_ADD)
        pck.add(Packet.STR16, player.name)
        pck.add(Packet.U8, 1 if player.leader else 0)
        self.broadcast(player, pck)

    def broadcast(self, player, packet):
        for p in self.players:
            if p != player:
                p.connection.send(packet)

    def removeSock(self, sock):
        for p in self.players:
            if p.connection.sock == sock:
                self.removePlayer(p)
                break

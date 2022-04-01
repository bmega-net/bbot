import re
from Room import Room

class RoomManager:
    def __init__(self):
        self.rooms = {}

    @staticmethod
    def validName(name):
        return re.match(r"^([\w\d ]+)$", name)

    def getRoom(self, name):
        if name in self.rooms:
            return self.rooms[name]
        return None

    def addRoom(self, name, playerPassword, leaderPassword):
        r = Room(self, name, playerPassword, leaderPassword)
        self.rooms[name] = r
        return r

    def removeSock(self, sock):
        for r in self.rooms:
            self.rooms[r].removeSock(sock)

    def broadcastData(self):
        values = {}
        n = 0
        values['server_rooms'] = len(self.rooms)
        for r in self.rooms:
            values['room_name_%d' % n] = self.rooms[r].name
            values['room_players_%d' % n] = len(self.rooms[r].players)
            n += 1
        return values

    def clearRooms(self):
        for r in self.rooms:
            if not self.rooms[r].players:
                print('[Room Manager] removing empty room %s' % r);
                del self.rooms[r]
                break

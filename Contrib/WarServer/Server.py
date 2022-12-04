import time
import socket
import select
import traceback
import urllib.parse
import urllib.request
import threading
from IncomingClient import IncomingClient
from Connection import Connection
from RoomManager import RoomManager

SERVER_PACKET_TIMEOUT = 0.2
AUTO_BROADCAST_EVERY = 15
SERVER_BACKLOG = 3


def SendBroadcast(values):
    try:
        print('[Broadcast] sending...')
        url = 'http://bbot.bmega.net/bbotwar.html'
        data = urllib.parse.urlencode(values).encode('ascii')
        req = urllib.request.Request(url, data)
        urllib.request.urlopen(req)
        print('[Broadcast] sent')
    except Exception as msg:
        print('[Broadcast] error(%s)' % msg)


class Server:
    def __init__(self, name, ip, port, status_tick):
        self.name = name
        self.ip = ip
        self.port = port
        self.status_tick = status_tick
        self.connections = {}
        self.lastBroadcast = 0
        self.roomManager = RoomManager()
        try:
            self.listenSock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.listenSock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.listenSock.bind((self.ip, self.port))
            self.listenSock.listen(SERVER_BACKLOG)
        except socket.error as msg:
            print('Creating listen socket: ', msg)
            traceback.print_exc()
        self.sockets = [self.listenSock]

    def Run(self):
        try:
            while 1:
                self.clearConnections()
                self.roomManager.clearRooms()
                self.processSockets()
                self.autoBroadcast()
        except Exception as msg:
            traceback.print_exc()

    def autoBroadcast(self):
        if time.time() - self.lastBroadcast > AUTO_BROADCAST_EVERY:
            self.lastBroadcast = time.time()
            self.broadcastServer()


    def broadcastServer(self):
        print('[Server] broadcast preparation')
        values = self.roomManager.broadcastData()
        values['server_name'] = self.name
        values['server_port'] = self.port
        values['server_players'] = len(self.connections)
        t = threading.Thread(target=SendBroadcast, args=(values, ))
        t.start()

    def processSockets(self):
        rs, ws, es = select.select(self.sockets, [], self.sockets, SERVER_PACKET_TIMEOUT)
        for r in rs:
            if r == self.listenSock:
                self.addSock(self.listenSock.accept())
            else:
                self.connections[r].recv()
        for e in es:
            if (e != self.listenSock) and (e in self.connections):
                self.connections[e].close()

    def clearConnections(self):
        hasDeleted = True
        while hasDeleted:
            hasDeleted = False
            for c in self.connections:
                if self.connections[c].timeout():
                    print('[Server] connection timeout: %s:%d' % self.connections[c].adr)
                    self.connections[c].close()
                    hasDeleted = True
                    break
            for c in self.sockets:
                if c._closed:
                    self.removeSock(c)
                    hasDeleted = True
                    break

    def removeSock(self, sock):
        self.roomManager.removeSock(sock)
        if sock in self.connections:
            del self.connections[sock]
        if sock in self.sockets:
            self.sockets.remove(sock)

    def addSock(self, conn):
        sock, adr = conn
        connection = Connection(self, adr, sock)
        connection.setClient(IncomingClient(self))
        self.connections[sock] = connection
        self.sockets.append(sock)

import struct


def Fletcher16(data):
    sum1 = 0
    sum2 = 0
    for i in data:
        sum1 = (sum1 + i) % 255
        sum2 = (sum2 + sum1) % 255
    return (sum2 << 8) | sum1


class Packet:
    U8 = 'B'
    S8 = 'b'
    U16 = 'H'
    S16 = 'h'
    U32 = 'I'
    S32 = 'i'
    U64 = 'Q'
    S64 = 'q'
    STR16 = 's'
    STR32 = 's'

    def __init__(self, buffer=b''):
        self.buffer = buffer
        self.byteOrder = '='
        self.readPos = 0

    def add(self, kind, value):
        f = self.byteOrder
        if kind == self.STR16 or kind == self.STR32:
            lk = self.U16 if kind == self.STR16 else self.U32
            self.add(lk, len(value))
            f += str(len(value))
            value = value.encode('ascii')
        f = f + kind
        self.buffer = self.buffer + struct.pack(f, value)
        return self

    def addBuffer(self, buffer):
        self.buffer = self.buffer + buffer

    def read(self, kind):
        f = self.byteOrder
        if kind == self.STR16 or kind == self.STR32:
            lk = self.U16 if kind == self.STR16 else self.U32
            l = self.read(lk)
            f += str(l)
        f = f + kind
        value = struct.unpack_from(f, self.buffer, self.readPos)[0]
        if kind == self.U8 or kind == self.S8:
            self.readPos += 1
        elif kind == self.U16 or kind == self.S16:
            self.readPos += 2
        elif kind == self.U32 or kind == self.S32:
            self.readPos += 4
        elif kind == self.U64 or kind == self.S64:
            self.readPos += 4
        elif kind == self.STR16 or kind == self.STR32:
            self.readPos += len(value)
            value = value.decode('ascii')
        return value

    def show(self):
        s = ''
        for x in self.buffer:
            s = "%s%.2X " % (s, x)
        print(s)
        return self

    @staticmethod
    def test():
        wri = Packet().add(Packet.U8, 10).add(Packet.U32, 6546541)
        wri.add(Packet.S32, -4561).add(Packet.STR16, 'AAbbAA')
        wri.show()

        rea = Packet(wri.buffer)
        print(rea.read(Packet.U8))
        print(rea.read(Packet.U32))
        print(rea.read(Packet.S32))
        print(rea.read(Packet.STR16))


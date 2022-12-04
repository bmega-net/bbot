CMD_SERVER_FIRST = 100;
CMD_SERVER_HELLO = CMD_SERVER_FIRST + 1;
CMD_SERVER_REMOVE = CMD_SERVER_HELLO + 1;
# NAME
CMD_SERVER_ADD = CMD_SERVER_REMOVE + 1;
#  NAME
#  ISLEADER
CMD_SERVER_STATUS = CMD_SERVER_ADD + 1;
#  +CMD_PLAYER_STATUS
#  ISLEADER
CMD_SERVER_STATUS_RECEIVED = CMD_SERVER_STATUS + 1;
CMD_SERVER_COMBO_TARGET = CMD_SERVER_STATUS_RECEIVED + 1;
#  +CMD_PLAYER_COMBO_TARGET
CMD_SERVER_COMBO_POS = CMD_SERVER_COMBO_TARGET + 1;
#  +CMD_PLAYER_COMBO_POS
CMD_SERVER_SIGNAL = CMD_SERVER_COMBO_POS + 1;
#	PLAYER ID
#  +CMD_PLAYER_SIGNAL
CMD_SERVER_ROOM_CREATED = CMD_SERVER_SIGNAL + 1;
CMD_SERVER_ROOM_UNAVAILABLE = CMD_SERVER_ROOM_CREATED + 1;
CMD_SERVER_ROOM_JOINED = CMD_SERVER_ROOM_UNAVAILABLE + 1;
#   ISLEADER
CMD_SERVER_ROOM_NOT_FOUND = CMD_SERVER_ROOM_JOINED + 1;
CMD_SERVER_ROOM_WRONG_PASSWORD = CMD_SERVER_ROOM_NOT_FOUND + 1;
CMD_SERVER_ROOM_INVALID_NAME = CMD_SERVER_ROOM_WRONG_PASSWORD + 1;
CMD_SERVER_LAST = CMD_SERVER_ROOM_INVALID_NAME;

CMD_CLIENT_FIRST = 200;
CMD_CLIENT_HELLO = CMD_CLIENT_FIRST + 1;
CMD_CLIENT_ROOM_JOIN = CMD_CLIENT_HELLO + 1;
#  ROOMNAME
#  PLAYERNAME
#  PASSWORD
CMD_CLIENT_ROOM_CREATE = CMD_CLIENT_ROOM_JOIN + 1;
#  ROOMNAME
#  PLAYERNAME
#  PASSWORD
#  LEADERPASSWORD
CMD_CLIENT_STATUS = CMD_CLIENT_ROOM_CREATE + 1;
#	ID
#	NAME
#	HP
#	HPMAX
#	MANA
#	MANAMAX
#	POSITION X
#	POSITION Y
#	POSITION Z
CMD_CLIENT_COMBO_TARGET = CMD_CLIENT_STATUS + 1;
#	COMBO NAME
#	TARGET ID
CMD_CLIENT_COMBO_POS = CMD_CLIENT_COMBO_TARGET + 1;
#	COMBO NAME
#	POSITION X
#	POSITION Y
#	POSITION Z
#   ISVERTICAL
CMD_CLIENT_SIGNAL = CMD_CLIENT_COMBO_POS + 1;
#  SIGNAL NAME
#  SIGNAL COLOR
#  SIGNAL DURATION
#	POSITION X
#	POSITION Y
#	POSITION Z
CMD_CLIENT_LAST = CMD_CLIENT_SIGNAL;

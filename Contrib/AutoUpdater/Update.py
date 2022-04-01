import sys
import time
import os
import subprocess
import shutil
import struct
import pdb

def get_version_from_win32_pe(file):
	# http://windowssdk.msdn.microsoft.com/en-us/library/ms646997.aspx
	sig = struct.pack("32s", u"VS_VERSION_INFO".encode("utf-16-le"))
	# This pulls the whole file into memory, so not very feasible for
	# large binaries.
	try:
		filedata = open(file, 'rb').read()
	except IOError:
		return "Unknown"
	offset = filedata.find(sig)
	if offset == -1:
	  return "Unknown"
	filedata = filedata[offset + 32 : offset + 32 + (13*4)]
	version_struct = struct.unpack("13I", filedata)
	ver_ms, ver_ls = version_struct[4], version_struct[5]
	return (ver_ls & 0x0000ffff, (ver_ms & 0xffff0000) >> 16, ver_ms & 0x0000ffff, (ver_ls & 0xffff0000) >> 16)

def insertDataIntoFile(fileName, pattern, replaceWith):
	fileIn = open(fileName, 'r', newline='')
	buffer = fileIn.read()
	fileIn.close()

	buffer = buffer.replace(pattern, replaceWith)

	fileOut = open(fileName, 'w', newline='')
	fileOut.write(buffer)
	fileOut.close()

def insertAddresses(addressesData, versionInt):
	addressesFile = r'..\..\Source\uBBotAddresses.pas'
	pattern = '{ @@NEW_ADDRESSES }'
	addressesOutput = "{$REGION 'Addresses for TibiaVer%s'}\n" % versionInt
	addressesOutput += '  if AdrSelected = TibiaVer%s then\n' % versionInt
	addressesOutput += '  begin\n'
	addressesOutput += addressesData.decode('ascii').replace('\r\n\r\n', '\r\n').replace('\n\n', '\n')
	addressesOutput += '  end;\n'
	addressesOutput += '{$ENDREGION}\n'
	addressesOutput += pattern
	insertDataIntoFile(addressesFile, pattern, addressesOutput)

def insertTibiaVer(version4):
	versionsFile = r'..\..\VERSIONS.inc';
	pattern = '{ @@NEW_TIBIAVER_SUPPORTED }'
	tibiaVerOutput = 'TibiaVer%s, %s' % (version4, pattern)
	insertDataIntoFile(versionsFile, pattern, tibiaVerOutput)

def insertTibiaSupported(versionDot):
	declarationsFile = r'..\..\Source\uTibiaDeclarations.pas';
	pattern = '{ @@NEW_VERSION_SUPPORTED }'
	tibiaSupportedOutput = ", '%s'%s" % (versionDot, pattern)
	insertDataIntoFile(declarationsFile, pattern, tibiaSupportedOutput)

def autoUpdate(filePath):
	print('1. Loading Tibia version from %s' % filePath)
	fileDir, tail = os.path.split(filePath)
	version = get_version_from_win32_pe(filePath)
	prefix = '8N'
	version4 = '%s%d%d%d' % (prefix, version[0], version[1], version[2])
	versionDot = '%s%d.%d%d' % (prefix, version[0], version[1], version[2])
	outputFile = r'..\..\TibiaClients\%s.exe' % version4
	print('Done, version: %s' % versionDot)

	print(r'2. Copying to %s' % outputFile)
	shutil.copyfile(filePath, outputFile)
	print('Done.')

	print('3. Starting Tibia')
	cwd = os.getcwd()
	print(fileDir)
	os.chdir(fileDir)
	subprocess.Popen([filePath], shell=True, stdin=None, stdout=None, stderr=None)
	os.chdir(cwd)
	print('Started.')

	time.sleep(2)

	print('4. Gathering addresses')
	addresses = subprocess.check_output('TibiaLoader.exe')
	print('Done.')

	print('5. Moving TibiaTA.ta13 to right directory')
	shutil.move('TibiaTA.ta13', r'..\..\Tibia TA\Addresses%s.ta13' % versionDot)
	print('Done.')

	print('6. Inserting into BBotAddresses.pas')
	insertAddresses(addresses, version4)
	print('Done.')

	print('7. Inserting TibiaVer into VERSIONS.inc')
	insertTibiaVer(version4)
	print('Done.')

	print('8. Inserting Tibia supported into TibiaDeclarations.pas')
	insertTibiaSupported(versionDot)
	print('Done.')


defaultTibia = r'C:\Program Files (x86)\Tibia\Tibia.exe'
path = defaultTibia
if len(sys.argv) > 1:
	path = sys.argv[1]
autoUpdate(path)

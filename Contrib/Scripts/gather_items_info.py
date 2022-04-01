import urllib.request
import urllib.parse
import re
import pdb
import csv
import time

# Stop validating SSL
import ssl
ssl._create_default_https_context = ssl._create_unverified_context

#pdb.set_trace()

re_textarea = re.compile('<textarea.*?>(.*?)</textarea>', re.DOTALL | re.MULTILINE);
re_weight = re.compile('^\|\s+weight\s+=\s+([\d\. ]+)$', re.MULTILINE)
re_price = re.compile('^\|\s+npcprice\s+=\s+([\d\. ]+)$', re.MULTILINE)
re_value = re.compile('^\|\s+npcvalue\s+=\s+([\d\. ]+)$', re.MULTILINE)

def getItemData(html):
	match = re_textarea.search(html)
	if match:
		return match.group(1)
	else:
		return ''

def getItemHtml(itemname):
	itemname = itemname.title().replace(' ', '_').replace('_Of_', '_of_').replace('_The_', '_the_')
	url = 'https://tibiawiki.com.br/index.php?action=edit&title=' + urllib.parse.quote(itemname)
	headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64)'}
	req = urllib.request.Request(url, headers=headers)
	with urllib.request.urlopen(req) as response:
		html = response.read().decode('utf-8')
		time.sleep(0.2)
		return html

def getItemWeight(data):
	match = re_weight.search(data)
	if match:
		return match.group(1).replace('.', '').replace(' ', '')
	else:
		return '-'

def getItemPrice(data):
	match = re_price.search(data)
	if match:
		return match.group(1).replace('.', '').replace(' ', '')
	else:
		return '0'

def getItemValue(data):
	match = re_value.search(data)
	if match:
		return match.group(1).replace('.', '').replace(' ', '')
	else:
		return '0'

def loadItem(id, flags, name, outFile):
	if name == 'unknown':
		outFile.write('%s,%s,%s,%s,%s,%s\n' % (id, flags, 0, 0, 0, ''))
	else:
		itemData = getItemData(getItemHtml(name))
		weight = getItemWeight(itemData)
		if itemData != '' and weight != '-':
			price = getItemPrice(itemData)
			value = getItemValue(itemData)
			outFile.write('%s,%s,%s,%s,%s,%s\n' % (id, flags, weight, price, value, name))
		else:
			outFile.write('%s,%s,%s,%s,%s,%s\n' % (id, flags, '???', '???', '???', name))

outf = open('OutProperties.txt', 'w')
inf = open('Properties.txt', 'r')
infCvs = csv.reader(inf)
for row in infCvs:
	id = row[0]
	flags = row[1]
	name = row[2]
	print('Loading %s with name %s (%s)' % (id, name, flags))
	loadItem(id, flags, name, outf)
	
inf.close()
outf.close()

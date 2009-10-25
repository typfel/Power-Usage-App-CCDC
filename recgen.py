#!/usr/bin/python

from datetime import datetime, timedelta
from random import randint
from plistlib import *

six_months_ago =  datetime.today() - timedelta(weeks=24)
one_week = timedelta(weeks=1)

meterValue = 0
timestamp = six_months_ago
recordings = []

while (timestamp < datetime.today()):
	meterValue = meterValue + randint(300, 600)
	recordings.append(dict(meterValue=meterValue, timestamp=timestamp))
	timestamp += one_week
	
print(writePlistToString(recordings))







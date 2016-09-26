import autofocus
import os
import sys
import libtiff

varlist_array = []

for dirname in os.listdir(sys.argv[1]):
	fullpath = sys.argv[1]+"/"+dirname
	if os.path.isdir(fullpath):
		print dirname
		autofocus.produceError(fullpath)


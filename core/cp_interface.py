import os
import csv
import subprocess
import re

def callCellProfiler(pipeline, inputDir, outputDir):
	#Call CellProfiler with a pipleline to determine best autofocus-slice
	print "Call: "
	cellprofilerarg = "-p "+pipeline+" -c -i "+inputDir+" -o "+outputDir
	print cellprofilerarg
	p = subprocess.Popen(["cellprofiler", cellprofilerarg])
	
	#Enable user to either wait for cell-profiler to respond (and fill variable 'p')
	# or to kill process via 'CTRL-Z'
	try:
		p.wait()
	except KeyboardInterrupt:
		p.kill()
		raise

	return


#Extract a column specified by a column name from csv file
def getColumnFromCSV(fname,columnName):
	fp = open(fname, 'rb')
	resultsReader = csv.reader(fp, delimiter=',')
	header = resultsReader.next()
	print header
	index = header.index(columnName)
	print "Column index: " + str(index)
	rows = []
	for idx,row in enumerate(resultsReader,start=1):
		rows.append(row[index])
	fp.close()

	return rows

def getAllColumnsFromCSV(fname):
	fp = open(fname, 'rb')
	resultsReader = csv.reader(fp, delimiter=',')
	header = resultsReader.next()
	rows = []
	for idx,row in enumerate(resultsReader,start=1):
		rows.append(row)
	fp.close()

	return header,rows

# change the input file of a cellprofiler pipeline
# the input string inputfiles can be a regular expression
def setInputFiles(inpipeline,outpipeline,inputfiles):
	fp = open(inpipeline, 'r')
	contents = fp.read()
	fp.close()
	newcontents = re.sub("Text that these images have in common \(case-sensitive\):(.*)","Text that these images have in common (case-sensitive):"+inputfiles,contents)
	fp = open(outpipeline, "w")
	fp.write(newcontents)
	fp.close
	return


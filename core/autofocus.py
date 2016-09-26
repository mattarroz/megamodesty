#-------------------------------------------------------------------------
# DESCRIPTION:
#	This function records several images at a given position at given 
#	microscope-parameters upon which the software 'CellProfiler' is
#	evoked to calculate the slice with the best focus. A gaussian fit
#	is used to interpolate the best focus and the best fit is returned.
#-------------------------------------------------------------------------


#from libtiff import TIFFfile, TIFFimage
import libtiff
import matplotlib.cm as cm
from scipy import ndimage
import numpy
import fnmatch
import sobel
import os
import csv
import posmax
import subprocess
import cp_interface


#from scipy import *
#from pylab import *
from scipy import optimize
from scipy import exp
from pylab import plot
from pylab import show
from pylab import imshow
from pylab import linspace

#the parameter directory is a folder with subfolders corresponding to 
# one z-stack of images
# Version that uses cellProfiler, very slow
def FindBestFocusSliceCellProfiler(directory, stepsize):
	if not os.path.exists(directory):
		print "Directory not Found!"
		raise
		return
	pipeline = '/home/matze/megamodesty/core/autofocus.cp'
	inputDir = directory
	outputDir = inputDir
	#Call CellProfiler with a pipleline to determine best autofocus-slice
	cp_interface.callCellProfiler(pipeline, inputDir, outputDir)

	#Read in CellProfiler-output from file specified in CellProfilerPipeline	
	varlist_str = cp_interface.getColumnFromCSV(directory+"/normvar.csv",'Math_Normalized Variance')
	#Convert from String to Float
	varlist = []
	for row in varlist_str:
		varlist.append(float(row))

	#Get best autofocus-slice
	maxvar = max(varlist)
	maxvar_index = posmax.posmax_nopsy(varlist)
	print "Maximal normalized variance: "
	print str(maxvar) + ' Slice: ' + str(maxvar_index)

	#Fit results to a gaussian function in order to get a more precise result
	plotGraph = False
	p1 = fitGaussian(varlist, maxvar, maxvar_index, stepsize, plotGraph)

	# Sanity check for fit, we should not return values far (more than 5) outside the measured range
	outside = 5
	if p1[0]>(len(varlist)-1+outside) or p1[0] < -outside:
		print "Sanity check for fit failed. Returning index of maximum variance."
		return maxvar_index

	return p1[0] #maxvar_index


#the parameter directory is a folder with subfolders corresponding to 
# one z-stack of images
# version that uses own implementation getNormVariance()
def FindBestFocusSlice(directory, stepsize):
	if not os.path.exists(directory):
		print "Directory "+directory+" not Found!"
		raise
		return


	filelist = os.listdir(directory)
	#print filelist
	filelist.sort() #max(filelist, key=lambda x: os.stat(x).st_mtime)
	varlist = []
	f = open(directory+"/normvar.csv","w")
	csvFile = csv.writer(f)
	for fname in filelist:
  		if fnmatch.fnmatch(fname, '*.tif'):
	 		normvar = getNormVariance(directory+"/"+fname) 
			varlist.append(normvar)
			csvFile.writerow([fname,normvar])
	f.close()

	#Get best autofocus-slice
	maxvar = max(varlist)
	maxvar_index = posmax.posmax_nopsy(varlist)
	print "Maximal normalized variance: "
	print str(maxvar) + ' Slice: ' + str(maxvar_index)

	#Fit results to a gaussian function in order to get a more precise result
	plotGraph = False
	p1 = fitGaussian(varlist, maxvar, maxvar_index, stepsize, plotGraph)

	# Sanity check for fit, we should not return values far (more than 5) outside the measured range
	outside = 5
	if p1[0]>(len(varlist)-1+outside) or p1[0] < -outside:
		print "Sanity check for fit failed. Returning index of maximum variance."
		return maxvar_index
	
	return p1[0] #maxvar_index




def fitGaussian(varlist, maxvar, maxvar_index, stepsize, plotGraph):
	#Fit results to a gaussian function in order to get a more precise result
	print "Fitting..."
	fitfunc = lambda p, x: p[3]*exp(-(p[0]-x)**2/(2*p[1]**2))+p[2] # Target function
	errfunc = lambda p, x, y: fitfunc(p, x) - y # Distance to the target function
	p0 = [float(maxvar_index),1.0,varlist[0],maxvar]
	x_func = linspace(0, len(varlist)-1, len(varlist)*100)
	x_data = linspace(0, len(varlist)-1, len(varlist))
	x_stddev = int(round(1.25/stepsize))
	x_fitmin = max(maxvar_index-x_stddev,0)
	x_fitmax = min(maxvar_index+x_stddev,len(varlist)-1)
	print "x_fitmin: " + str(x_fitmin) + " x_fitmax: " + str(x_fitmax)
	try:
		p1, success = optimize.leastsq(errfunc, p0[:],args=(x_data[x_fitmin:x_fitmax],varlist[x_fitmin:x_fitmax]))
		print p1
	except:
		print "Fit Failed."

	if plotGraph:
		funcplot = plot(x_func,fitfunc(p1,x_func))
		print str(len(x_data)) + ' ' + str(len(varlist))
		dataplot = plot(x_data,varlist, "r.")
		#show()

	return p1



def getNewestImagesInDirectory(directory):
	filelist = os.listdir(directory)
	#print filelist
	filelist = filter(lambda x: os.path.isdir(directory+x), filelist)
	filelist.sort() #max(filelist, key=lambda x: os.stat(x).st_mtime)
	#print filelist
	newest = filelist[len(filelist)-1]
	print "Newest autofocus images: " + newest

	return newest+"/"


def getNormVariance(fname):
	tif = libtiff.TIFFfile(fname)
	samples, sample_names = tif.get_samples()

	floatImage = numpy.array(samples[0][0]).astype(float)
	
	#imshow(samples[0][0], cmap=cm.gray)
	edgedImage = sobel.sobel(floatImage)
	#imshow(edgedImage, cmap=cm.gray)
	var = ndimage.variance(edgedImage)
	normvar = var/ndimage.mean(edgedImage)
	
	tif.data._mmap.close()
	tif.close()

	return normvar

def produceError(directory):
	filelist = os.listdir(directory)
	#print filelist
	filelist.sort() #max(filelist, key=lambda x: os.stat(x).st_mtime)
	varlist = []

	f = open(directory+"/normvar.csv","w")
	csvFile = csv.writer(f)
	for fname in filelist:
  		if fnmatch.fnmatch(fname, '*.tif'):
	 		normvar = getNormVariance(directory+"/"+fname) 
			varlist.append(normvar)

			csvFile.writerow([fname,normvar])
	f.close()

	return varlist

class AutoFocusError(Exception):
	def __init__(self, value):
		self.value = value
	def __str__(self):
		return repr(self.value)


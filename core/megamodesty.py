#!/usr/bin/python
# -*- coding: utf-8 -*-

import time
import ntpath
import posixpath
import socket
import pickle
from datetime import date

import sys
import copy

import autofocus

class Setting:
	def __eq__(self, other):
		return self.__dict__ == other.__dict__	

class AcquisitionSetting(Setting):

	def __init__(self,microscope):
		self.microscope = microscope
		
		#Add/differentiate between settings of different microscopes at your lab 
		if self.microscope:
			self.nlaser = 6 # old confocal
		else:
			self.nlaser = 7 # new confocal

		return


# TODO: 
#	- Webfrontend
#	- funktion um beliebige pipelines aufzurufen und auszuwerten 
#			==> wuerde standartisiertes ausgabeformat seitens cellprofiler vorraussetzen
#			==> ist im prinzip durch spalten und zeilen der csv's gegeben
#			==> die oberflaeche muss dann das erstellen von regeln erlauben, die aus messwerten entscheidungen ableiten lassen
#			  *  diese "Entscheidungen" betreffen konkrete Anweisungen zu einer Messung
#			==> Es braeuchte eine Oberflaeche um Messungen zu definieren
#			  * die Messung selbst koennte auch als Klasse definiert sein, beispielweise mit einer Methode Measure()
#			==> Braucht es das alles??? für den moment reicht es auch einfach fix ein python skript zu machen
#			- sollten wir nicht doch die virtual channels nehmen???

# TODO jetzt:
# - es sind noch nicht alle settings die wirklich für die messung gebraucht werden in restore und getSettings
# - was wäre am sinnvollsten ? ==> ich sollte einfach mal ohne vollst. settings den ablauf testen
# - aus execute flim measurement sollten vielleicht die anzahl der frames als argument raus und in settings wandern

class MegaModesty:
	def __init__(self, microscope):
#		self.base_af_path = '/Matthias/FluoView-Automatisierung/AutoFocus-Bilder/autofocus-stack'
#		self.af_directory = '/mnt/biodata' + base_af_path
#		self.af_directory_win = '\\\\biodata\\thbp' + ntpath.normpath(base_af_path)

#		self.base_meas_path = IntilizeMeasurementFolder()
#		self.meas_directory = '/mnt/biodata' + base_meas_path
#		self.meas_directory_win = '\\\\biodata\\thbp' + ntpath.normpath(base_meas_path)

		self.microscope = microscope	#Identification of microscope


		#Connection to microscope
		sys.stdout.write("Connecting to ")
		HOST = '141.20.63.13'	#insert here your microsocpe ip
		sys.stdout.write(str(HOST))
		port_list = [33333,33332] #insert here your microsocpe port (or several ports if you have several microscopes)
		PORT = port_list[self.microscope]
		sys.stdout.write(':'+str(PORT)+'...')
		self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		try:
			self.s.connect((HOST, PORT))
		except:
			raise Exception('could not connect to server. Exiting. :(')

		sys.stdout.write('connected. :)\n')

		self.s.settimeout(1.0)		
		#Class Properties
		#create new instance of settings class
		self.currentsettings = AcquisitionSetting(microscope)

		#fill values with current settings from Olympus Software
		self.getSettings(self.currentsettings)
		self.af_acq_settings = AcquisitionSetting (self.microscope) #
		self.meas_acq_settings = AcquisitionSetting (self.microscope) #Question??? difference to line above?


		return

	def __del__(self):	#called when program is to be closed
		sys.stdout.write("Closing connection...")
		self.executeCommand("Exit")	#MS: Question: what does exactly?
		self.s.close()
		sys.stdout.write("done.\n")
		print "Have a nice day :)"

		return
	
	def quitProgram(self):
		answer = raw_input("Do you really want to quit and close connection ([y]/n)? ")
		if answer[0] == 'n':
			return
		else:
			exit()

		# we should never reach this point
		return

	# in case user needs an advice
	def advice(self):
		advice = "Don't Panic!"

		print advice

		exit(42)

		return


	def executeCommand(self, command):
		#All commands for the microscope to execute are sent via this function
		print "Sending command " + command #feedback for the user
		self.s.sendall(command)	#actually send command to microscope
		sys.stdout.write("Waiting for response")
		retval = None
		
		#allowing to wait until 
		#	a) positive response from microscope, or
		#	b) user kills process via "CTRL-z"
		while not retval:
			try:
				retval = self.s.recv(1024)
			except KeyboardInterrupt:
				self.quitProgram()
			except:	
				sys.stdout.write(".")
	
		sys.stdout.write('Response received. Value: ' + repr(retval) + "\n")
	
		return retval

	def AutoFocusRun(self, fov):
		self.autoFocusGranularity = fov.autoFocusGranularity
		self.autoFocusRange = fov.autoFocusRange
		
		#Ensure that (new/changed) settings are actually updated at the microscope, too!
		self.restoreSettings(self.af_acq_settings,self.currentsettings)
		self.currentsettings = copy.deepcopy(self.af_acq_settings)
		
		try:
			#Command microscope to do a z-Scan with the current parameters (start, end, slices, stepwidht, etc)
			# this is executed only if a autofocus has been called previously such that 'fov.zFocus' exists
			print "Performing autofocus around previous focus z="+str(fov.zFocus)+' um'
			self.executeCommand('Execute_ZScan'
						+';'+str(+self.autoFocusRange+fov.zFocus)
						+';'+str(self.autoFocusGranularity)
						+';'+str(2*self.autoFocusRange/self.autoFocusGranularity+1))
			#get best focus slice from recorded zStack (via calling CellProfiler)

			#Access directory in which autofocus-stacks are saved and determine latest image file
#			newest = autofocus.getNewestImagesInDirectory(self.af_acq_settings.directory_unix)
			retval = autofocus.FindBestFocusSlice(self.af_acq_settings.directory_unix,self.autoFocusGranularity)

			#Move objective of microscope to best focus position
			self.executeCommand('GoToSlice;'+str(round(retval,2)))
			self.bestFocusSlice = retval
			fov.zFocus = -self.autoFocusRange+fov.zFocus + self.autoFocusGranularity * self.bestFocusSlice

		except: # in case there is no fov.zFocus we go here
			#Command microscope to do a z-Scan with the current parameters (start, end, slices, stepwidht, etc)
			# this is executed only if autofocus has NOT been called previously such that 'fov.zFocus' does not yet exist			
			self.executeCommand('Execute_ZScan'
						+';'+str(+self.autoFocusRange)
						+';'+str(self.autoFocusGranularity)
						+';'+str(2*self.autoFocusRange/self.autoFocusGranularity+1))
			#get best focus slice from recorded zStack (via calling CellProfiler)

			#Access directory in which autofocus-stacks are saved and determine latest image file
#			newest = autofocus.getNewestImagesInDirectory(self.af_acq_settings.directory_unix)
			retval = autofocus.FindBestFocusSlice(self.af_acq_settings.directory_unix,self.autoFocusGranularity)
#Move objective of microscope to best focus position	
			self.executeCommand('GoToSlice;'+str(round(retval,2)))
			self.bestFocusSlice = retval
			fov.zFocus = -self.autoFocusRange + self.autoFocusGranularity * self.bestFocusSlice

		fp = open(self.af_acq_settings.directory_unix+"/../focus.csv","a")
#		fp.write("Time,Focus,autoFocusGranularity,autoFocusRange\n")
		fp.write(time.asctime()+","+str(fov.zFocus)+","+str(self.autoFocusGranularity)+","+str(self.autoFocusRange)+"\n")
		fp.close()

		return retval

	def Measurement(self, fov, nimages,fname):
		#Description:
		#	this function performs a FLIM measurement for 'nimages'
		#	at a given 'field of view' (fov)
		#
		# TODO: - currentsettings muss in restore vielleicht schon gesetzt werden
		#       - ich sollte die messungen vielleicht irgendwie schlau benennen

		#Extract parameters from 'field of view' (fov)
		self.meas_acq_settings.scanningarea.PanX = str(fov.PanX)
		self.meas_acq_settings.scanningarea.PanY = str(fov.PanY)
		self.meas_acq_settings.scanningarea.zoom = str(fov.zoom)
		print "Measuring at:"
		print 'X' + self.meas_acq_settings.scanningarea.PanX + ' Y' + self.meas_acq_settings.scanningarea.PanY
		self.meas_acq_settings.zoom = str(fov.zoom) #FIXME: redundant
		
		#Ensure that (new/changed) settings are actually updated at the microscope, too!
		self.restoreSettings(self.meas_acq_settings,self.currentsettings)
		self.currentsettings = copy.deepcopy(self.meas_acq_settings)
		
		#Execute a FLIM Measurement
		self.executeCommand('executeFLIMMeasurement;'+str(nimages)+';'+fname)

		return

	def StackMeasurement(self,fov,stop,stepsize,zslices,fname):
		#Description:
		#	this function performs a FLIM measurement for 'nimages'
		#	at a given 'field of view' (fov)
		#
		# TODO: - currentsettings muss in restore vielleicht schon gesetzt werden
		#       - ich sollte die messungen vielleicht irgendwie schlau benennen

		#FIXME: settings sollten als parameter uebergeben werden
		#Extract parameters from 'field of view' (fov)
		self.meas_acq_settings.scanningarea.PanX = str(fov.PanX)
		self.meas_acq_settings.scanningarea.PanY = str(fov.PanY)
		self.meas_acq_settings.scanningarea.zoom = str(fov.zoom)
		print "Measuring at:"
		print 'X' + self.meas_acq_settings.scanningarea.PanX + ' Y' + self.meas_acq_settings.scanningarea.PanY
		self.meas_acq_settings.zoom = str(fov.zoom) #FIXME: redundant
		
		#Ensure that (new/changed) settings are actually updated at the microscope, too!
		self.restoreSettings(self.meas_acq_settings,self.currentsettings)
		self.currentsettings = self.meas_acq_settings
		
		#Execute a FLIM Measurement
		self.executeCommand('executeStackFLIMMeasurement;'+stop+';'+stepsize+';'+zslices+';'+fname)

		return


	def OlympusMeasurement(self, nimages):
		
		#Ensure that (new/changed) settings are actually updated at the microscope, too!
		self.restoreSettings(self.meas_acq_settings,self.currentsettings)
		self.currentsettings = self.meas_acq_settings
		
		#Execute a FLIM Measurement
		self.executeCommand('Execute_TScan;\"\";'+str(nimages))

		return
	
	def IntilizeMeasurementFolder(self):
		today = date.today()
		d.isoformat()

		# TODO

		return foldername

	# FIXME: sollte ich hier self.currentsettings verwenden anstatt dasselbe Objekt als Parameter zu übergeben?
	def restoreSettings(self, settings, currentsettings):
	# DESCRIPTION:
	#	compares the digital settings ('settings') with the
	# 	current physical settings at the microscope ('currentsettings')
	#	and sets the physical settings according to the digital ones.
	#
	# IMPORTANT: currently, not all setting values available are restored yet!!!!
	# FIXME: extend values to be compared/set
	#
	#
		#FIXME: sollte das ganz weg?
		#		if settings == currentsettings:
		#			print "No settings to change..."
		#
		#			return

		if (settings.directory_win != currentsettings.directory_win) or (settings.hdrecording_state != currentsettings.hdrecording_state):
			self.executeCommand('SetHardDiskRecording;1;'+settings.directory_win)
			#FIXME: redundant wegen set scanningarea, oder nicht?!
			#		if settings.zoom != currentsettings.zoom:
			#			self.executeCommand("SetZoom;"+settings.zoom)
			
			#MS: Question: Indentation?
                if settings.td1 != currentsettings.td1:
                        self.executeCommand('SetTD1;'+settings.td1.state+';'
                                                     +settings.td1.laser+';'
                                                     +settings.td1.group+';'
                                                     +settings.td1.pmtvoltage+';'
                                                     +settings.td1.multi+';'
                                                     +settings.td1.cutoffperc+';'
                                                     +settings.td1.power)

                if settings.ch1 != currentsettings.ch1:
                        self.executeCommand('SetCHS1;'+settings.ch1.state+';'
                                                     +settings.ch1.laser+';'
                                                     +settings.ch1.group+';'
                                                     +settings.ch1.pmtvoltage+';'
                                                     +settings.ch1.multi+';'
                                                     +settings.ch1.cutoffperc+';'
                                                     +settings.ch1.power)
  
		if settings.ch2 != currentsettings.ch2:
                        self.executeCommand('SetCHS2;'+settings.ch2.state+';'
                                                     +settings.ch2.laser+';'
                                                     +settings.ch2.group+';'
                                                     +settings.ch2.pmtvoltage+';'
                                                     +settings.ch2.multi+';'
                                                     +settings.ch2.cutoffperc+';'
                                                     +settings.ch2.power)



#FIXME: funzt net, der check


		#MS: Question: why only on/off-status? Where do we set the power?
		#MR: Good question. => FIXME
		#Set laser on/off for every laser
#		for i in range(0,settings.nlaser):
		#FIXME!
		#	try:
		#		if settings.laserstatus[i] != currentsettings.laserstatus[i]:
		#			self.executeCommand('SetLaser;'+str(i)+';'+str(settings.laserstatus[i]))
		#	except: #MS: Question: why the same with or without exception?
#			self.executeCommand('SetLaser;'+str(i)+';'+str(settings.laserstatus[i]))


		for i,status in enumerate(settings.laserstatus):
			if status != currentsettings.laserstatus[i]:
				self.executeCommand('SetLaser;'+str(i)+';'+str(status))
		
		#Set excitation dichroic mirror if necessary
		if settings.ExcitationDM != currentsettings.ExcitationDM:
			self.executeCommand('SetExcitationDM;'+settings.ExcitationDM)
		#Set emission dichroic mirror 1 if necessary
		if settings.EmissionDM1 != currentsettings.EmissionDM1:
			self.executeCommand('SetEmissionDM1;'+settings.EmissionDM1)
		#Set emission dichroic mirror 2 if necessary
		if settings.EmissionDM2 != currentsettings.EmissionDM2:
			self.executeCommand('SetEmissionDM2;'+settings.EmissionDM2)
		#Set emission dichroic mirror 3 if necessary
		if settings.EmissionDM3 != currentsettings.EmissionDM3:
			self.executeCommand('SetEmissionDM3;'+settings.EmissionDM3)
		#Set PanX, PanY, rotation and zoom of scanning area
#		if settings.scanningarea != currentsettings.scanningarea:
		self.executeCommand('SetScanningArea;'+settings.scanningarea.rotation+';'
								+settings.scanningarea.PanX+';'
								+settings.scanningarea.PanY+';'
								+settings.scanningarea.zoom)
		#Set pixel dwell time (= exposure time)
		if settings.pixeldwelltime != currentsettings.pixeldwelltime:
			self.executeCommand('SetDwellTime;' + settings.pixeldwelltime + ';0')
		#Set pixel-dimensions of image to be recorded
		if settings.imagesize != currentsettings.imagesize:
			self.executeCommand('SetImageSize;'+settings.imagesize)

		#FIXME
#		if (settings.pinholestate != currentsettings.pinholestate) or (settings.pinhole != currentsettings.pinhole):
#			self.executeCommand('SetPinhole;'+settings.pinholestate+';'+settings.pinhole)

		#FIXME
		#if settings.acquisitionmode != currentsettings.acquisitionmode:
		#	self.executeCommand('SetAcuiqisitionMode;'+settings.acquisitionmode.scanWay+';'
		#		+settings.acquisitionmode.scanTypeRegion+';'
		#		+settings.acquisitionmode.dwellTime+';'
		#		+settings.acquisitionmode.stateAutoHV+';'
		#		+settings.acquisitionmode.stateImageAdjust+';'
		#		+settings.acquisitionmode.IA_outward+';'
		#		+settings.acquisitionmode.IA_inward)
		
		#TODO etc.

		#currentsettings = settings
		return


	def getSettings(self, settings):
		#DESCRIPTION:
		#	this function retrieves all (most?) microscope-parameters
		#	Information flow: factual physical settings at microscope ---> digital settings in python
		
		#get zoom
		settings.zoom = self.executeCommand("GetZoom;")
		
	
		#Get information related to hard disk recording and saving paths
		settings.hdrecording_state = self.executeCommand('GetHardDiskRecState;')
		settings.directory_win = self.executeCommand('GetHardDiskRecPath;')
		settings.directory_unix = self.win2unixpath(settings.directory_win)
		print settings.directory_unix
		
		#Get parameters for the excitation dichroic mirror
		settings.ExcitationDM = self.executeCommand('GetExcitationDM;')
		
		#Get parameters for all three emission dichroic mirrors
		settings.EmissionDM1 = self.executeCommand('GetEmissionDM1;')
		settings.EmissionDM2 = self.executeCommand('GetEmissionDM2;')
		settings.EmissionDM3 = self.executeCommand('GetEmissionDM3;')
		
		#Get BrightFieldSettings
		settings.td1 = Setting()	#MS Question: instantiate a new property??? MR: Yes.
		strretarray = self.executeCommand('GetTD1;')
		retarray = strretarray.split(';')	
		settings.td1.state = retarray[0]
		settings.td1.laser = retarray[1]
		settings.td1.group = retarray[2]
		settings.td1.pmtvoltage = retarray[3]
		settings.td1.multi = retarray[4]
		settings.td1.cutoffperc = retarray[5]
		settings.td1.power = retarray[6]

		#Get parameters for channel 1
		settings.ch1 = Setting()
		strretarray = self.executeCommand('GetCHS1;')
		retarray = strretarray.split(';')	
		settings.ch1.state = retarray[0]
		settings.ch1.laser = retarray[1]
		settings.ch1.group = retarray[2]
		settings.ch1.pmtvoltage = retarray[3]
		settings.ch1.multi = retarray[4]
		settings.ch1.cutoffperc = retarray[5]
		settings.ch1.power = retarray[6]
		
		#Get parameters for channel 2
		settings.ch2 = Setting()
		strretarray = self.executeCommand('GetCHS2;')
		retarray = strretarray.split(';')	
		settings.ch2.state = retarray[0]
		settings.ch2.laser = retarray[1]
		settings.ch2.group = retarray[2]
		settings.ch2.pmtvoltage = retarray[3]
		settings.ch2.multi = retarray[4]
		settings.ch2.cutoffperc = retarray[5]
		settings.ch2.power = retarray[6]

		#Get on/off status of every laser in the microscope
		settings.laserstatus = []
		for i in range(0,settings.nlaser):
			settings.laserstatus.append(self.executeCommand('GetLaser;'+str(i)))
		
		#TODO: Get parameters for channel xyz
		
		#Get PanX, PanY, Zoom and Rotation of scanning area
		settings.scanningarea = Setting()
		strretarray = self.executeCommand('GetScanningArea;')
		retarray = strretarray.split(';')
		settings.scanningarea.rotation = retarray[0]
		settings.scanningarea.PanX = retarray[1]
		settings.scanningarea.PanY = retarray[2]
		settings.scanningarea.zoom = retarray[3]

		#Get information related to the acquisition mode
		settings.acquisitionmode = Setting()
		strretarray = self.executeCommand('GetAcquisitionMode;')
		retarray = strretarray.split(';')
		settings.acquisitionmode.scanWay = retarray[0]
		settings.acquisitionmode.scanTypeRegion = retarray[1]
		settings.acquisitionmode.dwellTime = retarray[2]
		settings.acquisitionmode.stateAutoHV = retarray[3]
		settings.acquisitionmode.stateImageAdjust = retarray[4]
		settings.acquisitionmode.IA_outward = retarray[5]
		settings.acquisitionmode.IA_inward = retarray[6]
		
		#get pixel dwell time (=exposure time)
		settings.pixeldwelltime = self.executeCommand('GetDwellTime;') #FIXME: redundant: Dopplung der DwellTimeInfo
		
		#get number of pixels each for width and height of images to be recorded
		settings.imagesize = self.executeCommand('GetImageSize;')

		#FIXME
#		retarray = self.executeCommand('GetPinhole;')
#		settings.pinholestate = retarray[0]
#		settings.pinhole  = retarray[1]

		# TODO etc.
		return settings

	def saveSettingsToFile(self,settings,fname):
		#DESCRIPTION:
		#	store settings as a pickle under a specified filename
		
		fileobj = open (fname,'w')
		success = pickle.dump(settings,fileobj)
		fileobj.close()

		return success

	def loadSettingsFromFile(self,fname):
		#DESCRIPTION:
		#	load settings as a pickle from a specified filename
		fileobj = open(fname,'r')
		settings = pickle.load(fileobj)
		fileobj.close()

		return settings

	def win2unixpath(self,path):
		#DESCRIPTION:
		#	convert windows file paths into unix file paths
		buf = path.replace('\\','/')
		# FIXME: es soltle auch molbp in golgo eingehaengt werden
		# FIXME 2: Dat ding is auch noch case-sensitive
		buf = buf.replace('//Biodata/thbp','/mnt/biodata')
		buf = buf.replace('//biodata/thbp','/mnt/biodata')
		return buf


class Cell:
	# hier kommt die zellpos (x,y,z,t) rein
        def __init__(self):
		#x = y = z = t = 0
		return


class FieldOfView:
	# hier kommt Pan, Zoom, z-Pos rein (+ an Stage denken, i.e. stagex, stagey)
        def __init__(self):
		#PanX = PanY = 0
		
		return



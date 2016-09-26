import autofocus
import settings
import megamodesty
import time




m = megamodesty.MegaModesty(1) # 0: new confocal, 1: old confocal


m.af_acq_settings = m.loadSettingsFromFile('/mnt/biodata/Matthias/af_acq_settings.pickle')
m.meas_acq_settings = m.loadSettingsFromFile('/mnt/biodata/Matthias/nb_acq_settings.pickle')

m.currentsettings = megamodesty.AcquisitionSetting(1)
m.getSettings(m.currentsettings)
#m.restoreSettings(m.af_acq_settings,currentsettings)

cellsx = [232.0,0.0]
cellsy = [254.0,-119.0]

#cellsx = [0.0,232.0]
#cellsy = [-119.0,254.0]


m.meas_acq_settings.scanningarea.PanX = str(cellsx[j])
m.meas_acq_settings.scanningarea.PanY = str(cellsy[j])
m.af_acq_settings.scanningarea.PanX =  m.meas_acq_settings.scanningarea.PanX
m.af_acq_settings.scanningarea.PanY =  m.meas_acq_settings.scanningarea.PanY
m.AutoFocusRun()



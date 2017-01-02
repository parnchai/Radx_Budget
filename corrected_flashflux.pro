Pro corrected_flashflux

;STEP A
;A1) Get FLASHFLUX reflected shortwave data
;***************************************************************************************************
;open ceres FLASH file
;Reflected Shortwave

READCOL,'/data/FF/timeseries/Flashflux_glbmean/globe_3A_3B.txt', year, mon, precip, cloud,$
surf_swnt, surf_lwnt, surf_swdn, surf_lwdn, tsi, toa_net, toa_sw, toa_lw, inso
;READCOL,'/data/FF/ELNino2015/STATS/elnino_tsi.txt', year, mon, net,$
;rsw, olr, inso, tsi, water, cloud,FORMAT=F, SKIPLINE = 1
 

;***************************************************************************************************
;A2) Get FLASHFlux mean solar incoming 
;***************************************************************************************************
;open ceres FLASH file
;Solar Insolation

;***************************************************************************************************
;A3) Get SORCE monthly mean solar incoming from 07/2012 - 12/2013
;***************************************************************************************************
;SORCE data + EBAF TSI
;restore, '/data/FF/timeseries/TSI/sorce_tsi_monthly_cstm2015.sav'

;solcon = sorce_tsi_monthly(112:151)
;diff_solar = solcon - tsi
;print, diff_solar
;solcon = sorce_tsi_monthly(118:149) 1/2013 - 8/2015
;print, solcon
;***************************************************************************************************
;A4) Calculate the FLASHFlux Albedo
;***************************************************************************************************
flash_albedo = toa_sw/inso

corrected_flashrsw = flash_albedo * tsi
;corrected_surfswdn = surf_swdn + diff_solar
;**************************************************************************************************'
;B Correcting FlashFlux Net data
;B1) Get FlashFlux monthly mean outgoing longwave
;***************************************************************************************************
;open ceres FLASH file
;Outgoing Longwave

;****************************************************************************************************
;B2) Calculate the corrected FlashFlux monthly mean net
;***************************************************************************************************
corrected_flashnet =tsi-corrected_flashrsw-toa_lw

;***************************************************************************************************
corrected_flashinso = tsi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
time = timegen(40,UNITS="Months", START=JULDAY(7,1,2012))
caldat, time, month, day, year
writecol, '/data/FF/timeseries/corrected_ff_glb2015.txt', year, month, toa_lw, corrected_flashinso, corrected_flashrsw, $
corrected_flashnet
  
;Saving data
save, corrected_flashrsw, corrected_flashnet, corrected_flashinso, filename='/data/FF/timeseries/corrected_flash_AGUglb2015.sav'


;Tropics
;STEP A
;A1) Get FLASHFLUX reflected shortwave data
;***************************************************************************************************
;open ceres FLASH file
;Reflected Shortwave

READCOL,'/data/FF/timeseries/Flashflux_glbmean/tropical_3A_3B.txt', year, mon, precip, cloud,$
surf_swnt, surf_lwnt, surf_swdn, surf_lwdn, tsi, toa_net, toa_sw, toa_lw, inso
;READCOL,'/data/FF/ELNino2015/STATS/elnino_tsi.txt', year, mon, net,$
;rsw, olr, inso, tsi, water, cloud,FORMAT=F, SKIPLINE = 1
 

;***************************************************************************************************
;A2) Get FLASHFlux mean solar incoming 
;***************************************************************************************************
;open ceres FLASH file
;Solar Insolation

;***************************************************************************************************
;A3) Get SORCE monthly mean solar incoming from 07/2012 - 12/2013
;***************************************************************************************************
;SORCE data + EBAF TSI
;restore, '/data/FF/timeseries/TSI/sorce_tsi_monthly_cstm2015.sav'

;solcon = sorce_tsi_monthly(112:151)
;diff_solar = solcon - tsi
;print, diff_solar
;solcon = sorce_tsi_monthly(118:149) 1/2013 - 8/2015
;print, solcon
;***************************************************************************************************
;A4) Calculate the FLASHFlux Albedo
;***************************************************************************************************
flash_albedo = toa_sw/inso

corrected_flashrsw = flash_albedo * tsi
;corrected_surfswdn = surf_swdn + diff_solar
;**************************************************************************************************'
;B Correcting FlashFlux Net data
;B1) Get FlashFlux monthly mean outgoing longwave
;***************************************************************************************************
;open ceres FLASH file
;Outgoing Longwave

;****************************************************************************************************
;B2) Calculate the corrected FlashFlux monthly mean net
;***************************************************************************************************
corrected_flashnet = tsi-corrected_flashrsw-toa_lw

;***************************************************************************************************
corrected_flashinso = tsi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
time = timegen(40,UNITS="Months", START=JULDAY(7,1,2012))
caldat, time, month, day, year
writecol, '/data/FF/timeseries/corrected_ff_cstm2015.txt', year, month, toa_lw, corrected_flashinso, corrected_flashrsw, $
corrected_flashnet
  
;Saving data
save, corrected_flashrsw, corrected_flashnet, corrected_flashinso, filename='/data/FF/timeseries/corrected_flash_AGUtrop2015.sav'

END
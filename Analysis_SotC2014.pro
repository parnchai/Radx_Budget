PRO Analysis_SotC2014

  ;****Code update January 26, 2016 ****
  ;This program produce TOA timeseries and anomaly timeseries using
  ;EBAF data with FLASHFlux as an extension.
  ;The purpose of this program is to determine the differences between EBAF
  ;and FLASHFlux 'estimate'. This code will employ FF V3A data from 8/2013 to
  ;12/2014 and use EBAF data from OG date to 07/2014 and 'extend' EBAF with
  ;offset normalized FF from 8/2014 to 12/2014. The 'extend' period will be
  ;evaluate.

;Step 1) Open CERES data and extract global variables
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.8_Subset_200003-201407.nc')
varid=ncdf_varid(cdfid, 'gtoa_lw_all_mon')
ncdf_varget,cdfid,varid, EBAF_olr
varid2=ncdf_varid(cdfid,'gtoa_sw_all_mon')
ncdf_varget,cdfid,varid2, EBAF_rsw
varid3=ncdf_varid(cdfid,'gsolar_mon')
ncdf_varget,cdfid,varid3, EBAF_tsi
varid4=ncdf_varid(cdfid,'gtoa_net_all_mon')
ncdf_varget,cdfid,varid4, EBAF_net
ncdf_close, cdfid

;Get overlap time frame
;*Ignore*
;As of January 26, 2016 EBAF is at 07/2015. FLASHFlux Version 3B starts on
;August 2014, so we have 12 months of overlap.
;*Ignore*
;The overlap time frame is from 08/2013 to 07/2014
EBAFFLASH_olr = EBAF_olr(161:172)
EBAFFLASH_rsw = EBAF_rsw(161:172)
EBAFFLASH_tsi = EBAF_tsi(161:172)
EBAFFLASH_net = EBAF_net(161:172)

;Step 2) Open FLASHFlux ASCII file that Anne W. produce. The file contains
  ;13 columns: year, mon, precip_h2o, cloud_frac, surf_swnt, surf_lwnt,
  ;surf_swdn, surf_lwdn, tsi, toa_net, toa_sw, toa_lw, inso, where tsi is
  ;coming from SORCE data and inso assumes a constant 1361 Wm-2.

;*note:using older file containing 8 columns: year, mon, toa_net, toa_sw,
;toa_lw, inso, precip, cld_frac
ndata = 30 ;monthly mean data from Aug2013-Dec2014
temp=''

flashdata=fltarr(8,ndata) ;init empty array for reading ASCII data
close,1
openr,1,'/data/FF/timeseries/Flashflux_glbmean/globe_v3Av3B_oblate_mod.txt'
readf,1,temp
readf,1,flashdata
flasholr=flashdata(4,*)
inso=flashdata(5,*)
rsw=flashdata(3,*)
toanet=flashdata(2,*)
flasholr=flasholr(13:29)
inso=inso(13:29)
rsw=rsw(13:29)
toanet=toanet(13:29)
;sorcetsi=flashdata(8,*)
restore, '/data/FF/timeseries/TSI/sorce_tsi_monthly_sotc2014.sav'
sorcetsi=sorce_tsi_sotc2014

;Step 3) Adjust FLASHFlux SW data to replace 1361 Wm-2 assumption with SORCE.

  flash_albedo = rsw/inso ;get the assume albedo value
  flashrsw = flash_albedo * sorcetsi ;This is an adjusted TOA SW.
  flashtoanet = sorcetsi-flashrsw-flasholr ;Adjusted TOA Net.

;Step 4) Offset normalization of FLASHFlux(FF) data to EBAF. SORCE TSI and
  ;EBAF tsi should be close to identical

  diff_olr = EBAFFLASH_olr - flasholr(0:11)
  diff_rsw = EBAFFLASH_rsw - flashrsw(0:11)
  diff_toanet = EBAFFLASH_net - flashtoanet(0:11)
  diff_tsi = EBAFFLASH_tsi - sorcetsi(0:11)
  ;Take the mean of the difference and add it back to FF data,i.e. normalization

  mean_dolr = mean(diff_olr)
  mean_drsw = mean(diff_rsw)
  mean_dtsi = mean(diff_tsi)
  mean_dtoanet = mean(diff_toanet)
  print, 'TSI V3A coeff: ', mean_dtsi
;Note: The mean above is a coefficient for FF V3A
;Need to get offset coefficient for FF V3B restore from Analysis_SotC2015.pro
;and add the mean offset to the corresponding versions.
;First V3A
  norflasholrV3A = flasholr(0:11)+mean_dolr
  norflashrswV3A = flashrsw(0:11)+mean_drsw
  norflashtoanetV3A = flashtoanet(0:11)+mean_dtoanet
  nortsiV3A = sorcetsi(0:11)+mean_dtsi
;Then V3B
restore, filename='/data/FF/timeseries/xnormV3B.sav'
norflasholrV3B = flasholr(12:16)+mean_dolr
norflashrswV3B = flashrsw(12:16)+mean_drsw
norflashtoanetV3B = flashtoanet(12:16)+mean_dtoanet
nortsiV3B = sorcetsi(12:16)+mean_dtsi
print, 'TSI V3B coeff: ', mean_dtsi
;Now put in all back into one vector
norflasholr=[norflasholrV3A,norflasholrV3B]
norflashrsw=[norflashrswV3A,norflashrswV3B]
norflashtoanet=[norflashtoanetV3A,norflashtoanetV3B]
nortsi=[nortsiV3A,nortsiV3B]

;Step 5) Complete time series from 3/2000 - 12/2015
toa_lw = [EBAF_olr,norflasholr(12:16)]
toa_sw = [EBAF_rsw,norflashrsw(12:16)]
mm_tsi = [EBAF_tsi,nortsi(12:16)]
toa_net= [EBAF_net,norflashtoanet(12:16)]
close, 1
;Step addendum - Opening EBAF data that ends in 12/2014 for FF 'estimate'
;evaluation
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.8_Subset_200003-201412.nc')
varid=ncdf_varid(cdfid, 'gtoa_lw_all_mon')
ncdf_varget,cdfid,varid, eval_olr
varid2=ncdf_varid(cdfid,'gtoa_sw_all_mon')
ncdf_varget,cdfid,varid2, eval_rsw
varid3=ncdf_varid(cdfid,'gsolar_mon')
ncdf_varget,cdfid,varid3, eval_tsi
varid4=ncdf_varid(cdfid,'gtoa_net_all_mon')
ncdf_varget,cdfid,varid4, eval_net
ncdf_close, cdfid

;Step 6) Open EBAF Climatology data set.
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.8_Subset_CLIM01-CLIM12.nc')
varid=ncdf_varid(cdfid, 'gtoa_net_all_clim')
ncdf_varget,cdfid,varid, EBAF_netclim

varid=ncdf_varid(cdfid, 'gtoa_lw_all_clim')
ncdf_varget,cdfid,varid, EBAF_olrclim

varid=ncdf_varid(cdfid, 'gtoa_sw_all_clim')
ncdf_varget,cdfid,varid, EBAF_rswclim

varid=ncdf_varid(cdfid, 'gsolar_clim')
ncdf_varget,cdfid,varid, EBAF_solarclim

varid=ncdf_varid(cdfid, 'ctime')
ncdf_varget,cdfid,varid, EBAF_time

ncdf_close, cdfid

ndata = n_elements(toa_lw)
print, 'ndata:', ndata
;Remember that variable above start in MARCH and climatology start in JAN!
;Need to acount for first 10 months
tenolr_clim = EBAF_olrclim(2:11)
tensolar_clim = EBAF_solarclim(2:11)
tenrsw_clim = EBAF_rswclim(2:11)
tennet_clim = EBAF_netclim(2:11)

nyear = (ndata-10)/12 ;The subtract 10 deals with the first 10 months
nyear = fix(nyear)
print, 'years: ', nyear
nn=nyear*12
olrclim_array = cmreplicate(EBAF_olrclim, nyear)
olrclim = reform(olrclim_array, nn)
olr_clim = [tenolr_clim, olrclim]
olr_anom = toa_lw - olr_clim
evalolr_anom = eval_olr - olr_clim

solarclim_array = cmreplicate(EBAF_solarclim,nyear)
solarclim = reform(solarclim_array, nn)
solar_clim = [tensolar_clim, solarclim]
solar_anom = mm_tsi - solar_clim
evalsolar_anom = eval_tsi - solar_clim

rswclim_array = cmreplicate(EBAF_rswclim,nyear)
rswclim = reform(rswclim_array, nn)
rsw_clim = [tenrsw_clim, rswclim]
rsw_anom = toa_sw - rsw_clim
evalrsw_anom = eval_rsw - rsw_clim

netclim_array = cmreplicate(EBAF_netclim,nyear)
netclim = reform(netclim_array, nn)
net_clim = [tennet_clim, netclim]
net_anom = toa_net - net_clim
evalnet_anom = eval_net - net_clim

insol_anom = solar_anom - rsw_anom

;Step 7) Plots, plots, and MORE Plots!!
Device, RETAIN=2
gray='BFBFBF'XL  ; 907F7F
white='FFFFFF'XL
black='000000'XL
red='0000FF'XL
blue='FF0000'XL
green='00611C'XL

time = TIMEGEN(195, UNITS="Months", START=JULDAY(3,1,2000))
time_z = TIMEGEN(185, UNITS="Months", START=JULDAY(3,1,2010))
time_overlap = TIMEGEN(17, UNITS="Months", START=JULDAY(8,1,2013))
time_flash = TIMEGEN(6, UNITS="Months", START=JULDAY(7,1,2014))

!p.multi=[0,1,4,0,1]
zeros = replicate(0, ndata)
Plot, time_z, zeros, ytitle='OLR(w/m^2)', XTICKUNITS = ['Time'],$
 Yrange=[-2.5,2.5],Xrange=[2456000,2457000],color=black, background=white, $
 XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly Anomalies OLR', charsize=2.2, thick=2.0
  ;cgBarplot, mei, color=liteblue, baroffset=0.6, barwidth=0.78, /overplot
 oplot, time, olr_anom, color=red, thick=2.0
 oplot, time_flash, olr_anom(172:177), color=blue, thick=2.0
  oplot, time, evalolr_anom, color=red, thick=2.0, psym=-1

Plot, time_z, zeros, ytitle='RSW(w/m^2)', XTICKUNITS = ['Time'],$
 Yrange=[-2,2],Xrange=[2456000,2457000],color=black, background=white, $
 XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly Anomalies RSW', charsize=2.2, thick=2.0

 oplot, time, rsw_anom, color=red, thick=2.0
  oplot, time_flash, rsw_anom(172:177), color=blue, thick=2.0
  oplot, time, evalrsw_anom, color=red, thick=2.0, psym=-1

Plot, time_z, zeros, ytitle='Incoming Solar(w/m^2)', XTICKUNITS = ['Time'],$
 Yrange=[-2,2],Xrange=[2456000,2457000],color=black, background=white, $
 XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly Anomalies TSI', charsize=2.2, thick=2.0

 oplot, time, solar_anom, color=red, thick=2.0
  oplot, time_flash, solar_anom(172:177), color=blue, thick=2.0
  oplot, time, evalsolar_anom, color=red, thick=2.0, psym=-1

 Plot, time_z, zeros, ytitle='NET(w/m^2)', XTICKUNITS = ['Time'],$
 Yrange=[-2,2],Xrange=[2456000,2457000],color=black, background=white, $
 XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly Anomalies NET', charsize=2.2, thick=2.0

 oplot, time, net_anom, color=red, thick=2.0
  oplot, time_flash, net_anom(172:177), color=blue, thick=2.0
  oplot, time, evalnet_anom, color=red, thick=2.0, psym=-1


 fNamePlotOut='/data/FF/timeseries/SotC2014_4subplot_eval'
  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)

  ;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;Zoom in
!p.multi=[0,1,4,0,1]
zeros = replicate(mean(toa_lw), nn)
Plot, time_z, zeros, ytitle='OLR(w/m^2)', XTICKUNITS = ['Time'],$
Yrange=[200,275],Xrange=[2456000,2457000],color=black, background=white, $
XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly OLR', charsize=1.5, thick=2.0

oplot, time, EBAF_olr, color=red, thick=2.0
oplot, time_overlap, norflasholr, color=blue, thick=2.0
oplot, time, eval_olr, color=red, thick=2.0, psym=-1

zeros = replicate(mean(toa_sw), nn)
Plot, time_z, zeros, ytitle='RSW(w/m^2)', XTICKUNITS = ['Time'],$
Yrange=[0,200],Xrange=[2456000,2457000],color=black, background=white, $
XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly RSW', charsize=1.5, thick=2.0

oplot, time, EBAF_rsw, color=red, thick=2.0
oplot, time_overlap,norflashrsw, color=blue, thick=2.0
oplot, time, eval_rsw, color=red, thick=2.0, psym=-1

zeros = replicate(mean(mm_tsi), nn)
Plot, time_z, zeros, ytitle='TSI(w/m^2)', XTICKUNITS = ['Time'],$
Yrange=[320,360],Xrange=[2456000,2457000],color=black, background=white, $
XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly TSI', charsize=1.5, thick=2.0

oplot, time, EBAF_tsi, color=red, thick=2.0
oplot, time_overlap, sorcetsi, color=blue, thick=2.0
oplot, time, eval_tsi, color=red, thick=2.0, psym=-1

zeros = replicate(mean(toa_net), nn)
Plot, time_z, zeros, ytitle='NET(w/m^2)', XTICKUNITS = ['Time'],$
Yrange=[-12,12],Xrange=[2456000,2457000],color=black, background=white, $
XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly NET', charsize=1.5, thick=2.0

oplot, time, EBAF_net, color=red, thick=2.0
oplot, time_overlap, norflashtoanet, color=blue, thick=2.0
oplot, time, eval_net, color=red, thick=2.0, psym=-1

fNamePlotOut='/data/FF/timeseries/SotC2014_eval'
image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;Plot the differences in the overlap timeframe
!p.multi=[0,1,3,0,1]
zeros=replicate(0,17)
Plot, time_overlap, zeros, ytitle='OLR(w/m^2)', XTICKUNITS = ['Time'],$
Yrange=[-1,1],Xrange=[2456500,2456850],color=black, background=white, $
XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of (EBAF-FF) OLR', charsize=2.2, thick=2.0
oplot, time_overlap, diff_olr-mean(diff_olr), color=red, thick=2.0
zeros=replicate(0,17)
Plot, time_overlap, zeros, ytitle='RSW(w/m^2)', XTICKUNITS = ['Time'],$
Yrange=[-1,1],Xrange=[2456500,2456850],color=black, background=white, $
XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of (EBAF-FF) RSW', charsize=2.2, thick=2.0
oplot, time_overlap, diff_rsw-mean(diff_rsw), color=red, thick=2.0
zeros=replicate(0,17)
Plot, time_overlap, zeros, ytitle='NET(w/m^2)', XTICKUNITS = ['Time'],$
Yrange=[-1,1],Xrange=[2456500,2456850],color=black, background=white, $
XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of (EBAF-FF) NET', charsize=2.2, thick=2.0
oplot, time_overlap, diff_toanet-mean(diff_toanet), color=red, thick=2.0

fNamePlotOut='/data/FF/timeseries/SotC2014_overlap_meanremove'
image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)

;Step 8)Evaluate the differences of FF 'estimate' with EBAF.

 est_dolr = eval_olr(173:177) - norflasholr(12:16)
 est_dolr_anom = evalolr_anom(173:177) - olr_anom(173:177)

 est_drsw = eval_rsw(173:177) - norflashrsw(12:16)
 est_drsw_anom = evalrsw_anom(173:177) - rsw_anom(173:177)

 est_dnet = eval_net(173:177) - norflashtoanet(12:16)
 est_dnet_anom = evalnet_anom(173:177) - net_anom(173:177)

 est_dsolar = eval_tsi(173:177) - nortsi(12:16)
 est_dsolar_anom = evalsolar_anom(173:177) - solar_anom(173:177)
 Print, '    , mean Diff_abs, mean Diff_anoms, max, min'
 Print, 'OLR: ', mean(est_dolr), mean(est_dolr_anom), max(abs(est_dolr_anom)), $
 min(abs(est_dolr_anom))
 Print, 'TSI: ', mean(est_dsolar), mean(est_dsolar_anom), max(abs(est_dsolar_anom)), $
 min(abs(est_dsolar_anom))
 Print, 'RSW: ', mean(est_drsw), mean(est_drsw_anom), max(abs(est_drsw_anom)), $
 min(abs(est_drsw_anom))
 Print, 'Net: ', mean(est_dnet), mean(est_dnet_anom), max(abs(est_dnet_anom)), $
 min(abs(est_dnet_anom))


END

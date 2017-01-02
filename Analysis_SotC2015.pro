PRO Analysis_SotC2015

  ;****Code update January 26, 2016 ****
  ;This program produce TOA timeseries and anomaly timeseries using
  ;EBAF data with FLASHFlux as an extension.
  ;Will now only use Version 3B of FLASHFlux data as overlap with EBAF
  mei = [-1.045, -.711, -.432, .052, .739, .936, 1.168, .575, .278, .112, .176, .041, $
  .041,-.173, -.181, .002, .116, -.181, -.373, -.586, -.175, .102, -.08, -.3, $
  -.312, -.258, .012, .193, .967, .997, .923, .858, .5, .36, .712, .578, $
  .406, .468, .65, .953, 1.567, 2.06, 1.972, 2.367, 2.527, 2.225, 2.308, 2.123,2.202,2.121,$
  1.96,2.07,1.699,1.001,0.312,0.175,-0.101,-0.379]
;Step 1) Open CERES data and extract variables
;cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.8_Subset_200003-201603.nc')
;varid=ncdf_varid(cdfid, 'gtoa_lw_all_mon')
;ncdf_varget,cdfid,varid, EBAF_olr
;varid2=ncdf_varid(cdfid,'gtoa_sw_all_mon')
;ncdf_varget,cdfid,varid2, EBAF_rsw
;varid3=ncdf_varid(cdfid,'gsolar_mon')
;ncdf_varget,cdfid,varid3, EBAF_tsi
;varid4=ncdf_varid(cdfid,'gtoa_net_all_mon')
;ncdf_varget,cdfid,varid4, EBAF_net
;ncdf_close, cdfid
;Uncomment below For Tropics
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.8_Tropics_200003-201603.nc')
varid=ncdf_varid(cdfid, 'toa_lw_all_mon')
ncdf_varget,cdfid,varid, EBAF_olr
varid2=ncdf_varid(cdfid, 'toa_sw_all_mon')
ncdf_varget,cdfid,varid2, EBAF_rsw
varid3=ncdf_varid(cdfid,'solar_mon')
ncdf_varget,cdfid,varid3, EBAF_tsi
varid4=ncdf_varid(cdfid,'toa_net_all_mon')
ncdf_varget,cdfid,varid4, EBAF_net
ncdf_close, cdfid
trop_olr = average(EBAF_olr,1) ;Average over longitude, then
EBAF_olr = average(trop_olr,1) ; average over latitude. EBAF_olr should now be 1-d over time
trop_rsw = average(EBAF_rsw,1) ;Average over longitude, then
EBAF_rsw = average(trop_rsw,1) ; average over latitude. EBAF_olr should now be 1-d over time
trop_tsi = average(EBAF_tsi,1) ;Average over longitude, then
EBAF_tsi = average(trop_tsi,1) ; average over latitude. EBAF_olr should now be 1-d over time
trop_net = average(EBAF_net,1) ;Average over longitude, then
EBAF_net = average(trop_net,1) ; average over latitude. EBAF_olr should now be 1-d over time


;Get overlap time frame
;As of July 1st, 2016 EBAF is at 3/2016. FLASHFlux Version 2G starts on
;January 2009, so we have 87 months of overlap.
EBAFFLASH_olr = EBAF_olr(106:189)
EBAFFLASH_rsw = EBAF_rsw(106:189)
EBAFFLASH_tsi = EBAF_tsi(106:189)
EBAFFLASH_net = EBAF_net(106:189)
;check array size
help, EBAFFLASH_olr
;Step 2) Open FLASHFlux ASCII file that Anne W. produce. The file contains
  ;13 columns: year, mon, precip_h2o, cloud_frac, surf_swnt, surf_lwnt,
  ;surf_swdn, surf_lwdn, tsi, toa_net, toa_sw, toa_lw, inso, where tsi is
  ;coming from SORCE data and inso assumes a constant 1361 Wm-2.

;ndata = 17 ;monthly mean data from Aug2014-Dec2015
;temp=''

;flashdata=fltarr(13,ndata) ;init empty array for reading ASCII data
;close,1
;openr,1,'/data/FF/timeseries/Flashflux_glbmean/globe_3B_oblatetrop.txt'
;readf,1,temp
;readf,1,flashdata
;flasholr=flashdata(11,*)
;inso=flashdata(12,*)
;flashrsw=flashdata(10,*)
;toanet=flashdata(9,*)
;sorcetsi=flashdata(8,*)
;restore, '/data/FF/timeseries/TSI/sorce_tsi_monthly_sotc2015.sav'
;sorcetsi=sorce_tsi_sotc2015
restore, '/data/FF/AMS-SatMet/Reconstruct_tropics_Oct2016.sav'
flasholr = flasholr
flashrsw = flashrsw
sorcetsi = flashtsi
help, sorcetsi
;Step 3) Adjust FLASHFlux SW data to replace 1361 Wm-2 assumption with SORCE.

  ;flash_albedo = rsw/inso ;get the assume albedo value
  flash_albedo = flashalbedo
  flashrsw = flash_albedo * sorcetsi ;This is an adjusted TOA SW.
  flashtoanet = sorcetsi-flashrsw-flasholr ;Adjusted TOA Net.

;Step 4) Offset normalization (debiased) of FLASHFlux(FF) data to EBAF. SORCE TSI and
  ;EBAF tsi should be close to identical

  diff_olr = EBAFFLASH_olr - flasholr(0:83)
  diff_rsw = EBAFFLASH_rsw - flashrsw(0:83)
  diff_tsi = EBAFFLASH_tsi - sorcetsi(0:83)

  mean_dolr = mean(diff_olr)
  mean_drsw = mean(diff_rsw)
  mean_dtsi = mean(diff_tsi)
;*****
  norflasholr = flasholr+mean_dolr
  norflashrsw = flashrsw+mean_drsw
  nortsi = sorcetsi+mean_dtsi
;norflashtoanet = nortsi - norflashrsw - norflasholr
;******
;step4a) Removal of linear trend
ndiff = n_elements(diff_olr)
day = indgen(ndiff)+1
resultolr = linfit(day,diff_olr, sigma=osigma)
resultrsw = linfit(day,diff_rsw, sigma=rsigma)
resulttsi = linfit(day,diff_tsi, sigma=tsigma)

print, '   Intercept,   Slope'
print, 'OLR: ', resultolr
print, 'RSW: ', resultrsw
print, 'TSI: ', resulttsi

;Linear fitted FF
day=indgen(ndiff+10)+1 ;ndiff+[the rest of FF]
linolr = resultolr[1]*day + resultolr[0]
linrsw = resultrsw[1]*day + resultrsw[0]
lintsi = resulttsi[1]*day + resulttsi[0]

linflasholr = norflasholr+linolr
linflashrsw = norflashrsw+linrsw
linflashtsi = nortsi+lintsi
help, linflasholr
;Step4b) Determine FF residual and determine monthly mean residual
FFresolr = EBAFFLASH_olr - linflasholr(0:83)
FFresrsw = EBAFFLASH_rsw - linflashrsw(0:83)
FFrestsi = EBAFFLASH_tsi - linflashtsi(0:83)

resolr = fltarr(12)
resrsw = fltarr(12)
restsi = fltarr(12)
for j =0,11 do begin
    resolr(j) = [FFresolr(j)+FFresolr(j+12)+FFresolr(j+24)+FFresolr(j+36)+FFresolr(j+48)+FFresolr(j+60)]/6
    resrsw(j) = [FFresrsw(j)+FFresrsw(j+12)+FFresrsw(j+24)+FFresrsw(j+36)+FFresrsw(j+48)+FFresrsw(j+60)]/6
    restsi(j) = [FFrestsi(j)+FFrestsi(j+12)+FFrestsi(j+24)+FFrestsi(j+36)+FFrestsi(j+48)+FFrestsi(j+60)]/6
    print, j
endfor
print, 'olr residual: ', resolr
print, 'rsw residual: ', resrsw
print, 'tsi residual: ', restsi
; add residual to linear fitted
resolr_array = cmreplicate(resolr, 7)
resolr = reform(resolr_array, 84)
resolr = [resolr,resolr(0:10)] ;++add in jan to sep
norflasholr = linflasholr + resolr
help, linflasholr
help, norflasholr
resrsw_array = cmreplicate(resrsw, 7)
resrsw = reform(resrsw_array, 84)
resrsw = [resrsw,resrsw[0:10]]
norflashrsw = linflashrsw + resrsw
restsi_array = cmreplicate(restsi, 7)
restsi = reform(restsi_array, 84)
restsi=[restsi,restsi[0:10]]
norflashtsi = linflashtsi + restsi
norflashtoanet = norflashtsi - norflashrsw - norflasholr
;Step 5) Complete time series from 3/2000 - 9/2016
help, EBAF_olr
toa_lw = [EBAF_olr(0:190),norflasholr(85:93)]
toa_sw = [EBAF_rsw(0:190),norflashrsw(85:93)]
mm_tsi = [EBAF_tsi(0:190),norflashtsi(85:93)]
toa_net= [EBAF_net(0:190),norflashtoanet(85:93)]
help, toa_lw
close, 1

;Step 6) Open EBAF Climatology data set.
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.8_Tropics_CLIM01-CLIM12.nc')
;For Tropics
varid=ncdf_varid(cdfid, 'toa_lw_all_clim')
ncdf_varget,cdfid,varid, EBAF_olrclim
trop_clim = average(EBAF_olrclim,1) ; avergae over longitude, then
EBAF_olrclim = average(trop_clim,1) ; average over lats.

varid=ncdf_varid(cdfid, 'toa_sw_all_clim')
ncdf_varget,cdfid,varid, EBAF_rswclim
troprsw_clim = average(EBAF_rswclim,1) ; avergae over longitude, then
EBAF_rswclim = average(troprsw_clim,1) ; average over lats.

varid=ncdf_varid(cdfid, 'toa_net_all_clim')
ncdf_varget,cdfid,varid, EBAF_netclim
tropnet_clim = average(EBAF_netclim,1) ; avergae over longitude, then
EBAF_netclim = average(tropnet_clim,1) ; average over lats.

varid=ncdf_varid(cdfid, 'solar_clim')
ncdf_varget,cdfid,varid, EBAF_solarclim
tropsolar_clim = average(EBAF_solarclim,1) ; avergae over longitude, then
EBAF_solarclim = average(tropsolar_clim,1) ; average over lats.

varid=ncdf_varid(cdfid, 'ctime')
ncdf_varget,cdfid,varid, EBAF_time

ncdf_close, cdfid
;Uncomment below for Global
;varid=ncdf_varid(cdfid, 'gtoa_net_all_clim')
;ncdf_varget,cdfid,varid, EBAF_netclim

;varid=ncdf_varid(cdfid, 'gtoa_lw_all_clim')
;ncdf_varget,cdfid,varid, EBAF_olrclim

;varid=ncdf_varid(cdfid, 'gtoa_sw_all_clim')
;ncdf_varget,cdfid,varid, EBAF_rswclim

;varid=ncdf_varid(cdfid, 'gsolar_clim')
;ncdf_varget,cdfid,varid, EBAF_solarclim

;varid=ncdf_varid(cdfid, 'ctime')
;ncdf_varget,cdfid,varid, EBAF_time

;ncdf_close, cdfid

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
olr_clim = [tenolr_clim, olrclim,EBAF_olrclim(0:10)] ;+++add in from Jan to Oct
olr_anom = toa_lw - olr_clim
help, olr_clim
print, 'olr anomaly: ', olr_anom(0:10)
solarclim_array = cmreplicate(EBAF_solarclim,nyear)
solarclim = reform(solarclim_array, nn)
solar_clim = [tensolar_clim, solarclim, EBAF_solarclim(0:10)]
solar_anom = mm_tsi - solar_clim

rswclim_array = cmreplicate(EBAF_rswclim,nyear)
rswclim = reform(rswclim_array, nn)
rsw_clim = [tenrsw_clim, rswclim, EBAF_rswclim(0:10)]
rsw_anom = toa_sw - rsw_clim

netclim_array = cmreplicate(EBAF_netclim,nyear)
netclim = reform(netclim_array, nn)
net_clim = [tennet_clim, netclim, EBAF_netclim(0:10)]

net_anom = toa_net - net_clim

insol_anom = solar_anom - rsw_anom

;addendum - double check EBAF value, i.e. how off are we?
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.8_Subset_200003-201605.nc')
varid=ncdf_varid(cdfid, 'gtoa_lw_all_mon')
ncdf_varget,cdfid,varid, new_olr
varid2=ncdf_varid(cdfid,'gtoa_sw_all_mon')
ncdf_varget,cdfid,varid2, new_rsw
varid3=ncdf_varid(cdfid,'gsolar_mon')
ncdf_varget,cdfid,varid3, new_tsi
varid4=ncdf_varid(cdfid,'gtoa_net_all_mon')
ncdf_varget,cdfid,varid4, new_net
ncdf_close, cdfid

;new_olranom = new_olr - olr_clim(0:195)
;new_rswanom = new_rsw - rsw_clim(0:195)
;new_tsianom = new_tsi - solar_clim(0:195)
;new_netanom = new_net - net_clim(0:195)
;Step 7) Plots, plots, and MORE Plots!!
Device, RETAIN=2
gray='BFBFBF'XL  ; 907F7F
white='FFFFFF'XL
black='000000'XL
red='0000FF'XL
blue='FF0000'XL
green='00611C'XL

time = TIMEGEN(200, UNITS="Months", START=JULDAY(3,1,2000))
time_z = TIMEGEN(185, UNITS="Months", START=JULDAY(3,1,2010))
time_overlap = TIMEGEN(90, UNITS="Months", START=JULDAY(1,1,2009))
time_flash = TIMEGEN(10, UNITS="Months", START=JULDAY(3,1,2016))
!p.multi=[0,1,3,0,1]
zeros = replicate(0, ndata)
Plot, time_z, zeros, ytitle='- Emitted LW(w/m^2)', XTICKUNITS = ['Time'],$
 Yrange=[-2,2],Xrange=[2456000,2457500],color=black, background=white, $
 XTICKINTERVAL=1, XMINOR=12,YMINOR=2, Title='Timeseries of Anomalies "- Emitted LW" (Monthly)', charsize=2.8, thick=2.0
 cgBarplot, mei, color=green, baroffset=0.5, barwidth=0.72, /overplot
 oplot, time, olr_anom, color=green, thick=2.0
oplot, time_flash, olr_anom(192:199), color=blue, thick=2.0
;oplot, time, new_olranom, color=red, thick=2.0, psym=-1
xyouts, 2456300, -1.5, 'CERES EBAF', color=red, size=2.0
xyouts, 2457000, -1.5, 'CERES FLASHFlux', color=blue, size=2.0

;Plot, time_z, zeros, ytitle='RSW(w/m^2)', XTICKUNITS = ['Time'],$
; Yrange=[-4,4],Xrange=[2456000,2457500],color=black, background=white, $
; XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Tropical Anomalies RSW (Monthly)', charsize=2.2, thick=2.0

; oplot, time, rsw_anom, color=red, thick=2.0
;  oplot, time_flash, rsw_anom(195:197), color=blue, thick=2.0
;  oplot, time, new_rswanom, color=green, thick=2.0, psym=-1

  Plot, time_z, zeros, ytitle='Absorbed Solar(w/m^2) [TSI-RSW]', XTICKUNITS = ['Time'],$
  Yrange=[-2,2],Xrange=[2456000,2457400],color=black, background=white, $
  XTICKINTERVAL=1, XMINOR=12, YMINOR=2, Title='Timeseries of Anomalies Absorbed Solar (Monthly)', charsize=2.8, thick=2.0
  oplot, time, solar_anom - rsw_anom, color=blue, thick=2.0
 oplot, time_flash, solar_anom(192:199) - rsw_anom(192:198), color=blue, thick=2.0
;  oplot, time, new_tsianom-new_rswanom, color=red, thick=2.0, psym=-1

 Plot, time_z, zeros, ytitle='NET(w/m^2)', XTICKUNITS = ['Time'],$
 Yrange=[-2,2],Xrange=[2456000,2457500],color=black, background=white, $
 XTICKINTERVAL=1, XMINOR=12,YMINOR=2, Title='Timeseries of Anomalies NET (Monthly)', charsize=2.8, thick=2.0

 oplot, time, net_anom, color=blue, thick=2.0
  ;oplot, time_flash, net_anom(192:198), color=blue, thick=2.0
;  oplot, time, new_netanom, color=red, thick=2.0, psym=-1


 fNamePlotOut='/data/FF/AMS-SatMet/CSTM_3subplot'
  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
;188-194
help, new_olranom
help, olr_anom
;diff_forecast_olr = olr_anom(190:194)-new_olranom(190:194)
;abs_diff_olr_fc = abs(diff_forecast_olr)
;standard_fc_olr = stddev(diff_forecast_olr)
;print, 'OLR Average Differeces: ', mean(diff_forecast_olr)
;print, 'Absolute: ', mean(abs_diff_olr_fc)
;print, '2-Sigma: ', 2*standard_fc_olr

absorbed = solar_anom(190:194) - rsw_anom(190:194)
;new_absorbed = new_tsianom(190:194)-new_rswanom(190:194)
;diff_forecast_sw = absorbed-new_absorbed
;abs_diff_sw_fc = abs(diff_forecast_sw)
;standard_fc_sw = stddev(diff_forecast_sw)
;print, 'SW Average Differeces: ', mean(diff_forecast_sw)
;print, 'Absolute: ', mean(abs_diff_sw_fc)
;print, '2-Sigma: ', 2*standard_fc_sw

;diff_forecast_net = net_anom(190:194)-new_netanom(190:194)
;abs_diff_net_fc = abs(diff_forecast_net)
;standard_fc_net = stddev(diff_forecast_net)
;print, 'Net Average Differeces: ', mean(diff_forecast_net)
;print, 'Absolute: ', mean(abs_diff_net_fc)
;print, '2-Sigma: ', 2*standard_fc_net


  ;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;Zoom in
;!p.multi=[0,1,4,0,1]
;zeros = replicate(mean(toa_lw), ndata)
;Plot, time, zeros, ytitle='OLR(w/m^2)', XTICKUNITS = ['Time'],$
;Yrange=[200,275],Xrange=[2455000,2457500],color=black, background=white, $
;XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly OLR', charsize=2.2, thick=2.0

;oplot, time, EBAF_olr, color=red, thick=2.0
;oplot, time_overlap, norflasholr, color=blue, thick=2.0
;oplot, time, new_olr, color=red, thick=2.0, psym=-1
;
;zeros = replicate(mean(mm_tsi), ndata)
;Plot, time, zeros, ytitle='TSI(w/m^2)', XTICKUNITS = ['Time'],$
;Yrange=[320,360],Xrange=[2455000,2457500],color=black, background=white, $
;XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly TSI', charsize=2.2, thick=2.0

;oplot, time, EBAF_tsi, color=red, thick=2.0
;oplot, time_overlap, sorcetsi, color=blue, thick=2.0
;oplot, time, new_solar, color=red, thick=2.0, psym=-1
;
;zeros = replicate(mean(toa_sw), ndata)
;Plot, time, zeros, ytitle='RSW(w/m^2)', XTICKUNITS = ['Time'],$
;Yrange=[80,120],Xrange=[2455000,2457500],color=black, background=white, $
;XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly RSW', charsize=2.2, thick=2.0

;oplot, time, EBAF_rsw, color=red, thick=2.0
;oplot, time_overlap,norflashrsw, color=blue, thick=2.0
;oplot, time, new_rsw, color=red, thick=2.0, psym=-1
;
;Plot, time, zeros, ytitle='NET(w/m^2)', XTICKUNITS = ['Time'],$
;Yrange=[-12,12],Xrange=[2455000,2457500],color=black, background=white, $
;XTICKINTERVAL=1, XMINOR=12, Title='Timeseries of Monthly NET', charsize=2.2, thick=2.0

;oplot, time, EBAF_net, color=red, thick=2.0
;oplot, time_overlap, norflashtoanet, color=blue, thick=2.0
;oplot, time, new_net, color=red, thick=2.0, psym=-1

fNamePlotOut='/data/FF/AMS-SatMet/AMS_Sat-Met_2016'
image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)

;Step 8)Get me some STATS! stat!
;copy and paste this from previous program OLR is toa_lw and RSW is toa_sw, etc.
;[2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015]
OLR=toa_lw
OLR_ymean = [mean(OLR[10:21]),mean(OLR[22:33]),mean(OLR[34:45]),mean(OLR[46:57]),$
mean(OLR[58:69]),mean(OLR[70:81]),mean(OLR[82:93]),mean(OLR[94:105]),$
mean(OLR[106:117]),mean(OLR[118:129]),mean(OLR[130:141]),mean(OLR[142:153]),$
mean(OLR[154:165]),mean(OLR[166:177])];,mean(OLR[178:189])]
TSI=mm_tsi
TSI_ymean = [mean(TSI[10:21]),mean(TSI[22:33]),mean(TSI[34:45]),mean(TSI[46:57]),$
mean(TSI[58:69]),mean(TSI[70:81]),mean(TSI[82:93]),mean(TSI[94:105]),$
mean(TSI[106:117]),mean(TSI[118:129]),mean(TSI[130:141]),mean(TSI[142:153]),$
mean(TSI[154:165]), mean(TSI[166:177])];,mean(TSI[178:189])]
RSW=toa_sw
RSW_ymean = [mean(RSW[10:21]),mean(RSW[22:33]),mean(RSW[34:45]),mean(RSW[46:57]),$
mean(RSW[58:69]),mean(RSW[70:81]),mean(RSW[82:93]),mean(RSW[94:105]),$
mean(RSW[106:117]),mean(RSW[118:129]),mean(RSW[130:141]),mean(RSW[142:153]),$
mean(RSW[154:165]),mean(RSW[166:177])];,mean(RSW[178:189])]
NET=toa_net
NET_ymean = [mean(NET[10:21]),mean(NET[22:33]),mean(NET[34:45]),mean(NET[46:57]),$
mean(NET[58:69]),mean(NET[70:81]),mean(NET[82:93]),mean(NET[94:105]),$
mean(NET[106:117]),mean(NET[118:129]),mean(NET[130:141]),mean(NET[142:153]),$
mean(NET[154:165]), mean(NET[166:177])];,mean(NET[178:189])]

 ;a)Year to year change [2015-2014]
  olr_change = mean(toa_lw(178:189))-mean(toa_lw(166:177))
  rsw_change = mean(toa_sw(178:189))-mean(toa_sw(166:177))
  tsi_change = mean(mm_tsi(178:189))-mean(mm_tsi(166:177))
  net_change = mean(toa_net(178:189))-mean(toa_net(166:177))

;aa)Special 2015(El Nino) change to 2013(normal)
 olr_2change = mean(toa_lw(178:189))-mean(toa_lw(154:165))
 rsw_2change = mean(toa_sw(178:189))-mean(toa_sw(154:165))
 tsi_2change = mean(mm_tsi(178:189))-mean(mm_tsi(154:165))
 net_2change = mean(toa_net(178:189))-mean(toa_net(154:165))

 ;b)Year anomaly
   olrAnom = mean(toa_lw(178:189)) - mean(OLR_ymean[0:13])
   rswAnom = mean(toa_sw(178:189)) - mean(RSW_ymean[0:13])
   tsiAnom = mean(mm_tsi(178:189)) - mean(TSI_ymean[0:13])
   netAnom = mean(toa_net(178:189)) - mean(NET_ymean[0:13])

 ;c)Variability and Print out
    Print, '       , 2015-2013, 2015-2014, 2015 Anom, Sigma'
    Print, 'OLR: ', olr_2change, olr_change, olrAnom, 2*stddev(OLR_ymean)
    Print, 'RSW: ', rsw_2change, rsw_change, rswAnom, 2*stddev(RSW_ymean)
    Print, 'TSI: ', tsi_2change, tsi_change, tsiAnom, 2*stddev(TSI_ymean)
    Print, 'Net: ', net_2change, net_change, netAnom, 2*stddev(NET_ymean)

    Print, '     , Overlap, 2-sigma'
    Print, 'OLR: ', mean(diff_olr), 2*stddev(diff_olr)
    Print, 'RSW: ', mean(diff_rsw), 2*stddev(diff_rsw)
    Print, 'TSI: ', mean(diff_tsi), 2*stddev(diff_tsi)

;Addendum step
;Get uncertainties STATS
uncert_olr = EBAFFLASH_olr - norflasholr(0:71)
uncert_rsw = EBAFFLASH_rsw - norflashrsw(0:71)
uncert_tsi = EBAFFLASH_tsi - norflashtsi(0:71)
uncert_net = EBAFFLASH_net - norflashtoanet(0:71)

stuncert_olr = 2*stddev(uncert_olr)
stuncert_rsw = 2*stddev(uncert_rsw)
stuncert_tsi = 2*stddev(uncert_tsi)
stuncert_net = 2*stddev(uncert_net)
print, '2-sigma OLR: ', stuncert_olr
print, '2-sigma RSW: ', stuncert_rsw
print, '2-sigma TSI: ', stuncert_tsi
print, '2-sigma NET: ', stuncert_net


;uncertanom_olr = (EBAFFLASH_olr-olrclim) -
;Write to ASCII for Tak
caldat, time, month, day, year
help, olr_anom
writecol, '/data/FF/AMS-SatMet/AMS-SatMet_anomtrop.txt', year, month, olr_anom, solar_anom, rsw_anom,$
net_anom
insol_anom = solar_anom - rsw_anom
writecol, '/data/FF/AMS-SatMet/AMS-SatMet_3plot_anomtrop.txt', year, month, olr_anom, insol_anom, net_anom
;caldat, time_overlap, month, day, year
;writecol, '/data/FF/AMS-SatMet/AMS-SatMet_overlap_olrtrop.txt', year, month, EBAFFLASH_olr, linflasholr, norflasholr
;writecol, '/data/FF/AMS-SatMet/AMS-SatMet_overlap_rswtrop.txt', year, month, EBAFFLASH_rsw, linflashrsw, norflashrsw
;writecol, '/data/FF/AMS-SatMet/AMS-SatMet_overlap_tsitrop.txt', year, month, EBAFFLASH_tsi, linflashtsi, norflashtsi
newtime = TIMEGEN(193, UNITS="Months", START=JULDAY(3,1,2000))
;caldat, newtime, month, day, year
;writecol, '/data/FF/AMS-SatMet/AMS-SatMet_newanomtrop.txt', year, month, new_olranom, new_tsianom, new_rswanom,$
;new_netanom
END

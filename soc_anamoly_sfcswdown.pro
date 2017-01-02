pro soc_anamoly_sfcswdown

;Comparing timeseries net anamoly for CERES-lite, Flash, and AIRS
;open ceres file [March 2000 - Dec 2010]
;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FLASHFlux/timeseries/EBAF/CERES_EBAF-Surface_Ed2.6r_Subset_200003-201002.nc')
varid=ncdf_varid(cdfid, 'gsfc_sw_down_all_mon')
ncdf_varget,cdfid,varid, EBAF_swdown
ncdf_close, cdfid
ndata=n_elements(EBAF_swdown)
;EBAF_net_overlap=EBAF_net[28:123]
;EBAFflash_net_overlap=EBAF[84:131] ;3/2007 - 2/2011
;EBAFflash_net_overlap=EBAF_net[106:129] ;1/2009-12/2010

result_EBAF=moment(EBAF_swdown,mdev=mean_dev_EBAF,sdev=std_EBAF)
help, result_EBAF
PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 
   
cdfid= ncdf_open('/data/FLASHFlux/timeseries/EBAF/CERES_EBAF-Surface_Ed2.6r_Subset_200003-201002.nc')
varid=ncdf_varid(cdfid, 'gsfc_sw_up_all_mon')
ncdf_varget,cdfid,varid, EBAF_swup
ncdf_close, cdfid

;EBAF_net_overlap=EBAF_net[28:123]
;EBAFflash_net_overlap=EBAF[84:131] ;3/2007 - 2/2011
;EBAFflash_net_overlap=EBAF_net[106:129] ;1/2009-12/2010

result_EBAF=moment(EBAF_swup,mdev=mean_dev_EBAF,sdev=std_EBAF)
help, result_EBAF
PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 

cdfid= ncdf_open('/data/FLASHFlux/timeseries/EBAF/CERES_EBAF-Surface_Ed2.6r_Subset_200003-201002.nc')
varid=ncdf_varid(cdfid, 'gsfc_lw_up_all_mon')
ncdf_varget,cdfid,varid, EBAF_lwup
ncdf_close, cdfid

;EBAF_net_overlap=EBAF_net[28:123]
;EBAFflash_net_overlap=EBAF[84:131] ;3/2007 - 2/2011
;EBAFflash_net_overlap=EBAF_net[106:129] ;1/2009-12/2010

result_EBAF=moment(EBAF_lwup,mdev=mean_dev_EBAF,sdev=std_EBAF)
help, result_EBAF
PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF

cdfid= ncdf_open('/data/FLASHFlux/timeseries/EBAF/CERES_EBAF-Surface_Ed2.6r_Subset_200003-201002.nc')
varid=ncdf_varid(cdfid, 'gsfc_lw_down_all_mon')
ncdf_varget,cdfid,varid, EBAF_lwdown
ncdf_close, cdfid

;EBAF_net_overlap=EBAF_net[28:123]
;EBAFflash_net_overlap=EBAF[84:131] ;3/2007 - 2/2011
;EBAFflash_net_overlap=EBAF_net[106:129] ;1/2009-12/2010

result_EBAF=moment(EBAF_lwdown,mdev=mean_dev_EBAF,sdev=std_EBAF)
help, result_EBAF
PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Allocate Parameters Here;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EBAF_arr=make_array(6,ndata)
anoEBAF_arr=make_array(6,ndata)
EBAF_arr(0,*) = EBAF_swup
EBAF_arr(1,*) = EBAF_swdown
EBAF_arr(2,*) = EBAF_lwup
EBAF_arr(3,*) = EBAF_lwdown
EBAF_arr(4,*) = EBAF_swdown - EBAF_swup
EBAF_arr(5,*) = EBAF_lwdown - EBAF_lwup

EBAF=fltarr(ndata)
;EBAF = [EBAF_swup, EBAF_swdown, EBAF_lwup, EBAF_lwdown]
for j = 0,5 do begin
	EBAF = EBAF_arr(j,*)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Calculate 10 yrs Monthly Averages;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mar=fltarr(ndata)
apr=fltarr(ndata)
may=fltarr(ndata)
jun=fltarr(ndata)
jul=fltarr(ndata)
aug=fltarr(ndata)
sep=fltarr(ndata)
oct=fltarr(ndata)
nov=fltarr(ndata)
dec=fltarr(ndata)
jan=fltarr(ndata)
feb=fltarr(ndata)

for i=0,ndata-1,12 do begin
		mar(i) = EBAF(i)
		apr(i+1) = EBAF(i+1)
		may(i+2) = EBAF(i+2)
		jun(i+3) = EBAF(i+3)
		jul(i+4) = EBAF(i+4)
		aug(i+5) = EBAF(i+5)
		sep(i+6) = EBAF(i+6)
		oct(i+7) = EBAF(i+7)
		nov(i+8) = EBAF(i+8)
		dec(i+9) = EBAF(i+9)
		jan(i+10) = EBAF(i+10)
		feb(i+11) = EBAF(i+11)
		print, 'i:', i
endfor

;Need to do this to avoid averaging zeroes
g_mar=where(mar ne 0, imar)
nmar = mar(g_mar)
g_apr=where(apr ne 0, iapr)
napr = apr(g_apr)
g_may=where(may ne 0, imay)
nmay = may(g_may)
g_jun=where(jun ne 0, ijun)
njun = jun(g_jun)
g_jul=where(jul ne 0, ijul)
njul = jul(g_jul)
g_aug=where(aug ne 0, iaug)
naug = aug(g_aug)
g_sep=where(sep ne 0, isep)
nsep = sep(g_sep)
g_oct=where(oct ne 0, ioct)
noct = oct(g_oct)
g_nov=where(nov ne 0, inov)
nnov = nov(g_nov)
g_dec=where(dec ne 0, idec)
ndec = dec(g_dec)
g_jan=where(jan ne 0, ijan)
njan = jan(g_jan)
g_feb=where(feb ne 0, ifeb)
nfeb = feb(g_feb)

maravg=moment(nmar, sdev=marstd)
apravg=moment(napr, sdev=aprstd)
mayavg=moment(nmay, sdev=maystd)
junavg=moment(njun, sdev=junstd)
julavg=moment(njul, sdev=julstd)
augavg=moment(naug, sdev=augstd)
sepavg=moment(nsep, sdev=sepstd)
octavg=moment(noct, sdev=octstd)
novavg=moment(nnov, sdev=novstd)
decavg=moment(ndec, sdev=decstd)
janavg=moment(njan, sdev=janstd)
febavg=moment(nfeb, sdev=febstd)

anoEBAF=fltarr(ndata)

for i=0,ndata-1,12 do begin
		anoEBAF(i) = EBAF(i) - maravg(0)
		anoEBAF(i+1) = EBAF(i+1) - apravg(0)
		anoEBAF(i+2) = EBAF(i+2) - mayavg(0)
		anoEBAF(i+3) = EBAF(i+3) - junavg(0)
		anoEBAF(i+4) = EBAF(i+4) - julavg(0)
		anoEBAF(i+5) = EBAF(i+5) - augavg(0)
		anoEBAF(i+6) = EBAF(i+6) - sepavg(0)
		anoEBAF(i+7) = EBAF(i+7) - octavg(0)
		anoEBAF(i+8) = EBAF(i+8) - novavg(0)
		anoEBAF(i+9) = EBAF(i+9) - decavg(0)
		anoEBAF(i+10) = EBAF(i+10) - janavg(0)
		anoEBAF(i+11) = EBAF(i+11) - febavg(0)
endfor
anoEBAF_arr(j,*) = anoEBAF
print, 'anomaly EBAF:', anoEBAF_arr
endfor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PLOTING;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gray='BFBFBF'XL  ; 907F7F
white='FFFFFF'XL
black='000000'XL
liteblue='ff9919'XL
green='00611C'XL
red='0000FF'XL
blue='FF0000'XL
pink='7F7FFF'XL
yellow='00FFFF'XL
time = TIMEGEN(ndata, UNITS="Months", START=JULDAY(3,1,2000))
flatline = TIMEGEN(ndata+36, UNITS="Months", START=JULDAY(3,1,2000))
zeros=intarr(ndata+36)


 ;PLOT, time, EBAF, ytitle='Surface Flux(w/m^2)', XTICKUNITS = ['Time'], Yrange=[0,500],Xrange=[2451605,2455900],$
 ;color=black, background=white, XTICKINTERVAL=1,XMINOR=12,$;, XTICKFORMAT='LABEL_DATE', xtitle='Time', $
 ;Title='Timeseries EBAF', charsize=1.2
; 	oplot, time,EBAF_swup, color=red
; 	oplot, time, EBAF_lwdown, color=blue
; 	oplot, time, EBAF_lwup, color=green


;fNamePlotOut='/data/FLASHFlux/timeseries/soc_2011/Surface_EBAF_SWDown'
;  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
  
PLOT, flatline, zeros, ytitle='Surface Flux Anomaly(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-2.5,2.5],Xrange=[2451605,2455900],$
 color=black, background=white, XTICKINTERVAL=1,XMINOR=12,$;, XTICKFORMAT='LABEL_DATE', xtitle='Time', $
 Title='Timeseries EBAF Anomaly', charsize=1.2
 	;oplot, time, anoEBAF_arr(0,*), color=red, psym=-2
    oplot, time, anoEBAF_arr(1,*), color=green, psym=-3
    ;oplot, time, anoEBAF_arr(4,*), color=blue, psym=-5

fNamePlotOut='/data/FLASHFlux/timeseries/soc_2011/Surface_EBAF_SWDown_Anomaly'
  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)

End
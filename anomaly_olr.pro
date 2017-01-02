pro anomaly_olr
;Comparing timeseries net anamoly for CERES-lite, Flash, and AIRS
;open ceres file [March 2000 - Dec 2010]
;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FLASHFlux/timeseries/EBAF/CERES_EBAF-TOA_Ed2.6r_Subset_200003-201106.nc')
varid=ncdf_varid(cdfid, 'gtoa_lw_all_mon')
ncdf_varget,cdfid,varid, EBAF_olr
ncdf_close, cdfid

EBAFflash_olr_overlap=EBAF_olr[84:131] ; March 2007 - Feb. 2011
;EBAF_olr_overlap=EBAF_olr[28:123]
;EBAFflash_olr_overlap=EBAF_olr[84:119] ;3/2007-2/2010

result_EBAF=moment(EBAF_olr,mdev=mean_dev_EBAF,sdev=std_EBAF)
help, result_EBAF
PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 
   
;***************************************************************************************************
;***************************************************************************************************
;open ceres FLASH file
;Outgoing Longwave
close,1

;open ceres FLASH file - Version 2G
ndata=66
temp=''
;versionf=''
;datef=''
flashdata=fltarr(8,ndata)
close,1
openr,1,'/data/FLASHFlux/timeseries/Flashflux_glbmean/globe_pc_oblate.txt'
readf,1,temp
readf,1,flashdata
flasholr_2G=fltarr(ndata)

flasholr_2G=flashdata(4,*)
flasholr_2G_overlap=flasholr_2G[8:55] ;3/2007-2/2011
close,1
result_flasholr_2G=moment(flasholr_2G,mdev=mean_dev_flasholr_2G,sdev=std_flasholr_2G)
help, result_flasholr_2G
PRINT, 'Mean: ', result_flasholr_2G[0] & PRINT, 'Variance: ', result_flasholr_2G[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_flasholr_2G & Print, 'Standard Deviation:', std_flasholr_2G
   
;************************************************************************************************
 diff_EBAFflash = EBAFflash_olr_overlap - flasholr_2G_overlap
mean_diff_EBAFflash = mean(diff_EBAFflash)
print, 'OVERLAP STATISTICS'
print, 'mean EBAF:', mean(EBAFflash_olr_overlap)
print, 'stddev EBAF:', stddev(EBAFflash_olr_overlap)
print, 'mean flash:', mean(flasholr_2G_overlap)
print, 'stddev flash:', stddev(flasholr_2G_overlap)
flash_num = n_elements(flasholr_2G)
print, 'flash_num:', flash_num
nor_flasholr = fltarr(flash_num)
	for j=0L, flash_num-1L do begin
		nor_flasholr(j) = flasholr_2G(j) + mean_diff_EBAFflash
	endfor
result_nor_flasholr=moment(nor_flasholr,mdev=mean_dev_nor_flasholr,sdev=std_nor_flasholr)
help, result_nor_flasholr
PRINT, 'Mean: ', result_nor_flasholr[0] & PRINT, 'Variance: ', result_nor_flasholr[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_nor_flasholr & Print, 'Standard Deviation:', std_nor_flasholr
;*************************************************************************************************
;Anomaly caluclation
;********************************
;EBAF olr
;***************************
;get monthly average
maravgolr=total(EBAF_olr(0)+EBAF_olr(12)+EBAF_olr(24)+EBAF_olr(36)+EBAF_olr(48)+EBAF_olr(60)+EBAF_olr(72)+EBAF_olr(84)+EBAF_olr(96)+EBAF_olr(108)+EBAF_olr(120)+EBAF_olr(132))/12
apravgolr=total(EBAF_olr(1)+EBAF_olr(13)+EBAF_olr(25)+EBAF_olr(37)+EBAF_olr(49)+EBAF_olr(61)+EBAF_olr(73)+EBAF_olr(85)+EBAF_olr(97)+EBAF_olr(109)+EBAF_olr(121)+EBAF_olr(133))/12
mayavgolr=total(EBAF_olr(2)+EBAF_olr(14)+EBAF_olr(26)+EBAF_olr(38)+EBAF_olr(50)+EBAF_olr(62)+EBAF_olr(74)+EBAF_olr(86)+EBAF_olr(98)+EBAF_olr(110)+EBAF_olr(122)+EBAF_olr(134))/12
junavgolr=total(EBAF_olr(3)+EBAF_olr(15)+EBAF_olr(27)+EBAF_olr(39)+EBAF_olr(51)+EBAF_olr(63)+EBAF_olr(75)+EBAF_olr(87)+EBAF_olr(99)+EBAF_olr(111)+EBAF_olr(123)+EBAF_olr(135))/12
julavgolr=total(EBAF_olr(4)+EBAF_olr(16)+EBAF_olr(28)+EBAF_olr(40)+EBAF_olr(52)+EBAF_olr(64)+EBAF_olr(76)+EBAF_olr(88)+EBAF_olr(100)+EBAF_olr(112)+EBAF_olr(124))/11
augavgolr=total(EBAF_olr(5)+EBAF_olr(17)+EBAF_olr(29)+EBAF_olr(41)+EBAF_olr(53)+EBAF_olr(65)+EBAF_olr(77)+EBAF_olr(89)+EBAF_olr(101)+EBAF_olr(113)+EBAF_olr(125))/11
sepavgolr=total(EBAF_olr(6)+EBAF_olr(18)+EBAF_olr(30)+EBAF_olr(42)+EBAF_olr(54)+EBAF_olr(66)+EBAF_olr(78)+EBAF_olr(90)+EBAF_olr(102)+EBAF_olr(114)+EBAF_olr(126))/11
octavgolr=total(EBAF_olr(7)+EBAF_olr(19)+EBAF_olr(31)+EBAF_olr(43)+EBAF_olr(55)+EBAF_olr(67)+EBAF_olr(79)+EBAF_olr(91)+EBAF_olr(103)+EBAF_olr(115)+EBAF_olr(127))/11
novavgolr=total(EBAF_olr(8)+EBAF_olr(20)+EBAF_olr(32)+EBAF_olr(44)+EBAF_olr(56)+EBAF_olr(68)+EBAF_olr(80)+EBAF_olr(92)+EBAF_olr(104)+EBAF_olr(116)+EBAF_olr(128))/11
decavgolr=total(EBAF_olr(9)+EBAF_olr(21)+EBAF_olr(33)+EBAF_olr(45)+EBAF_olr(57)+EBAF_olr(69)+EBAF_olr(81)+EBAF_olr(93)+EBAF_olr(105)+EBAF_olr(117)+EBAF_olr(129))/11
janavgolr=total(EBAF_olr(10)+EBAF_olr(22)+EBAF_olr(34)+EBAF_olr(46)+EBAF_olr(58)+EBAF_olr(70)+EBAF_olr(82)+EBAF_olr(94)+EBAF_olr(106)+EBAF_olr(118)+EBAF_olr(130))/11
febavgolr=total(EBAF_olr(11)+EBAF_olr(23)+EBAF_olr(35)+EBAF_olr(47)+EBAF_olr(59)+EBAF_olr(71)+EBAF_olr(83)+EBAF_olr(95)+EBAF_olr(107)+EBAF_olr(119)+EBAF_olr(131))/11

avgolr=[maravgolr,apravgolr,mayavgolr,junavgolr,julavgolr,augavgolr,sepavgolr,octavgolr,novavgolr,decavgolr,janavgolr,febavgolr]
tsavgolr=[avgolr,avgolr,avgolr,avgolr,avgolr,avgolr,avgolr,avgolr,avgolr,avgolr,avgolr,maravgolr,apravgolr,mayavgolr,junavgolr]
anoEBAF_olr=EBAF_olr-tsavgolr

;*********************************
;FLASH olr Start from July. 2006
;*********************************
;begin deseason
fjul=total(nor_flasholr(0)+nor_flasholr(12)+nor_flasholr(24)+nor_flasholr(36)+nor_flasholr(48)+nor_flasholr(60))/6
faug=total(nor_flasholr(1)+nor_flasholr(13)+nor_flasholr(25)+nor_flasholr(37)+nor_flasholr(49)+nor_flasholr(61))/6
fsep=total(nor_flasholr(2)+nor_flasholr(14)+nor_flasholr(26)+nor_flasholr(38)+nor_flasholr(50)+nor_flasholr(62))/6
foct=total(nor_flasholr(3)+nor_flasholr(15)+nor_flasholr(27)+nor_flasholr(39)+nor_flasholr(51)+nor_flasholr(63))/6
fnov=total(nor_flasholr(4)+nor_flasholr(16)+nor_flasholr(28)+nor_flasholr(40)+nor_flasholr(52)+nor_flasholr(64))/6
fdec=total(nor_flasholr(5)+nor_flasholr(17)+nor_flasholr(29)+nor_flasholr(41)+nor_flasholr(53)+nor_flasholr(65))/6
fjan=total(nor_flasholr(6)+nor_flasholr(18)+nor_flasholr(30)+nor_flasholr(42)+nor_flasholr(54))/5
ffeb=total(nor_flasholr(7)+nor_flasholr(19)+nor_flasholr(31)+nor_flasholr(43)+nor_flasholr(55))/5
fmar=total(nor_flasholr(8)+nor_flasholr(20)+nor_flasholr(32)+nor_flasholr(44)+nor_flasholr(56))/5
fapr=total(nor_flasholr(9)+nor_flasholr(21)+nor_flasholr(33)+nor_flasholr(45)+nor_flasholr(57))/5
fmay=total(nor_flasholr(10)+nor_flasholr(22)+nor_flasholr(34)+nor_flasholr(46)+nor_flasholr(58))/5
fjun=total(nor_flasholr(11)+nor_flasholr(23)+nor_flasholr(35)+nor_flasholr(47)+nor_flasholr(59))/5

avgnor_flasholr=[fjul,faug,fsep,foct,fnov,fdec,fjan,ffeb,fmar,fapr,fmay,fjun]
monfmean=[avgnor_flasholr,avgnor_flasholr,avgnor_flasholr,avgnor_flasholr,avgnor_flasholr,fjul,faug,fsep,foct,fnov,fdec]
anonor_flasholr=nor_flasholr-monfmean

;print, 'EBAF olr anomaly:'
;for i=0,129 do begin
;print, anoEBAF_olr(i)
;endfor

print, 'FLASH olr anomaly:'
for i=54,65 do begin
print, flasholr_2G(i)
endfor

gray='BFBFBF'XL  ; 907F7F
white='FFFFFF'XL
black='000000'XL
liteblue='ff9919'XL
green='00611C'XL
red='0000FF'XL
blue='FF0000'XL
pink='7F7FFF'XL
yellow='00FFFF'XL
; Create format strings for a two-level axis:  
;dummy = LABEL_DATE(DATE_FORMAT=['%Y'])  
;time = findgen(ndata) 
time = TIMEGEN(136, UNITS="Months", START=JULDAY(3,1,2000))
;timeceres=TIMEGEN(93, UNITS="Months", START=JULDAY(7,1,2002))
timeflash=TIMEGEN(36, UNITS="Months", START=JULDAY(1,1,2009))
;timeflash=TIMEGEN(59, UNITS="Months", START=JULDAY(7,1,2006))
timeline= TIMEGEN(140, UNITS="Months", START=JULDAY(3,1,2000))
zeros=intarr(140)

 PLOT, timeline, zeros, ytitle='OLR(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-2,2],Xrange=[2451605,2455900],$
 color=black, background=white,XTICKINTERVAL=1,XMINOR=12, $;, XTICKFORMAT='LABEL_DATE', xtitle='Time', $
 Title='Timeseries of Monthly Anomaly OLR', charsize=1.2
 ;oplot, timeceres, anoceres, color=blue, psym=-4
 oplot,timeflash,anonor_flasholr(30:65),color=blue,psym=-4
 oplot,time, anoEBAF_olr, color=red,psym=-4
 
xyouts, 2454810,1.8, 'CERESLite_EBAF', color=red, charsize=1.5, charthick=1.5
;xyouts, 2454810,1.6, 'CERESLite_Aqua (Normalized)', color=blue, charsize=1.5, charthick=1.5
xyouts, 2454810,1.4, 'FLASHFlux (Normalized)', color=blue, charsize=1.5, charthick=1.5

fNamePlotOut='/data/FLASHFlux/timeseries/soc_2011/anomaly_olr'
  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
END
pro anomaly_tsi_rsw
;Comparing timeseries tsi anamoly for CERES-lite, Flash, and AIRS
;open ceres file [March 2000 - Feb 2010]
;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FLASHFlux/timeseries/EBAF/CERES_EBAF-TOA_Ed2.6r_Subset_200003-201106.nc')
varid=ncdf_varid(cdfid, 'gsolar_mon')
ncdf_varget,cdfid,varid, EBAF_tsi
ncdf_close, cdfid

EBAFflash_tsi_overlap=EBAF_tsi[84:131] ; March 2007 - Feb. 2011

result_EBAF=moment(EBAF_tsi,mdev=mean_dev_EBAF,sdev=std_EBAF)
help, result_EBAF
PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 
   
;***************************************************************************************************
;***************************************************************************************************
;open ceres FLASH file


restore, '/data/FLASHFlux/timeseries/corrected_flash.sav'
flashtsi_2G=float(corrected_flashinso)
flashtsi_2G_overlap=float(corrected_flashinso[8:55]) ;3/2007-2/2011
result_flashtsi_2G=moment(flashtsi_2G,mdev=mean_dev_flashtsi_2G,sdev=std_flashtsi_2G)

PRINT, 'Mean: ', result_flashtsi_2G[0] & PRINT, 'Variance: ', result_flashtsi_2G[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_flashtsi_2G & Print, 'Standard Deviation:', std_flashtsi_2G 
   
;************************************************************************************************
 diff_EBAFflash = EBAFflash_tsi_overlap - flashtsi_2G_overlap
mean_diff_EBAFflash = mean(diff_EBAFflash)
print, 'OVERLAP STATISTICS'
print, 'mean EBAF:', mean(EBAFflash_tsi_overlap)
print, 'stddev EBAF:', stddev(EBAFflash_tsi_overlap)
print, 'mean flash:', mean(flashtsi_2G_overlap)
print, 'stddev flash:', stddev(flashtsi_2G_overlap)
flash_num = n_elements(flashtsi_2G)
print, 'flash_num:', flash_num
nor_flashtsi = fltarr(flash_num)
	for j=0L, flash_num-1L do begin
		nor_flashtsi(j) = flashtsi_2G(j) + mean_diff_EBAFflash
	endfor
result_nor_flashtsi=moment(nor_flashtsi,mdev=mean_dev_nor_flashtsi,sdev=std_nor_flashtsi)
help, result_nor_flashtsi
PRINT, 'Mean: ', result_nor_flashtsi[0] & PRINT, 'Variance: ', result_nor_flashtsi[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_nor_flashtsi & Print, 'Standard Deviation:', std_nor_flashtsi
;*************************************************************************************************
;Anomaly caluclation
;********************************
;EBAF tsi
;***************************
;get monthly average
maravgtsi=total(EBAF_tsi(0)+EBAF_tsi(12)+EBAF_tsi(24)+EBAF_tsi(36)+EBAF_tsi(48)+EBAF_tsi(60)+EBAF_tsi(72)+EBAF_tsi(84)+EBAF_tsi(96)+EBAF_tsi(108)+EBAF_tsi(120)+EBAF_tsi(132))/12
apravgtsi=total(EBAF_tsi(1)+EBAF_tsi(13)+EBAF_tsi(25)+EBAF_tsi(37)+EBAF_tsi(49)+EBAF_tsi(61)+EBAF_tsi(73)+EBAF_tsi(85)+EBAF_tsi(97)+EBAF_tsi(109)+EBAF_tsi(121)+EBAF_tsi(133))/12
mayavgtsi=total(EBAF_tsi(2)+EBAF_tsi(14)+EBAF_tsi(26)+EBAF_tsi(38)+EBAF_tsi(50)+EBAF_tsi(62)+EBAF_tsi(74)+EBAF_tsi(86)+EBAF_tsi(98)+EBAF_tsi(110)+EBAF_tsi(122)+EBAF_tsi(134))/12
junavgtsi=total(EBAF_tsi(3)+EBAF_tsi(15)+EBAF_tsi(27)+EBAF_tsi(39)+EBAF_tsi(51)+EBAF_tsi(63)+EBAF_tsi(75)+EBAF_tsi(87)+EBAF_tsi(99)+EBAF_tsi(111)+EBAF_tsi(123)+EBAF_tsi(135))/12
julavgtsi=total(EBAF_tsi(4)+EBAF_tsi(16)+EBAF_tsi(28)+EBAF_tsi(40)+EBAF_tsi(52)+EBAF_tsi(64)+EBAF_tsi(76)+EBAF_tsi(88)+EBAF_tsi(100)+EBAF_tsi(112)+EBAF_tsi(124))/11
augavgtsi=total(EBAF_tsi(5)+EBAF_tsi(17)+EBAF_tsi(29)+EBAF_tsi(41)+EBAF_tsi(53)+EBAF_tsi(65)+EBAF_tsi(77)+EBAF_tsi(89)+EBAF_tsi(101)+EBAF_tsi(113)+EBAF_tsi(125))/11
sepavgtsi=total(EBAF_tsi(6)+EBAF_tsi(18)+EBAF_tsi(30)+EBAF_tsi(42)+EBAF_tsi(54)+EBAF_tsi(66)+EBAF_tsi(78)+EBAF_tsi(90)+EBAF_tsi(102)+EBAF_tsi(114)+EBAF_tsi(126))/11
octavgtsi=total(EBAF_tsi(7)+EBAF_tsi(19)+EBAF_tsi(31)+EBAF_tsi(43)+EBAF_tsi(55)+EBAF_tsi(67)+EBAF_tsi(79)+EBAF_tsi(91)+EBAF_tsi(103)+EBAF_tsi(115)+EBAF_tsi(127))/11
novavgtsi=total(EBAF_tsi(8)+EBAF_tsi(20)+EBAF_tsi(32)+EBAF_tsi(44)+EBAF_tsi(56)+EBAF_tsi(68)+EBAF_tsi(80)+EBAF_tsi(92)+EBAF_tsi(104)+EBAF_tsi(116)+EBAF_tsi(128))/11
decavgtsi=total(EBAF_tsi(9)+EBAF_tsi(21)+EBAF_tsi(33)+EBAF_tsi(45)+EBAF_tsi(57)+EBAF_tsi(69)+EBAF_tsi(81)+EBAF_tsi(93)+EBAF_tsi(105)+EBAF_tsi(117)+EBAF_tsi(129))/11
janavgtsi=total(EBAF_tsi(10)+EBAF_tsi(22)+EBAF_tsi(34)+EBAF_tsi(46)+EBAF_tsi(58)+EBAF_tsi(70)+EBAF_tsi(82)+EBAF_tsi(94)+EBAF_tsi(106)+EBAF_tsi(118)+EBAF_tsi(130))/11
febavgtsi=total(EBAF_tsi(11)+EBAF_tsi(23)+EBAF_tsi(35)+EBAF_tsi(47)+EBAF_tsi(59)+EBAF_tsi(71)+EBAF_tsi(83)+EBAF_tsi(95)+EBAF_tsi(107)+EBAF_tsi(119)+EBAF_tsi(131))/11

avgtsi=[maravgtsi,apravgtsi,mayavgtsi,junavgtsi,julavgtsi,augavgtsi,sepavgtsi,octavgtsi,novavgtsi,decavgtsi,janavgtsi,febavgtsi]
tsavgtsi=[avgtsi,avgtsi,avgtsi,avgtsi,avgtsi,avgtsi,avgtsi,avgtsi,avgtsi,avgtsi,avgtsi,maravgtsi,apravgtsi,mayavgtsi,junavgtsi]
anoEBAF_tsi=EBAF_tsi-tsavgtsi

;*********************************
;FLASH tsi
;*********************************
;begin deseason
fjul=total(nor_flashtsi(0)+nor_flashtsi(12)+nor_flashtsi(24)+nor_flashtsi(36)+nor_flashtsi(48)+nor_flashtsi(60))/6
faug=total(nor_flashtsi(1)+nor_flashtsi(13)+nor_flashtsi(25)+nor_flashtsi(37)+nor_flashtsi(49)+nor_flashtsi(61))/6
fsep=total(nor_flashtsi(2)+nor_flashtsi(14)+nor_flashtsi(26)+nor_flashtsi(38)+nor_flashtsi(50)+nor_flashtsi(62))/6
foct=total(nor_flashtsi(3)+nor_flashtsi(15)+nor_flashtsi(27)+nor_flashtsi(39)+nor_flashtsi(51)+nor_flashtsi(63))/6
fnov=total(nor_flashtsi(4)+nor_flashtsi(16)+nor_flashtsi(28)+nor_flashtsi(40)+nor_flashtsi(52)+nor_flashtsi(64))/6
fdec=total(nor_flashtsi(5)+nor_flashtsi(17)+nor_flashtsi(29)+nor_flashtsi(41)+nor_flashtsi(53)+nor_flashtsi(65))/6
fjan=total(nor_flashtsi(6)+nor_flashtsi(18)+nor_flashtsi(30)+nor_flashtsi(42)+nor_flashtsi(54))/5
ffeb=total(nor_flashtsi(7)+nor_flashtsi(19)+nor_flashtsi(31)+nor_flashtsi(43)+nor_flashtsi(55))/5
fmar=total(nor_flashtsi(8)+nor_flashtsi(20)+nor_flashtsi(32)+nor_flashtsi(44)+nor_flashtsi(56))/5
fapr=total(nor_flashtsi(9)+nor_flashtsi(21)+nor_flashtsi(33)+nor_flashtsi(45)+nor_flashtsi(57))/5
fmay=total(nor_flashtsi(10)+nor_flashtsi(22)+nor_flashtsi(34)+nor_flashtsi(46)+nor_flashtsi(58))/5
fjun=total(nor_flashtsi(11)+nor_flashtsi(23)+nor_flashtsi(35)+nor_flashtsi(47)+nor_flashtsi(59))/5

avgnor_flashtsi=[fjul,faug,fsep,foct,fnov,fdec,fjan,ffeb,fmar,fapr,fmay,fjun]
monfmean=[avgnor_flashtsi,avgnor_flashtsi,avgnor_flashtsi,avgnor_flashtsi,avgnor_flashtsi,fjul,faug,fsep,foct,fnov,fdec]
anonor_flashtsi=nor_flashtsi-monfmean


;***************************************************************************************************
;RSW
;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FLASHFlux/timeseries/EBAF/CERES_EBAF-TOA_Ed2.6r_Subset_200003-201106.nc')
varid=ncdf_varid(cdfid, 'gtoa_sw_all_mon')
ncdf_varget,cdfid,varid, EBAF_rsw
ncdf_close, cdfid

;EBAF_rsw_overlap=EBAF_rsw[28:123]
EBAFflash_rsw_overlap=EBAF_rsw[84:131] ;3/2007-2/2011

result_EBAF=moment(EBAF_rsw,mdev=mean_dev_EBAF,sdev=std_EBAF)
help, result_EBAF
PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 
   
;***************************************************************************************************
;***************************************************************************************************
;open ceres FLASH file


restore, '/data/FLASHFlux/timeseries/corrected_flash.sav'
flashrsw_2G=float(corrected_flashrsw)
flashrsw_2G_overlap=float(corrected_flashrsw[8:55]) ;3/2007-2/2011
;close,1
result_flashrsw_2G=moment(flashrsw_2G,mdev=mean_dev_flashrsw_2G,sdev=std_flashrsw_2G)

;help, result_flashrsw_2G
;help, flashrsw_2G_overlap
;help, EBAFflash_rsw_overlap

PRINT, 'Mean: ', result_flashrsw_2G[0] & PRINT, 'Variance: ', result_flashrsw_2G[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_flashrsw_2G & Print, 'Standard Deviation:', std_flashrsw_2G 
   
;************************************************************************************************
 diff_EBAFflash = EBAFflash_rsw_overlap - flashrsw_2G_overlap
mean_diff_EBAFflash = mean(diff_EBAFflash)
print, 'OVERLAP STATISTICS'
print, 'mean EBAF:', mean(EBAFflash_rsw_overlap)
print, 'stddev EBAF:', stddev(EBAFflash_rsw_overlap)
print, 'mean flash:', mean(flashrsw_2G_overlap)
print, 'stddev flash:', stddev(flashrsw_2G_overlap)
flash_num = n_elements(flashrsw_2G)
print, 'flash_num:', flash_num
nor_flashrsw = fltarr(flash_num)
	for j=0L, flash_num-1L do begin
		nor_flashrsw(j) = flashrsw_2G(j) + mean_diff_EBAFflash
	endfor
result_nor_flashrsw=moment(nor_flashrsw,mdev=mean_dev_nor_flashrsw,sdev=std_nor_flashrsw)
help, result_nor_flashrsw
PRINT, 'Mean: ', result_nor_flashrsw[0] & PRINT, 'Variance: ', result_nor_flashrsw[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_nor_flashrsw & Print, 'Standard Deviation:', std_nor_flashrsw
;*************************************************************************************************
;Anomaly caluclation
;********************************
;EBAF rsw
;***************************
;get monthly average
maravgrsw=total(EBAF_rsw(0)+EBAF_rsw(12)+EBAF_rsw(24)+EBAF_rsw(36)+EBAF_rsw(48)+EBAF_rsw(60)+EBAF_rsw(72)+EBAF_rsw(84)+EBAF_rsw(96)+EBAF_rsw(108)+EBAF_rsw(120)+EBAF_rsw(132))/12
apravgrsw=total(EBAF_rsw(1)+EBAF_rsw(13)+EBAF_rsw(25)+EBAF_rsw(37)+EBAF_rsw(49)+EBAF_rsw(61)+EBAF_rsw(73)+EBAF_rsw(85)+EBAF_rsw(97)+EBAF_rsw(109)+EBAF_rsw(121)+EBAF_rsw(133))/12
mayavgrsw=total(EBAF_rsw(2)+EBAF_rsw(14)+EBAF_rsw(26)+EBAF_rsw(38)+EBAF_rsw(50)+EBAF_rsw(62)+EBAF_rsw(74)+EBAF_rsw(86)+EBAF_rsw(98)+EBAF_rsw(110)+EBAF_rsw(122)+EBAF_rsw(134))/12
junavgrsw=total(EBAF_rsw(3)+EBAF_rsw(15)+EBAF_rsw(27)+EBAF_rsw(39)+EBAF_rsw(51)+EBAF_rsw(63)+EBAF_rsw(75)+EBAF_rsw(87)+EBAF_rsw(99)+EBAF_rsw(111)+EBAF_rsw(123)+EBAF_rsw(135))/12
julavgrsw=total(EBAF_rsw(4)+EBAF_rsw(16)+EBAF_rsw(28)+EBAF_rsw(40)+EBAF_rsw(52)+EBAF_rsw(64)+EBAF_rsw(76)+EBAF_rsw(88)+EBAF_rsw(100)+EBAF_rsw(112)+EBAF_rsw(124))/11
augavgrsw=total(EBAF_rsw(5)+EBAF_rsw(17)+EBAF_rsw(29)+EBAF_rsw(41)+EBAF_rsw(53)+EBAF_rsw(65)+EBAF_rsw(77)+EBAF_rsw(89)+EBAF_rsw(101)+EBAF_rsw(113)+EBAF_rsw(125))/11
sepavgrsw=total(EBAF_rsw(6)+EBAF_rsw(18)+EBAF_rsw(30)+EBAF_rsw(42)+EBAF_rsw(54)+EBAF_rsw(66)+EBAF_rsw(78)+EBAF_rsw(90)+EBAF_rsw(102)+EBAF_rsw(114)+EBAF_rsw(126))/11
octavgrsw=total(EBAF_rsw(7)+EBAF_rsw(19)+EBAF_rsw(31)+EBAF_rsw(43)+EBAF_rsw(55)+EBAF_rsw(67)+EBAF_rsw(79)+EBAF_rsw(91)+EBAF_rsw(103)+EBAF_rsw(115)+EBAF_rsw(127))/11
novavgrsw=total(EBAF_rsw(8)+EBAF_rsw(20)+EBAF_rsw(32)+EBAF_rsw(44)+EBAF_rsw(56)+EBAF_rsw(68)+EBAF_rsw(80)+EBAF_rsw(92)+EBAF_rsw(104)+EBAF_rsw(116)+EBAF_rsw(128))/11
decavgrsw=total(EBAF_rsw(9)+EBAF_rsw(21)+EBAF_rsw(33)+EBAF_rsw(45)+EBAF_rsw(57)+EBAF_rsw(69)+EBAF_rsw(81)+EBAF_rsw(93)+EBAF_rsw(105)+EBAF_rsw(117)+EBAF_rsw(129))/11
janavgrsw=total(EBAF_rsw(10)+EBAF_rsw(22)+EBAF_rsw(34)+EBAF_rsw(46)+EBAF_rsw(58)+EBAF_rsw(70)+EBAF_rsw(82)+EBAF_rsw(94)+EBAF_rsw(106)+EBAF_rsw(118)+EBAF_rsw(130))/11
febavgrsw=total(EBAF_rsw(11)+EBAF_rsw(23)+EBAF_rsw(35)+EBAF_rsw(47)+EBAF_rsw(59)+EBAF_rsw(71)+EBAF_rsw(83)+EBAF_rsw(95)+EBAF_rsw(107)+EBAF_rsw(119)+EBAF_rsw(131))/11

avgrsw=[maravgrsw,apravgrsw,mayavgrsw,junavgrsw,julavgrsw,augavgrsw,sepavgrsw,octavgrsw,novavgrsw,decavgrsw,janavgrsw,febavgrsw]
tsavgrsw=[avgrsw,avgrsw,avgrsw,avgrsw,avgrsw,avgrsw,avgrsw,avgrsw,avgrsw,avgrsw,avgrsw,maravgrsw,apravgrsw,mayavgrsw,junavgrsw]
anoEBAF_rsw=EBAF_rsw-tsavgrsw

;*********************************
;FLASH rsw
;*********************************
;begin deseason
fjul=total(nor_flashrsw(0)+nor_flashrsw(12)+nor_flashrsw(24)+nor_flashrsw(36)+nor_flashrsw(48)+nor_flashrsw(60))/6
faug=total(nor_flashrsw(1)+nor_flashrsw(13)+nor_flashrsw(25)+nor_flashrsw(37)+nor_flashrsw(49)+nor_flashrsw(61))/6
fsep=total(nor_flashrsw(2)+nor_flashrsw(14)+nor_flashrsw(26)+nor_flashrsw(38)+nor_flashrsw(50)+nor_flashrsw(62))/6
foct=total(nor_flashrsw(3)+nor_flashrsw(15)+nor_flashrsw(27)+nor_flashrsw(39)+nor_flashrsw(51)+nor_flashrsw(63))/6
fnov=total(nor_flashrsw(4)+nor_flashrsw(16)+nor_flashrsw(28)+nor_flashrsw(40)+nor_flashrsw(52)+nor_flashrsw(64))/6
fdec=total(nor_flashrsw(5)+nor_flashrsw(17)+nor_flashrsw(29)+nor_flashrsw(41)+nor_flashrsw(53)+nor_flashrsw(65))/6
fjan=total(nor_flashrsw(6)+nor_flashrsw(18)+nor_flashrsw(30)+nor_flashrsw(42)+nor_flashrsw(54))/5
ffeb=total(nor_flashrsw(7)+nor_flashrsw(19)+nor_flashrsw(31)+nor_flashrsw(43)+nor_flashrsw(55))/5
fmar=total(nor_flashrsw(8)+nor_flashrsw(20)+nor_flashrsw(32)+nor_flashrsw(44)+nor_flashrsw(56))/5
fapr=total(nor_flashrsw(9)+nor_flashrsw(21)+nor_flashrsw(33)+nor_flashrsw(45)+nor_flashrsw(57))/5
fmay=total(nor_flashrsw(10)+nor_flashrsw(22)+nor_flashrsw(34)+nor_flashrsw(46)+nor_flashrsw(58))/5
fjun=total(nor_flashrsw(11)+nor_flashrsw(23)+nor_flashrsw(35)+nor_flashrsw(47)+nor_flashrsw(59))/5

avgnor_flashrsw=[fjul,faug,fsep,foct,fnov,fdec,fjan,ffeb,fmar,fapr,fmay,fjun]
monfmean=[avgnor_flashrsw,avgnor_flashrsw,avgnor_flashrsw,avgnor_flashrsw,avgnor_flashrsw,fjul,faug,fsep,foct,fnov,fdec]
anonor_flashrsw=nor_flashrsw-monfmean

anoEBAF_tsi_rsw = anoEBAF_tsi - anoEBAF_rsw
;print, 'EBAF TSI-RSW anomaly:'
;for i=0,129 do begin
;print, anoEBAF_tsi_rsw(i)
;endfor

anonor_flashtsi_flashrsw = anonor_flashtsi - anonor_flashrsw
print, 'FLASH TSI-RSW anomaly:'
for i=30,58 do begin
print, anonor_flashtsi_flashrsw(i)
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

 PLOT, timeline, zeros, ytitle='Absorbed Solar(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-2,2],Xrange=[2451605,2455900],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12,$;, XTICKFORMAT='LABEL_DATE', xtitle='Time', $
 Title='Timeseries of Monthly Anomaly Absorbed Solar(TSI-RSW)', charsize=1.2
 ;oplot, timeceres, anoceres, color=blue, psym=-4
 oplot,timeflash,anonor_flashtsi_flashrsw(30:65),color=blue,psym=-4
 oplot,time, anoEBAF_tsi_rsw, color=red,psym=-4
 
xyouts, 2454810,1.8, 'CERESLite_EBAF', color=red, charsize=1.5, charthick=1.5
;xyouts, 2454810,1.6, 'CERESLite_Aqua (Normalized)', color=blue, charsize=1.5, charthick=1.5
xyouts, 2454810,1.4, 'FLASHFlux (Normalized)', color=blue, charsize=1.5, charthick=1.5

fNamePlotOut='/data/FLASHFlux/timeseries/soc_2011/anomaly_absorbed'
  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
END
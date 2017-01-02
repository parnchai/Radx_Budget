pro anomaly_net
;Comparing timeseries net anamoly for CERES-lite, Flash, and AIRS
;open ceres file [March 2000 - Dec 2010]
;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FLASHFlux/timeseries/EBAF/CERES_EBAF-TOA_Ed2.6r_Subset_200003-201106.nc')
varid=ncdf_varid(cdfid, 'gtoa_net_all_mon')
ncdf_varget,cdfid,varid, EBAF_net
ncdf_close, cdfid

EBAFflash_net_overlap=EBAF_net[84:131] ;3/2007-2/2011

result_EBAF=moment(EBAF_net,mdev=mean_dev_EBAF,sdev=std_EBAF)
help, result_EBAF
PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 
   
;***************************************************************************************************
;***************************************************************************************************
;open ceres FLASH file


restore, '/data/FLASHFlux/timeseries/corrected_flash.sav'
flashnet_2G=float(corrected_flashnet)
flashnet_2G_overlap=float(corrected_flashnet[8:55]) ;overlap 3/2007 - 2/2011
result_flashnet_2G=moment(flashnet_2G,mdev=mean_dev_flashnet_2G,sdev=std_flashnet_2G)

PRINT, 'Mean: ', result_flashnet_2G[0] & PRINT, 'Variance: ', result_flashnet_2G[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_flashnet_2G & Print, 'Standard Deviation:', std_flashnet_2G 
   
;************************************************************************************************
 diff_EBAFflash = EBAFflash_net_overlap - flashnet_2G_overlap
mean_diff_EBAFflash = mean(diff_EBAFflash)
print, 'OVERLAP STATISTICS'
print, 'mean EBAF:', mean(EBAFflash_net_overlap)
print, 'stddev EBAF:', stddev(EBAFflash_net_overlap)
print, 'mean flash:', mean(flashnet_2G_overlap)
print, 'stddev flash:', stddev(flashnet_2G_overlap)
flash_num = n_elements(flashnet_2G)
print, 'flash_num:', flash_num
nor_flashnet = fltarr(flash_num)
	for j=0L, flash_num-1L do begin
		nor_flashnet(j) = flashnet_2G(j) + mean_diff_EBAFflash
	endfor
result_nor_flashnet=moment(nor_flashnet,mdev=mean_dev_nor_flashnet,sdev=std_nor_flashnet)
help, result_nor_flashnet
PRINT, 'Mean: ', result_nor_flashnet[0] & PRINT, 'Variance: ', result_nor_flashnet[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_nor_flashnet & Print, 'Standard Deviation:', std_nor_flashnet
;*************************************************************************************************
;Anomaly caluclation
;********************************
;EBAF NET
;***************************
;get monthly average
maravgnet=total(EBAF_net(0)+EBAF_net(12)+EBAF_net(24)+EBAF_net(36)+EBAF_net(48)+EBAF_net(60)+EBAF_net(72)+EBAF_net(84)+EBAF_net(96)+EBAF_net(108)+EBAF_net(120)+EBAF_net(132))/12
apravgnet=total(EBAF_net(1)+EBAF_net(13)+EBAF_net(25)+EBAF_net(37)+EBAF_net(49)+EBAF_net(61)+EBAF_net(73)+EBAF_net(85)+EBAF_net(97)+EBAF_net(109)+EBAF_net(121)+EBAF_net(133))/12
mayavgnet=total(EBAF_net(2)+EBAF_net(14)+EBAF_net(26)+EBAF_net(38)+EBAF_net(50)+EBAF_net(62)+EBAF_net(74)+EBAF_net(86)+EBAF_net(98)+EBAF_net(110)+EBAF_net(122)+EBAF_net(134))/12
junavgnet=total(EBAF_net(3)+EBAF_net(15)+EBAF_net(27)+EBAF_net(39)+EBAF_net(51)+EBAF_net(63)+EBAF_net(75)+EBAF_net(87)+EBAF_net(99)+EBAF_net(111)+EBAF_net(123)+EBAF_net(135))/12
julavgnet=total(EBAF_net(4)+EBAF_net(16)+EBAF_net(28)+EBAF_net(40)+EBAF_net(52)+EBAF_net(64)+EBAF_net(76)+EBAF_net(88)+EBAF_net(100)+EBAF_net(112)+EBAF_net(124))/11
augavgnet=total(EBAF_net(5)+EBAF_net(17)+EBAF_net(29)+EBAF_net(41)+EBAF_net(53)+EBAF_net(65)+EBAF_net(77)+EBAF_net(89)+EBAF_net(101)+EBAF_net(113)+EBAF_net(125))/11
sepavgnet=total(EBAF_net(6)+EBAF_net(18)+EBAF_net(30)+EBAF_net(42)+EBAF_net(54)+EBAF_net(66)+EBAF_net(78)+EBAF_net(90)+EBAF_net(102)+EBAF_net(114)+EBAF_net(126))/11
octavgnet=total(EBAF_net(7)+EBAF_net(19)+EBAF_net(31)+EBAF_net(43)+EBAF_net(55)+EBAF_net(67)+EBAF_net(79)+EBAF_net(91)+EBAF_net(103)+EBAF_net(115)+EBAF_net(127))/11
novavgnet=total(EBAF_net(8)+EBAF_net(20)+EBAF_net(32)+EBAF_net(44)+EBAF_net(56)+EBAF_net(68)+EBAF_net(80)+EBAF_net(92)+EBAF_net(104)+EBAF_net(116)+EBAF_net(128))/11
decavgnet=total(EBAF_net(9)+EBAF_net(21)+EBAF_net(33)+EBAF_net(45)+EBAF_net(57)+EBAF_net(69)+EBAF_net(81)+EBAF_net(93)+EBAF_net(105)+EBAF_net(117)+EBAF_net(129))/11
janavgnet=total(EBAF_net(10)+EBAF_net(22)+EBAF_net(34)+EBAF_net(46)+EBAF_net(58)+EBAF_net(70)+EBAF_net(82)+EBAF_net(94)+EBAF_net(106)+EBAF_net(118)+EBAF_net(130))/11
febavgnet=total(EBAF_net(11)+EBAF_net(23)+EBAF_net(35)+EBAF_net(47)+EBAF_net(59)+EBAF_net(71)+EBAF_net(83)+EBAF_net(95)+EBAF_net(107)+EBAF_net(119)+EBAF_net(131))/11

avgnet=[maravgnet,apravgnet,mayavgnet,junavgnet,julavgnet,augavgnet,sepavgnet,octavgnet,novavgnet,decavgnet,janavgnet,febavgnet]
tsavgnet=[avgnet,avgnet,avgnet,avgnet,avgnet,avgnet,avgnet,avgnet,avgnet,avgnet,avgnet,maravgnet,apravgnet,mayavgnet,junavgnet]
anoEBAF_net=EBAF_net-tsavgnet

;*********************************
;FLASH NET
;*********************************
;begin deseason
fjul=total(nor_flashnet(0)+nor_flashnet(12)+nor_flashnet(24)+nor_flashnet(36)+nor_flashnet(48)+nor_flashnet(60))/6
faug=total(nor_flashnet(1)+nor_flashnet(13)+nor_flashnet(25)+nor_flashnet(37)+nor_flashnet(49)+nor_flashnet(61))/6
fsep=total(nor_flashnet(2)+nor_flashnet(14)+nor_flashnet(26)+nor_flashnet(38)+nor_flashnet(50)+nor_flashnet(62))/6
foct=total(nor_flashnet(3)+nor_flashnet(15)+nor_flashnet(27)+nor_flashnet(39)+nor_flashnet(51)+nor_flashnet(63))/6
fnov=total(nor_flashnet(4)+nor_flashnet(16)+nor_flashnet(28)+nor_flashnet(40)+nor_flashnet(52)+nor_flashnet(64))/6
fdec=total(nor_flashnet(5)+nor_flashnet(17)+nor_flashnet(29)+nor_flashnet(41)+nor_flashnet(53)+nor_flashnet(65))/6
fjan=total(nor_flashnet(6)+nor_flashnet(18)+nor_flashnet(30)+nor_flashnet(42)+nor_flashnet(54))/5
ffeb=total(nor_flashnet(7)+nor_flashnet(19)+nor_flashnet(31)+nor_flashnet(43)+nor_flashnet(55))/5
fmar=total(nor_flashnet(8)+nor_flashnet(20)+nor_flashnet(32)+nor_flashnet(44)+nor_flashnet(56))/5
fapr=total(nor_flashnet(9)+nor_flashnet(21)+nor_flashnet(33)+nor_flashnet(45)+nor_flashnet(57))/5
fmay=total(nor_flashnet(10)+nor_flashnet(22)+nor_flashnet(34)+nor_flashnet(46)+nor_flashnet(58))/5
fjun=total(nor_flashnet(11)+nor_flashnet(23)+nor_flashnet(35)+nor_flashnet(47)+nor_flashnet(59))/5

avgnor_flashnet=[fjul,faug,fsep,foct,fnov,fdec,fjan,ffeb,fmar,fapr,fmay,fjun]
monfmean=[avgnor_flashnet,avgnor_flashnet,avgnor_flashnet,avgnor_flashnet,avgnor_flashnet,fjul,faug,fsep,foct,fnov,fdec]
anonor_flashnet=nor_flashnet-monfmean

;print, 'EBAF NET anomaly:'
;for i=0,129 do begin
;print, anoEBAF_net(i)
;endfor

print, 'FLASH NET anomaly:'
for i=30,58 do begin
print, anonor_flashnet(i)
endfor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
; Create format strings for a two-level axis:  
;dummy = LABEL_DATE(DATE_FORMAT=['%Y'])  
;time = findgen(ndata) 
time = TIMEGEN(136, UNITS="Months", START=JULDAY(3,1,2000))
;timeceres=TIMEGEN(93, UNITS="Months", START=JULDAY(7,1,2002))
timeflash=TIMEGEN(36, UNITS="Months", START=JULDAY(1,1,2009))
;timeflash=TIMEGEN(59, UNITS="Months", START=JULDAY(7,1,2006))
timeline= TIMEGEN(140, UNITS="Months", START=JULDAY(3,1,2000))
zeros=intarr(140)

;plot, time, flash_net, color=black, background=white
; Generate the Date/Time data  

;TIMEGEN(118, Units='Months')  
 PLOT, timeline, zeros, ytitle='NET(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-2,2],Xrange=[2451605,2455900],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12,$;, XTICKFORMAT='LABEL_DATE', xtitle='Time', $
 Title='Timeseries of Monthly Anomaly NET(absored SW - OLR)', charsize=1.2
 ;oplot, timeceres, anoceres, color=blue, psym=-4
 oplot,timeflash,anonor_flashnet(30:65),color=blue,psym=-4
 oplot,time, anoEBAF_net, color=red,psym=-4
 
xyouts, 2454810,1.8, 'CERESLite_EBAF', color=red, charsize=1.5, charthick=1.5
;xyouts, 2454810,1.6, 'CERESLite_Aqua (Normalized)', color=blue, charsize=1.5, charthick=1.5
xyouts, 2454810,1.4, 'FLASHFlux (Normalized)', color=blue, charsize=1.5, charthick=1.5

fNamePlotOut='/data/FLASHFlux/timeseries/soc_2011/anomaly_net'
  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
END
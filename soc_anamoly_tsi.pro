pro soc_anamoly_tsi

;Comparing timeseries tsi anamoly for CERES-lite, Flash, and AIRS
;open ceres file [March 2000 - Feb 2010]
;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.6r_Subset_200003-201206.nc')
varid=ncdf_varid(cdfid, 'gsolar_mon')
ncdf_varget,cdfid,varid, EBAF_tsi
ncdf_close, cdfid

;For consistent data set of EBAf - need to start from July 2002
;EBAF_tsi = EBAF_tsi[28:147]

;EBAFflash_tsi_overlap=EBAF_tsi[84:119] ; July 2009 - Jun. 2012

EBAFflash_tsi_overlap=EBAF_tsi[112:147] ; July 2009 - Jun. 2012
result_EBAF=moment(EBAF_tsi,mdev=mean_dev_EBAF,sdev=std_EBAF)
help, result_EBAF
PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 
   
;**************************************************************************************************
;open ceres FLASH file


restore, '/data/FF/timeseries/corrected_flash.sav'
flashtsi_2G=float(corrected_flashinso)
flashtsi_2G_overlap=float(corrected_flashinso[36:71]) ;from 7/2009 to 6/2012


result_flashtsi_2G=moment(flashtsi_2G,mdev=mean_dev_flashtsi_2G,sdev=std_flashtsi_2G)

PRINT, 'Mean: ', result_flashtsi_2G[0] & PRINT, 'Variance: ', result_flashtsi_2G[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_flashtsi_2G & Print, 'Standard Deviation:', std_flashtsi_2G
;**************************************************************************************************

diff_EBAFflash = EBAFflash_tsi_overlap - flashtsi_2G_overlap
print, diff_EBAFflash
mean_diff_EBAFflash = mean(diff_EBAFflash)
x=indgen(36)
result_fit=linfit(x, diff_EBAFflash)
mean_overlap2009=mean(diff_EBAFflash[0:11]) ;7/2009-6/2010
mean_overlap2010=mean(diff_EBAFflash[12:23]) ;7/2010-6/2011
mean_overlap2011=mean(diff_EBAFflash[24:35]) ;7/2011-6/2012


mean_overlap = [mean_overlap2009,mean_overlap2010,mean_overlap2011]
mean_overlap_total = mean(mean_overlap)

two_sigma_overlap = 2*stddev(mean_overlap)
sigma_overlap = stddev(mean_overlap)


print,'3 years diff overlap:', mean_overlap_total, two_sigma_overlap, sigma_overlap
print, 'OVERLAP STATISTICS'
print, 'mean EBAF:', mean(EBAFflash_tsi_overlap)
print, 'stddev EBAF:', stddev(EBAFflash_tsi_overlap)
print, 'mean flash:', mean(flashtsi_2G_overlap)
print, 'stddev flash:', stddev(flashtsi_2G_overlap)

flash_num = n_elements(flashtsi_2G)
print, 'flahnum:', flash_num
nor_flashtsi = fltarr(flash_num)
nor_flashtsi_slope = fltarr(flash_num)
	for j=0L, flash_num-1L do begin
		nor_flashtsi(j) = flashtsi_2G(j) + mean_diff_EBAFflash
		if j lt 36 then begin
			nor_flashtsi_slope(j) = nor_flashtsi(j)
			endif else begin 
			nor_flashtsi_slope(j) = result_fit(1)*(j-36) + flashtsi_2G(j) + result_fit(0)
			endelse
	endfor
nor_flashtsi=nor_flashtsi_slope

;*************************************************************************************************
;added additional step sugeest by TAk and Paul to deseasonalized the timeseries
;rts = EBAF_tsi(48:119) - nor_flashtsi ;Subtract the entire FLASH timeseries with EBAF
rts = EBAF_tsi(112:147) - nor_flashtsi(36:71) ;Subtract just the overlapping timeseries
;print, 'RTS:', rts
;print, 'MEAN RTS:', mean(rts)
;Compute the mean climatology of the residual time series
jul_rts = [rts(0), rts(12), rts(24)]
aug_rts = [rts(1), rts(13), rts(25)]
sep_rts = [rts(2), rts(14), rts(26)]
oct_rts = [rts(3), rts(15), rts(27)]
nov_rts = [rts(4), rts(16), rts(28)]
dec_rts = [rts(5), rts(17), rts(29)]
jan_rts = [rts(6), rts(18), rts(30)]
feb_rts = [rts(7), rts(19), rts(31)]
mar_rts = [rts(8), rts(20), rts(32)]
apr_rts = [rts(9), rts(21), rts(33)]
may_rts = [rts(10), rts(22), rts(34)]
jun_rts = [rts(11), rts(23), rts(35)]

;jul_rts = [rts(0), rts(12), rts(24),rts(36), rts(48), rts(60)]
;aug_rts = [rts(1), rts(13), rts(25),rts(37), rts(49), rts(61)]
;sep_rts = [rts(2), rts(14), rts(26),rts(38), rts(50), rts(62)]
;oct_rts = [rts(3), rts(15), rts(27),rts(39), rts(51), rts(63)]
;nov_rts = [rts(4), rts(16), rts(28),rts(40), rts(52), rts(64)]
;dec_rts = [rts(5), rts(17), rts(29),rts(41), rts(53), rts(65)]
;jan_rts = [rts(6), rts(18), rts(30),rts(42), rts(54), rts(66)]
;feb_rts = [rts(7), rts(19), rts(31),rts(43), rts(55), rts(67)]
;mar_rts = [rts(8), rts(20), rts(32),rts(44), rts(56), rts(68)]
;apr_rts = [rts(9), rts(21), rts(33),rts(45), rts(57), rts(69)]
;may_rts = [rts(10), rts(22), rts(34),rts(46), rts(58), rts(70)]
;jun_rts = [rts(11), rts(23), rts(35),rts(47), rts(59), rts(71)]

jul_rts = mean(jul_rts)
aug_rts = mean(aug_rts)
sep_rts = mean(sep_rts)
oct_rts = mean(oct_rts)
nov_rts = mean(nov_rts)
dec_rts = mean(dec_rts)
jan_rts = mean(jan_rts)
feb_rts = mean(feb_rts)
mar_rts = mean(mar_rts)
apr_rts = mean(apr_rts)
may_rts = mean(may_rts)
jun_rts = mean(jun_rts)

mean_rts = [jul_rts,aug_rts,sep_rts,oct_rts,nov_rts,dec_rts,jan_rts,feb_rts,mar_rts,apr_rts,may_rts,jun_rts]
;print, 'Mean monthly rts:', mean_rts
mean_rtsall = [mean_rts,mean_rts, mean_rts,mean_rts,mean_rts, mean_rts, jul_rts,aug_rts,sep_rts,oct_rts,nov_rts,dec_rts]
nor_flashtsi = nor_flashtsi + mean_rtsall
check = EBAF_tsi(112:147) - nor_flashtsi(36:71) 
print, 'Check:', check
print, 'MEAN RTS:', mean(check)
;NOW the normalized FLASHFlux is ZERO compare to EBAF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

result_nor_flashtsi=moment(nor_flashtsi,mdev=mean_dev_nor_flashtsi,sdev=std_nor_flashtsi)

PRINT, 'Mean: ', result_nor_flashtsi[0] & PRINT, 'Variance: ', result_nor_flashtsi[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_nor_flashtsi & Print, 'Standard Deviation:', std_nor_flashtsi

;SET MERGE data
patch_tsi = [EBAF_tsi,flashtsi_2G[72:77]]

result_patch_tsi=moment(patch_tsi,mdev=mean_dev_patch_tsi,sdev=std_patch_tsi) ;Print mean

PRINT, 'Mean MERGE ', result_patch_tsi[0] & PRINT, 'Variance: ', result_patch_tsi[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_patch_tsi & Print, 'Standard Deviation:', std_patch_tsi

;Determine mean for each year of merge data
mean_2012=mean(patch_tsi[142:153])
mean_2011=mean(patch_tsi[130:141])
mean_2010=mean(patch_tsi[118:129])
mean_2009=mean(patch_tsi[106:117])
mean_2008=mean(patch_tsi[94:105])
mean_2007=mean(patch_tsi[82:93])
mean_2006=mean(patch_tsi[70:81])
mean_2005=mean(patch_tsi[58:69])
mean_2004=mean(patch_tsi[46:57])
mean_2003=mean(patch_tsi[34:45])
mean_2002=mean(patch_tsi[22:33])
mean_2001=mean(patch_tsi[10:21])
;***********************************************
;Determine climatology of merge data set
;***********************************************
mean_data_2008=[mean_2001,mean_2002,mean_2003,mean_2004,mean_2005,mean_2006,mean_2007,mean_2008]
mean_data_2009=[mean_data_2008, mean_2009]
mean_data_2010=[mean_data_2009, mean_2010]
mean_data_2011=[mean_data_2010, mean_2011]
mean_data_2012=[mean_data_2011, mean_2012]

;*************************************************
;Find 2 Sigma interannual variability
;**************************************************
two_sigma_2008=2*stddev(mean_data_2008)
two_sigma_2009=2*stddev(mean_data_2009)
two_sigma_2010=2*stddev(mean_data_2010)
two_sigma_2011=2*stddev(mean_data_2011)
two_sigma_2012=2*stddev(mean_data_2012)

;***************************************************
;Print stats to screen
;**************************************************8
print, '2012:', mean(mean_2012) & print, two_sigma_2012
print, '2011:', mean(mean_2011) & print, two_sigma_2011
print, '2008:', mean(mean_2008) & print, two_sigma_2008
;*************************
print, '2012 anomaly:', mean_2012-mean(mean_data_2011)
print, '2011 anomaly:', mean_2011-mean(mean_data_2010)
print, '2010 anomaly:', mean_2010-mean(mean_data_2009)
print, '2009 anomaly:', mean_2009-mean(mean_data_2008)
;*************************************************
print, '2012-2011:', mean_2012-mean_2011
print, '2011-2010:', mean_2011-mean_2010
print, '2010-2009:', mean_2010-mean_2009
print, '2009-2008:', mean_2009-mean_2008
;************************************************
result_patchtsi=moment(patch_tsi,mdev=mean_dev_patchtsi,sdev=std_patchtsi)
PRINT, 'Mean: ', result_patchtsi[0] & PRINT, 'Variance: ', result_patchtsi[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_patchtsi & Print, 'Standard Deviation:', std_patchtsi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin creating climatology
jan=[EBAF_tsi(10),EBAF_tsi(22),EBAF_tsi(34),EBAF_tsi(46),EBAF_tsi(58),EBAF_tsi(70),EBAF_tsi(82),EBAF_tsi(94),EBAF_tsi(106),EBAF_tsi(118), EBAF_tsi(130)]
feb=[EBAF_tsi(11),EBAF_tsi(23),EBAF_tsi(35),EBAF_tsi(47),EBAF_tsi(59),EBAF_tsi(71),EBAF_tsi(83),EBAF_tsi(95),EBAF_tsi(107),EBAF_tsi(119),EBAF_tsi(131)]
mar=[EBAF_tsi(12),EBAF_tsi(24),EBAF_tsi(36),EBAF_tsi(48),EBAF_tsi(60),EBAF_tsi(72),EBAF_tsi(84),EBAF_tsi(96),EBAF_tsi(108),EBAF_tsi(120),EBAF_tsi(132)]
apr=[EBAF_tsi(13),EBAF_tsi(25),EBAF_tsi(37),EBAF_tsi(49),EBAF_tsi(61),EBAF_tsi(73),EBAF_tsi(85),EBAF_tsi(97),EBAF_tsi(109),EBAF_tsi(121),EBAF_tsi(133)]
may=[EBAF_tsi(14),EBAF_tsi(26),EBAF_tsi(38),EBAF_tsi(50),EBAF_tsi(62),EBAF_tsi(74),EBAF_tsi(86),EBAF_tsi(98),EBAF_tsi(110),EBAF_tsi(122),EBAF_tsi(134)]
jun=[EBAF_tsi(15),EBAF_tsi(27),EBAF_tsi(39),EBAF_tsi(51),EBAF_tsi(63),EBAF_tsi(75),EBAF_tsi(87),EBAF_tsi(99),EBAF_tsi(111),EBAF_tsi(123),EBAF_tsi(135)]
jul=[EBAF_tsi(16),EBAF_tsi(28),EBAF_tsi(40),EBAF_tsi(52),EBAF_tsi(64),EBAF_tsi(76),EBAF_tsi(88),EBAF_tsi(100),EBAF_tsi(112),EBAF_tsi(124),EBAF_tsi(136)]
aug=[EBAF_tsi(17),EBAF_tsi(29),EBAF_tsi(41),EBAF_tsi(53),EBAF_tsi(65),EBAF_tsi(77),EBAF_tsi(89),EBAF_tsi(101),EBAF_tsi(113),EBAF_tsi(125),EBAF_tsi(137)]
sep=[EBAF_tsi(18),EBAF_tsi(30),EBAF_tsi(42),EBAF_tsi(54),EBAF_tsi(66),EBAF_tsi(78),EBAF_tsi(90),EBAF_tsi(102),EBAF_tsi(114),EBAF_tsi(126),EBAF_tsi(138)]
oct=[EBAF_tsi(19),EBAF_tsi(31),EBAF_tsi(43),EBAF_tsi(55),EBAF_tsi(67),EBAF_tsi(79),EBAF_tsi(91),EBAF_tsi(103),EBAF_tsi(115),EBAF_tsi(127),EBAF_tsi(139)]
nov=[EBAF_tsi(20),EBAF_tsi(32),EBAF_tsi(44),EBAF_tsi(56),EBAF_tsi(68),EBAF_tsi(80),EBAF_tsi(92),EBAF_tsi(104),EBAF_tsi(116),EBAF_tsi(128),EBAF_tsi(140)]
dec=[EBAF_tsi(21),EBAF_tsi(33),EBAF_tsi(45),EBAF_tsi(57),EBAF_tsi(69),EBAF_tsi(81),EBAF_tsi(93),EBAF_tsi(105),EBAF_tsi(117),EBAF_tsi(129),EBAF_tsi(141)]

maravg=moment(mar, sdev=marstd)
apravg=moment(apr, sdev=aprstd)
mayavg=moment(may, sdev=maystd)
junavg=moment(jun, sdev=junstd)
julavg=moment(jul, sdev=julstd)
augavg=moment(aug, sdev=augstd)
sepavg=moment(sep, sdev=sepstd)
octavg=moment(oct, sdev=octstd)
novavg=moment(nov, sdev=novstd)
decavg=moment(dec, sdev=decstd)
janavg=moment(jan, sdev=janstd)
febavg=moment(feb, sdev=febstd)

avgEBAF_tsi=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0)]
;stdEBAF_tsi=[julstd,augstd,sepstd,octstd,novstd,decstd]
ten_months=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
monmean=[avgEBAF_tsi,avgEBAF_tsi,avgEBAF_tsi,avgEBAF_tsi,avgEBAF_tsi,avgEBAF_tsi,avgEBAF_tsi,avgEBAF_tsi,avgEBAF_tsi,avgEBAF_tsi,avgEBAF_tsi,avgEBAF_tsi, ten_months]
help, monmean
anopatch_tsi=patch_tsi-monmean

anoEBAF=anopatch_tsi[0:147]
anoflash=anopatch_tsi[147:153]

result_anopatch=moment(anopatch_tsi, mdev=mean_dev_anopatch, sdev=std_anopatch)
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;WRITE TO FILE
openw,1,'/data/FF/timeseries/soc_2012/soc_2012_stats_tsi.txt'
printf,1, '','CERLite_EBAF', '','CERLite_Aqua','', 'FLASHFlux','', 'CERLite_EBAF+Aqua', '','CERLite_EBAF+FLASHFlux', '','Normalized'
printf,1, 'MEAN:',  result_EBAF[0], result_flashtsi_2G[0],$
 result_nor_flashtsi[0], result_anopatch[0], result_patchtsi[0] 
printf,1, 'Variance:',  result_EBAF[1], result_flashtsi_2G[1],$
 result_nor_flashtsi[1], result_anopatch[1], result_patchtsi[1]
Printf,1, 'Mean Absolute Deviation:', mean_dev_EBAF,mean_dev_flashtsi_2G,$
 mean_dev_nor_flashtsi, mean_dev_anopatch, mean_dev_patchtsi
Printf,1, 'Standard Deviation:', std_EBAF,std_flashtsi_2G,$
 std_nor_flashtsi, std_anopatch, std_patchtsi
close,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin FLASHFlux only anomaly analysis base on its own climatology
;		Flashflux data start on July 2006 - currently 78 data points to December 2012
;*********************************************************************************************

flash_jul=[nor_flashtsi(0), nor_flashtsi(12), nor_flashtsi(24), nor_flashtsi(36), nor_flashtsi(48), nor_flashtsi(60), nor_flashtsi(72)]
flash_aug=[nor_flashtsi(1), nor_flashtsi(13), nor_flashtsi(25), nor_flashtsi(37), nor_flashtsi(49), nor_flashtsi(61), nor_flashtsi(73)]
flash_sep=[nor_flashtsi(2), nor_flashtsi(14), nor_flashtsi(26), nor_flashtsi(38), nor_flashtsi(50), nor_flashtsi(62), nor_flashtsi(74)]
flash_oct=[nor_flashtsi(3), nor_flashtsi(15), nor_flashtsi(27), nor_flashtsi(39), nor_flashtsi(51), nor_flashtsi(63), nor_flashtsi(75)]
flash_nov=[nor_flashtsi(4), nor_flashtsi(16), nor_flashtsi(28), nor_flashtsi(40), nor_flashtsi(52), nor_flashtsi(64), nor_flashtsi(76)]
flash_dec=[nor_flashtsi(5), nor_flashtsi(17), nor_flashtsi(29), nor_flashtsi(41), nor_flashtsi(53), nor_flashtsi(65), nor_flashtsi(77)]
flash_jan=[nor_flashtsi(6), nor_flashtsi(18), nor_flashtsi(30), nor_flashtsi(42), nor_flashtsi(54), nor_flashtsi(66)]
flash_feb=[nor_flashtsi(7), nor_flashtsi(19), nor_flashtsi(31), nor_flashtsi(43), nor_flashtsi(55), nor_flashtsi(67)]
flash_mar=[nor_flashtsi(8), nor_flashtsi(20), nor_flashtsi(32), nor_flashtsi(44), nor_flashtsi(56), nor_flashtsi(68)]
flash_apr=[nor_flashtsi(9), nor_flashtsi(21), nor_flashtsi(33), nor_flashtsi(45), nor_flashtsi(57), nor_flashtsi(69)]
flash_may=[nor_flashtsi(10), nor_flashtsi(22), nor_flashtsi(34), nor_flashtsi(46), nor_flashtsi(58), nor_flashtsi(70)]
flash_jun=[nor_flashtsi(11), nor_flashtsi(23), nor_flashtsi(35), nor_flashtsi(47), nor_flashtsi(59), nor_flashtsi(71)]

f_mar=moment(flash_mar, sdev=flash_marstd)
f_apr=moment(flash_apr, sdev=flash_aprstd)
f_may=moment(flash_may, sdev=flash_maystd)
f_jun=moment(flash_jun, sdev=jflash_unstd)
f_jul=moment(flash_jul, sdev=flash_julstd)
f_aug=moment(flash_aug, sdev=flash_augstd)
f_sep=moment(flash_sep, sdev=flash_sepstd)
f_oct=moment(flash_oct, sdev=flash_octstd)
f_nov=moment(flash_nov, sdev=flash_novstd)
f_dec=moment(flash_dec, sdev=flash_decstd)
f_jan=moment(flash_jan, sdev=flash_janstd)
f_feb=moment(flash_feb, sdev=flash_febstd)
clim = [julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0),maravg(0),apravg(0),mayavg(0),junavg(0)]

avgflash = [f_jul(0), f_aug(0), f_sep(0), f_oct(0), f_nov(0), f_dec(0), f_jan(0), f_feb(0), f_mar(0), f_apr(0), f_may(0), f_jun(0)]
sevenmths = [f_jul(0), f_aug(0), f_sep(0), f_oct(0), f_nov(0), f_dec(0)]
fmthmean = [avgflash,avgflash,avgflash,avgflash,avgflash,avgflash,sevenmths]
patchmonmean = [clim,clim,clim,clim,clim,clim, julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
;aaflash_tsi = nor_flashtsi - fmthmean 
aaflash_tsi = nor_flashtsi - patchmonmean 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Original FLASH tsi anomalies with patch climatologies

print, 'clim:', clim
clim = [clim, clim, clim, clim, clim, clim, julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
orig_anom = flashtsi_2G - clim

;Slope linear fit
slope_anom = nor_flashtsi_slope - clim 

;Do the differences
diff_orig = orig_anom - anopatch_tsi(76:153)
diff_slope = slope_anom - anopatch_tsi(76:153)
diff_des = aaflash_tsi - anopatch_tsi(76:153) 

print,'2-Sigma of N&D overlap:',2*stddev(diff_des(36:71))
print,'2-Sigma of orig overlap:',2*stddev(diff_orig(36:71))
print,'2-Sigma of linearfit overlap:',2*stddev(diff_slope(36:71))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print, 'Mean Orginial FF:', mean(flashtsi_2G_overlap) 
print, 'Mean EBAF:', mean(EBAFflash_tsi_overlap)
;print, 'Mean Normalized FF:',
print, 'Mean FF (linear fit):', mean(nor_flashtsi_slope(36:71)) - result_fit(0)
print, 'Mean FF(N&D):',mean(nor_flashtsi(36:71)) 
;;;;;;;;;;;;;;;;;;;;;;;;;
;Plotting begin here!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gray='BFBFBF'XL  ; 907F7F
white='FFFFFF'XL
black='000000'XL
liteblue='ff9919'XL
green='00611C'XL
red='0000FF'XL
blue='FF0000'XL
pink='7F7FFF'XL
yellow='00FFFF'XL
orange='FFB000'XL
; Create format strings for a two-level axis:  
;dummy = LABEL_DATE(DATE_FORMAT=['%Y'])  
;time = findgen(ndata) 
time = TIMEGEN(153, UNITS="Months", START=JULDAY(3,1,2000))
timeaaf=TIMEGEN(78, UNITS="Months", START=JULDAY(7,1,2006))
timef=TIMEGEN(78, UNITS="Months", START=JULDAY(7,1,2009))
timeflash=TIMEGEN(7, UNITS="Months", START=JULDAY(6,1,2012))
timeline= TIMEGEN(200, UNITS="Months", START=JULDAY(1,1,2000))
timeairs = timegen(125, UNITS="Months", START=JULDAY(9,1,2002))
timenoaa=timegen(118, UNITS="months", start=JULDAY(3,1,2003))
timediff=timegen(47, UNITS="months", start=JULDAY(7,1,2009))
timenpp=timegen(12, UNITS="months", start=JULDAY(2,1,2012))
timeannual = timegen(12, Units="years", start=Julday(1,1,2001))

zeros=intarr(160)
y = replicate(mean_diff_EBAFflash, 200)
help, diff_EBAFflash
;x = indgen(40)
print, 'overlap slope:', linfit(x, diff_EBAFflash)
fitline = result_fit(0) + result_fit(1)*x

print, 'EBAF overlap:'
for ii=0L,35 do begin
	print, EBAFflash_tsi_overlap(ii)
endfor
print, 'FF(N&D) overlap:'
for ii=36,71 do begin
	print, nor_flashtsi(ii)
endfor

;PLOT absolute value
;plot, time, flash_tsi, color=black, background=white
; Generate the Date/Time data  

; PLOT, timeline, zeros, ytitle='tsi(w/m^2)', XTICKUNITS = ['Time'], Yrange=[225,250],Xrange=[2452500,2456000],$
; color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
; Title='Timeseries of Monthly tsi', charsize=1.2
;oplot, time, EBAF_tsi, color=red, psym=-4
; oplot, timeaaf,nor_flashtsi(36:77) , color=blue, psym=-2
 ;oplot, timeaaf, nor_flashtsi_slope(36:77), color=blue, psym=-4
 ;oplot, timenpp, npp_tsi, color=pink, psym=-2
 ;oplot, timenoaa, noaa, color=green, psym=-4
 
  
;xyouts, 2453810-50,247, 'NOAA', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2453810-250-50,247, '-<>', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2453810-50,245, 'Normalized FLASHFlux', color=blue, charsize=1.5, charthick=1.5 
;xyouts, 2453810-250-50,245, '-*', color=blue, charsize=1.5, charthick=1.5
;xyouts, 2454810-50,247, 'NPP', color=pink, charsize=1.5, charthick=1.5 
;xyouts, 2454810-250-50,247, '-*', color=pink, charsize=1.5, charthick=1.5
;xyouts, 2454810-50,245, 'CERES_EBAF', color=red, charsize=1.5, charthick=1.5
;xyouts, 2454810-200-50,245, '-<>', color=red, charsize=1.5, charthick=1.5
;xyouts, 2454810+600-50,245, 'Normalized FF with Slope', color=blue, charsize=1.5, charthick=1.5
;xyouts, 2454810+600-150-50,245, '-<>', color=blue, charsize=1.5, charthick=1.5

;fNamePlotOut='/data/FLASHFlux/timeseries/soc_2012/tsi'
; image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
!p.multi=[0,1,2,0,1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PLot Anomaly
;;;;;;;;;;;;;;;;;;
;TIMEGEN(118, Units='Months')  
 PLOT, timeline, zeros, ytitle='tsi(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-1.5,1.5],Xrange=[2454000,2456000],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Monthly Anomaly tsi', charsize=1.2

 oplot,timeflash,anoflash,color=blue, thick=2
  oplot,timeaaf,aaflash_tsi,color=blue,psym=-2
 oplot,time, anoEBAF, color=red, thick=2
 ;oplot, timediff, anopatch_tsi(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int, color=black, linestyle=2, thick=2
 ;oplot, timediff, anopatch_tsi(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int), color=black, linestyle=2, thick=2
 oplot, timeaaf, slope_anom, color=orange, psym=-4
oplot, timeaaf, orig_anom, color=green, psym=-4
; oplot, timenpp, anonpp_tsi,color=pink,psym=-2

xyouts, 2454510,-1, 'FF Original', color=green, charsize=1.5, charthick=1.5 
xyouts, 2454510-150,-1, '-<>', color=green, charsize=1.5, charthick=1.5 
xyouts, 2454510,-1.2, 'FF Normalized and Deseasonalized ', color=blue, charsize=1.5, charthick=1.5 
xyouts, 2454510-150,-1.2, '-*', color=blue, charsize=1.5, charthick=1.5
xyouts, 2454510,-1.4, 'FF Normalized (linear fit) ', color=orange, charsize=1.5, charthick=1.5 
xyouts, 2454510-150,-1.4, '-<>', color=orange, charsize=1.5, charthick=1.5
xyouts, 2454510,-1.6, 'CERES_EBAF', color=red, charsize=1.5, charthick=1.5
xyouts, 2454510-150,-1.6, '-', color=red, charsize=1.5, charthick=1.5
xyouts, 2454650+170,-1.6, '+ FLASHFlux', color=blue, charsize=1.5, charthick=1.5
xyouts, 2454510-130+10,-1.6, '-', color=blue, charsize=1.5, charthick=1.5

;xyouts, 2455000, -1.6, '2-sigma overlap:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+175, -1.6, two_sigma_overlap, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -1.8, '2-sigma overlap slope:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+275, -1.8, 2*sigma_slope, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2, '2-sigma overlap int:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2, 2*sigma_int, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2.2, '2-sigma timeseries:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2.2, 2*std_anopatch, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, 2.0, 'Trend adjustment', color=black, charthick=1.5, charsize=1.5

  

 PLOT, timeline, zeros, ytitle='tsi(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-1.5,1.5],Xrange=[2454000,2456000],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Monthly Anomaly tsi', charsize=1.2

; oplot,timeflash,anoflash,color=blue, thick=2
  oplot,timeaaf,diff_des,color=blue,psym=-2
 ;oplot,time, anoEBAF, color=red, thick=2
 ;oplot, timediff, anopatch_tsi(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int, color=black, linestyle=2, thick=2
 ;oplot, timediff, anopatch_tsi(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int), color=black, linestyle=2, thick=2
 oplot, timeaaf, diff_slope, color=orange, psym=-4
oplot, timeaaf, diff_orig, color=green, psym=-4
 ;oplot, timenpp, anonpp_tsi,color=pink,psym=-2

xyouts, 2454510,-1.0, 'Original', color=green, charsize=1.5, charthick=1.5 
xyouts, 2454510-150,-1.0, '-<>', color=green, charsize=1.5, charthick=1.5 
xyouts, 2454510,-1.2, 'Normalized and Deseasonalized ', color=blue, charsize=1.5, charthick=1.5 
xyouts, 2454510-150,-1.2, '-*', color=blue, charsize=1.5, charthick=1.5
xyouts, 2454510,-1.4, 'Normalized (linear fit) ', color=orange, charsize=1.5, charthick=1.5 
xyouts, 2454510-150,-1.4, '-<>', color=orange, charsize=1.5, charthick=1.5

;xyouts, 2455000, -1.6, '2-sigma overlap:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+175, -1.6, two_sigma_overlap, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -1.8, '2-sigma overlap slope:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+275, -1.8, 2*sigma_slope, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2, '2-sigma overlap int:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2, 2*sigma_int, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2.2, '2-sigma timeseries:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2.2, 2*std_anopatch, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, 2.0, 'Trend adjustment', color=black, charthick=1.5, charsize=1.5

 fNamePlotOut='/data/FF/timeseries/soc_2012/deseason_tsi'
  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
  
!p.multi=[0,1,1,0,1]
zeros=replicate(339.9,10000)
 PLOT, timeline, zeros, ytitle='TSI(Wm^-2)', XTICKUNITS = ['Time'], Yrange=[339.5,340.5],Xrange=[2452000,2456000],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Yearly TSI', charsize=1.2
for mm=0L, 11 do print, 'annual:', mean_data_2012(mm)

  oplot,timeannual,mean_data_2012,color=blue,psym=-2
  ;errplot, timeannual, mean_data_2012-interann, mean_data_2012+interann, color=red

fNamePlotOut='/data/FF/timeseries/soc_2012/annual_TSI'
  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
  
save, anopatch_tsi, patch_tsi, anoflash, anoEBAF, nor_flashtsi, EBAF_tsi,aaflash_tsi, filename='/data/FF/timeseries/soc2012_tsi.dat'
END
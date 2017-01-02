pro soc_anamoly_rsw

;Open EBAF versin 2.7
;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.7_Subset_200003-201302.nc')
varid=ncdf_varid(cdfid, 'gtoa_sw_all_mon')
ncdf_varget,cdfid,varid, EBAF27_rsw
ncdf_close, cdfid
help, EBAF27_rsw
result_EBAF=moment(EBAF27_rsw,mdev=mean_dev_EBAF,sdev=std_EBAF)

PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 
   
;Comparing timeseries rsw anamoly for CERES-lite, Flash, and AIRS
;open ceres file [March 2000 - Feb 2010]

;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.6r_Subset_200003-201206.nc')
varid=ncdf_varid(cdfid, 'gtoa_sw_all_mon')
ncdf_varget,cdfid,varid, EBAF_rsw
ncdf_close, cdfid

;For consistent data set of EBAF - need to start form july 2002
;EBAF_rsw = EBAF_rsw[28:147]
;EBAFflash_rsw_overlap=EBAF_rsw[84:119] ;7/2009-6/2012

EBAFflash_rsw_overlap=EBAF_rsw[112:147] ; July 2009 - Jun. 2012

result_EBAF=moment(EBAF_rsw,mdev=mean_dev_EBAF,sdev=std_EBAF)

PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 

;***************************************************************************************************
;***************************************************************************************************
;open ceres FLASH file




restore, '/data/FF/timeseries/corrected_flash.sav'
flashrsw_2G=float(corrected_flashrsw)
flashrsw_2G_overlap=float(corrected_flashrsw[36:71]) ;from 7/2009 to 6/2012



result_flashrsw_2G=moment(flashrsw_2G,mdev=mean_dev_flashrsw_2G,sdev=std_flashrsw_2G)

PRINT, 'Mean: ', result_flashrsw_2G[0] & PRINT, 'Variance: ', result_flashrsw_2G[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_flashrsw_2G & Print, 'Standard Deviation:', std_flashrsw_2G

;**********************************************************************************************

diff_EBAFflash = EBAFflash_rsw_overlap - flashrsw_2G_overlap
mean_diff_EBAFflash = mean(diff_EBAFflash)
x=indgen(36)
result_fit=linfit(x, diff_EBAFflash)

;mean_overlap2007=mean(diff_EBAFflash[0:11]) ;3/2007-2/2008
;mean_overlap2008=mean(diff_EBAFflash[12:23]) ;3/2008-2/2009
mean_overlap2009=mean(diff_EBAFflash[0:11]) ;7/2009-6/2010
mean_overlap2010=mean(diff_EBAFflash[12:23]) ;7/2010-6/2011
mean_overlap2011=mean(diff_EBAFflash[24:35]) ;7/2011-6/2012


mean_overlap = [mean_overlap2009,mean_overlap2010,mean_overlap2011]
mean_overlap_total = mean(mean_overlap)

two_sigma_overlap = 2*stddev(mean_overlap)
sigma_overlap = stddev(mean_overlap)


print,'3 years diff overlap:', mean_overlap_total, two_sigma_overlap, sigma_overlap
print, 'OVERLAP STATISTICS'
print, 'mean EBAF:', mean(EBAFflash_rsw_overlap)
print, 'stddev EBAF:', stddev(EBAFflash_rsw_overlap)
print, 'mean flash:', mean(flashrsw_2G_overlap)
print, 'stddev flash:', stddev(flashrsw_2G_overlap)

flash_num = n_elements(flashrsw_2G)
print, 'flahnum:', flash_num
nor_flashrsw = fltarr(flash_num)
nor_flashrsw_slope = fltarr(flash_num)
	for j=0L, flash_num-1L do begin
		nor_flashrsw(j) = flashrsw_2G(j) + mean_diff_EBAFflash
		if j lt 36 then begin
			nor_flashrsw_slope(j) = nor_flashrsw(j)
			endif else begin 
			nor_flashrsw_slope(j) = result_fit(1)*(j-36) + flashrsw_2G(j) + result_fit(0)
			endelse
	endfor

nor_flashrsw=nor_flashrsw_slope

;*************************************************************************************************
;added additional step sugeest by TAk and Paul to deseasonalized the timeseries
;rts = EBAF_rsw(48:119) - nor_flashrsw ;Subtract the entire FLASH timeseries with EBAF
rts = EBAF_rsw(112:147) - nor_flashrsw(36:71) ;Subtract just the overlapping timeseries
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
nor_flashrsw = nor_flashrsw + mean_rtsall
check = EBAF_rsw(112:147) - nor_flashrsw(36:71) 
print, 'Check:', check
print, 'MEAN RTS:', mean(check)
;NOW the normalized FLASHFlux is ZERO compare to EBAF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

result_nor_flashrsw=moment(nor_flashrsw,mdev=mean_dev_nor_flashrsw,sdev=std_nor_flashrsw)
;diff_norflash = EBAFflash_rsw_overlap - nor_flashrsw(36:71) + mean_diff_EBAFflash
;diff_norflash_slope = EBAFflash_rsw_overlap - nor_flashrsw_slope(36:71) + mean_diff_EBAFflash
PRINT, 'Mean: ', result_nor_flashrsw[0] & PRINT, 'Variance: ', result_nor_flashrsw[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_nor_flashrsw & Print, 'Standard Deviation:', std_nor_flashrsw

;SET MERGE data
patch_rsw = [EBAF_rsw,nor_flashrsw[72:77]]


;Determine mean for each year of merge data
mean_2012=mean(patch_rsw[142:153])
mean_2011=mean(patch_rsw[130:141])
mean_2010=mean(patch_rsw[118:129])
mean_2009=mean(patch_rsw[106:117])
mean_2008=mean(patch_rsw[94:105])
mean_2007=mean(patch_rsw[82:93])
mean_2006=mean(patch_rsw[70:81])
mean_2005=mean(patch_rsw[58:69])
mean_2004=mean(patch_rsw[46:57])
mean_2003=mean(patch_rsw[34:45])
mean_2002=mean(patch_rsw[22:33])
mean_2001=mean(patch_rsw[10:21])
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
result_patchrsw=moment(patch_rsw,mdev=mean_dev_patchrsw,sdev=std_patchrsw)
PRINT, 'Mean: ', result_patchrsw[0] & PRINT, 'Variance: ', result_patchrsw[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_patchrsw & Print, 'Standard Deviation:', std_patchrsw


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin creating climatology for EBAF Ed2.7
jan=[EBAF27_rsw(10),EBAF27_rsw(22),EBAF27_rsw(34),EBAF27_rsw(46),EBAF27_rsw(58),EBAF27_rsw(70),EBAF27_rsw(82),EBAF27_rsw(94),EBAF27_rsw(106),EBAF27_rsw(118), EBAF27_rsw(130),EBAF27_rsw(142), EBAF27_rsw(154)]
feb=[EBAF27_rsw(11),EBAF27_rsw(23),EBAF27_rsw(35),EBAF27_rsw(47),EBAF27_rsw(59),EBAF27_rsw(71),EBAF27_rsw(83),EBAF27_rsw(95),EBAF27_rsw(107),EBAF27_rsw(119),EBAF27_rsw(131),EBAF27_rsw(143), EBAF27_rsw(155)]
mar=[EBAF27_rsw(12),EBAF27_rsw(24),EBAF27_rsw(36),EBAF27_rsw(48),EBAF27_rsw(60),EBAF27_rsw(72),EBAF27_rsw(84),EBAF27_rsw(96),EBAF27_rsw(108),EBAF27_rsw(120),EBAF27_rsw(132),EBAF27_rsw(144)]
apr=[EBAF27_rsw(13),EBAF27_rsw(25),EBAF27_rsw(37),EBAF27_rsw(49),EBAF27_rsw(61),EBAF27_rsw(73),EBAF27_rsw(85),EBAF27_rsw(97),EBAF27_rsw(109),EBAF27_rsw(121),EBAF27_rsw(133),EBAF27_rsw(145)]
may=[EBAF27_rsw(14),EBAF27_rsw(26),EBAF27_rsw(38),EBAF27_rsw(50),EBAF27_rsw(62),EBAF27_rsw(74),EBAF27_rsw(86),EBAF27_rsw(98),EBAF27_rsw(110),EBAF27_rsw(122),EBAF27_rsw(134),EBAF27_rsw(146)]
jun=[EBAF27_rsw(15),EBAF27_rsw(27),EBAF27_rsw(39),EBAF27_rsw(51),EBAF27_rsw(63),EBAF27_rsw(75),EBAF27_rsw(87),EBAF27_rsw(99),EBAF27_rsw(111),EBAF27_rsw(123),EBAF27_rsw(135),EBAF27_rsw(147)]
jul=[EBAF27_rsw(16),EBAF27_rsw(28),EBAF27_rsw(40),EBAF27_rsw(52),EBAF27_rsw(64),EBAF27_rsw(76),EBAF27_rsw(88),EBAF27_rsw(100),EBAF27_rsw(112),EBAF27_rsw(124),EBAF27_rsw(136),EBAF27_rsw(148)]
aug=[EBAF27_rsw(17),EBAF27_rsw(29),EBAF27_rsw(41),EBAF27_rsw(53),EBAF27_rsw(65),EBAF27_rsw(77),EBAF27_rsw(89),EBAF27_rsw(101),EBAF27_rsw(113),EBAF27_rsw(125),EBAF27_rsw(137),EBAF27_rsw(149)]
sep=[EBAF27_rsw(18),EBAF27_rsw(30),EBAF27_rsw(42),EBAF27_rsw(54),EBAF27_rsw(66),EBAF27_rsw(78),EBAF27_rsw(90),EBAF27_rsw(102),EBAF27_rsw(114),EBAF27_rsw(126),EBAF27_rsw(138),EBAF27_rsw(150)]
oct=[EBAF27_rsw(19),EBAF27_rsw(31),EBAF27_rsw(43),EBAF27_rsw(55),EBAF27_rsw(67),EBAF27_rsw(79),EBAF27_rsw(91),EBAF27_rsw(103),EBAF27_rsw(115),EBAF27_rsw(127),EBAF27_rsw(139),EBAF27_rsw(151)]
nov=[EBAF27_rsw(20),EBAF27_rsw(32),EBAF27_rsw(44),EBAF27_rsw(56),EBAF27_rsw(68),EBAF27_rsw(80),EBAF27_rsw(92),EBAF27_rsw(104),EBAF27_rsw(116),EBAF27_rsw(128),EBAF27_rsw(140),EBAF27_rsw(152)]
dec=[EBAF27_rsw(21),EBAF27_rsw(33),EBAF27_rsw(45),EBAF27_rsw(57),EBAF27_rsw(69),EBAF27_rsw(81),EBAF27_rsw(93),EBAF27_rsw(105),EBAF27_rsw(117),EBAF27_rsw(129),EBAF27_rsw(141),EBAF27_rsw(153)]

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

avgEBAF27_rsw=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0)]
;stdEBAF27_rsw=[julstd,augstd,sepstd,octstd,novstd,decstd]
ten_months=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
monmean=[avgEBAF27_rsw,avgEBAF27_rsw,avgEBAF27_rsw,avgEBAF27_rsw,avgEBAF27_rsw,avgEBAF27_rsw,avgEBAF27_rsw,avgEBAF27_rsw,avgEBAF27_rsw,avgEBAF27_rsw,avgEBAF27_rsw,avgEBAF27_rsw, avgEBAF27_rsw]

anoEBAF27_rsw = EBAF27_rsw - monmean
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin creating climatology
jan=[EBAF_rsw(10),EBAF_rsw(22),EBAF_rsw(34),EBAF_rsw(46),EBAF_rsw(58),EBAF_rsw(70),EBAF_rsw(82),EBAF_rsw(94),EBAF_rsw(106),EBAF_rsw(118), EBAF_rsw(130)]
feb=[EBAF_rsw(11),EBAF_rsw(23),EBAF_rsw(35),EBAF_rsw(47),EBAF_rsw(59),EBAF_rsw(71),EBAF_rsw(83),EBAF_rsw(95),EBAF_rsw(107),EBAF_rsw(119),EBAF_rsw(131)]
mar=[EBAF_rsw(12),EBAF_rsw(24),EBAF_rsw(36),EBAF_rsw(48),EBAF_rsw(60),EBAF_rsw(72),EBAF_rsw(84),EBAF_rsw(96),EBAF_rsw(108),EBAF_rsw(120),EBAF_rsw(132)]
apr=[EBAF_rsw(13),EBAF_rsw(25),EBAF_rsw(37),EBAF_rsw(49),EBAF_rsw(61),EBAF_rsw(73),EBAF_rsw(85),EBAF_rsw(97),EBAF_rsw(109),EBAF_rsw(121),EBAF_rsw(133)]
may=[EBAF_rsw(14),EBAF_rsw(26),EBAF_rsw(38),EBAF_rsw(50),EBAF_rsw(62),EBAF_rsw(74),EBAF_rsw(86),EBAF_rsw(98),EBAF_rsw(110),EBAF_rsw(122),EBAF_rsw(134)]
jun=[EBAF_rsw(15),EBAF_rsw(27),EBAF_rsw(39),EBAF_rsw(51),EBAF_rsw(63),EBAF_rsw(75),EBAF_rsw(87),EBAF_rsw(99),EBAF_rsw(111),EBAF_rsw(123),EBAF_rsw(135)]
jul=[EBAF_rsw(16),EBAF_rsw(28),EBAF_rsw(40),EBAF_rsw(52),EBAF_rsw(64),EBAF_rsw(76),EBAF_rsw(88),EBAF_rsw(100),EBAF_rsw(112),EBAF_rsw(124),EBAF_rsw(136)]
aug=[EBAF_rsw(17),EBAF_rsw(29),EBAF_rsw(41),EBAF_rsw(53),EBAF_rsw(65),EBAF_rsw(77),EBAF_rsw(89),EBAF_rsw(101),EBAF_rsw(113),EBAF_rsw(125),EBAF_rsw(137)]
sep=[EBAF_rsw(18),EBAF_rsw(30),EBAF_rsw(42),EBAF_rsw(54),EBAF_rsw(66),EBAF_rsw(78),EBAF_rsw(90),EBAF_rsw(102),EBAF_rsw(114),EBAF_rsw(126),EBAF_rsw(138)]
oct=[EBAF_rsw(19),EBAF_rsw(31),EBAF_rsw(43),EBAF_rsw(55),EBAF_rsw(67),EBAF_rsw(79),EBAF_rsw(91),EBAF_rsw(103),EBAF_rsw(115),EBAF_rsw(127),EBAF_rsw(139)]
nov=[EBAF_rsw(20),EBAF_rsw(32),EBAF_rsw(44),EBAF_rsw(56),EBAF_rsw(68),EBAF_rsw(80),EBAF_rsw(92),EBAF_rsw(104),EBAF_rsw(116),EBAF_rsw(128),EBAF_rsw(140)]
dec=[EBAF_rsw(21),EBAF_rsw(33),EBAF_rsw(45),EBAF_rsw(57),EBAF_rsw(69),EBAF_rsw(81),EBAF_rsw(93),EBAF_rsw(105),EBAF_rsw(117),EBAF_rsw(129),EBAF_rsw(141)]

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

avgEBAF_rsw=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0)]
;stdEBAF_rsw=[julstd,augstd,sepstd,octstd,novstd,decstd]
ten_months=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
monmean=[avgEBAF_rsw,avgEBAF_rsw,avgEBAF_rsw,avgEBAF_rsw,avgEBAF_rsw,avgEBAF_rsw,avgEBAF_rsw,avgEBAF_rsw,avgEBAF_rsw,avgEBAF_rsw,avgEBAF_rsw,avgEBAF_rsw, ten_months]
help, monmean
anopatch_rsw=patch_rsw-monmean

anoEBAF=anopatch_rsw[0:147]
anoflash=anopatch_rsw[147:153]

result_anopatch=moment(anopatch_rsw, mdev=mean_dev_anopatch, sdev=std_anopatch)
print, 'std_anopatch:', std_anopatch


;WRITE TO FILE
openw,1,'/data/FF/timeseries/soc_2012/soc_2012_stats_rsw.txt'
printf,1, '','CERLite_EBAF', '','', 'FLASHFlux','', '','Normalized Flashflux','','','Anomaly','','','CERLite_EBAF+FLASHFlux'
printf,1, 'MEAN:',  result_EBAF[0], result_flashrsw_2G[0],$
 result_nor_flashrsw[0], result_anopatch[0] , result_patchrsw[0]
printf,1, 'Variance:',  result_EBAF[1],  result_flashrsw_2G[1],$
 result_nor_flashrsw[1], result_anopatch[1], result_patchrsw[1]
Printf,1, 'Mean Absolute Deviation:', mean_dev_EBAF,mean_dev_flashrsw_2G,$
 mean_dev_nor_flashrsw, mean_dev_anopatch, mean_dev_patchrsw
Printf,1, 'Standard Deviation:', std_EBAF,std_flashrsw_2G,$
 std_nor_flashrsw, std_anopatch, std_patchrsw
close,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calculate mean anomaly differences between EBAF2.6r and EBAF 2.7. Also FF and EBAF2.7 for the last six months.
diff_anoEBAF = anoEBAF27_rsw[0:147] - anoEBAF
result_diffanoEBAF = moment(diff_anoEBAF, mdev=mean_dev_anopatch, sdev=std_anopatch)
print, 'EBAF2.7-E2.6r mean:', result_diffanoEBAF[0]
print, 'EBAF2.7-E2.6r Mean Absolute Deviation:', mean_dev_anopatch
print, 'EBAF2.7-E2.6r 2Sigma:', 2*std_anopatch
print, 'XxXXXXXXXXXXXXXXXxxxxxxxxxxxxxxxxxx'
diff_anoflash = anoEBAF27_rsw[147:153] - anoflash
result_diffanoflash = moment(diff_anoflash, mdev=mean_dev_anopatch, sdev=std_anopatch)
print, 'EBAF2.7-FF mean:', result_diffanoflash[0]
print, 'EBAF2.7-FF Mean Absolute Deviation:', mean_dev_anopatch
print, 'EBAF2.7-FF 2Sigma:', 2*std_anopatch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin FLASHFlux only anomaly analysis base on its own climatology
;		Flashflux data start on July 2006 - currently 78 data points to December 2012
;*********************************************************************************************

flash_jul=[nor_flashrsw(0), nor_flashrsw(12), nor_flashrsw(24), nor_flashrsw(36), nor_flashrsw(48), nor_flashrsw(60), nor_flashrsw(72)]
flash_aug=[nor_flashrsw(1), nor_flashrsw(13), nor_flashrsw(25), nor_flashrsw(37), nor_flashrsw(49), nor_flashrsw(61), nor_flashrsw(73)]
flash_sep=[nor_flashrsw(2), nor_flashrsw(14), nor_flashrsw(26), nor_flashrsw(38), nor_flashrsw(50), nor_flashrsw(62), nor_flashrsw(74)]
flash_oct=[nor_flashrsw(3), nor_flashrsw(15), nor_flashrsw(27), nor_flashrsw(39), nor_flashrsw(51), nor_flashrsw(63), nor_flashrsw(75)]
flash_nov=[nor_flashrsw(4), nor_flashrsw(16), nor_flashrsw(28), nor_flashrsw(40), nor_flashrsw(52), nor_flashrsw(64), nor_flashrsw(76)]
flash_dec=[nor_flashrsw(5), nor_flashrsw(17), nor_flashrsw(29), nor_flashrsw(41), nor_flashrsw(53), nor_flashrsw(65), nor_flashrsw(77)]
flash_jan=[nor_flashrsw(6), nor_flashrsw(18), nor_flashrsw(30), nor_flashrsw(42), nor_flashrsw(54), nor_flashrsw(66)]
flash_feb=[nor_flashrsw(7), nor_flashrsw(19), nor_flashrsw(31), nor_flashrsw(43), nor_flashrsw(55), nor_flashrsw(67)]
flash_mar=[nor_flashrsw(8), nor_flashrsw(20), nor_flashrsw(32), nor_flashrsw(44), nor_flashrsw(56), nor_flashrsw(68)]
flash_apr=[nor_flashrsw(9), nor_flashrsw(21), nor_flashrsw(33), nor_flashrsw(45), nor_flashrsw(57), nor_flashrsw(69)]
flash_may=[nor_flashrsw(10), nor_flashrsw(22), nor_flashrsw(34), nor_flashrsw(46), nor_flashrsw(58), nor_flashrsw(70)]
flash_jun=[nor_flashrsw(11), nor_flashrsw(23), nor_flashrsw(35), nor_flashrsw(47), nor_flashrsw(59), nor_flashrsw(71)]

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
;aaflash_rsw = nor_flashrsw - fmthmean 
aaflash_rsw = nor_flashrsw - patchmonmean 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Original FLASH rsw anomalies with patch climatologies

;print, 'clim:', clim
clim = [clim, clim, clim, clim, clim, clim, julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
orig_anom = flashrsw_2G - clim

;Slope linear fit
slope_anom = nor_flashrsw_slope - clim 

;Do the differences
diff_orig = orig_anom - anopatch_rsw(76:153)
diff_slope = slope_anom - anopatch_rsw(76:153)
diff_des = aaflash_rsw - anopatch_rsw(76:153) 

print,'2-Sigma of N&D overlap:',2*stddev(diff_des(36:71))
print,'2-Sigma of orig overlap:',2*stddev(diff_orig(36:71))
print,'2-Sigma of linearfit overlap:',2*stddev(diff_slope(36:71))
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;NPP - 10 months data
close,1

;open ceres FLASH file - Version 2G/2H
ndata=11
temp=''

nppdata=fltarr(6,ndata)
close,1
openr,1,'/data/FF/timeseries/npp.dat'
readf,1,temp
readf,1,nppdata
npp_rsw=fltarr(ndata)

npp_rsw=nppdata(3,*)
close,1
npp_monmean=[febavg(0),maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
anonpp_rsw=npp_rsw-npp_monmean
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calculate standard deviation of intercept and slope using the method describe in
;An introduction to Error Analysis by John R. Taylor pp 187-188
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Note: I already have sigma_y, aka sigma_overlap

delta = n_elements(diff_EBAFflash)*total(x^2)-total(x)^2
sigma_int = sigma_overlap * sqrt(total(x^2)/delta)
sigma_slope = sigma_overlap * sqrt(n_elements(diff_EBAFflash)/delta)

;print, 'sigma_int', 2*sigma_int
;print, 'sigma_slope', 2*sigma_slope

upper_rsw = 2*sigma_overlap+2*sigma_slope+2*sigma_int
lower_rsw = 2*sigma_overlap+2*sigma_slope+2*sigma_int

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;print, 'Mean Orginial FF:', mean(flashrsw_2G_overlap) 
;print, 'Mean EBAF:', mean(EBAFflash_rsw_overlap)
;print, 'Mean Normalized FF:',
;print, 'Mean FF (linear fit):', mean(nor_flashrsw_slope(36:71)) - result_fit(0)
;print, 'Mean FF(N&D):',mean(nor_flashrsw(36:71)) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;print, 'EBAF overlap:'
for ii=106,147 do begin
	;print, EBAF_rsw(ii)
endfor
;print, 'FF(N&D) overlap:'
for ii=30,71 do begin
	;print, nor_flashrsw(ii)
endfor

;Plotting begin here!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DEVICE, retain=2
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
time = TIMEGEN(156, UNITS="Months", START=JULDAY(3,1,2000))
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
;print, 'overlap slope:', linfit(x, diff_EBAFflash)
fitline = result_fit(0) + result_fit(1)*x
!p.multi=[0,1,2,0,1]
;PLOT absolute value
;plot, time, flash_net, color=black, background=white
; Generate the Date/Time data  

 PLOT, timeline, zeros, ytitle='rsw(w/m^2)', XTICKUNITS = ['Time'], Yrange=[75,125],Xrange=[2452500,2456000],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Monthly rsw', charsize=1.2
oplot, time, EBAF_rsw, color=red, psym=-4
oplot, time, EBAF27_rsw, color=green, thick=2
oplot, timef, flashrsw_2G, color=blue, thick=2
; oplot, timeaaf,nor_flashrsw(36:77) , color=blue, psym=-2
 ;oplot, timeaaf, nor_flashrsw_slope(36:77), color=blue, psym=-4
 ;oplot, timenpp, npp_rsw, color=pink, psym=-2
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

;fNamePlotOut='/data/FLASHFlux/timeseries/soc_2012/rsw'
; image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PLot Anomaly
;;;;;;;;;;;;;;;;;;
;TIMEGEN(118, Units='Months')  
 PLOT, timeline, zeros, ytitle='RSW(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-2.5,2.5],Xrange=[2451800,2456250],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Monthly Anomaly RSW', charsize=1.2

 oplot,timeflash,anoflash,color=blue, thick=2
 ; oplot,timeaaf,aaflash_rsw,color=blue,psym=-2
 oplot,time, anoEBAF, color=red, thick=2
 ;oplot, timediff, anopatch_rsw(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int, color=black, linestyle=2, thick=2
 ;oplot, timediff, anopatch_rsw(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int), color=black, linestyle=2, thick=2
; oplot, timeaaf, slope_anom, color=orange, psym=-4
oplot, time, anoEBAF27_rsw, color=green, thick=2
; oplot, timenpp, anonpp_rsw,color=pink,psym=-2

;xyouts, 2454510,-1.3, 'FF Original', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,-1.3, '-<>', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2454510,2.2, 'FF Normalized and Deseasonalized ', color=blue, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,2.2, '-*', color=blue, charsize=1.5, charthick=1.5
;xyouts, 2454510,1.7, 'FF Normalized (linear fit) ', color=orange, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,1.7, '-<>', color=orange, charsize=1.5, charthick=1.5
xyouts, 2454510,1.7, 'EBAF Ed2.7 ', color=green, charsize=1.5, charthick=1.5 
xyouts, 2454510-150,1.7, '-', color=green, charsize=1.5, charthick=1.5
xyouts, 2454510,2.0, 'CERES_EBAF', color=red, charsize=1.5, charthick=1.5
xyouts, 2454510-150,2.0, '-', color=red, charsize=1.5, charthick=1.5
xyouts, 2454650+220,2.0, '+ FLASHFlux', color=blue, charsize=1.5, charthick=1.5
xyouts, 2454510-130+10,2.0, '-', color=blue, charsize=1.5, charthick=1.5

;xyouts, 2455000, -1.6, '2-sigma overlap:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+175, -1.6, two_sigma_overlap, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -1.8, '2-sigma overlap slope:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+275, -1.8, 2*sigma_slope, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2, '2-sigma overlap int:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2, 2*sigma_int, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2.2, '2-sigma timeseries:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2.2, 2*std_anopatch, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, 2.0, 'Trend adjustment', color=black, charthick=1.5, charsize=1.5

  

; PLOT, timeline, zeros, ytitle='RSW(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-4.5,3.5],Xrange=[2454000,2456050],$
; color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
; Title='Timeseries of Monthly Anomaly RSW', charsize=1.2

; oplot,timeflash,anoflash,color=blue, thick=2
;  oplot,timeaaf,diff_des,color=blue,psym=-2
 ;oplot,time, anoEBAF, color=red, thick=2
 ;oplot, timediff, anopatch_rsw(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int, color=black, linestyle=2, thick=2
 ;oplot, timediff, anopatch_rsw(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int), color=black, linestyle=2, thick=2
; oplot, timeaaf, diff_slope, color=orange, psym=-4
;oplot, timeaaf, diff_orig, color=green, psym=-4
 ;oplot, timenpp, anonpp_rsw,color=pink,psym=-2

;xyouts, 2454510,-1.0, 'Original', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,-1.0, '-<>', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2454510,2.2, 'Normalized and Deseasonalized ', color=blue, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,2.2, '-*', color=blue, charsize=1.5, charthick=1.5
;xyouts, 2454510,1.7, 'Normalized (linear fit) ', color=orange, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,1.7, '-<>', color=orange, charsize=1.5, charthick=1.5

;xyouts, 2455000, -1.6, '2-sigma overlap:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+175, -1.6, two_sigma_overlap, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -1.8, '2-sigma overlap slope:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+275, -1.8, 2*sigma_slope, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2, '2-sigma overlap int:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2, 2*sigma_int, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2.2, '2-sigma timeseries:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2.2, 2*std_anopatch, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, 2.0, 'Trend adjustment', color=black, charthick=1.5, charsize=1.5

 fNamePlotOut='/data/FF/timeseries/soc_2012/deseason_RSW'
  image= cgsnapshot(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)

;!p.multi=[0,1,1,0,1]
;zeros=replicate(99.5,10000)
; PLOT, timeline, zeros, ytitle='RSW(Wm^-2)', XTICKUNITS = ['Time'], Yrange=[98.5,100.5],Xrange=[2452000,2456000],$
; color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
; Title='Timeseries of Yearly RSW', charsize=1.2


;  oplot,timeannual,mean_data_2012,color=blue,psym=-2
;  ;errplot, timeannual, mean_data_2012-interann, mean_data_2012+interann, color=red
;for mm=0L, 11 do print, 'annual:', mean_data_2012(mm)
;fNamePlotOut='/data/FF/timeseries/soc_2012/annual_RSW'
;  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
  
save, anopatch_rsw, patch_rsw, anoflash, anoEBAF, nor_flashrsw, EBAF_rsw, aaflash_rsw, upper_rsw, lower_rsw, filename='/data/FF/timeseries/soc2012_rsw.dat'
  
END
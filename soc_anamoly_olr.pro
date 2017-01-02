pro soc_anamoly_olr

;Open EBAF versin 2.7
;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.7_Subset_200003-201306.nc')
varid=ncdf_varid(cdfid, 'gtoa_lw_all_mon')
ncdf_varget,cdfid,varid, EBAF_olr
ncdf_close, cdfid
help, EBAF_olr

EBAF_olr_overlap = EBAF_olr(148:159)
;***************************************************************************************************
;open ceres FLASH file

close,1

;open ceres FLASH file - Version 3A
ndata=18
temp=''

flashdata=fltarr(8,ndata)
close,1
openr,1,'/data/FF/timeseries/Flashflux_glbmean/globe_pc_oblate_2013.txt'
readf,1,temp
readf,1,flashdata
flasholr=fltarr(ndata)

flasholr=flashdata(4,*)


flasholr_overlap=flasholr[0:11] ;7/2012 - 6/2013


;***************************************************************************************************


diff_EBAFflash = EBAFflash_olr_overlap - flasholr_2G_overlap
mean_diff_EBAFflash = mean(diff_EBAFflash)
print, 'mean diff bias:', mean_diff_EBAFflash
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
print, 'mean EBAF:', mean(EBAFflash_olr_overlap)
print, 'stddev EBAF:', stddev(EBAFflash_olr_overlap)
print, 'mean flash:', mean(flasholr_2G_overlap)
print, 'stddev flash:', stddev(flasholr_2G_overlap)

flash_num = n_elements(flasholr_2G)
print, 'flashnum:', flash_num
nor_flasholr = fltarr(flash_num)
nor_flasholr_slope = fltarr(flash_num)
	for j=0L, flash_num-1L do begin
		nor_flasholr(j) = flasholr_2G(j) + mean_diff_EBAFflash 
			
			if j lt 36 then begin
			nor_flasholr_slope(j) = nor_flasholr(j)
			endif else begin 
			nor_flasholr_slope(j) = result_fit(1)*(j-36) + flasholr_2G(j) + result_fit(0)
			endelse
	
	endfor

nor_flasholr=nor_flasholr_slope ;Normalize FLASHFlux to EBAF with slope trend adjusted


;diff_norflash = EBAFflash_olr_overlap - nor_flasholr(36:71) 
;diff_norflash_slope = EBAFflash_olr_overlap - nor_flasholr_slope(36:71) + mean_diff_EBAFflash 
;*************************************************************************************************
;added additional step sugeest by TAk and Paul to deseasonalized the timeseries
;rts = EBAF_olr(48:119) - nor_flasholr ;Subtract the entire FLASH timeseries with EBAF
rts = EBAF_olr(112:147) - nor_flasholr(36:71) ;Subtract just the overlapping timeseries
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
nor_flasholr = nor_flasholr + mean_rtsall
check = EBAF_olr(112:147) - nor_flasholr(36:71) 
print, 'Check:', check
print, 'MEAN RTS:', mean(check)
;NOW the normalized FLASHFlux is ZERO compare to EBAF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
result_nor_flasholr=moment(nor_flasholr,mdev=mean_dev_nor_flasholr,sdev=std_nor_flasholr) ;Print mean

PRINT, 'Mean nor_flash: ', result_nor_flasholr[0] & PRINT, 'Variance: ', result_nor_flasholr[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_nor_flasholr & Print, 'Standard Deviation:', std_nor_flasholr

;SET MERGE data
patch_olr = [EBAF_olr,nor_flasholr[72:77]]
help, patch_olr
result_patch_olr=moment(patch_olr,mdev=mean_dev_patch_olr,sdev=std_patch_olr) ;Print mean

PRINT, 'Mean MERGE ', result_patch_olr[0] & PRINT, 'Variance: ', result_patch_olr[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_patch_olr & Print, 'Standard Deviation:', std_patch_olr

;Determine mean for each year of merge data
mean_2012=mean(patch_olr[142:153])
mean_2011=mean(patch_olr[130:141])
mean_2010=mean(patch_olr[118:129])
mean_2009=mean(patch_olr[106:117])
mean_2008=mean(patch_olr[94:105])
mean_2007=mean(patch_olr[82:93])
mean_2006=mean(patch_olr[70:81])
mean_2005=mean(patch_olr[58:69])
mean_2004=mean(patch_olr[46:57])
mean_2003=mean(patch_olr[34:45])
mean_2002=mean(patch_olr[22:33])
mean_2001=mean(patch_olr[10:21])
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

result_patcholr=moment(patch_olr,mdev=mean_dev_patcholr,sdev=std_patcholr)
PRINT, 'Mean: ', result_patcholr[0] & PRINT, 'Variance: ', result_patcholr[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_patcholr & Print, 'Standard Deviation:', std_patcholr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin creating climatology for EBAF Ed2.7
jan=[EBAF27_olr(10),EBAF27_olr(22),EBAF27_olr(34),EBAF27_olr(46),EBAF27_olr(58),EBAF27_olr(70),EBAF27_olr(82),EBAF27_olr(94),EBAF27_olr(106),EBAF27_olr(118), EBAF27_olr(130),EBAF27_olr(142), EBAF27_olr(154)]
feb=[EBAF27_olr(11),EBAF27_olr(23),EBAF27_olr(35),EBAF27_olr(47),EBAF27_olr(59),EBAF27_olr(71),EBAF27_olr(83),EBAF27_olr(95),EBAF27_olr(107),EBAF27_olr(119),EBAF27_olr(131),EBAF27_olr(143), EBAF27_olr(155)]
mar=[EBAF27_olr(12),EBAF27_olr(24),EBAF27_olr(36),EBAF27_olr(48),EBAF27_olr(60),EBAF27_olr(72),EBAF27_olr(84),EBAF27_olr(96),EBAF27_olr(108),EBAF27_olr(120),EBAF27_olr(132),EBAF27_olr(144)]
apr=[EBAF27_olr(13),EBAF27_olr(25),EBAF27_olr(37),EBAF27_olr(49),EBAF27_olr(61),EBAF27_olr(73),EBAF27_olr(85),EBAF27_olr(97),EBAF27_olr(109),EBAF27_olr(121),EBAF27_olr(133),EBAF27_olr(145)]
may=[EBAF27_olr(14),EBAF27_olr(26),EBAF27_olr(38),EBAF27_olr(50),EBAF27_olr(62),EBAF27_olr(74),EBAF27_olr(86),EBAF27_olr(98),EBAF27_olr(110),EBAF27_olr(122),EBAF27_olr(134),EBAF27_olr(146)]
jun=[EBAF27_olr(15),EBAF27_olr(27),EBAF27_olr(39),EBAF27_olr(51),EBAF27_olr(63),EBAF27_olr(75),EBAF27_olr(87),EBAF27_olr(99),EBAF27_olr(111),EBAF27_olr(123),EBAF27_olr(135),EBAF27_olr(147)]
jul=[EBAF27_olr(16),EBAF27_olr(28),EBAF27_olr(40),EBAF27_olr(52),EBAF27_olr(64),EBAF27_olr(76),EBAF27_olr(88),EBAF27_olr(100),EBAF27_olr(112),EBAF27_olr(124),EBAF27_olr(136),EBAF27_olr(148)]
aug=[EBAF27_olr(17),EBAF27_olr(29),EBAF27_olr(41),EBAF27_olr(53),EBAF27_olr(65),EBAF27_olr(77),EBAF27_olr(89),EBAF27_olr(101),EBAF27_olr(113),EBAF27_olr(125),EBAF27_olr(137),EBAF27_olr(149)]
sep=[EBAF27_olr(18),EBAF27_olr(30),EBAF27_olr(42),EBAF27_olr(54),EBAF27_olr(66),EBAF27_olr(78),EBAF27_olr(90),EBAF27_olr(102),EBAF27_olr(114),EBAF27_olr(126),EBAF27_olr(138),EBAF27_olr(150)]
oct=[EBAF27_olr(19),EBAF27_olr(31),EBAF27_olr(43),EBAF27_olr(55),EBAF27_olr(67),EBAF27_olr(79),EBAF27_olr(91),EBAF27_olr(103),EBAF27_olr(115),EBAF27_olr(127),EBAF27_olr(139),EBAF27_olr(151)]
nov=[EBAF27_olr(20),EBAF27_olr(32),EBAF27_olr(44),EBAF27_olr(56),EBAF27_olr(68),EBAF27_olr(80),EBAF27_olr(92),EBAF27_olr(104),EBAF27_olr(116),EBAF27_olr(128),EBAF27_olr(140),EBAF27_olr(152)]
dec=[EBAF27_olr(21),EBAF27_olr(33),EBAF27_olr(45),EBAF27_olr(57),EBAF27_olr(69),EBAF27_olr(81),EBAF27_olr(93),EBAF27_olr(105),EBAF27_olr(117),EBAF27_olr(129),EBAF27_olr(141),EBAF27_olr(153)]

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

avgEBAF27_olr=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0)]
;stdEBAF27_olr=[julstd,augstd,sepstd,octstd,novstd,decstd]
ten_months=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
monmean=[avgEBAF27_olr,avgEBAF27_olr,avgEBAF27_olr,avgEBAF27_olr,avgEBAF27_olr,avgEBAF27_olr,avgEBAF27_olr,avgEBAF27_olr,avgEBAF27_olr,avgEBAF27_olr,avgEBAF27_olr,avgEBAF27_olr, avgEBAF27_olr]

anoEBAF27_olr = EBAF27_olr - monmean
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin creating climatology
jan=[EBAF_olr(10),EBAF_olr(22),EBAF_olr(34),EBAF_olr(46),EBAF_olr(58),EBAF_olr(70),EBAF_olr(82),EBAF_olr(94),EBAF_olr(106),EBAF_olr(118), EBAF_olr(130)]
feb=[EBAF_olr(11),EBAF_olr(23),EBAF_olr(35),EBAF_olr(47),EBAF_olr(59),EBAF_olr(71),EBAF_olr(83),EBAF_olr(95),EBAF_olr(107),EBAF_olr(119),EBAF_olr(131)]
mar=[EBAF_olr(12),EBAF_olr(24),EBAF_olr(36),EBAF_olr(48),EBAF_olr(60),EBAF_olr(72),EBAF_olr(84),EBAF_olr(96),EBAF_olr(108),EBAF_olr(120),EBAF_olr(132)]
apr=[EBAF_olr(13),EBAF_olr(25),EBAF_olr(37),EBAF_olr(49),EBAF_olr(61),EBAF_olr(73),EBAF_olr(85),EBAF_olr(97),EBAF_olr(109),EBAF_olr(121),EBAF_olr(133)]
may=[EBAF_olr(14),EBAF_olr(26),EBAF_olr(38),EBAF_olr(50),EBAF_olr(62),EBAF_olr(74),EBAF_olr(86),EBAF_olr(98),EBAF_olr(110),EBAF_olr(122),EBAF_olr(134)]
jun=[EBAF_olr(15),EBAF_olr(27),EBAF_olr(39),EBAF_olr(51),EBAF_olr(63),EBAF_olr(75),EBAF_olr(87),EBAF_olr(99),EBAF_olr(111),EBAF_olr(123),EBAF_olr(135)]
jul=[EBAF_olr(16),EBAF_olr(28),EBAF_olr(40),EBAF_olr(52),EBAF_olr(64),EBAF_olr(76),EBAF_olr(88),EBAF_olr(100),EBAF_olr(112),EBAF_olr(124),EBAF_olr(136)]
aug=[EBAF_olr(17),EBAF_olr(29),EBAF_olr(41),EBAF_olr(53),EBAF_olr(65),EBAF_olr(77),EBAF_olr(89),EBAF_olr(101),EBAF_olr(113),EBAF_olr(125),EBAF_olr(137)]
sep=[EBAF_olr(18),EBAF_olr(30),EBAF_olr(42),EBAF_olr(54),EBAF_olr(66),EBAF_olr(78),EBAF_olr(90),EBAF_olr(102),EBAF_olr(114),EBAF_olr(126),EBAF_olr(138)]
oct=[EBAF_olr(19),EBAF_olr(31),EBAF_olr(43),EBAF_olr(55),EBAF_olr(67),EBAF_olr(79),EBAF_olr(91),EBAF_olr(103),EBAF_olr(115),EBAF_olr(127),EBAF_olr(139)]
nov=[EBAF_olr(20),EBAF_olr(32),EBAF_olr(44),EBAF_olr(56),EBAF_olr(68),EBAF_olr(80),EBAF_olr(92),EBAF_olr(104),EBAF_olr(116),EBAF_olr(128),EBAF_olr(140)]
dec=[EBAF_olr(21),EBAF_olr(33),EBAF_olr(45),EBAF_olr(57),EBAF_olr(69),EBAF_olr(81),EBAF_olr(93),EBAF_olr(105),EBAF_olr(117),EBAF_olr(129),EBAF_olr(141)]

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

avgEBAF_olr=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0)]
;stdEBAF_olr=[julstd,augstd,sepstd,octstd,novstd,decstd]
ten_months=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
monmean=[avgEBAF_olr,avgEBAF_olr,avgEBAF_olr,avgEBAF_olr,avgEBAF_olr,avgEBAF_olr,avgEBAF_olr,avgEBAF_olr,avgEBAF_olr,avgEBAF_olr,avgEBAF_olr,avgEBAF_olr, ten_months]
help, monmean
anopatch_olr=patch_olr-monmean

anoEBAF=anopatch_olr[0:147]
anoflash=anopatch_olr[147:153]

result_anopatch=moment(anopatch_olr, mdev=mean_dev_anopatch, sdev=std_anopatch)
print, 'std_anopatch:', std_anopatch


;WRITE TO FILE
openw,1,'/data/FF/timeseries/soc_2012/soc_2012_stats_olr.txt'
printf,1, '','CERLite_EBAF', '','', 'FLASHFlux','', '','Normalized Flashflux','','','Anomaly','','','CERLite_EBAF+FLASHFlux'
printf,1, 'MEAN:',  result_EBAF[0], result_flasholr_2G[0],$
 result_nor_flasholr[0], result_anopatch[0] , result_patcholr[0]
printf,1, 'Variance:',  result_EBAF[1],  result_flasholr_2G[1],$
 result_nor_flasholr[1], result_anopatch[1], result_patcholr[1]
Printf,1, 'Mean Absolute Deviation:', mean_dev_EBAF,mean_dev_flasholr_2G,$
 mean_dev_nor_flasholr, mean_dev_anopatch, mean_dev_patcholr
Printf,1, 'Standard Deviation:', std_EBAF,std_flasholr_2G,$
 std_nor_flasholr, std_anopatch, std_patcholr
close,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin FLASHFlux only anomaly analysis base on its own climatology
;		Flashflux data start on July 2006 - currently 78 data points to December 2012
;*********************************************************************************************

flash_jul=[nor_flasholr(0), nor_flasholr(12), nor_flasholr(24), nor_flasholr(36), nor_flasholr(48), nor_flasholr(60), nor_flasholr(72)]
flash_aug=[nor_flasholr(1), nor_flasholr(13), nor_flasholr(25), nor_flasholr(37), nor_flasholr(49), nor_flasholr(61), nor_flasholr(73)]
flash_sep=[nor_flasholr(2), nor_flasholr(14), nor_flasholr(26), nor_flasholr(38), nor_flasholr(50), nor_flasholr(62), nor_flasholr(74)]
flash_oct=[nor_flasholr(3), nor_flasholr(15), nor_flasholr(27), nor_flasholr(39), nor_flasholr(51), nor_flasholr(63), nor_flasholr(75)]
flash_nov=[nor_flasholr(4), nor_flasholr(16), nor_flasholr(28), nor_flasholr(40), nor_flasholr(52), nor_flasholr(64), nor_flasholr(76)]
flash_dec=[nor_flasholr(5), nor_flasholr(17), nor_flasholr(29), nor_flasholr(41), nor_flasholr(53), nor_flasholr(65), nor_flasholr(77)]
flash_jan=[nor_flasholr(6), nor_flasholr(18), nor_flasholr(30), nor_flasholr(42), nor_flasholr(54), nor_flasholr(66)]
flash_feb=[nor_flasholr(7), nor_flasholr(19), nor_flasholr(31), nor_flasholr(43), nor_flasholr(55), nor_flasholr(67)]
flash_mar=[nor_flasholr(8), nor_flasholr(20), nor_flasholr(32), nor_flasholr(44), nor_flasholr(56), nor_flasholr(68)]
flash_apr=[nor_flasholr(9), nor_flasholr(21), nor_flasholr(33), nor_flasholr(45), nor_flasholr(57), nor_flasholr(69)]
flash_may=[nor_flasholr(10), nor_flasholr(22), nor_flasholr(34), nor_flasholr(46), nor_flasholr(58), nor_flasholr(70)]
flash_jun=[nor_flasholr(11), nor_flasholr(23), nor_flasholr(35), nor_flasholr(47), nor_flasholr(59), nor_flasholr(71)]

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
;aaflash_olr = nor_flasholr - fmthmean 
aaflash_olr = nor_flasholr - patchmonmean 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Original FLASH olr anomalies with patch climatologies

print, 'clim:', clim
clim = [clim, clim, clim, clim, clim, clim, julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
orig_anom = flasholr_2G - clim

;Slope linear fit
slope_anom = nor_flasholr_slope - clim 

;Do the differences
diff_orig = orig_anom - anopatch_olr(76:153)
diff_slope = slope_anom - anopatch_olr(76:153)
diff_des = aaflash_olr - anopatch_olr(76:153) 

print,'2-Sigma of N&D overlap:',2*stddev(diff_des(36:71))
print,'2-Sigma of orig overlap:',2*stddev(diff_orig(36:71))
print,'2-Sigma of linearfit overlap:',2*stddev(diff_slope(36:71))
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;Calculate mean anomaly differences between EBAF2.6r and EBAF 2.7. Also FF and EBAF2.7 for the last six months.
diff_anoEBAF = anoEBAF27_olr[0:147] - anoEBAF
result_diffanoEBAF = moment(diff_anoEBAF, mdev=mean_dev_anopatch, sdev=std_anopatch)
print, 'EBAF2.7-E2.6r mean:', result_diffanoEBAF[0]
print, 'EBAF2.7-E2.6r Mean Absolute Deviation:', mean_dev_anopatch
print, 'EBAF2.7-E2.6r 2Sigma:', 2*std_anopatch
print, 'XxXXXXXXXXXXXXXXXxxxxxxxxxxxxxxxxxx'
diff_anoflash = anoEBAF27_olr[147:153] - anoflash
result_diffanoflash = moment(diff_anoflash, mdev=mean_dev_anopatch, sdev=std_anopatch)
print, 'EBAF2.7-FF mean:', result_diffanoflash[0]
print, 'EBAF2.7-FF Mean Absolute Deviation:', mean_dev_anopatch
print, 'EBAF2.7-FF 2Sigma:', 2*std_anopatch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calculate standard deviation of intercept and slope using the method describe in
;An introduction to Error Analysis by John R. Taylor pp 187-188
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Note: I already have sigma_y, aka sigma_overlap

delta = n_elements(diff_EBAFflash)*total(x^2)-total(x)^2
sigma_int = sigma_overlap * sqrt(total(x^2)/delta)
sigma_slope = sigma_overlap * sqrt(n_elements(diff_EBAFflash)/delta)

;print, 'sigma_overlap', 2*sigma_overlap
;print, 'sigma_int', 2*sigma_int
;print, 'sigma_slope', 2*sigma_slope

upper_olr = anopatch_olr(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int
lower_olr = anopatch_olr(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int)

;print, 'EBAF overlap:'
for ii=106,147 do begin
	;print, EBAF_olr(ii)
endfor
;print, 'FF(N&D) overlap:'
for ii=30,71 do begin
	;print, nor_flasholr(ii)
endfor

;;;;;;;;;;;;;;;;;;;;;;;;;
;Plotting begin here!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Device, RETAIN=2
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
time = TIMEGEN(166, UNITS="Months", START=JULDAY(3,1,2000))
timeaaf=TIMEGEN(96, UNITS="Months", START=JULDAY(7,1,2006))
timef=TIMEGEN(78, UNITS="Months", START=JULDAY(7,1,2009))
timeflash=TIMEGEN(7, UNITS="Months", START=JULDAY(6,1,2012))
timeline= TIMEGEN(200, UNITS="Months", START=JULDAY(1,1,2000))
timediff=timegen(47, UNITS="months", start=JULDAY(7,1,2009))
timeannual = timegen(12, Units="years", start=Julday(1,1,2001))

zeros=intarr(160)
y = replicate(mean_diff_EBAFflash, 200)
help, diff_EBAFflash
;x = indgen(40)
;print, 'overlap slope:', linfit(x, diff_EBAFflash)
fitline = result_fit(0) + result_fit(1)*x
lin_bias = mean_diff_EBAFflash - result_fit(0)
;print, 'confused:', lin_bias
huh = replicate(lin_bias,160)

;print, 'Mean Orginial FF:', mean(flasholr_2G_overlap) 
;print, 'Mean EBAF:', mean(EBAFflash_olr_overlap)
;;print, 'Mean Normalized FF:',
;print, 'Mean FF (linear fit):', mean(nor_flasholr_slope(36:71)) - result_fit(0)
;print, 'Mean FF(N&D):',mean(nor_flasholr(36:71)) 
;PLOT absolute value
;plot, time, flash_olr, color=black, background=white
; Generate the Date/Time data  
!p.multi=[0,1,2,0,1]
 PLOT, timeline, zeros, ytitle='OLR(w/m^2)', XTICKUNITS = ['Time'], Yrange=[225,250],Xrange=[2452500,2456500],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Monthly OLR', charsize=1.2
oplot, time, EBAF_olr, color=red, thick=2, psym=-4
oplot, time, EBAF27_olr, color=green, thick=2
oplot, timeaaf, flasholr_2G, color=blue, thick=2
 oplot, timef,nor_flasholr(36:77) , color=blue, psym=-2
;oplot, timef, nor_flasholr_slope(36:77), color=blue, psym=-4
 ;oplot, timenpp, npp_olr, color=pink, psym=-2
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PLot Anomaly
;;;;;;;;;;;;;;;;;;
;TIMEGEN(118, Units='Months')  
 PLOT, timeline, zeros, ytitle='OLR(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-3.5,3.5],Xrange=[2452500,2456500],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Monthly Anomaly OLR', charsize=1.2

 oplot,timeflash,anoflash,color=blue, thick=2
  oplot,timef,aaflash_olr(36:77),color=blue,psym=-2
 oplot,time, anoEBAF, color=red, thick=2
  oplot,time, anoEBAF27_olr, color=green, thick=2
;oplot, timediff, anopatch_olr(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int, color=black, linestyle=2, thick=2
;oplot, timediff, anopatch_olr(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int), color=black, linestyle=2, thick=2
 ;oplot, timeaaf, slope_anom, color=orange, psym=-4
oplot, timeaaf, orig_anom, color=blue, thick=2
fNamePlotOut='/data/FF/timeseries/OLR'
 image= cgsnapshot(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
; oplot, timenpp, anonpp_olr,color=pink,psym=-2

;xyouts, 2454510,-1.3, 'FF Original', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,-1.3, '-<>', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2454510,2.2, 'FF Normalized and Deseasonalized ', color=blue, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,2.2, '-*', color=blue, charsize=1.5, charthick=1.5
;xyouts, 2454510,1.7, 'FF Normalized (linear fit) ', color=orange, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,1.7, '-<>', color=orange, charsize=1.5, charthick=1.5
;xyouts, 2454510,2.8, 'CERES_EBAF', color=red, charsize=1.5, charthick=1.5
;xyouts, 2454510-150,2.8, '-', color=red, charsize=1.5, charthick=1.5
;xyouts, 2454650+170,2.8, '+ FLASHFlux', color=blue, charsize=1.5, charthick=1.5
;xyouts, 2454510-130+10,2.8, '-', color=blue, charsize=1.5, charthick=1.5

;xyouts, 2455000, -1.6, '2-sigma overlap:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+175, -1.6, two_sigma_overlap, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -1.8, '2-sigma overlap slope:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+275, -1.8, 2*sigma_slope, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2, '2-sigma overlap int:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2, 2*sigma_int, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2.2, '2-sigma timeseries:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2.2, 2*std_anopatch, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, 2.0, 'Trend adjustment', color=black, charthick=1.5, charsize=1.5

  

; PLOT, timeline, zeros, ytitle='OLR(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-3.5,3.5],Xrange=[2453500,2456000],$
; color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
; Title='Timeseries of Monthly Anomaly OLR', charsize=1.2

; oplot,timeflash,anoflash,color=blue, thick=2
;  oplot,timeaaf,diff_des,color=blue,psym=-2
 ;oplot,time, anoEBAF, color=red, thick=2
 ;oplot, timediff, anopatch_olr(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int, color=black, linestyle=2, thick=2
 ;oplot, timediff, anopatch_olr(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int), color=black, linestyle=2, thick=2
; oplot, timeaaf, diff_slope, color=orange, psym=-4
;oplot, timeaaf, diff_orig, color=green, psym=-4
;soplot, timeline, huh, color=black, thick=2
 ;oplot, timenpp, anonpp_olr,color=pink,psym=-2

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

 ;fNamePlotOut='/data/FF/timeseries/soc_2012/deseason_OLR'
 ; image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)

;!p.multi=[0,1,1,0,1]
; PLOT, timeline, zeros, ytitle='OLR(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-1.5,1.5],Xrange=[2451900,2456100],$
;color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
; Title='Timeseries of Monthly Anomaly OLR', charsize=1.2

; oplot,timeflash,anoflash,color=blue, thick=2
;  oplot,timeaaf,aaflash_olr,color=blue,psym=-2
; oplot,time, anoEBAF, color=red, thick=2
; oplot, time, anoEBAF27_olr, color=green, thick=2
 ;oplot, timediff, anopatch_olr(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int, color=black, linestyle=2, thick=2
 ;oplot, timediff, anopatch_olr(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int), color=black, linestyle=2, thick=2
; oplot, timeaaf, slope_anom, color=orange, psym=-4
;oplot, timeaaf, orig_anom, color=green, psym=-4
;oplot, timeairs, olr, color=orange,thick=1
;oplot, timenoaa, ano_noaa, color=green, thick=1
; oplot, timenpp, anonpp_olr,color=pink,psym=-2

;xyouts, 2453510,-1.3, 'EBAF 2.7', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2453510-250,-1.3, '-', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2454510,2.2, 'lized ', color=blue, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,2.2, '-*', color=blue, charsize=1.5, charthick=1.5
;xyouts, 2453510,1.7, 'AIRS ', color=orange, charsize=1.5, charthick=1.5 
;xyouts, 2453510-250,1.7, '-', color=orange, charsize=1.5, charthick=1.5
;xyouts, 2453510,1.3, 'CERES_EBAF', color=red, charsize=1.5, charthick=1.5
;xyouts, 2453510-250,1.3, '-', color=red, charsize=1.5, charthick=1.5
;xyouts, 2453650+370,1.3, '+ FLASHFlux(N&D)', color=blue, charsize=1.5, charthick=1.5
;xyouts, 2453510-200+10,1.3, '-', color=blue, charsize=1.5, charthick=1.5

; fNamePlotOut='/data/FF/timeseries/soc_2012/OLR_Airs_Noaa'
;  image= cgsnapshot(filename=fNamePlotOut);,Quality=100,/JPEG,/NODIALOG)

;!p.multi=[0,1,1,0,1]
;zeros=replicate(239.5,10000)
; PLOT, timeline, zeros, ytitle='OLR(Wm^-2)', XTICKUNITS = ['Time'], Yrange=[238,241],Xrange=[2452000,2456000],$
; color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
; Title='Timeseries of Yearly OLR', charsize=1.2

;
;  oplot,timeannual,mean_data_2012,color=blue,psym=-2
;  ;errplot, timeannual, mean_data_2012-interann, mean_data_2012+interann, color=red
;  for mm=0L, 11 do print, 'annual:', mean_data_2012(mm)
;
;fNamePlotOut='/data/FF/timeseries/soc_2012/annual_OLR'
;  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)

; save, anopatch_olr, patch_olr, anoflash, anoEBAF, nor_flasholr, EBAF_olr, aaflash_olr,upper_olr, lower_olr, filename='/data/FF/timeseries/soc2012_olr.dat'
  
END
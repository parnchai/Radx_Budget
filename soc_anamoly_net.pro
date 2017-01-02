pro soc_anamoly_net

;Open EBAF versin 2.7
;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.7_Subset_200003-201302.nc')
varid=ncdf_varid(cdfid, 'gtoa_net_all_mon')
ncdf_varget,cdfid,varid, EBAF27_net
ncdf_close, cdfid
help, EBAF27_net
result_EBAF=moment(EBAF27_net,mdev=mean_dev_EBAF,sdev=std_EBAF)

PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 
;Comparing timeseries net anamoly for CERES-lite, Flash, and AIRS
;open ceres file [March 2000 - Dec 2010]
;***************************************************************************************************
;***************************************************************************************************
;CERES data
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.6r_Subset_200003-201206.nc')
varid=ncdf_varid(cdfid, 'gtoa_net_all_mon')
ncdf_varget,cdfid,varid, EBAF_net
ncdf_close, cdfid
;EBAF_net = EBAF_net[28:147]
;EBAF_net_overlap=EBAF_net[28:123]
;EBAFflash_net_overlap=EBAF_net[84:119] ;7/2009 - 6/2012

EBAFflash_net_overlap=EBAF_net[112:147] ; July 2009 - Jun. 2012

result_EBAF=moment(EBAF_net,mdev=mean_dev_EBAF,sdev=std_EBAF)
PRINT, 'Mean: ', result_EBAF[0] & PRINT, 'Variance: ', result_EBAF[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_EBAF & Print, 'Standard Deviation:', std_EBAF 



;***************************************************************************************************
;***************************************************************************************************
;open ceres FLASH file


restore, '/data/FF/timeseries/corrected_flash.sav'
flashnet_2G=float(corrected_flashnet)
flashnet_2G_overlap=float(corrected_flashnet[36:71]) ;7/2009-6/2012
result_flashnet_2G=moment(flashnet_2G,mdev=mean_dev_flashnet_2G,sdev=std_flashnet_2G)


PRINT, 'Mean: ', result_flashnet_2G[0] & PRINT, 'Variance: ', result_flashnet_2G[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_flashnet_2G & Print, 'Standard Deviation:', std_flashnet_2G 

;*************************************************************************************************


diff_EBAFflash = EBAFflash_net_overlap - flashnet_2G_overlap
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
print, 'mean EBAF:', mean(EBAFflash_net_overlap)
print, 'stddev EBAF:', stddev(EBAFflash_net_overlap)
print, 'mean flash:', mean(flashnet_2G_overlap)
print, 'stddev flash:', stddev(flashnet_2G_overlap)

flash_num = n_elements(flashnet_2G)
print, 'flash_num:', flash_num
nor_flashnet = fltarr(flash_num)
nor_flashnet_slope = fltarr(flash_num)
	for j=0L, flash_num-1L do begin
		nor_flashnet(j) = flashnet_2G(j) + mean_diff_EBAFflash
		if j lt 36 then begin
			nor_flashnet_slope(j) = nor_flashnet(j)
			endif else begin 
			nor_flashnet_slope(j) = result_fit(1)*(j-36) + flashnet_2G(j) + result_fit(0)
			endelse
	endfor
nor_flashnet=nor_flashnet_slope
;*************************************************************************************************
;added additional step sugeest by TAk and Paul to deseasonalized the timeseries
;rts = EBAF_net(48:119) - nor_flashnet ;Subtract the entire FLASH timeseries with EBAF
rts = EBAF_net(112:147) - nor_flashnet(36:71) ;Subtract just the overlapping timeseries
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
nor_flashnet = nor_flashnet + mean_rtsall
check = EBAF_net(112:147) - nor_flashnet(36:71) 
print, 'Check:', check
print, 'MEAN RTS:', mean(check)
;NOW the normalized FLASHFlux is ZERO compare to EBAF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
result_nor_flashnet=moment(nor_flashnet,mdev=mean_dev_nor_flashnet,sdev=std_nor_flashnet)

PRINT, 'Mean: ', result_nor_flashnet[0] & PRINT, 'Variance: ', result_nor_flashnet[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_nor_flashnet & Print, 'Standard Deviation:', std_nor_flashnet

;SET MERGE data
patch_net = [EBAF_net,nor_flashnet[72:77]]

;Determine mean for each year of merge data
mean_2012=mean(patch_net[142:153])
mean_2011=mean(patch_net[130:141])
mean_2010=mean(patch_net[118:129])
mean_2009=mean(patch_net[106:117])
mean_2008=mean(patch_net[94:105])
mean_2007=mean(patch_net[82:93])
mean_2006=mean(patch_net[70:81])
mean_2005=mean(patch_net[58:69])
mean_2004=mean(patch_net[46:57])
mean_2003=mean(patch_net[34:45])
mean_2002=mean(patch_net[22:33])
mean_2001=mean(patch_net[10:21])
;***********************************************
;Determine climatology of merge data set
;***********************************************
mean_data_2002=[mean_2001,mean_2002]
mean_data_2003=[mean_2001,mean_2002,mean_2003]
mean_data_2004=[mean_2001,mean_2002,mean_2003,mean_2004]
mean_data_2005=[mean_2001,mean_2002,mean_2003,mean_2004,mean_2005]
mean_data_2006=[mean_2001,mean_2002,mean_2003,mean_2004,mean_2005,mean_2006]
mean_data_2007=[mean_2001,mean_2002,mean_2003,mean_2004,mean_2005,mean_2006,mean_2007]
mean_data_2008=[mean_2001,mean_2002,mean_2003,mean_2004,mean_2005,mean_2006,mean_2007,mean_2008]
mean_data_2009=[mean_data_2008, mean_2009]
mean_data_2010=[mean_data_2009, mean_2010]
mean_data_2011=[mean_data_2010, mean_2011]
mean_data_2012=[mean_data_2011, mean_2012]
for mm=0L, 11 do print, 'annual:', mean_data_2012(mm)

;*************************************************
;Find 2 Sigma interannual variability
;**************************************************
two_sigma_2001=2*stddev(mean_2001)
two_sigma_2002=2*stddev(mean_data_2002)
two_sigma_2003=2*stddev(mean_data_2003)
two_sigma_2004=2*stddev(mean_data_2004)
two_sigma_2005=2*stddev(mean_data_2005)
two_sigma_2006=2*stddev(mean_data_2006)
two_sigma_2007=2*stddev(mean_data_2007)
two_sigma_2008=2*stddev(mean_data_2008)
two_sigma_2009=2*stddev(mean_data_2009)
two_sigma_2010=2*stddev(mean_data_2010)
two_sigma_2011=2*stddev(mean_data_2011)
two_sigma_2012=2*stddev(mean_data_2012)

interann = [two_sigma_2001,two_sigma_2002,two_sigma_2003,two_sigma_2004,two_sigma_2005, $
			two_sigma_2006,two_sigma_2007,two_sigma_2008,two_sigma_2009,two_sigma_2010, $
			two_sigma_2011,two_sigma_2012]
for nn=0L, 11 do print, 'interannual:', interann(nn)
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
result_patchnet=moment(patch_net,mdev=mean_dev_patchnet,sdev=std_patchnet)
PRINT, 'Mean: ', result_patchnet[0] & PRINT, 'Variance: ', result_patchnet[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_patchnet & Print, 'Standard Deviation:', std_patchnet


;***************************************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin creating climatology for EBAF Ed2.7
jan=[EBAF27_net(10),EBAF27_net(22),EBAF27_net(34),EBAF27_net(46),EBAF27_net(58),EBAF27_net(70),EBAF27_net(82),EBAF27_net(94),EBAF27_net(106),EBAF27_net(118), EBAF27_net(130),EBAF27_net(142), EBAF27_net(154)]
feb=[EBAF27_net(11),EBAF27_net(23),EBAF27_net(35),EBAF27_net(47),EBAF27_net(59),EBAF27_net(71),EBAF27_net(83),EBAF27_net(95),EBAF27_net(107),EBAF27_net(119),EBAF27_net(131),EBAF27_net(143), EBAF27_net(155)]
mar=[EBAF27_net(12),EBAF27_net(24),EBAF27_net(36),EBAF27_net(48),EBAF27_net(60),EBAF27_net(72),EBAF27_net(84),EBAF27_net(96),EBAF27_net(108),EBAF27_net(120),EBAF27_net(132),EBAF27_net(144)]
apr=[EBAF27_net(13),EBAF27_net(25),EBAF27_net(37),EBAF27_net(49),EBAF27_net(61),EBAF27_net(73),EBAF27_net(85),EBAF27_net(97),EBAF27_net(109),EBAF27_net(121),EBAF27_net(133),EBAF27_net(145)]
may=[EBAF27_net(14),EBAF27_net(26),EBAF27_net(38),EBAF27_net(50),EBAF27_net(62),EBAF27_net(74),EBAF27_net(86),EBAF27_net(98),EBAF27_net(110),EBAF27_net(122),EBAF27_net(134),EBAF27_net(146)]
jun=[EBAF27_net(15),EBAF27_net(27),EBAF27_net(39),EBAF27_net(51),EBAF27_net(63),EBAF27_net(75),EBAF27_net(87),EBAF27_net(99),EBAF27_net(111),EBAF27_net(123),EBAF27_net(135),EBAF27_net(147)]
jul=[EBAF27_net(16),EBAF27_net(28),EBAF27_net(40),EBAF27_net(52),EBAF27_net(64),EBAF27_net(76),EBAF27_net(88),EBAF27_net(100),EBAF27_net(112),EBAF27_net(124),EBAF27_net(136),EBAF27_net(148)]
aug=[EBAF27_net(17),EBAF27_net(29),EBAF27_net(41),EBAF27_net(53),EBAF27_net(65),EBAF27_net(77),EBAF27_net(89),EBAF27_net(101),EBAF27_net(113),EBAF27_net(125),EBAF27_net(137),EBAF27_net(149)]
sep=[EBAF27_net(18),EBAF27_net(30),EBAF27_net(42),EBAF27_net(54),EBAF27_net(66),EBAF27_net(78),EBAF27_net(90),EBAF27_net(102),EBAF27_net(114),EBAF27_net(126),EBAF27_net(138),EBAF27_net(150)]
oct=[EBAF27_net(19),EBAF27_net(31),EBAF27_net(43),EBAF27_net(55),EBAF27_net(67),EBAF27_net(79),EBAF27_net(91),EBAF27_net(103),EBAF27_net(115),EBAF27_net(127),EBAF27_net(139),EBAF27_net(151)]
nov=[EBAF27_net(20),EBAF27_net(32),EBAF27_net(44),EBAF27_net(56),EBAF27_net(68),EBAF27_net(80),EBAF27_net(92),EBAF27_net(104),EBAF27_net(116),EBAF27_net(128),EBAF27_net(140),EBAF27_net(152)]
dec=[EBAF27_net(21),EBAF27_net(33),EBAF27_net(45),EBAF27_net(57),EBAF27_net(69),EBAF27_net(81),EBAF27_net(93),EBAF27_net(105),EBAF27_net(117),EBAF27_net(129),EBAF27_net(141),EBAF27_net(153)]

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

avgEBAF27_net=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0)]
;stdEBAF27_net=[julstd,augstd,sepstd,octstd,novstd,decstd]
ten_months=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
monmean=[avgEBAF27_net,avgEBAF27_net,avgEBAF27_net,avgEBAF27_net,avgEBAF27_net,avgEBAF27_net,avgEBAF27_net,avgEBAF27_net,avgEBAF27_net,avgEBAF27_net,avgEBAF27_net,avgEBAF27_net, avgEBAF27_net]

anoEBAF27_net = EBAF27_net - monmean
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin creating climatology
jan=[EBAF_net(10),EBAF_net(22),EBAF_net(34),EBAF_net(46),EBAF_net(58),EBAF_net(70),EBAF_net(82),EBAF_net(94),EBAF_net(106),EBAF_net(118), EBAF_net(130)]
feb=[EBAF_net(11),EBAF_net(23),EBAF_net(35),EBAF_net(47),EBAF_net(59),EBAF_net(71),EBAF_net(83),EBAF_net(95),EBAF_net(107),EBAF_net(119),EBAF_net(131)]
mar=[EBAF_net(12),EBAF_net(24),EBAF_net(36),EBAF_net(48),EBAF_net(60),EBAF_net(72),EBAF_net(84),EBAF_net(96),EBAF_net(108),EBAF_net(120),EBAF_net(132)]
apr=[EBAF_net(13),EBAF_net(25),EBAF_net(37),EBAF_net(49),EBAF_net(61),EBAF_net(73),EBAF_net(85),EBAF_net(97),EBAF_net(109),EBAF_net(121),EBAF_net(133)]
may=[EBAF_net(14),EBAF_net(26),EBAF_net(38),EBAF_net(50),EBAF_net(62),EBAF_net(74),EBAF_net(86),EBAF_net(98),EBAF_net(110),EBAF_net(122),EBAF_net(134)]
jun=[EBAF_net(15),EBAF_net(27),EBAF_net(39),EBAF_net(51),EBAF_net(63),EBAF_net(75),EBAF_net(87),EBAF_net(99),EBAF_net(111),EBAF_net(123),EBAF_net(135)]
jul=[EBAF_net(16),EBAF_net(28),EBAF_net(40),EBAF_net(52),EBAF_net(64),EBAF_net(76),EBAF_net(88),EBAF_net(100),EBAF_net(112),EBAF_net(124),EBAF_net(136)]
aug=[EBAF_net(17),EBAF_net(29),EBAF_net(41),EBAF_net(53),EBAF_net(65),EBAF_net(77),EBAF_net(89),EBAF_net(101),EBAF_net(113),EBAF_net(125),EBAF_net(137)]
sep=[EBAF_net(18),EBAF_net(30),EBAF_net(42),EBAF_net(54),EBAF_net(66),EBAF_net(78),EBAF_net(90),EBAF_net(102),EBAF_net(114),EBAF_net(126),EBAF_net(138)]
oct=[EBAF_net(19),EBAF_net(31),EBAF_net(43),EBAF_net(55),EBAF_net(67),EBAF_net(79),EBAF_net(91),EBAF_net(103),EBAF_net(115),EBAF_net(127),EBAF_net(139)]
nov=[EBAF_net(20),EBAF_net(32),EBAF_net(44),EBAF_net(56),EBAF_net(68),EBAF_net(80),EBAF_net(92),EBAF_net(104),EBAF_net(116),EBAF_net(128),EBAF_net(140)]
dec=[EBAF_net(21),EBAF_net(33),EBAF_net(45),EBAF_net(57),EBAF_net(69),EBAF_net(81),EBAF_net(93),EBAF_net(105),EBAF_net(117),EBAF_net(129),EBAF_net(141)]

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

avgEBAF_net=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0)]
;stdEBAF_net=[julstd,augstd,sepstd,octstd,novstd,decstd]
ten_months=[maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
monmean=[avgEBAF_net,avgEBAF_net,avgEBAF_net,avgEBAF_net,avgEBAF_net,avgEBAF_net,avgEBAF_net,avgEBAF_net,avgEBAF_net,avgEBAF_net,avgEBAF_net,avgEBAF_net, ten_months]
help, monmean
anopatch_net=patch_net-monmean

anoEBAF=anopatch_net[0:147]
anoflash=anopatch_net[147:153]

result_anopatch=moment(anopatch_net, mdev=mean_dev_anopatch, sdev=std_anopatch)
print, 'std_anopatch:', std_anopatch


;WRITE TO FILE
openw,1,'/data/FF/timeseries/soc_2012/soc_2012_stats_net.txt'
printf,1, '','CERLite_EBAF', '','', 'FLASHFlux','', '','Normalized Flashflux','','','Anomaly','','','CERLite_EBAF+FLASHFlux'
printf,1, 'MEAN:',  result_EBAF[0], result_flashnet_2G[0],$
 result_nor_flashnet[0], result_anopatch[0] , result_patchnet[0]
printf,1, 'Variance:',  result_EBAF[1],  result_flashnet_2G[1],$
 result_nor_flashnet[1], result_anopatch[1], result_patchnet[1]
Printf,1, 'Mean Absolute Deviation:', mean_dev_EBAF,mean_dev_flashnet_2G,$
 mean_dev_nor_flashnet, mean_dev_anopatch, mean_dev_patchnet
Printf,1, 'Standard Deviation:', std_EBAF,std_flashnet_2G,$
 std_nor_flashnet, std_anopatch, std_patchnet
close,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin FLASHFlux only anomaly analysis base on its own climatology
;		Flashflux data start on July 2006 - currently 78 data points to December 2012
;*********************************************************************************************

flash_jul=[nor_flashnet(0), nor_flashnet(12), nor_flashnet(24), nor_flashnet(36), nor_flashnet(48), nor_flashnet(60), nor_flashnet(72)]
flash_aug=[nor_flashnet(1), nor_flashnet(13), nor_flashnet(25), nor_flashnet(37), nor_flashnet(49), nor_flashnet(61), nor_flashnet(73)]
flash_sep=[nor_flashnet(2), nor_flashnet(14), nor_flashnet(26), nor_flashnet(38), nor_flashnet(50), nor_flashnet(62), nor_flashnet(74)]
flash_oct=[nor_flashnet(3), nor_flashnet(15), nor_flashnet(27), nor_flashnet(39), nor_flashnet(51), nor_flashnet(63), nor_flashnet(75)]
flash_nov=[nor_flashnet(4), nor_flashnet(16), nor_flashnet(28), nor_flashnet(40), nor_flashnet(52), nor_flashnet(64), nor_flashnet(76)]
flash_dec=[nor_flashnet(5), nor_flashnet(17), nor_flashnet(29), nor_flashnet(41), nor_flashnet(53), nor_flashnet(65), nor_flashnet(77)]
flash_jan=[nor_flashnet(6), nor_flashnet(18), nor_flashnet(30), nor_flashnet(42), nor_flashnet(54), nor_flashnet(66)]
flash_feb=[nor_flashnet(7), nor_flashnet(19), nor_flashnet(31), nor_flashnet(43), nor_flashnet(55), nor_flashnet(67)]
flash_mar=[nor_flashnet(8), nor_flashnet(20), nor_flashnet(32), nor_flashnet(44), nor_flashnet(56), nor_flashnet(68)]
flash_apr=[nor_flashnet(9), nor_flashnet(21), nor_flashnet(33), nor_flashnet(45), nor_flashnet(57), nor_flashnet(69)]
flash_may=[nor_flashnet(10), nor_flashnet(22), nor_flashnet(34), nor_flashnet(46), nor_flashnet(58), nor_flashnet(70)]
flash_jun=[nor_flashnet(11), nor_flashnet(23), nor_flashnet(35), nor_flashnet(47), nor_flashnet(59), nor_flashnet(71)]

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
;aaflash_net = nor_flashnet - fmthmean 
aaflash_net = nor_flashnet - patchmonmean 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Original FLASH net anomalies with patch climatologies

print, 'clim:', clim
clim = [clim, clim, clim, clim, clim, clim, julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
orig_anom = flashnet_2G - clim

;Slope linear fit
slope_anom = nor_flashnet_slope - clim 

;Do the differences
diff_orig = orig_anom - anopatch_net(76:153)
diff_slope = slope_anom - anopatch_net(76:153)
diff_des = aaflash_net - anopatch_net(76:153) 

print,'2-Sigma of N&D overlap:',2*stddev(diff_des(36:71))
print,'2-Sigma of orig overlap:',2*stddev(diff_orig(36:71))
print,'2-Sigma of linearfit overlap:',2*stddev(diff_slope(36:71))
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calculate mean anomaly differences between EBAF2.6r and EBAF 2.7. Also FF and EBAF2.7 for the last six months.
diff_anoEBAF = anoEBAF27_net[0:147] - anoEBAF
result_diffanoEBAF = moment(diff_anoEBAF, mdev=mean_dev_anopatch, sdev=std_anopatch)
print, 'EBAF2.7-E2.6r mean:', result_diffanoEBAF[0]
print, 'EBAF2.7-E2.6r Mean Absolute Deviation:', mean_dev_anopatch
print, 'EBAF2.7-E2.6r 2Sigma:', 2*std_anopatch
print, 'XxXXXXXXXXXXXXXXXxxxxxxxxxxxxxxxxxx'
diff_anoflash = anoEBAF27_net[147:153] - anoflash
result_diffanoflash = moment(diff_anoflash, mdev=mean_dev_anopatch, sdev=std_anopatch)
print, 'EBAF2.7-FF mean:', result_diffanoflash[0]
print, 'EBAF2.7-FF Mean Absolute Deviation:', mean_dev_anopatch
print, 'EBAF2.7-FF 2Sigma:', 2*std_anopatch
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
npp_net=fltarr(ndata)

npp_net=nppdata(4,*)
;print, npp_net
close,1
npp_monmean=[febavg(0),maravg(0),apravg(0),mayavg(0),junavg(0),julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0)]
anonpp_net=npp_net-npp_monmean
;print, anonpp_net
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calculate standard deviation of intercept and slope using the method describe in
;An introduction to Error Analysis by John R. Taylor pp 187-188
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Note: I already have sigma_y, aka sigma_overlap

delta = n_elements(diff_EBAFflash)*total(x^2)-total(x)^2
sigma_int = sigma_overlap * sqrt(total(x^2)/delta)
sigma_slope = sigma_overlap * sqrt(n_elements(diff_EBAFflash)/delta)

;print, 'sigma_int', sigma_int
;print, 'sigma_slope', sigma_slope

upper_net = anopatch_net(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int
lower_net = anopatch_net(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;print, 'Mean Orginial FF:', mean(flashnet_2G_overlap) 
;print, 'Mean EBAF:', mean(EBAFflash_net_overlap)
;;print, 'Mean Normalized FF:',
;print, 'Mean FF (linear fit):', mean(nor_flashnet_slope(36:71)) - result_fit(0)
;print, 'Mean FF(N&D):',mean(nor_flashnet(36:71)) 

;print, 'EBAF overlap:'
for ii=106,147 do begin
	;print, EBAF_net(ii)
endfor
;print, 'FF(N&D) overlap:'
for ii=30,71 do begin
	;print, nor_flashnet(ii)
endfor
;;;;;;;;;;;;;;;;;;;;;;;;;
;Plotting begin here!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Device, retain=2
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

 PLOT, timeline, zeros, ytitle='net(w/m^2)', XTICKUNITS = ['Time'], Yrange=[225,250],Xrange=[2452500,2456000],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Monthly net', charsize=1.2
oplot, time, EBAF_net, color=red, psym=-4
oplot, time, EBAF27_net, color=green, thick=2
oplot, timef, flashnet_2G, color=blue, thick=2
 
  
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

;fNamePlotOut='/data/FLASHFlux/timeseries/soc_2012/net'
; image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PLot Anomaly
;;;;;;;;;;;;;;;;;;
;TIMEGEN(118, Units='Months')  
 PLOT, timeline, zeros, ytitle='NET(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-1.5,1.5],Xrange=[2451800,2456000],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Monthly Anomaly NET', charsize=1.2

 oplot,timeflash,anoflash,color=blue, thick=2
 ; oplot,timeaaf,aaflash_net,color=blue,psym=-2
 oplot,time, anoEBAF, color=red, thick=2
 ;oplot, timediff, anopatch_net(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int, color=black, linestyle=2, thick=2
 ;oplot, timediff, anopatch_net(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int), color=black, linestyle=2, thick=2
 ;oplot, timeaaf, slope_anom, color=orange, psym=-4
;oplot, timeaaf, orig_anom, color=green, psym=-4
 oplot, time, anoEBAF27_net,color=green,thick=2

xyouts, 2454510,5, 'FF Original', color=green, charsize=1.5, charthick=1.5 
xyouts, 2454510-150,5, '-<>', color=green, charsize=1.5, charthick=1.5 
xyouts, 2454510,2.2, 'FF Normalized and Deseasonalized ', color=blue, charsize=1.5, charthick=1.5 
xyouts, 2454510-150,2.2, '-*', color=blue, charsize=1.5, charthick=1.5
;xyouts, 2454510,1.7, 'FF Normalized (linear fit) ', color=orange, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,1.7, '-<>', color=orange, charsize=1.5, charthick=1.5
xyouts, 2454510,1.7, 'EBAF Ed2.7 ', color=green, charsize=1.5, charthick=1.5 
xyouts, 2454510-150,1.7, '-', color=green, charsize=1.5, charthick=1.5
xyouts, 2454510,1.8, 'CERES_EBAF', color=red, charsize=1.5, charthick=1.5
xyouts, 2454510-150,1.8, '-', color=red, charsize=1.5, charthick=1.5
xyouts, 2454650+220,1.8, '+ FLASHFlux', color=blue, charsize=1.5, charthick=1.5
xyouts, 2454510-130+10,1.8, '-', color=blue, charsize=1.5, charthick=1.5

;xyouts, 2455000, -1.6, '2-sigma overlap:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+175, -1.6, two_sigma_overlap, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -1.8, '2-sigma overlap slope:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+275, -1.8, 2*sigma_slope, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2, '2-sigma overlap int:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2, 2*sigma_int, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, -2.2, '2-sigma timeseries:', color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000+210, -2.2, 2*std_anopatch, color=black, charthick=1.5, charsize=1.5
;xyouts, 2455000, 2.0, 'Trend adjustment', color=black, charthick=1.5, charsize=1.5

  

; PLOT, timeline, zeros, ytitle='NET(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-1.5,8.5],Xrange=[2454000,2456000],$
; color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
; Title='Timeseries of Monthly Anomaly NET', charsize=1.2

; oplot,timeflash,anoflash,color=blue, thick=2
;  oplot,timeaaf,diff_des,color=blue,psym=-2
 ;oplot,time, anoEBAF, color=red, thick=2
 ;oplot, timediff, anopatch_net(84:125)+2*sigma_overlap+2*sigma_slope+2*sigma_int, color=black, linestyle=2, thick=2
 ;oplot, timediff, anopatch_net(84:125)-(2*sigma_overlap+2*sigma_slope+2*sigma_int), color=black, linestyle=2, thick=2
; oplot, timeaaf, diff_slope, color=orange, psym=-4
;oplot, timeaaf, diff_orig, color=green, psym=-4

 ;oplot, timenpp, anonpp_net,color=pink,psym=-2

;xyouts, 2454510,5.0, 'Original', color=green, charsize=1.5, charthick=1.5 
;xyouts, 2454510-150,5.0, '-<>', color=green, charsize=1.5, charthick=1.5 
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

 ;fNamePlotOut='/data/FF/timeseries/soc_2012/deseason_NET'
 ; image= cgsnapshot(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)

;!p.multi=[0,1,1,0,1]

 ;PLOT, timeline, zeros, ytitle='NET(Wm^-2)', XTICKUNITS = ['Time'], Yrange=[-1.5,1.5],Xrange=[2452000,2456000],$
 ;color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 ;Title='Timeseries of Yearly NET', charsize=1.2


;  oplot,timeannual,mean_data_2012,color=blue,psym=-2
;  errplot, timeannual, mean_data_2012-interann, mean_data_2012+interann, color=red

;fNamePlotOut='/data/FF/timeseries/soc_2012/annual_NET'
;  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)


save, anopatch_net, patch_net, anoflash, anoEBAF, nor_flashnet, EBAF_net, aaflash_net,upper_net,lower_net, filename='/data/FF/timeseries/soc2012_net.dat'
 
END
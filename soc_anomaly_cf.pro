pro soc_anomaly_cf

;Comparing timeseries cldFrac anamoly for CERES-lite, Flash, and terra
;open ceres file [March 2000 - Feb 2010]
;***************************************************************************************************
;***************************************************************************************************
;CERES data
;March 2000 thru June 2012
cdfid= ncdf_open('/data/FLASHFlux/timeseries/Cereslite_Ed2_6/CERES_SSF1deg-Month-lite_Terra_Ed2.6_Subset_200003-201206.nc')
varid=ncdf_varid(cdfid, 'gcldarea_daynight_mon')
ncdf_varget,cdfid,varid, terra_cldFrac
ncdf_close, cdfid

;Reform date to July 2002 thru June 2012
terra_cldFrac = terra_cldFrac[28:147]
;terraflash_cldFrac_overlap=terra_cldFrac[108:143] ;3/2009-2/2012
;result_terra=moment(terra_cldFrac,mdev=mean_dev_terra,sdev=std_terra)

;PRINT, 'Mean: ', result_terra[0] & PRINT, 'Variance: ', result_terra[1] & $  
;   Print, 'Mean Absolute Deviation:', mean_dev_terra & Print, 'Standard Deviation:', std_terra 

;***************************************************************************************************
;***************************************************************************************************

;CERES data
;July 2002 thru June 2006
cdfid= ncdf_open('/data/FLASHFlux/timeseries/Cereslite_Ed2_6/CERES_SSF1deg-Month-lite_Aqua_Ed2.6_Subset_200207-201206.nc')
varid=ncdf_varid(cdfid, 'gcldarea_daynight_mon')
ncdf_varget,cdfid,varid, aqua_cldFrac
ncdf_close, cdfid


;aquaflash_cldFrac_overlap=aqua_cldFrac[108:143] ;3/2009-2/2012
;result_aqua=moment(aqua_cldFrac,mdev=mean_dev_aqua,sdev=std_aqua)

;PRINT, 'Mean: ', result_aqua[0] & PRINT, 'Variance: ', result_aqua[1] & $  
;   Print, 'Mean Absolute Deviation:', mean_dev_aqua & Print, 'Standard Deviation:', std_aqua 

;***************************************************************************************************
;***************************************************************************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Need to write this as a function to read in terra olr data - for now write it here
;terradata begin July 2002 thru December 2012
terra_id = hdf_sd_start('/data/FLASHFlux/timeseries/MODIS_MONTHLY_L3_timeseries_11314183027/MOD08_M3.051.dimensionAverage.9812_0.hdf')

index1 = hdf_sd_nametoindex(terra_id, 'Cloud_Fraction_Mean_Mean')
varid1 = hdf_sd_select(terra_id, index1)
hdf_sd_getdata, varid1, terra_modis
hdf_sd_endaccess, varid1
terra_modis=terra_modis*100
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Need to write this as a function to read in aqua olr data - for now write it here
;aquadata begin July 2002 thru December 2012
aqua_id = hdf_sd_start('/data/FLASHFlux/timeseries/MODIS_MONTHLY_L3_timeseries_11314183027/MYD08_M3.051.dimensionAverage.9812_1.hdf')

index1 = hdf_sd_nametoindex(aqua_id, 'Cloud_Fraction_Mean_Mean')
varid1 = hdf_sd_select(aqua_id, index1)
hdf_sd_getdata, varid1, aqua_modis
hdf_sd_endaccess, varid1
aqua_modis=aqua_modis*100
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin patch olr anomaly
;Should write this as a method!!!!
jul=[terra_cldFrac(0),terra_cldFrac(12),terra_cldFrac(24),terra_cldFrac(36),terra_cldFrac(48),terra_cldFrac(60),terra_cldFrac(72),terra_cldFrac(84),terra_cldFrac(96),terra_cldFrac(108)]
aug=[terra_cldFrac(1),terra_cldFrac(13),terra_cldFrac(25),terra_cldFrac(37),terra_cldFrac(49),terra_cldFrac(61),terra_cldFrac(73),terra_cldFrac(85),terra_cldFrac(97),terra_cldFrac(109)]
sep=[terra_cldFrac(2),terra_cldFrac(14),terra_cldFrac(26),terra_cldFrac(38),terra_cldFrac(50),terra_cldFrac(62),terra_cldFrac(74),terra_cldFrac(86),terra_cldFrac(98),terra_cldFrac(110)]
oct=[terra_cldFrac(3),terra_cldFrac(15),terra_cldFrac(27),terra_cldFrac(39),terra_cldFrac(51),terra_cldFrac(63),terra_cldFrac(75),terra_cldFrac(87),terra_cldFrac(99),terra_cldFrac(111)]
nov=[terra_cldFrac(4),terra_cldFrac(16),terra_cldFrac(28),terra_cldFrac(40),terra_cldFrac(52),terra_cldFrac(64),terra_cldFrac(76),terra_cldFrac(88),terra_cldFrac(100),terra_cldFrac(112)]
dec=[terra_cldFrac(5),terra_cldFrac(17),terra_cldFrac(29),terra_cldFrac(41),terra_cldFrac(53),terra_cldFrac(65),terra_cldFrac(77),terra_cldFrac(89),terra_cldFrac(101),terra_cldFrac(113)]
jan=[terra_cldFrac(6),terra_cldFrac(18),terra_cldFrac(30),terra_cldFrac(42),terra_cldFrac(54),terra_cldFrac(66),terra_cldFrac(78),terra_cldFrac(90),terra_cldFrac(102),terra_cldFrac(114)]
feb=[terra_cldFrac(7),terra_cldFrac(19),terra_cldFrac(31),terra_cldFrac(43),terra_cldFrac(55),terra_cldFrac(67),terra_cldFrac(79),terra_cldFrac(91),terra_cldFrac(103),terra_cldFrac(115)]
mar=[terra_cldFrac(8),terra_cldFrac(20),terra_cldFrac(32),terra_cldFrac(44),terra_cldFrac(56),terra_cldFrac(68),terra_cldFrac(80),terra_cldFrac(92),terra_cldFrac(104),terra_cldFrac(116)]
apr=[terra_cldFrac(9),terra_cldFrac(21),terra_cldFrac(33),terra_cldFrac(45),terra_cldFrac(57),terra_cldFrac(69),terra_cldFrac(81),terra_cldFrac(93),terra_cldFrac(105),terra_cldFrac(117)]
may=[terra_cldFrac(10),terra_cldFrac(22),terra_cldFrac(34),terra_cldFrac(46),terra_cldFrac(58),terra_cldFrac(70),terra_cldFrac(82),terra_cldFrac(94),terra_cldFrac(106),terra_cldFrac(118)]
jun=[terra_cldFrac(11),terra_cldFrac(23),terra_cldFrac(35),terra_cldFrac(47),terra_cldFrac(59),terra_cldFrac(71),terra_cldFrac(83),terra_cldFrac(95),terra_cldFrac(107),terra_cldFrac(119)]

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

avgterra_cldFrac=[julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0),maravg(0),apravg(0),mayavg(0),junavg(0)]
stdterra_cldFrac=[julstd,augstd,sepstd,octstd,novstd,decstd,janstd,febstd,marstd,aprstd,maystd,junstd]
ten_months=[julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),maravg(0),apravg(0),mayavg(0),junavg(0)]
monmean=[avgterra_cldFrac,avgterra_cldFrac,avgterra_cldFrac,avgterra_cldFrac,avgterra_cldFrac,avgterra_cldFrac,avgterra_cldFrac,avgterra_cldFrac,avgterra_cldFrac,avgterra_cldFrac, avgterra_cldFrac,avgterra_cldFrac]

anoterra_cldFrac=terra_cldFrac-monmean

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin patch olr anomaly
jul=[aqua_cldFrac(0),aqua_cldFrac(12),aqua_cldFrac(24),aqua_cldFrac(36),aqua_cldFrac(48),aqua_cldFrac(60),aqua_cldFrac(72),aqua_cldFrac(84),aqua_cldFrac(96),aqua_cldFrac(108)]
aug=[aqua_cldFrac(1),aqua_cldFrac(13),aqua_cldFrac(25),aqua_cldFrac(37),aqua_cldFrac(49),aqua_cldFrac(61),aqua_cldFrac(73),aqua_cldFrac(85),aqua_cldFrac(97),aqua_cldFrac(109)]
sep=[aqua_cldFrac(2),aqua_cldFrac(14),aqua_cldFrac(26),aqua_cldFrac(38),aqua_cldFrac(50),aqua_cldFrac(62),aqua_cldFrac(74),aqua_cldFrac(86),aqua_cldFrac(98),aqua_cldFrac(110)]
oct=[aqua_cldFrac(3),aqua_cldFrac(15),aqua_cldFrac(27),aqua_cldFrac(39),aqua_cldFrac(51),aqua_cldFrac(63),aqua_cldFrac(75),aqua_cldFrac(87),aqua_cldFrac(99),aqua_cldFrac(111)]
nov=[aqua_cldFrac(4),aqua_cldFrac(16),aqua_cldFrac(28),aqua_cldFrac(40),aqua_cldFrac(52),aqua_cldFrac(64),aqua_cldFrac(76),aqua_cldFrac(88),aqua_cldFrac(100),aqua_cldFrac(112)]
dec=[aqua_cldFrac(5),aqua_cldFrac(17),aqua_cldFrac(29),aqua_cldFrac(41),aqua_cldFrac(53),aqua_cldFrac(65),aqua_cldFrac(77),aqua_cldFrac(89),aqua_cldFrac(101),aqua_cldFrac(113)]
jan=[aqua_cldFrac(6),aqua_cldFrac(18),aqua_cldFrac(30),aqua_cldFrac(42),aqua_cldFrac(54),aqua_cldFrac(66),aqua_cldFrac(78),aqua_cldFrac(90),aqua_cldFrac(102),aqua_cldFrac(114)]
feb=[aqua_cldFrac(7),aqua_cldFrac(19),aqua_cldFrac(31),aqua_cldFrac(43),aqua_cldFrac(55),aqua_cldFrac(67),aqua_cldFrac(79),aqua_cldFrac(91),aqua_cldFrac(103),aqua_cldFrac(115)]
mar=[aqua_cldFrac(8),aqua_cldFrac(20),aqua_cldFrac(32),aqua_cldFrac(44),aqua_cldFrac(56),aqua_cldFrac(68),aqua_cldFrac(80),aqua_cldFrac(92),aqua_cldFrac(104),aqua_cldFrac(116)]
apr=[aqua_cldFrac(9),aqua_cldFrac(21),aqua_cldFrac(33),aqua_cldFrac(45),aqua_cldFrac(57),aqua_cldFrac(69),aqua_cldFrac(81),aqua_cldFrac(93),aqua_cldFrac(105),aqua_cldFrac(117)]
may=[aqua_cldFrac(10),aqua_cldFrac(22),aqua_cldFrac(34),aqua_cldFrac(46),aqua_cldFrac(58),aqua_cldFrac(70),aqua_cldFrac(82),aqua_cldFrac(94),aqua_cldFrac(106),aqua_cldFrac(118)]
jun=[aqua_cldFrac(11),aqua_cldFrac(23),aqua_cldFrac(35),aqua_cldFrac(47),aqua_cldFrac(59),aqua_cldFrac(71),aqua_cldFrac(83),aqua_cldFrac(95),aqua_cldFrac(107),aqua_cldFrac(119)]

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

avgaqua_cldFrac=[julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0),maravg(0),apravg(0),mayavg(0),junavg(0)]
stdaqua_cldFrac=[julstd,augstd,sepstd,octstd,novstd,decstd,janstd,febstd,marstd,aprstd,maystd,junstd]
ten_months=[julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),maravg(0),apravg(0),mayavg(0),junavg(0)]
monmean=[avgaqua_cldFrac,avgaqua_cldFrac,avgaqua_cldFrac,avgaqua_cldFrac,avgaqua_cldFrac,avgaqua_cldFrac,avgaqua_cldFrac,avgaqua_cldFrac,avgaqua_cldFrac,avgaqua_cldFrac, avgaqua_cldFrac,avgaqua_cldFrac]

anoaqua_cldFrac=aqua_cldFrac-monmean

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin patch olr anomaly
jul=[terra_modis(0),terra_modis(12),terra_modis(24),terra_modis(36),terra_modis(48),terra_modis(60),terra_modis(72),terra_modis(84),terra_modis(96),terra_modis(108),terra_modis(120)]
aug=[terra_modis(1),terra_modis(13),terra_modis(25),terra_modis(37),terra_modis(49),terra_modis(61),terra_modis(73),terra_modis(85),terra_modis(97),terra_modis(109),terra_modis(121)]
sep=[terra_modis(2),terra_modis(14),terra_modis(26),terra_modis(38),terra_modis(50),terra_modis(62),terra_modis(74),terra_modis(86),terra_modis(98),terra_modis(110),terra_modis(122)]
oct=[terra_modis(3),terra_modis(15),terra_modis(27),terra_modis(39),terra_modis(51),terra_modis(63),terra_modis(75),terra_modis(87),terra_modis(99),terra_modis(111),terra_modis(123)]
nov=[terra_modis(4),terra_modis(16),terra_modis(28),terra_modis(40),terra_modis(52),terra_modis(64),terra_modis(76),terra_modis(88),terra_modis(100),terra_modis(112),terra_modis(124)]
dec=[terra_modis(5),terra_modis(17),terra_modis(29),terra_modis(41),terra_modis(53),terra_modis(65),terra_modis(77),terra_modis(89),terra_modis(101),terra_modis(113),terra_modis(125)]
jan=[terra_modis(6),terra_modis(18),terra_modis(30),terra_modis(42),terra_modis(54),terra_modis(66),terra_modis(78),terra_modis(90),terra_modis(102),terra_modis(114)]
feb=[terra_modis(7),terra_modis(19),terra_modis(31),terra_modis(43),terra_modis(55),terra_modis(67),terra_modis(79),terra_modis(91),terra_modis(103),terra_modis(115)]
mar=[terra_modis(8),terra_modis(20),terra_modis(32),terra_modis(44),terra_modis(56),terra_modis(68),terra_modis(80),terra_modis(92),terra_modis(104),terra_modis(116)]
apr=[terra_modis(9),terra_modis(21),terra_modis(33),terra_modis(45),terra_modis(57),terra_modis(69),terra_modis(81),terra_modis(93),terra_modis(105),terra_modis(117)]
may=[terra_modis(10),terra_modis(22),terra_modis(34),terra_modis(46),terra_modis(58),terra_modis(70),terra_modis(82),terra_modis(94),terra_modis(106),terra_modis(118)]
jun=[terra_modis(11),terra_modis(23),terra_modis(35),terra_modis(47),terra_modis(59),terra_modis(71),terra_modis(83),terra_modis(95),terra_modis(107),terra_modis(119)]

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

avgterra_modis=[julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0),maravg(0),apravg(0),mayavg(0),junavg(0)]
stdterra_modis=[julstd,augstd,sepstd,octstd,novstd,decstd,janstd,febstd,marstd,aprstd,maystd,junstd]
ten_months=[julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),maravg(0),apravg(0),mayavg(0),junavg(0)]
monmean=[avgterra_modis,avgterra_modis,avgterra_modis,avgterra_modis,avgterra_modis,avgterra_modis,avgterra_modis,avgterra_modis,avgterra_modis,avgterra_modis, avgterra_modis,avgterra_modis,ten_months]

anoterra_modis=terra_modis-monmean
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin patch olr anomaly
jul=[aqua_modis(0),aqua_modis(12),aqua_modis(24),aqua_modis(36),aqua_modis(48),aqua_modis(60),aqua_modis(72),aqua_modis(84),aqua_modis(96),aqua_modis(108),aqua_modis(120)]
aug=[aqua_modis(1),aqua_modis(13),aqua_modis(25),aqua_modis(37),aqua_modis(49),aqua_modis(61),aqua_modis(73),aqua_modis(85),aqua_modis(97),aqua_modis(109),aqua_modis(121)]
sep=[aqua_modis(2),aqua_modis(14),aqua_modis(26),aqua_modis(38),aqua_modis(50),aqua_modis(62),aqua_modis(74),aqua_modis(86),aqua_modis(98),aqua_modis(110),aqua_modis(122)]
oct=[aqua_modis(3),aqua_modis(15),aqua_modis(27),aqua_modis(39),aqua_modis(51),aqua_modis(63),aqua_modis(75),aqua_modis(87),aqua_modis(99),aqua_modis(111),aqua_modis(123)]
nov=[aqua_modis(4),aqua_modis(16),aqua_modis(28),aqua_modis(40),aqua_modis(52),aqua_modis(64),aqua_modis(76),aqua_modis(88),aqua_modis(100),aqua_modis(112),aqua_modis(124)]
dec=[aqua_modis(5),aqua_modis(17),aqua_modis(29),aqua_modis(41),aqua_modis(53),aqua_modis(65),aqua_modis(77),aqua_modis(89),aqua_modis(101),aqua_modis(113),aqua_modis(125)]
jan=[aqua_modis(6),aqua_modis(18),aqua_modis(30),aqua_modis(42),aqua_modis(54),aqua_modis(66),aqua_modis(78),aqua_modis(90),aqua_modis(102),aqua_modis(114)]
feb=[aqua_modis(7),aqua_modis(19),aqua_modis(31),aqua_modis(43),aqua_modis(55),aqua_modis(67),aqua_modis(79),aqua_modis(91),aqua_modis(103),aqua_modis(115)]
mar=[aqua_modis(8),aqua_modis(20),aqua_modis(32),aqua_modis(44),aqua_modis(56),aqua_modis(68),aqua_modis(80),aqua_modis(92),aqua_modis(104),aqua_modis(116)]
apr=[aqua_modis(9),aqua_modis(21),aqua_modis(33),aqua_modis(45),aqua_modis(57),aqua_modis(69),aqua_modis(81),aqua_modis(93),aqua_modis(105),aqua_modis(117)]
may=[aqua_modis(10),aqua_modis(22),aqua_modis(34),aqua_modis(46),aqua_modis(58),aqua_modis(70),aqua_modis(82),aqua_modis(94),aqua_modis(106),aqua_modis(118)]
jun=[aqua_modis(11),aqua_modis(23),aqua_modis(35),aqua_modis(47),aqua_modis(59),aqua_modis(71),aqua_modis(83),aqua_modis(95),aqua_modis(107),aqua_modis(119)]

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

avgaqua_modis=[julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),janavg(0),febavg(0),maravg(0),apravg(0),mayavg(0),junavg(0)]
stdaqua_modis=[julstd,augstd,sepstd,octstd,novstd,decstd,janstd,febstd,marstd,aprstd,maystd,junstd]
ten_months=[julavg(0),augavg(0),sepavg(0),octavg(0),novavg(0),decavg(0),maravg(0),apravg(0),mayavg(0),junavg(0)]
monmean=[avgaqua_modis,avgaqua_modis,avgaqua_modis,avgaqua_modis,avgaqua_modis,avgaqua_modis,avgaqua_modis,avgaqua_modis,avgaqua_modis,avgaqua_modis, avgaqua_modis,avgaqua_modis,ten_months]

anoaqua_modis=aqua_modis-monmean


;Restore RSW data
restore, '/data/FLASHFlux/timeseries/soc2012_rsw.dat'
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
time = TIMEGEN(130, UNITS="Months", START=JULDAY(7,1,2002))
timeflash=TIMEGEN(7, UNITS="Months", START=JULDAY(6,1,2012))
timeold=TIMEGEN(148, UNITS="Months", START=JULDAY(3,1,2000))
zeros=intarr(160)


;plot, time, flash_net, color=black, background=white
; Generate the Date/Time data  
 PLOT, time, zeros, ytitle='Cloud Frac', XTICKUNITS = ['Time'], Yrange=[0,100],Xrange=[2454000,2456000],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Monthly Cloud Fractions', charsize=1.2
 
 oplot, time, terra_cldFrac, color=red
 oplot, time, terra_modis, color=red, linestyle=2
 
 oplot, time, aqua_cldFrac, color=blue
 oplot, time, aqua_modis, color=blue, linestyle=2
 
 
  PLOT, time, zeros, ytitle='Cloud Frac', XTICKUNITS = ['Time'], Yrange=[-3,3],Xrange=[2454000,2456000],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Monthly Cloud Fractions', charsize=1.2
 
 oplot, time, anoterra_cldFrac, color=red, linestyle=2, thick=1
 oplot, time, anoterra_modis, color=red, psym=-2
 
 oplot, time, anoaqua_cldFrac, color=blue, linestyle=2, thick=1
 oplot, time, anoaqua_modis, color=blue, psym=-2
 
  oplot,timeflash,anoflash,color=blue,psym=-4, thick=2
 oplot,timeold, anoEBAF, color=red,psym=-4, thick=2

xyouts, 2454000, -1.6, '--', color=red, charthick=1.5, charsize=1.5
xyouts, 2454000+200, -1.6, 'SSF1Deg Terra', color=red, charthick=1.5, charsize=1.5
xyouts, 2454000, -1.9, '--', color=blue, charthick=1.5, charsize=1.5
xyouts, 2454000+200, -1.9, 'SSF1Deg Aqua', color=blue, charthick=1.5, charsize=1.5
xyouts, 2454000, -2.2, '-*', color=red, charthick=1.5, charsize=1.5
xyouts, 2454000+200, -2.2, 'MODIS Terra', color=red, charthick=1.5, charsize=1.5
xyouts, 2454000, -2.5, '-*', color=blue, charthick=1.5, charsize=1.5
xyouts, 2454000+200, -2.5, 'MOSDIS Aqua', color=blue, charthick=1.5, charsize=1.5

xyouts, 2454000+200, -2.9, 'Thick line is RSW', color=black, charthick=1.5, charsize=1.5

fNamePlotOut='/data/FLASHFlux/timeseries/soc_2012/Anomaly_CFrac_RSW'
  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)


END
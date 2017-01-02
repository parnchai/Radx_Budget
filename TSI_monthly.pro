Pro TSI_monthly

READCOL, '/data/FF/timeseries/TSI/normalize_TSI.txt', year, mon, day, snum, $
solcon_au, FORMAT=F, SKIPLINE = 1


READCOL, '/data/FF/timeseries/TSI/earthsundist_1983_2013.txt', year, day, ed, FORMAT=F,$
SKIPLINE=1

solcon_ed = solcon_au/ed^2
bnum=6270; 3/1/2000
enum=11323;12/31/2013

solcon=solcon_ed(6269:11322)
year=year(6269:11322)
month = mon(6269:11322)
day = day(6269:11322)
solcon = solcon
Jan = where(month eq 1)
jan_solcon = solcon(Jan)
nyears = n_elements(jan_solcon)

January_solcon = [mean(jan_solcon[0:30]), mean(jan_solcon[31:61]),$
mean(jan_solcon[62:92]), mean(jan_solcon[93:123]), mean(jan_solcon[124:154]), $
mean(jan_solcon[155:185]), mean(jan_solcon[186:216]), mean(jan_solcon[217:247]),$
mean(jan_solcon[248:278]), mean(jan_solcon[279:309]), mean(jan_solcon[310:340]),$
mean(jan_solcon[341:371]), mean(jan_solcon[372:402])]


Feb = where(month eq 2)
feb_solcon = solcon(Feb)
nyears = n_elements(feb_solcon)

February_solcon = [mean(feb_solcon[0:27]), mean(feb_solcon[28:55]),$
mean(feb_solcon[56:83]), mean(feb_solcon[84:112]), mean(feb_solcon[113:140]), $
mean(feb_solcon[141:168]), mean(feb_solcon[169:196]), mean(feb_solcon[197:225]),$
mean(feb_solcon[226:253]), mean(feb_solcon[254:281]), mean(feb_solcon[282:309]),$
mean(feb_solcon[310:338]), mean(feb_solcon[339:366])]


March = where(month eq 3)
mar_solcon = solcon(March)
nyears = n_elements(mar_solcon)/31

March_solcon = [mean(mar_solcon[0:30]), mean(mar_solcon[31:61]),$
 mean(mar_solcon[62:92]), mean(mar_solcon[93:123]), mean(mar_solcon[124:154]), $
mean(mar_solcon[155:185]), mean(mar_solcon[186:216]), mean(mar_solcon[217:247]),$
 mean(mar_solcon[248:278]), mean(mar_solcon[279:309]), mean(mar_solcon[310:340]),$
 mean(mar_solcon[341:371]), mean(mar_solcon[372:402]), mean(mar_solcon[403:433])]

April = where(month eq 4)
apr_solcon = solcon(April)
nyears = n_elements(apr_solcon)
print, nyears
April_solcon = [mean(apr_solcon[0:29]), mean(apr_solcon[30:59]),$
 mean(apr_solcon[60:89]), mean(apr_solcon[90:119]), mean(apr_solcon[120:149]), $
mean(apr_solcon[150:179]), mean(apr_solcon[180:209]), mean(apr_solcon[210:229]),$
 mean(apr_solcon[230:259]), mean(apr_solcon[260:289]), mean(apr_solcon[290:319]),$
 mean(apr_solcon[320:349]), mean(apr_solcon[350:379]), mean(apr_solcon[380:409])]


May = where(month eq 5)
may_solcon = solcon(May)
nyears = n_elements(may_solcon)/31

May_solcon = [mean(may_solcon[0:30]), mean(may_solcon[31:61]),$
 mean(may_solcon[62:92]), mean(may_solcon[93:123]), mean(may_solcon[124:154]), $
mean(may_solcon[155:185]), mean(may_solcon[186:216]), mean(may_solcon[217:247]),$
 mean(may_solcon[248:278]), mean(may_solcon[279:309]), mean(may_solcon[310:340]),$
 mean(may_solcon[341:371]), mean(may_solcon[372:402]), mean(may_solcon[403:433])]

June = where(month eq 6)
jun_solcon = solcon(June)
nyears = n_elements(jun_solcon)/30

June_solcon = [mean(apr_solcon[0:29]), mean(jun_solcon[30:59]),$
 mean(jun_solcon[60:89]), mean(jun_solcon[90:119]), mean(jun_solcon[120:149]), $
mean(jun_solcon[150:179]), mean(jun_solcon[180:209]), mean(jun_solcon[210:229]),$
 mean(jun_solcon[230:259]), mean(jun_solcon[260:289]), mean(jun_solcon[290:319]),$
 mean(jun_solcon[320:349]), mean(jun_solcon[350:379]), mean(jun_solcon[380:409])]
 
 
Jul = where(month eq 7)
jul_solcon = solcon(Jul)
nyears = n_elements(jul_solcon)/31

July_solcon = [mean(jul_solcon[0:30]), mean(jul_solcon[31:61]),$
 mean(jul_solcon[62:92]), mean(jul_solcon[93:123]), mean(jul_solcon[124:154]), $
mean(jul_solcon[155:185]), mean(jul_solcon[186:216]), mean(jul_solcon[217:247]),$
 mean(jul_solcon[248:278]), mean(jul_solcon[279:309]), mean(jul_solcon[310:340]),$
 mean(jul_solcon[341:371]), mean(jul_solcon[372:402]), mean(jul_solcon[403:433])]
 

Aug = where(month eq 8)
aug_solcon = solcon(Aug)
nyears = n_elements(aug_solcon)/31

August_solcon = [mean(aug_solcon[0:30]), mean(aug_solcon[31:61]),$
 mean(aug_solcon[62:92]), mean(aug_solcon[93:123]), mean(aug_solcon[124:154]), $
mean(aug_solcon[155:185]), mean(aug_solcon[186:216]), mean(aug_solcon[217:247]),$
 mean(aug_solcon[248:278]), mean(aug_solcon[279:309]), mean(aug_solcon[310:340]),$
 mean(aug_solcon[341:371]), mean(aug_solcon[372:402]), mean(aug_solcon[403:433])]


Sept = where(month eq 9)
sep_solcon = solcon(Sept)
nyears = n_elements(sep_solcon)/30

September_solcon = [mean(sep_solcon[0:29]), mean(sep_solcon[30:59]),$
 mean(sep_solcon[60:89]), mean(sep_solcon[90:119]), mean(sep_solcon[120:149]), $
mean(sep_solcon[150:179]), mean(sep_solcon[180:209]), mean(sep_solcon[210:229]),$
 mean(sep_solcon[230:259]), mean(sep_solcon[260:289]), mean(sep_solcon[290:319]),$
 mean(sep_solcon[320:349]), mean(sep_solcon[350:379]), mean(sep_solcon[380:409])]
 
 
Oct = where(month eq 10)
oct_solcon = solcon(Oct)
nyears = n_elements(oct_solcon)/31

October_solcon = [mean(oct_solcon[0:30]), mean(oct_solcon[31:61]),$
 mean(oct_solcon[62:92]), mean(oct_solcon[93:123]), mean(oct_solcon[124:154]), $
mean(oct_solcon[155:185]), mean(oct_solcon[186:216]), mean(oct_solcon[217:247]),$
 mean(oct_solcon[248:278]), mean(oct_solcon[279:309]), mean(oct_solcon[310:340]),$
 mean(oct_solcon[341:371]), mean(oct_solcon[372:402]), mean(oct_solcon[403:433])]
 
 
Nov = where(month eq 11)
nov_solcon = solcon(Nov)
nyears = n_elements(nov_solcon)/30

November_solcon = [mean(nov_solcon[0:29]), mean(nov_solcon[30:59]),$
 mean(nov_solcon[60:89]), mean(nov_solcon[90:119]), mean(nov_solcon[120:149]), $
mean(nov_solcon[150:179]), mean(nov_solcon[180:209]), mean(nov_solcon[210:229]),$
 mean(nov_solcon[230:259]), mean(nov_solcon[260:289]), mean(nov_solcon[290:319]),$
 mean(nov_solcon[320:349]), mean(nov_solcon[350:379]), mean(nov_solcon[380:409])]
 
 
Dec = where(month eq 12)
dec_solcon = solcon(Dec)
nyears = n_elements(dec_solcon)/31

December_solcon = [mean(dec_solcon[0:30]), mean(dec_solcon[31:61]),$
 mean(dec_solcon[62:92]), mean(dec_solcon[93:123]), mean(dec_solcon[124:154]), $
mean(dec_solcon[155:185]), mean(dec_solcon[186:216]), mean(dec_solcon[217:247]),$
 mean(dec_solcon[248:278]), mean(dec_solcon[279:309]), mean(dec_solcon[310:340]),$
 mean(dec_solcon[341:371]), mean(dec_solcon[372:402]), mean(dec_solcon[403:433])]

month_solcon = [March_solcon[0], April_solcon[0], May_solcon[0], $
June_solcon[0], July_solcon[0], August_solcon[0], September_solcon[0],$
October_solcon[0], November_solcon[0], December_solcon[0],January_solcon[0],$
 February_solcon[0],$
  March_solcon[1], April_solcon[1], May_solcon[1], $
June_solcon[1], July_solcon[1], August_solcon[1], September_solcon[1],$
October_solcon[1], November_solcon[1], December_solcon[1], January_solcon[1],$
 February_solcon[1],$
 March_solcon[2], April_solcon[2], May_solcon[2], $
June_solcon[2], July_solcon[2], August_solcon[2], September_solcon[2],$
October_solcon[2], November_solcon[2], December_solcon[2], January_solcon[2],$
 February_solcon[2],$
  March_solcon[3], April_solcon[3], May_solcon[3], $
June_solcon[3], July_solcon[3], August_solcon[3], September_solcon[3],$
October_solcon[3], November_solcon[3], December_solcon[3], January_solcon[3],$
 February_solcon[3],$
  March_solcon[4], April_solcon[4], May_solcon[4], $
June_solcon[4], July_solcon[4], August_solcon[4], September_solcon[4],$
October_solcon[4], November_solcon[4], December_solcon[4], January_solcon[4],$
 February_solcon[4],$
  March_solcon[5], April_solcon[5], May_solcon[5], $
June_solcon[5], July_solcon[5], August_solcon[5], September_solcon[5],$
October_solcon[5], November_solcon[5], December_solcon[5], January_solcon[5],$
 February_solcon[5],$
  March_solcon[6], April_solcon[6], May_solcon[6], $
June_solcon[6], July_solcon[6], August_solcon[6], September_solcon[6],$
October_solcon[6], November_solcon[6], December_solcon[6], January_solcon[6],$
 February_solcon[6],$
  March_solcon[7], April_solcon[7], May_solcon[7], $
June_solcon[7], July_solcon[7], August_solcon[7], September_solcon[7],$
October_solcon[7], November_solcon[7], December_solcon[7], January_solcon[7],$
 February_solcon[7],$
  March_solcon[8], April_solcon[8], May_solcon[8], $
June_solcon[8], July_solcon[8], August_solcon[8], September_solcon[8],$
October_solcon[8], November_solcon[8], December_solcon[8], January_solcon[8],$
 February_solcon[8],$
  March_solcon[9], April_solcon[9], May_solcon[9], $
June_solcon[9], July_solcon[9], August_solcon[9], September_solcon[9],$
October_solcon[9], November_solcon[9], December_solcon[9],January_solcon[9],$
 February_solcon[9],$
  March_solcon[10], April_solcon[10], May_solcon[10], $
June_solcon[10], July_solcon[10], August_solcon[10], September_solcon[10],$
October_solcon[10], November_solcon[10], December_solcon[10],January_solcon[10],$
 February_solcon[10],$
  March_solcon[11], April_solcon[11], May_solcon[11], $
June_solcon[11], July_solcon[11], August_solcon[11], September_solcon[11],$
October_solcon[11], November_solcon[11], December_solcon[11],January_solcon[11],$
 February_solcon[11],$
  March_solcon[12], April_solcon[12], May_solcon[12], $
June_solcon[12], July_solcon[12], August_solcon[12], September_solcon[12],$
October_solcon[12], November_solcon[12], December_solcon[12],January_solcon[12],$
 February_solcon[12],$
  March_solcon[13], April_solcon[13], May_solcon[13], $
June_solcon[13], July_solcon[13], August_solcon[13], September_solcon[13],$
October_solcon[13], November_solcon[13], December_solcon[13]]

nmon = n_elements(month_solcon)
month_solcon = month_solcon
mu_solcon = mean(month_solcon)
sig_solcon = stddev(month_solcon)

;Need to normalize RMIB TSI with EBAF TSI using monthly climatology differences
cdfid= ncdf_open('/data/FF/timeseries/EBAF/CERES_EBAF-TOA_Ed2.7_Subset_200003-201306.nc')
varid=ncdf_varid(cdfid, 'gsolar_mon')
ncdf_varget,cdfid,varid, EBAF_solar
ncdf_close, cdfid

;diff_solar = EBAF_solar[10:153] - month_solcon[10:153] ;Jan2001-Dec2012 
;Create diff_solar climatology

;jan_solar = mean([diff_solar(0),diff_solar(12),diff_solar(24),diff_solar(36),diff_solar(48)$
;,diff_solar(60),diff_solar(72),diff_solar(84),diff_solar(96),diff_solar(108),diff_solar(120)$
;,diff_solar(132)]);,diff_solar(144)]);,diff_solar(156)
  
;feb_solar = mean([diff_solar(1),diff_solar(13),diff_solar(25),diff_solar(37),diff_solar(49)$
;,diff_solar(61),diff_solar(73),diff_solar(85),diff_solar(97),diff_solar(109),diff_solar(121)$
;,diff_solar(133)]);,diff_solar(145)]);,diff_solar(157)])

;mar_solar = mean([diff_solar(2),diff_solar(14),diff_solar(26),diff_solar(38),diff_solar(50)$
;,diff_solar(62),diff_solar(74),diff_solar(86),diff_solar(98),diff_solar(110),diff_solar(122)$
;,diff_solar(134)]);,diff_solar(146)]);,diff_solar(158)])

;apr_solar = mean([diff_solar(3),diff_solar(15),diff_solar(27),diff_solar(39),diff_solar(51)$
;,diff_solar(63),diff_solar(75),diff_solar(87),diff_solar(99),diff_solar(111),diff_solar(123)$
;,diff_solar(135)]);,diff_solar(147)]);,diff_solar(159)])

;may_solar = mean([diff_solar(4),diff_solar(16),diff_solar(28),diff_solar(40),diff_solar(52)$
;,diff_solar(64),diff_solar(76),diff_solar(88),diff_solar(100),diff_solar(112),diff_solar(124)$
;,diff_solar(136)]);,diff_solar(148)])

;jun_solar = mean([diff_solar(5),diff_solar(17),diff_solar(29),diff_solar(41),diff_solar(53)$
;,diff_solar(65),diff_solar(77),diff_solar(89),diff_solar(101),diff_solar(113),diff_solar(125)$
;,diff_solar(137)]);,diff_solar(149)])

;jul_solar = mean([diff_solar(6),diff_solar(18),diff_solar(30),diff_solar(42),diff_solar(54)$
;,diff_solar(66),diff_solar(78),diff_solar(90),diff_solar(102),diff_solar(114),diff_solar(126)$
;,diff_solar(138)]);,diff_solar(150)])

;aug_solar = mean([diff_solar(7),diff_solar(19),diff_solar(31),diff_solar(43),diff_solar(55)$
;,diff_solar(67),diff_solar(79),diff_solar(91),diff_solar(103),diff_solar(115),diff_solar(127)$
;,diff_solar(139)]);,diff_solar(151)])

;sep_solar = mean([diff_solar(8),diff_solar(20),diff_solar(32),diff_solar(44),diff_solar(56)$
;,diff_solar(68),diff_solar(80),diff_solar(92),diff_solar(104),diff_solar(116),diff_solar(128)$
;,diff_solar(140)]);,diff_solar(152)])

;oct_solar = mean([diff_solar(9),diff_solar(21),diff_solar(33),diff_solar(45),diff_solar(57)$
;,diff_solar(69),diff_solar(81),diff_solar(93),diff_solar(105),diff_solar(117),diff_solar(129)$
;,diff_solar(141)]);,diff_solar(153)])

;nov_solar = mean([diff_solar(10),diff_solar(22),diff_solar(34),diff_solar(46),diff_solar(58),$
;diff_solar(70),diff_solar(82),diff_solar(94),diff_solar(106),diff_solar(118),diff_solar(130)$
;,diff_solar(142)]) ;,diff_solar(154)])

;dec_solar = mean([diff_solar(11),diff_solar(23),diff_solar(35),diff_solar(47),diff_solar(59)$
;,diff_solar(71),diff_solar(83),diff_solar(95),diff_solar(107),diff_solar(119),diff_solar(131)$
;,diff_solar(143)]);,diff_solar(155)])

;solar_diffclim = [jan_solar, feb_solar, mar_solar, apr_solar, may_solar, jun_solar,$
;jul_solar, aug_solar, sep_solar, oct_solar, nov_solar, dec_solar]
;ten_solar = [mar_solar, apr_solar, may_solar, jun_solar,$
;jul_solar, aug_solar, sep_solar,oct_solar, nov_solar, dec_solar]


;diffsclim_array=cmreplicate(solar_diffclim,13)
;diffsclim_array=reform(diffsclim_array,156)
;diffsclim_array = [ten_solar, diffsclim_array]
;print, solar_diffclim
;Normalize RMIB using solar monthly difference climatology
; month_solcon = month_solcon + diffsclim_array
 
; diff_normal = EBAF_solar[10:153] - month_solcon[10:153]
; twosigma = 2*stddev(diff_normal)
; print, 'two_sigma: ', twosigma 
;help, month_solcon

;diff_sc = EBAF_solar - month_solcon[0:159]
geodetic = month_solcon[142:153]/EBAF_solar[142:153]
help, geodetic
geclim_arr = cmreplicate(geodetic,13)

geclim_arr = reform(geclim_arr,156)
ten_ge = geodetic(2:11)
geclim_arr = [ten_ge,geclim_arr]
month_solcon = month_solcon/geclim_arr
diff_sc = EBAF_solar - month_solcon[0:159]
help, month_solcon
!p.multi=[0,1,2,0,1]
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
time = TIMEGEN(166, UNITS="months", START=JULDAY(3,1,2000))

PLOT, time, 0.999676*month_solcon, ytitle='TSI(w/m^2)', XTICKUNITS = ['Time'], Yrange=[325,355],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of Month TSI', charsize=1.2
 oplot, time, EBAF_solar, color=red, thick=2
 
PLOT, time, diff_sc, ytitle='TSI(w/m^2)', XTICKUNITS = ['Time'], Yrange=[-0.5,0.5],$
 color=black, background=white, XTICKINTERVAL=1, XMINOR=12, $
 Title='Timeseries of EBAF TSI - SORCE V14 TSI', charsize=1.2 
 ;xyouts, 2455400.0, 1360.5, 'Mean: ', color=black, charsize=2.0
 ;xyouts, 2455595.0, 1360.5, mu_solcon, color=black, charsize=2.0
 ;xyouts, 2456225.0, 1360.5, 'W/m^2', color=black, charsize=2.0
 
 ; xyouts, 2455000.0, 1360.25, 'Standard Deviation: ', color=black, charsize=2.0
 ;xyouts, 2455595.0, 1360.25, sig_solcon, color=black, charsize=2.0
 ;xyouts, 2456225.0, 1360.25, 'W/m^2', color=black, charsize=2.0

 fNamePlotOut='/data/FF/timeseries/TSI/month_solar'
  image= TVREAD(filename=fNamePlotOut,Quality=100,/JPEG,/NODIALOG)
  
  ;month_solcon = [EBAF_solar(10:
  
  save, month_solcon, filename='/data/FF/timeseries/month_solcon.sav'
end
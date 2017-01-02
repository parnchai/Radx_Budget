Pro sorceforecast

;open file
;number of data from Jan 1,1983 - Jun 20, 2013
ndata=11138
temp=''
sorcedata=fltarr(4, ndata)
close,1
openr,1, '/data/FF/timeseries/sorce_v14_1983_2013.txt'
readf,1,temp
readf,1,sorcedata

sorceyear=sorcedata(0,*)
sorcemth=sorcedata(1,*)
sorceday=sorcedata(2,*)
solcon_au=sorcedata(3,*)
solcon=reform(solcon_au)
help, solcon
sma365=TS_SMOOTH(solcon,365)
help, sma365
time = indgen(ndata)
;time = TIMEGEN(11138, UNITS="Days", START=JULDAY(1,1,1983))
;close,1

P = psd(time,solcon, freq, /plot)
  print, P

END


pro write_flash_anamoly
;flash anamoly data output
;**************************************************************************************************
;NET
;**************************************************************************************************
restore, '/data/FLASHFlux/timeseries/corrected_flash.sav'
flashnet_2G=float(corrected_flashnet)
flashnet_2G_overlap=float(corrected_flashnet[8:43])
;close,1
result_flashnet_2G=moment(flashnet_2G,mdev=mean_dev_flashnet_2G,sdev=std_flashnet_2G)
help, result_flashnet_2G
help, flashnet_2G

PRINT, 'Mean: ', result_flashnet_2G[0] & PRINT, 'Variance: ', result_flashnet_2G[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_flashnet_2G & Print, 'Standard Deviation:', std_flashnet_2G 
   
;************************************************************************************************
;OLR
;*************************************************************************************************
close,1

;open ceres FLASH file - Version 2G
ndata=56
temp=''
;versionf=''
;datef=''
flashdata=fltarr(8,ndata)
close,1
openr,1,'/data/FLASHFlux/timeseries/Flashflux_glbmean/globe_pc.txt'
readf,1,temp
readf,1,flashdata
flasholr_2G=fltarr(ndata)

flasholr_2G=flashdata(4,*)
flasholr_2G_overlap=flasholr_2G[8:43]
close,1
result_flasholr_2G=moment(flasholr_2G,mdev=mean_dev_flasholr_2G,sdev=std_flasholr_2G)
help, result_flasholr_2G
PRINT, 'Mean: ', result_flasholr_2G[0] & PRINT, 'Variance: ', result_flasholr_2G[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_flasholr_2G & Print, 'Standard Deviation:', std_flasholr_2G

;*************************************************************************************************
;RSW
;**************************************************************************************************
close,1
restore, '/data/FLASHFlux/timeseries/corrected_flash.sav'
flashrsw_2G=float(corrected_flashrsw)
flashrsw_2G_overlap=float(corrected_flashrsw[8:43]) ;from 3/2007 to 2/2010
close,1
result_flashrsw_2G=moment(flashrsw_2G,mdev=mean_dev_flashrsw_2G,sdev=std_flashrsw_2G)
help, result_flashrsw_2G
PRINT, 'Mean: ', result_flashrsw_2G[0] & PRINT, 'Variance: ', result_flashrsw_2G[1] & $  
   Print, 'Mean Absolute Deviation:', mean_dev_flashrsw_2G & Print, 'Standard Deviation:', std_flashrsw_2G
end


library(data.table)
library(dplyr)
library(lubridate)

dt_house <- fread("./Data/household_power_consumption.txt")
dt_house[,Date:=dmy(dt_house$Date)]
dt_house[, DateTime:=paste(Date, Time)]
dt_house[, DateTime:=ymd_hms(DateTime)]

dt_feb <- copy(dt_house[year(Date)==2007 & month(Date)==2 & (day(Date)==1 | day(Date) ==2)])
dt_feb3 <- copy(dt_house[year(DateTime)==2007 & month(Date)==2 & day(Date)==3 & hour(DateTime)==0  & minute(DateTime)==0 & second(DateTime)==0])
dt_feb <- rbind(dt_feb, dt_feb3)


remove(dt_house)


dt_feb[, Global_active_power:=as.numeric(Global_active_power)]



png(filename = "plot2.png", width = 480, height = 480)

plot(dt_feb$DateTime, dt_feb$Global_active_power, 
     type="l", xaxt="n", xlab="",
     ylab="Global Active Power (kilowatts)")
dt_label <- dt_feb[hour(DateTime)==0  & minute(DateTime)==0 & second(DateTime)==0]$DateTime

axis(1, at=dt_label, wday(dt_label, label=T))


dev.off()


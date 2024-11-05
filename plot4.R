


library(data.table)
library(dplyr)
library(lubridate)

dt_house <- fread("./Data/household_power_consumption.txt")
dt_house[,Date:=dmy(dt_house$Date)]
dt_house[, DateTime:=paste(Date, Time)]
dt_house[, DateTime:=ymd_hms(DateTime)]

dt_house[Sub_metering_1=="?", Sub_metering_1:='0']
dt_house[Sub_metering_2=="?", Sub_metering_2:='0']
dt_house[Sub_metering_3=="?", Sub_metering_3:='0']

dt_feb <- copy(dt_house[year(Date)==2007 & month(Date)==2 & (day(Date)==1 | day(Date) ==2)])
dt_feb3 <- copy(dt_house[year(DateTime)==2007 & month(Date)==2 & day(Date)==3 & hour(DateTime)==0  & minute(DateTime)==0 & second(DateTime)==0])
dt_feb <- rbind(dt_feb, dt_feb3)

head(dt_house)

remove(dt_house)

dt_feb[, Global_active_power:=as.numeric(Global_active_power)]
dt_feb[, Sub_metering_1:=as.numeric(Sub_metering_1)]
dt_feb[, Sub_metering_2:=as.numeric(Sub_metering_2)]
dt_feb[, Sub_metering_3:=as.numeric(Sub_metering_3)]
dt_feb[, Voltage:=as.numeric(Voltage)]

head(dt_feb)

png(filename = "plot4.png", width = 480, height = 480)

dt_label <- dt_feb[hour(DateTime)==0  & minute(DateTime)==0 & second(DateTime)==0]$DateTime

par(mfrow=c(2,2), mar=c(4,4,1,1))

#subplot 1
plot(dt_feb$DateTime, dt_feb$Global_active_power, 
     type="l", xaxt="n", xlab="",
     ylab="Global Active Power (kilowatts)")

axis(1, at=dt_label, wday(dt_label, label=T))

#subplot 2
plot(dt_feb$DateTime, dt_feb$Voltage, 
     type="l", xaxt="n", xlab="datetime",
     ylab="Voltage", col="black")

axis(1, at=dt_label, wday(dt_label, label=T))

#subplot 3
plot(dt_feb$DateTime, dt_feb$Sub_metering_1, 
     type="l", xaxt="n", xlab="",
     ylab="Energy Sub Metering", col="black")


lines(dt_feb$DateTime, dt_feb$Sub_metering_2, 
      type="l", xaxt="n", xlab="",
      col="red")


lines(dt_feb$DateTime, dt_feb$Sub_metering_3, 
      type="l", xaxt="n", xlab="",
      ,col="blue")

dt_label <- dt_feb[hour(DateTime)==0  & minute(DateTime)==0 & second(DateTime)==0]$DateTime

axis(1, at=dt_label, wday(dt_label, label=T))

legend("topright", lty=c(1,1,1), 
       col=c("black", "red", "blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#subplot 4
plot(dt_feb$DateTime, dt_feb$Global_reactive_power, 
     type="l", xaxt="n", xlab="datetime",
     ylab="Global Reactive Power (kilowatts)")

axis(1, at=dt_label, wday(dt_label, label=T))

dev.off()



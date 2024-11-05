

library(data.table)
library(dplyr)
library(lubridate)

dt_house <- fread("./Data/household_power_consumption.txt")
dt_house[,Date:=dmy(dt_house$Date)]
dt_feb <- copy(dt_house[year(Date)==2007 & month(Date)==2 & (day(Date)==1 | day(Date) ==2)])
remove(dt_house)

dt_feb[, Global_active_power:=as.numeric(Global_active_power)]

png(filename = "plot1.png", width = 480, height = 480)


hist(dt_feb$Global_active_power, 
     col="red", xlab="Global Active Power (kilowatts)", 
     ylab = "Frequency",
     main="Global Active Power")


dev.off()


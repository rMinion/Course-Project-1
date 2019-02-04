########### Stage 0: Downloading data, subseting and formating dates

#Downloading data to working directory
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "epc.zip", 
              method = "curl", mode = "wb")
#unziping folder
unzip("epc.zip")

##calculating needed RAM memory 
# memory required = no. of column * no. of rows * 8 bytes/numeric
# bytes
9*2075259*8 
# aprox. needed RAM is:
round(9*2075259*8/2^{20})

#rading the data (just to prove that there is no need to ant fast)
library(dplyr)
data<-read.table(file = "household_power_consumption.txt", header = TRUE, sep=";", 
                 stringsAsFactors = FALSE, dec=".", colClasses = c("character","character", "numeric","numeric","numeric","numeric","numeric","numeric","numeric"), 
                 na.strings = "?")

#checking data structure
str(data)

#seting "Date" class 
data$Date<-as.Date(data$Date, format = "%d/%m/%Y")

#filtering only dates between 1st and 2nd of February 2007
data<-data %>%
  filter(Date >= as.Date("01/02/2007",format = "%d/%m/%Y") & Date <=as.Date("02/02/2007", format = "%d/%m/%Y"))

#checking if the filter is ok 
table(data$Date)


########## Plot no. 4: 

#opening file
png(filename = "plot4.png", width = 480, height = 480, units = "px")
# creating grid 2x2
par(mfrow = c(2,2))
#plot no.1
plot(x = time(data$Time), y = data$Global_active_power, type="l", 
     ylab = "Global Active Power (kilowatts)", xlab="", xaxt="n")
axis(side = 1, at = c(0, 2880/2, 2880), labels = c("Thu", "Fri", "Sat"))
#plot no.2
plot(x = time(data$Time), y = data$Voltage, type="l", 
     ylab = "Voltage", xlab="datetime", xaxt="n")
axis(side = 1, at = c(0, 2880/2, 2880), labels = c("Thu", "Fri", "Sat"))
#plot no.3
plot(x = time(data$Time), y = data$Sub_metering_1, type="l", 
     ylab = "Energy sub metering", xlab="", xaxt="n")
lines(x = time(data$Time), y = data$Sub_metering_2, col = "red")
lines(x = time(data$Time), y = data$Sub_metering_3, col = "blue")
axis(side = 1, at = c(0, 2880/2, 2880), labels = c("Thu", "Fri", "Sat"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = c(1,1), lwd = c(1,1))
#plot no.4 
plot(x = time(data$Time), y = data$Global_reactive_power, type="h", xlab="datetime", xaxt="n")
axis(side = 1, at = c(0, 2880/2, 2880), labels = c("Thu", "Fri", "Sat"))
dev.off()
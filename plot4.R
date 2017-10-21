#specify packages required
packages <- c("lubridate", "dplyr")

#load required packages to library. 
#install if they are not available.
check.packages <- function(x){
        if (require(x, character.only = TRUE) == FALSE){
                install.packages(x, dep = TRUE)
                library(x, character.only = TRUE)
        }
        else {
                library(x, character.only = TRUE)
        }
}

lapply(packages, FUN = check.packages)

#download the source file
if(!file.exists("data.txt")) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                      destfile = "data.zip")
        unzip("data.zip")
        file.rename("household_power_consumption.txt", "data.txt")
}

#import the file into R
data <- read.table("data.txt", header = TRUE, sep = ";", na.strings = "?")

#convert the first column to date
data$Date <- dmy(data$Date)

#filter the data to the relevant dates
filtered <- filter(data, Date == "2007-02-01" | Date == "2007-02-02")

#slice the data to the relevant vector(s)
plot4 <-  mutate(filtered, Time2 = paste(Date, Time)) %>% 
                select(-Time) %>% 
                rename(Time = Time2)
plot4$Time <- ymd_hms(plot4$Time)


#Create the 4th Plot, a collection of plots!

png(filename = "plot4.png", width = 480, height = 480,
    units = "px", bg = "transparent")
par(mfrow = c(2,2))
#Plot the 1st Graph
plot(plot4$Time, plot4$Global_active_power, 
     type = "l", ylab = "Global Active Power (kilowatts)", xlab="")

#Plot the 2nd Graph
plot(plot4$Time, plot4$Voltage, 
     type = "l", ylab = "Voltage", xlab = "datetime")

#Plot the 3rd Graph
with(plot4, plot(Time, Sub_metering_1, type = "l", 
                 ylab = "Energy sub metering", xlab = "")) 
with(plot4, lines(Time, Sub_metering_2, col = "red"))
with(plot4, lines(Time, Sub_metering_3, col = "blue"))
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = 1, col = c("black","red","blue"), bty = "n")

#Plot the 4th Graph
with(plot4, plot(Time, Global_reactive_power, 
                 xlab = "datetime", type = "l"))

dev.off()

        
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
plot3 <- select(filtered, Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3) %>% 
                mutate(Time2 = paste(Date, Time)) %>% 
                select(Time2, Sub_metering_1, Sub_metering_2, Sub_metering_3) %>% 
                rename(Time = Time2)
plot3$Time <- ymd_hms(plot3$Time)


#Create the 3rd Plot, comparing Energy sub metering against Time
png(filename = "plot3.png", width = 480, height = 480,
    units = "px", bg = "transparent")
with(plot3, plot(Time, Sub_metering_1, type = "l", 
                 ylab = "Energy sub metering", xlab = "")) 
with(plot3, lines(Time, Sub_metering_2, col = "red"))
with(plot3, lines(Time, Sub_metering_3, col = "blue"))
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = 1, col = c("black","red","blue"))

dev.off()

        
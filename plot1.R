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

#slice the data to the relevant vector
gap <- as.numeric(filtered$Global_active_power)
#gap <- as.numeric(lapply(gap, FUN = (function(x) {x/1000})))


#create the 1st plot, a histogram of global active power
png(filename = "plot1.png", width = 480, height = 480,
    units = "px", bg = "transparent")
hist(gap, col = "red", 
     xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")
dev.off()

        
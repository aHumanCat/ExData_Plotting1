#
# EDA_getData.R
#  common script to get and unzip
#  data archive.
#  also sets file realated variables 
#  that are used in this script
#
# plot4.R ( this file )
#  reads in raw data file, subsets as desribed 
#  and creates the plot specifed and writes
#  it to the png device listed
#

source("./EDA_getData.R")
library(data.table)
library(dplyr)


# read in the full data set
hPowerAll <- read.table( dataSetFilePath , 
                         sep=";", 
                         dec=".", 
                         na.strings="?",
                         header=TRUE,
                         colClasses=c( rep("character",2), rep("numeric",7)))

# subset to grab Feb 1 , Feb 2 2007 data only
cat( sprintf(" | Subsetting %s \n", dataSetFilePath ))
smallDataSet <- hPowerAll[ grep("^[12]/2/2007", hPowerAll$Date), ]

# remove the full data set from memory - ( conserve resources )
rm( hPowerAll )

# create new combined date/time column and convert to POSIX time
smallDataSet <- mutate( smallDataSet, 
                        Date_Time = paste( Date, Time, sep = ' '))

smallDataSet$Date_Time <- as.POSIXct( smallDataSet$Date_Time, 
                                      format="%d/%m/%Y %H:%M:%S" )


# open the png file descriptor
#  file is written to the working directory
cat( " | Creating plot3.png" )
png(file = "plot4.png", bg = "transparent")

# set layout for for plots , column firs orientation
par(mfcol=c(2,2))

# write plot 1 to the png file 
plot( smallDataSet$Date_Time, 
      smallDataSet$Global_active_power,
      type="l",
      ylab="Global Active Power",
      xlab="",
      sub="")

# write plot 2 out to the png device ( set 1 )
plot( smallDataSet$Date_Time, 
      smallDataSet$Sub_metering_1,
      type="l",
      ylab="Energy sub metering",
      xlab="",
      sub="")

# add set 2 to plot 2
points(smallDataSet$Date_Time,smallDataSet$Sub_metering_2,type="l",col="RED")

# add set 3 to plot 2
points(smallDataSet$Date_Time,smallDataSet$Sub_metering_3,type="l",col="BLUE")

# add the legend
legend("topright", 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black","red","blue"),
       ,lty=1,
       lwd=1)

# write plot 3 out to the png device
plot( smallDataSet$Date_Time, 
      smallDataSet$Voltage,
      type="l",
      ylab="Voltage",
      xlab="datetime",
      sub="")

# write plot 4 out to the png device
plot( smallDataSet$Date_Time, 
      smallDataSet$Global_reactive_power,
      type="l",
      ylab="Global_reactive_power",
      xlab="datetime",
      sub="")

#close the file descriptor
dev.off()

#end of program


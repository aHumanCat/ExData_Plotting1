#
# EDA_getData.R
#  common script to get and unzip
#  data archive.
#  also sets file realated variables 
#  that are used in this script
#
# plot3.R ( this file )
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


# create new combined date/time column and convert to POSIX time
smallDataSet <- mutate( smallDataSet, 
                        Date_Time = paste( Date, Time, sep = ' '))

smallDataSet$Date_Time <- as.POSIXct( smallDataSet$Date_Time, 
                                      format="%d/%m/%Y %H:%M:%S" )


# open the png file descriptor
#  file is written to the working directory
cat( " | Creating plot3.png" )
png(file = "plot3.png", bg = "transparent")

# write the plot out to the png device ( set 1 )
plot( smallDataSet$Date_Time, 
      smallDataSet$Sub_metering_1,
      type="l",
      ylab="Energy sub metering",
      xlab="",
      sub="")

#(add set 2)
points(smallDataSet$Date_Time,smallDataSet$Sub_metering_2,type="l",col="RED")

#(add set 3)
points(smallDataSet$Date_Time,smallDataSet$Sub_metering_3,type="l",col="BLUE")

# add legend 
legend("topright", 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black","red","blue"),
       ,lty=1,
       lwd=1)

#close the file descriptor
dev.off()

#end of program

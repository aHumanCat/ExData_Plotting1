#
# EDA_getData.R
#  common script to get and unzip
#  data archive.
#  also sets file realated variables 
#  that are used in this script
#
# plot1.R ( this file )
#  reads in raw data file, subsets as desribed 
#  and creates the plot specifed and writes
#  it to the png device listed
#

source("./EDA_getData.R")
library(data.table)


cat( sprintf(" | Reading in %s\n", dataSetFilePath ))

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

# open the png file descriptor
#  file is written to the working directory
cat( " | Creating plot1.png" )
png(file = "plot1.png", bg = "transparent")

# write the plot out to the png device
hist( smallDataSet$Global_active_power ,
      col="RED",
      main="Global Active Power",
      xlab="Global Active Power (kilowatts)")

#close the file descriptor
dev.off()

#end of program

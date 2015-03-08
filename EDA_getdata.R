#
# EDA_getData.R
# Get and extract raw data file
#   per user instructions
# This files is sourced by all the
#   plotting scripts in tne assigment
# The raw data file will be saved the "data"
#   directory in in the getwd() of the current R session
# "./data" will be created if it does not exist
#
workingDir <- getwd()
dataDir <- sprintf("%s/data", workingDir)
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataSetArchive <-  sprintf( "%s/household_power_consumption.zip", dataDir )
dataSetFile <- "household_power_consumption.txt"
dataSetFilePath <- sprintf("%s/%s", dataDir, dataSetFile )
osType <- .Platform$OS.type
validResponse <- FALSE
useLocalDataSet <- FALSE


extractDataFile <- function(){
  
  cat( sprintf(" | Unzipping %s\n", dataSetArchive ))
  unzip( dataSetArchive, exdir = dataDir )
  
  
}


if( !file.exists( dataDir )){
  
  cat( sprintf( " | Creating data directory %s\n", dataDir ))
  dir.create( dataDir )
  
}else{
  
  if( file.exists( dataSetArchive)){
    
    cat(sprintf("\n | Dataset Archive %s is existing.\n", dataSetArchive))
    
    while( validResponse == FALSE ){
      
      answer <- readline("Would you like to use the local copy?[ Y or N ] ")
      
      if( validResponse <- grepl("[Yy]", answer) ){
        
        useLocalDataSet <- TRUE
        cat( sprintf(" | Using local copy of %s\n", dataSetArchive))
      }
      else if( validResponse <- grepl("[Nn]", answer ) ){
        useLocalDataSet <- FALSE
      }
    }
  }
}




#
# Download dataset archive if needed/requested
#
if( !useLocalDataSet ){
  
  cat( sprintf(" | Downloading data Archive\n"))
  
  if( osType == "windows" ){
    download.file( fileUrl, destfile = dataSetArchive )
  }else{
    download.file( fileUrl, destfile = dataSetArchive, method = "curl" )
  }
  extractDataFile()  

}else{
  
  if( !file.exists( dataSetFilePath )){
   
    extractDataFile()
  }
}

cat( sprintf(" | %s is ready for use.\n", dataSetFilePath ) )

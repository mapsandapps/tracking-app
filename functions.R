appendTrack <- function(filenames) {
  extensions <- gsub("^.+\\.", "", filenames)
  fileNumbers <- 1:length(filenames)
  for (fileNumber in fileNumbers) {
    # delete original extension and add new one:
    newFilename <-  paste(sub(paste("\\.", extensions[fileNumber], sep = ""), "", filenames[fileNumber]), ".csv", sep = "") 

    if (extensions[fileNumber] != "csv") {
      gpsbabelCommand <- paste("sudo gpsbabel -t -i ", 
      extensions[fileNumber], 
      " -f '", 
      filenames[fileNumber],
      "' -o unicsv -F '", 
      newFilename,
      "'",
      sep = "")

      system(gpsbabelCommand)
    } else {
      newFilename <- filenames[fileNumber]
    }

    # add variables (based on GPS/addvariables.R)
    track <- read.csv(newFilename, 
      header = TRUE)
    if(!exists("Altitude", track))
      (track$Altitude <- NA)
    if(!exists("Date", track))
      (track$Date <- NA)
    if(!exists("Time", track))
      (track$Time <- NA)
    track <- track[c("Latitude", "Longitude", "Altitude", "Date", "Time")]
    track$Seg <- 1
    track$Seg[1] <- NA # keeps map from drawing a line between one ride and the next

  # check whether it should append or not:
    if(file.exists("allTracks.csv")) {
      write.table(track, 
        "allTracks.csv",
        append = TRUE,
        quote = FALSE,
        sep = ",",
        row.names = FALSE,
        col.names = FALSE)
    } else {
      write.table(track, 
        "allTracks.csv",
        append = FALSE,
        quote = FALSE,
        sep = ",",
        row.names = FALSE,
        col.names = TRUE)      
    }

  }
}

mapSpecs <- function(tracks, rangeConst) {
  meanLon <- mean(allTracks$Longitude, 
    na.rm = TRUE)
  meanLat <- mean(allTracks$Latitude, 
    na.rm = TRUE)
  lonHiRange <- quantile(allTracks$Longitude, 
    probs = c(1 - rangeConst), 
    na.rm = TRUE)
  lonLoRange <- quantile(allTracks$Longitude, 
    probs = c(rangeConst), 
    na.rm = TRUE)
  lonRange <- lonHiRange - lonLoRange
  latHiRange <- quantile(allTracks$Latitude, 
    probs = c(1 - rangeConst), 
    na.rm = TRUE)
  latLoRange <- quantile(allTracks$Latitude, 
    probs = c(rangeConst), 
    na.rm = TRUE)
  latRange <- latHiRange - latLoRange
  # lonRange <- range(allTracks$Longitude)[2] - range(allTracks$Longitude)[1]
  # latRange <- range(allTracks$Latitude)[2] - range(allTracks$Latitude)[1]

  mapWidth <- max(lonRange, latRange)
  mapZoom <- floor(13 - log2(10 * mapWidth))

  return(data.frame(meanLon, meanLat, 
    lonHiRange, lonLoRange, latHiRange, latLoRange,
    mapZoom))
}



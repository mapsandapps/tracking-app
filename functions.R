appendTrack <- function(fileNumbers) {
  for (fileNumber in fileNumbers) {

    newFilename <-  paste(sub(paste("\\.", extension, sep = ""), "", gpxFilenames[fileNumber]), ".csv", sep = "") # deletes original extension

    gpsbabelCommand <- paste("sudo gpsbabel -t -i ", 
      GPSType, 
      " -f '", 
      gpxFilenames[fileNumber],
      "' -o unicsv -F '", 
      newFilename,
      "'",
      sep = "")

    system(gpsbabelCommand)

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

  # need code to check whether it should append or not

    write.table(track, 
      "allTracks.csv",
      append = TRUE,
      quote = FALSE,
      sep = ",",
      row.names = FALSE,
      col.names = FALSE)

  }
}
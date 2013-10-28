appendTrack <- function(filenames) {
  extensions <- gsub("^.+\\.", "", filenames)
  fileNumbers <- 1:length(filenames)
  for (fileNumber in fileNumbers) {
    # delete original extension and add new one:
    newFilename <-  paste(sub(paste("\\.", extensions[fileNumber], sep = ""), "", filenames[fileNumber]), ".csv", sep = "") 

    gpsbabelCommand <- paste("sudo gpsbabel -t -i ", 
      extensions[fileNumber], 
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
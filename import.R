#
# Developer : Mollie Taylor (mollie.taylor@gmail.com)
# Date : 2013
# All code ©2013 Mollie Taylor
# All rights reserved
#


# system() # intern = TRUE?
# file1 <- read.csv(file.choose(),
	# header = TRUE)

# extension <- readline("What extension do your files have? ")
extension <- ".gpx"
extension <- sub(".", "", extension) # cuts the period, so they're standardized
# if they have .csv, possibly skip straight to mapping

# glob2rx(".gpx")
gpxFilenames <- Sys.glob(paste("*.", extension, sep = ""))



# there's probably a more efficient way to do this than a loop:

fileNumbers <- 1:length(gpxFilenames)

for (fileNumber in fileNumbers) {

	newFilename <- 	paste(sub(paste("\\.", extension, sep = ""), "", gpxFilenames[fileNumber]), ".csv", sep = "") # deletes original extension

	gpsbabelCommand <- paste("sudo gpsbabel -t -i ", 
		extension, 
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
	track <- track[c("Latitude", "Longitude", "Altitude", "Date", "Time")]
	track$Seg <- 1
	track$Seg[1] <- NA # keeps map from drawing a line between one ride and the next

	write.table(track, 
		"allTracks.csv",
		append = TRUE,
		quote = FALSE,
		sep = ",",
		row.names = FALSE,
		col.names = FALSE)

}

#
# Developer : Mollie Taylor (mollie.taylor@gmail.com)
# Date : 2013
# All code ©2013 Mollie Taylor
# All rights reserved
#

# system() # intern = TRUE?
# file1 <- read.csv(file.choose(),
	# header = TRUE)

# appending <- readline("Append? (y/n) ")

source("functions.R")

# file.choose()
library(tcltk)
# this means i should be able to remove the loop below:
# filenames <- lapply(tk_choose.files(caption = "Choose X"), function)

filenames <- tk_choose.files(caption = "Choose files")
# grepl regexpr gregexpr



appendTrack(filenames)
#
# Developer : Mollie Taylor (mollie.taylor@gmail.com)
# Date : 2013
# All code ©2013 Mollie Taylor
# All rights reserved
#

source("functions.R")

library(tcltk)
# this means i should be able to remove the loop below:
# filenames <- lapply(tk_choose.files(caption = "Choose X"), function)

filenames <- tk_choose.files(caption = "Choose files")

appendTrack(filenames)
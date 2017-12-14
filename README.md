# rawImage_extractor Bayer pattern = BGGR or BGNR, N=Near Infrared
It is a Matlab code for extracting information from RAW image files. Such raw data are extracted without any post image processing, 
to do so, we can find a good help [here](https://stackoverflow.com/questions/39623001/how-can-i-read-10-bit-raw-image-which-contain-rgb-ir-data)
To using the code, we have two raw images:

	TE3-RGB-15_31-495.raw  <- rgb image
	TE3-RGBN-15_31-495.raw  <- the same scenario as before but with nir infection in the RGB channels


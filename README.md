# kilosort2plx
KilosortPlx updated for Kilosort 2 (work in progress)
Built off of https://github.com/madeleinea/KilosortPLX

## Current status: 
Extracted binary file converter from kilosortplx as prep for kilosort 2.

Updated batch conversion process to move raw data from RawData to a folder called ConvertedData

## To do:
Plug in kilosort2 code to spike sort the converted files.

## Instructions to run:
git clone or download all the files

Set current working directory to kilosort2plx folder.

Create an "RawData" and "ConvertedData" folder; put your plx or pl2 files into RawData.

Update batch_plexon_to_bin_conv.m with the directory of your kilosort2plx folder.

Run batch_plexon_to_bin_conv.m


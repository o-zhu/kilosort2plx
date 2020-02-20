# kilosort2plx
KilosortPlx updated for Kilosort 2 (work in progress)

Built from https://github.com/madeleinea/KilosortPLX

Built from https://github.com/MouseLand/Kilosort2

## Current status: 
Extracted binary file converter from kilosortplx as prep for kilosort 2.

Updated batch conversion process to move raw data from RawData to a folder called SessionsToSort

Wrote batch script to scan through all folders+binary files in SessionsToSort and runs kilosort2 on all binary files.

## To do:
Have someone else test out the batch scripts on another computer.

## Instructions to run:
git clone or download all the files

Set current working directory to kilosort2plx folder.

Create an "RawData" and "SessionsToSort" folder; put your plx or pl2 files into RawData.

Update batch_plexon_to_bin_conv.m with the directory of your kilosort2plx folder.

Run batch_plexon_to_bin_conv.m (WINDOWS ONLY)

Update batch_master_kilosort.m with your kilosort2plx directory and directory of your config files (e.g. "~/kilosort2plx/batch_kilosort2_config/"

Update your kilosort parameters (e.g. sample rate, num_channels, firing rate)

Update your channel map to match all binary files in SessionsToSort.

Run batch_master_kilosort.m




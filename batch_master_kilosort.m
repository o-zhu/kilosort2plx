%% Kilosort 2 Configuration and Parameters
% Built from kilosort2: https://github.com/MouseLand/Kilosort2
% Updates by Oliver Zhu, 2/20/2020

% To use this script, put all your data in the folder SessionsToSort, with
% separate folders for each session that contains all the binary files for
% that session. 

% Warning: all binary files must share the same channel map.

% Path to converted binary data sessions
data_dir = '/home/freedmanlab_tf2/kilosort2plx/SessionsToSort/'; 
% Get a list of all files and folders in this folder.
files = dir(data_dir);
files(ismember( {files.name}, {'.', '..'})) = [];  %remove . and ..
dirFlags = [files.isdir];
sessionFolders = files(dirFlags);

% Kilosort2 Parameters
pathToYourConfigFile = '/home/freedmanlab_tf2/kilosort2plx/batch_kilosort2_config/';
chanMapFile = 'batchChanMap.mat'; % Assume same channel map for all sessions.
num_channels = 16; % Number of channels in each binary file.

addpath(genpath('/home/freedmanlab_tf2/kilosort2plx')) % path to kilosort folder
addpath('/home/freedmanlab_tf2/Documents/MATLAB/npy-matlab-master/npy-matlab/') % for converting to Phy

% Scan through sessions; each session may have more than one binary file to convert
for session=1:length(sessionFolders)
    rootZ = strcat(data_dir,sessionFolders(session).name); % the raw data binary file is in this folder
    rootH = rootZ; % path to temporary binary file (same size as data, should be on fast SSD)

    ops.trange = [0 Inf]; % time range to sort
    ops.NchanTOT    = num_channels; % total number of channels in your recording

    run(fullfile(pathToYourConfigFile, 'StandardConfig.m'))
    ops.fproc       = fullfile(rootH, 'temp_wh.dat'); % proc file on a fast SSD
    ops.chanMap = fullfile(pathToYourConfigFile, chanMapFile);

    %%% this block runs all the steps of the algorithm
    fprintf('Looking for data inside %s \n', rootZ)

    % is there a channel map file in this folder?
    fs = dir(fullfile(rootZ, 'chan*.mat'));
    if ~isempty(fs)
        ops.chanMap = fullfile(rootZ, fs(1).name);
    end

    % find the binary files
    fs = [dir(fullfile(rootZ, '*.bin')) dir(fullfile(rootZ, '*.dat'))];
    
    % Scan through all binary files
    for bin_file = 1:length(fs)
        
        ops.fbinary = fullfile(rootZ, fs(bin_file).name);

        ops.outputFolderName = strcat('Outputs-', fs(bin_file).name,date);
        ops.outputFolder = mkdir(rootZ, ops.outputFolderName);
        outputDir = strcat(rootZ, '/', ops.outputFolderName);
        
        % preprocess data to create temp_wh.dat
        rez = preprocessDataSub(ops);

        % time-reordering as a function of drift
        rez = clusterSingleBatches(rez);

        % saving here is a good idea, because the rest can be resumed after loading rez
        save(fullfile(outputDir, 'rez.mat'), 'rez', '-v7.3');

        % main tracking and template matching algorithm
        rez = learnAndSolve8b(rez);

        % final merges
        rez = find_merges(rez, 1);

        % final splits by SVD
        rez = splitAllClusters(rez, 1);

        % final splits by amplitudes
        rez = splitAllClusters(rez, 0);

        % decide on cutoff
        rez = set_cutoff(rez);

        fprintf('found %d good units \n', sum(rez.good>0))

        % write to Phy
        fprintf('Saving results to Phy  \n')
        rezToPhy(rez, outputDir);
        
        movefile(ops.fbinary,outputDir)
        delete(ops.fproc) % Delete temp file
        
    end
    
end

print('ALL DONE!')

%% if you want to save the results to a Matlab file...
% 
% % discard features in final rez file (too slow to save)
% rez.cProj = [];
% rez.cProjPC = [];
% 
% % save final results as rez2
% fprintf('Saving final results in rez2  \n')
% fname = fullfile(rootZ, 'rez2.mat');
% save(fname, 'rez', '-v7.3');

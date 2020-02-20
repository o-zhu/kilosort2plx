%% Batch plx/pl2 to binary converter
% Built from kilosortPLX: https://github.com/madeleinea/KilosortPLX
% Updates by Oliver Zhu, 2/20/2020

% default options are in parenthesis after the comment
tic; % start timer
PATH = 'D:\\kilosort2plx\\'; % edit this to be the path to your Kilosort folder
dataPATH = strcat(PATH, 'RawData\\'); % path to your raw data folder
conv_dataPATH = strcat(PATH, 'ConvertedData\\');
rawdatafolder = dir(dataPATH);
FILE = 0;

% Load PLX conversion library
addpath(genpath(PATH)) % loads all scripts in kilosort2plx folder

% Multi-core option
% p = gcp();

% errorpath = strcat(PATH, 'ErrorFiles\\'); % path to error files folder,where files will go if they cause errors(un-comment try/catch statements at lines 9, 41-44) 
for i=1:length(rawdatafolder)
    if getfield(rawdatafolder(i),'isdir') ~= 1
%          try                                % un-comment if some files are causing errors, keep commented if all/most files are causing errors
            PLXnameAlone = getfield(rawdatafolder(i),'name');
            fprintf('Current file is: ')
            fprintf(PLXnameAlone)

            %PLXnameAlone = input('Please enter the name of the PLEXON file to be sorted (in single quotes with suffix): ');
            [ops] = PLXStandardConfig(PLXnameAlone,PATH,dataPATH);

            fprintf('Time %3.0fs. ', toc)
            %
            if ops.GPU     
                fprintf('Initializing GPU ...\n')
                gpuDevice(1); % initialize GPU (will erase any existing GPU arrays)
            end

            [uproj, ops] = PLXpreprocessData(ops); % preprocess data and extract spikes for initialization
            
            movefile(strcat(dataPATH,PLXnameAlone), conv_dataPATH)
    end
    disp(strcat('Converted: ', PLXnameAlone))
    FILE = FILE +1;
end

disp(strcat('Files converted: ', num2str(FILE)))
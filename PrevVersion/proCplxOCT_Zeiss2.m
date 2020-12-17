function ProcdData = proCplxOCT_Zeiss2(fn,options)

%Load Acquisition Parameters
numPoints = options.numPoints;
numAscans = options.numAscans;
numBscans = options.numBscans;

volNum = 1;
%%% File open %%%
fid = fopen(fn);
%For each frame
for FrameNum = 1:numBscans
%     fseek(fid,numPoints*numAscans*(FrameNum-1)+(volNum-1)*(2*numPoints*numAscans*numBscans),-1);
    
    %%% Load raw spectrum %%%
    rawData(:,:,FrameNum) = fread(fid,[numPoints,numAscans], 'uint8');
   
end

rawData = permute(rawData,[2 1 3]);
rawData = flipud(rawData);


ProcdData = rawData;
% % Call Axial Motion Correction Code
% if ~contains(fn,'Flow')
%     savepath = strrep(folder,'RAW','intensity');
%     if ~exist(savepath,'dir')
%         mkdir(savepath);
%     end
%     avgOctVol_dB = rawData;
%     save(fullfile(savepath,[fn(1:end-4),'_intensity.mat']), 'avgOctVol_dB', '-v7.3');
%     
% else
%     savepath = strrep(folder,'RAW','Processed');
%     if ~exist(savepath,'dir')
%         mkdir(savepath);
%     end
%     save(fullfile(savepath,[fn(1:end-4),'_ZOCTA']), 'rawData', '-v7.3');
%     
% end

fclose(fid);



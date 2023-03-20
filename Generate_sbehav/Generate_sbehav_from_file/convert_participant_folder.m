function sbehav = convert_participant_folder(foldername)
%Converts the input from all participant files in a folder to data readable
%by the RML
allfiles = dir(foldername);
counter = 1;
sbehav = {};
for filenumber = 1:length(allfiles)
    filename = allfiles(filenumber).name;
    if not(contains(filename,'txt'))
        continue
    else
        sbehav{counter}=Read_txt_input(fullfile(allfiles(filenumber).folder,filename),'Testbehav');
        counter = counter+1;
    end

end
% Store the output in the folder itself, and in the folder for analysis of
% the sbehav file
save(fullfile('Output','sbehav.mat'),'sbehav')
save(fullfile('..','..','RML','Output','sbehav.mat'),'sbehav')


%bat_quit
% saves workspace and closes log and main figure window
%
% Written by Daniel Buscombe, Nov 2009
% revised December 2010, Apr 2012
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

warning off all

h=findobj('tag','current_image'); % find image data
dat=get(h); % for mat-file

delete(findobj('tag','untrans'))

% update and close text file log
fprintf(fid,'%s\n','%------------------------');
fprintf(fid,'%s\n',['%quit at ',datestr(now,31)]);
fclose(fid);

mkdir([pwd,filesep,'outputs'])
mkdir([pwd,filesep,'outputs',filesep,'data'])

hgsave(h0, [pwd,filesep,'outputs',filesep,'data',filesep,['BATSession_',...
    datestr(sessionID,30)],'.fig']) % save figure

save([pwd,filesep,'outputs',filesep,'data',filesep,['BATSession_',...
    datestr(sessionID,30)]],'dat') % save data
close(findobj('tag','uw_fig')) % close main figure

% cals 'bat_mat2txt' to convert mat file into comma delimited txt file
bat_mat2txt([pwd,filesep,'outputs',filesep,'data',filesep,['BATSession_',...
    datestr(sessionID,30)],'.mat'])

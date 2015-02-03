
% bat_save
% saves the current session as a matlab fig file, which can be loaded in
% again
%
% Written by Daniel Buscombe, Nov 2009
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

hgsave(h0, ['bat_fig',datestr(sessionID,30),'.fig'])
uiwait(msgbox('Figure saved ...'));

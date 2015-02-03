
% bat_print.m
% 1. prints fig, 
% 2. updates Lprint
%
% Written by Daniel Buscombe, Nov 2009
% revised Apr 2012
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

export_fig(['.',filesep,'outputs',filesep,'prints',filesep,'bat_fig',datestr(sessionID,30),'_',num2str(Lprint)],ax)

% 
% % make all buttons and menus invisible
% set(get(h0,'children'),'visible','off')
% delete(him1)
% 
% % get current image
% ix=get(findobj('tag','PickImage'),'value');
% % and current image data
% sample=get(findobj('tag','current_image'),'userdata');
% 
% % update title
% a=get(findobj('tag','im_axes1'),'title');
% set(a,'string',char(sample(ix).name),'visible','on');
% 
% % new image
% bat_setaxes
% 
% % print figure as tiff
% % print(h0,'-dtiff','-noui','-zbuffer',...
% %     ['bat_fig',datestr(sessionID,30),'_',num2str(Lprint),'.tiff'])

Lprint=Lprint+1; % updates printer counter

% set(get(h0,'children'),'visible','on') % make everything visible again
% 
% [iconData,iconCmap]=imread('bat.jpg');
% him1=axes('position',[.89 .03 0.1 0.2],'Xtick',[],'Ytick',[],'box','on');
% ic1=imagesc(iconData); axis image off
% 
% figure(h0)

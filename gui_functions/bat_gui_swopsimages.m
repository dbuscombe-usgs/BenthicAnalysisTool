
% bat_gui_swopsimages
% callback for main program, swops images 
%
% Written by Daniel Buscombe, Nov 2009
% modified Apr 2012 for v0.5 to have only 1 image in memory at one time
% (current sample ix) but in such a way that if an image has been
% transformed before, keep that transformation data
%
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

% get current image
ix=get(findobj('tag','PickImage'),'value');
% and current image data

sample=get(findobj('tag','current_image'),'userdata');

% get next image
if isempty(sample(ix).data)
   if isempty(sample(ix).trans_data)
   sample(ix).data=imread([image_path char(image_name(ix))]); % if it's never been transformed, load it in
   else
   sample(ix).data=sample(ix).trans_data; % if it's been transformed before, use that data again    
   end
end

if ~exist('ButtonName','var')
    tmp=zeros(1,length(sample));
    for k=1:length(sample)
        tmp(k)=sample(k).istransformed;
    end
    if any(tmp==1)
     ButtonName = 'Yes';
    end
    
else
    ButtonName='No';
end

% deal with transformation if applicable
switch ButtonName
  case 'Yes'
      if ~sample(ix).istransformed
          if isempty(sample(ix).trans_data)
            bat_transform_fileload % transform it (for the first time)
          else
            sample(ix).data=sample(ix).trans_data; % if it's been transformed before, use that data again 
          end
      end
end

set(findobj('tag','current_image'),'cdata',sample(ix).data);
    
if (ix-1) > 0  % if ix is greater than 1
    for n=1:ix-1
        sample(n).data=[]; 
    end
end
   
if (ix+1) < length(image_name)
    for n=ix+1:length(image_name)
        sample(n).data=[];    
    end
end
  

% remove plotted points from previous image
chx = get(gca,'Children');
if length(chx)>=2
chx(end)=[];
delete(chx)
end

% update title
a=get(findobj('tag','im_axes1'),'title');
set(a,'string',char(sample(ix).name));

% new image
bat_setaxes

% set userdata again before labels get turned back on
set(findobj('tag','current_image'),'userdata',sample);
% turn on labels
bat_labelson

close(findobj('tag','untrans'))  



% if ix < length(image_name)
%     if isempty(sample(ix+1).data)
%        sample(ix+1).data=imread([image_path char(image_name(ix+1))]); 
%     end
% end

% if ix > 1
%     if isempty(sample(ix-1).data)
%        sample(ix-1).data=imread([image_path char(image_name(ix-1))]); 
%     end
% end

% if sample(ix).istransformed==1 %  already transformed
%     
% % make subfigure of untransformed image, for reference
% funtrans = figure('Color',[.3 .7 .3],...
%               'units','pixels',...
%               'position',[200 200 500 500],...
%               'menubar','none',...
%               'name','Untransformed image',...
%               'numbertitle','off',...
%               'resize','on',...
%               'visible','on',...
%               'tag','untrans');
% axuntran = axes('xlim',[0 1],'ylim',[0 1]);
% 
% imuntran = image('Parent',axuntran, ...
% 	'CData',[], ...
% 	'CDataMapping','scaled', ...
% 	'Tag','im_untrans');
% 
% set(imuntran,'userdata',sample);
% set(imuntran,'cdata',sample(ix).data_orig); % show current image 
% % in new window
% 
% h=findobj('tag','im_untrans');
% [Nv,Nu,c] = size(sample(ix).data_orig);  
% set(h,'xdata',[1:Nu]);
% set(h,'ydata',[1:Nv]);
% set(axuntran,'xlim',[sample(ix).axes_orig(1),sample(ix).axes_orig(2)],'ylim',[sample(ix).axes_orig(3),sample(ix).axes_orig(4)])
% %set(axuntran,'xlim',get(findobj('tag','im_axes1'),'Xlim'),'ylim',...
% %get(findobj('tag','im_axes1'),'Ylim')); 
% set(gca,'ydir','reverse')
% xlabel('pixels'); ylabel('pixels')    
% title(sample(ix).name)
% maximise
% 
% end


    

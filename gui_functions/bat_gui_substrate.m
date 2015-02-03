
% bat_gui_substrate.m
% changes and assigns the substrate
% deletes old annotations and sets menu back to 'empty'
%
% Written by Daniel Buscombe, Nov 2009
% revised Apr 2012
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

% get what substrate the user has chosen
h=findobj('Tag','PickSubstrate1');
subval=get(h,'value');

list=get(h,'string'); % get the substrate list
numlist=max(size(list)); % number of categories

% get current data
ix=get(findobj('tag','PickImage'),'value');
sample=get(findobj('tag','current_image'),'userdata');

for i=1:numlist
   if subval==i
       txt=list(i); % assign appropriate text
   end
end

% delete existing annotation
delete(findobj('tag','subtxt1'))

% print info to log file
fprintf(fid,'%s\n','%------------------------');
fprintf(fid,'%s\n',['%Substrate assigned to image: ',sample(ix).name]);
fprintf(fid,'%s\n',['%substrate type: ',char(txt)]);

% plot text
text(.02,.04,char(txt),'units','normalized','tag','subtxt1');
set(findobj('tag','subtxt1'),'Color','y','FontSize',12)

% update data structure
sample(ix).substrate1=subval; % changed

% no change
% if isfield(sample,'countall_names')
sample(ix).counttxt=sample(ix).counttxt;
sample(ix).confidence=sample(ix).confidence;
sample(ix).countall_names=sample(ix).countall_names;
sample(ix).countall_coords=sample(ix).countall_coords;
sample(ix).count=sample(ix).count;
sample(ix).metatxt=sample(ix).metatxt;
sample(ix).substrate2=sample(ix).substrate2;
% end

% if isfield(sample,'data_orig')
sample(ix).data_orig=sample(ix).data_orig;
sample(ix).axes_orig=sample(ix).axes_orig;
% end

% if isfield(sample,'area')
sample(ix).area=sample(ix).area;
sample(ix).area_coord=sample(ix).area_coord;
% end

% if isfield(sample,'length')
sample(ix).length=sample(ix).length;
sample(ix).length_coord=sample(ix).length_coord;
% end

sample(ix).data=sample(ix).data; 
sample(ix).name=sample(ix).name; 
sample(ix).istransformed=sample(ix).istransformed; 
sample(ix).adate=sample(ix).adate;
sample(ix).atime=sample(ix).atime;
sample(ix).localX=sample(ix).localX;
sample(ix).localY=sample(ix).localY;
sample(ix).altitude=sample(ix).altitude;
sample(ix).lat=sample(ix).lat;
sample(ix).lon=sample(ix).lon;
sample(ix).res=sample(ix).res;
        
h=findobj('tag','current_image');
set(h,'userdata',sample);
set(h,'cdata',sample(ix).data);    
        
clear subtxt1

h=findobj('Tag','PickSubstrate1');
set(h,'value',1); % put menu back to 'empty'

% remove subtxt is exists already
% if exist('subtxt')
%     try
%     delete(subtxt)
%     catch
%         continue
%     end
% end
      

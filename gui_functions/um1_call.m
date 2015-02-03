
function [] = um1_call(varargin)
% for deleting points in the sub-window
%
% Written by Daniel Buscombe, Nov 2009
% revised Apr 2012 so only the last point is deleted when right click
% (rather than all of them)
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

% Callback for uimenu to delete the points.
S = varargin{3};% Get the structure.

S.ln=S.ln(end-(S.Cnt-1):end);
S.txt=S.txt(end-(S.Cnt-1):end);
S.maintxt=S.maintxt(end-(S.Cnt-1):end);
S.mainplot=S.mainplot(end-(S.Cnt-1):end);

% lengthdat=length(S.ln(:));

% delete(S.ln(end));  % Delete last line.
% delete(S.txt(end)); % delete last text
% 
% delete(S.maintxt(end)); % and for the main
% delete(S.mainplot(end));

% S.ln = [];  % And reset the structures.
% S.txt=[];
% 
% S.maintxt=[]; % reset for the main fig
% S.mainplot=[];

S.Cnt=S.Cnt-1;

fprintf(S.fid,'%s\n','%********************Last count cleared***************');
set(S.ax,'ButtonDownFcn',{@ax_bdfcn,S})

% remove plotted points from previous image
chx = get(gca,'Children');
% get all those which do not have userdata (i.e. every annotation rather
% than the image itself)
ind=[];
for lenchx=1:length(chx)
     if isempty(get(chx(lenchx),'UserData'))
         ind=[ind;lenchx];
     end
end
delete(chx(ind(1:2)))


% chx(end)=[]; % this stops the image being deleted
% delete(chx(end-1:end)) % last 2 elements because involves both symbol and label

% delete last 1 object from the data structure
ix=get(findobj('tag','PickImage'),'value');
% and current image data
sample=get(findobj('tag','current_image'),'userdata');

count=sample(ix).count;
count(end)=NaN;

counttxt=sample(ix).counttxt; 
counttxt(end)={''};

confidence=sample(ix).confidence; 
confidence(end)={''};

countall_names=sample(ix).countall_names; 
countall_names(end)={''};

countall_coords=sample(ix).countall_coords; 
countall_coords(end)={''};

metatxt=sample(ix).metatxt; 
metatxt(end)={''};

% changed
sample(ix).counttxt=counttxt;
sample(ix).confidence=confidence;
sample(ix).countall_names=countall_names;
sample(ix).countall_coords=countall_coords;
sample(ix).count=count;
sample(ix).metatxt=metatxt;

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

% no change
sample(ix).substrate1=sample(ix).substrate1;
sample(ix).substrate2=sample(ix).substrate2;
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
sample(ix).trans_data=sample(ix).trans_data;        



        
% h=findobj('tag','current_image');
% set(h,'userdata',sample);
% set(h,'cdata',sample(ix).data);

set(findobj('tag','current_image'),'userdata',sample);
set(findobj('tag','current_image'),'cdata',sample(ix).data);


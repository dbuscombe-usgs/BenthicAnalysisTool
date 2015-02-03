
% bat_transform_fileload
% 1. checks images haven't already been transformed 
% 2. if not, does a geometric transformation on the input images
% 3. updates text log and data structure
%
% Written by Daniel Buscombe, December 2010
% revised Apr 2012 to accomodate changes to way images are loaded in (upon
% swopsimage rather than all at the beginning)
% also modified to use qinterp2 (http://www.mathworks.com/matlabcentral/fileexchange/10772) 
% which is much faster than interp2
%
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

for i=1:length(ix)

set(findobj('tag','current_image'),'cdata',sample(ix(i)).data);

sample(ix(i)).data_orig=sample(ix(i)).data;
sample(ix(i)).axes_orig=[get(findobj('tag','im_axes1'),'Xlim'),...
    get(findobj('tag','im_axes1'),'Ylim')]; 
  
% do transformation   
    if ~exist('Tdat','var')
    [T_name, T_path] = uigetfile({'*.mat';'*.*'},'Load transform data ...');	
    % get file, add it to path, and load it
    addpath(T_path)
    load(T_name)
    end

    index=floor(sample(ix(i)).altitude); % round the altitude value 
    %down to nearest integer
    if index > max(floor(([sample.altitude])))
        index=max(floor(([sample.altitude])));
    end
    
    step_size = 1; % do transformation
    [imnew,axesofnew] = imgeomt(Tdat.H{index+1}, ...
        get(findobj('tag','current_image'),'CData'), 'cubic', step_size );

    fprintf(fid,'%s\n','%------------------------');
    fprintf(fid,'%s\n',['%Image transformed: ',sample(ix(i)).name]);
    fprintf(fid,'%s\n',['%Transformation Altitude: ',num2str(index)]);
    
    [Nv,Nu,c] = size(imnew);  
    mmperpx=rectDims.dims{i}; % mm per pixel in new transformed image
    h=findobj('tag','current_image');
    set(h,'xdata',[1:Nu].*mmperpx)
    set(h,'ydata',[1:Nv].*mmperpx)
    set(findobj('tag','im_axes1'),'xlim',[0.5 (Nu*mmperpx)+0.5],'ylim',...
        [0.5 (Nv*mmperpx)+.5])
    
    fprintf(fid,'%s\n',['%Resolution (mm/px): ',num2str(mmperpx)]);
    fprintf(fid,'%s\n','%------------------------');
    
    % a=get(findobj('tag','im_axes1'),'xlabel');
    b=get(findobj('tag','im_axes1'),'ylabel');
    set(get(findobj('tag','im_axes1'),'xlabel'),'string','mm')  
    set(b,'string','mm')  
    grid on
    
% changed    
sample(ix(i)).data=imnew;
sample(ix(i)).istransformed=1;
sample(ix(i)).res=mmperpx;

sample(ix(i)).trans_data=imnew;

% no change
% if isfield(sample,'countall_names')
sample(ix(i)).counttxt=sample(ix(i)).counttxt;
sample(ix(i)).confidence=sample(ix(i)).confidence;
sample(ix(i)).countall_names=sample(ix(i)).countall_names;

sample(ix(i)).countall_coords= sample(ix(i)).countall_coords;

sample(ix(i)).count=sample(ix(i)).count;
sample(ix(i)).metatxt=sample(ix(i)).metatxt;
% end

sample(ix(i)).substrate1=sample(ix(i)).substrate1; % no change
sample(ix(i)).substrate2=sample(ix(i)).substrate2; % no change
sample(ix(i)).name=sample(ix(i)).name; % no change
sample(ix(i)).adate=sample(ix(i)).adate;
sample(ix(i)).atime=sample(ix(i)).atime;
sample(ix(i)).localX=sample(ix(i)).localX;
sample(ix(i)).localY=sample(ix(i)).localY;
sample(ix(i)).altitude=sample(ix(i)).altitude;
sample(ix(i)).lat=sample(ix(i)).lat;
sample(ix(i)).lon=sample(ix(i)).lon;

sample(ix(i)).area_coord=sample(ix(i)).area_coord;   
sample(ix(i)).area=sample(ix(i)).area;   
sample(ix(i)).length_coord=sample(ix(i)).length_coord;   
sample(ix(i)).length=sample(ix(i)).length;           


% h=findobj('tag','current_image');
% set(h,'userdata',sample);
% set(h,'cdata',sample(ix(i)).data);

set(findobj('tag','current_image'),'userdata',sample);
set(findobj('tag','current_image'),'cdata',sample(ix(i)).data);

end




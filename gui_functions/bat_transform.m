
% bat_transform
% 1. checks images haven't already been transformed 
% 2. if not, does a geometric transformation on the input images
% 3. updates text log and data structure
%
% Written by Daniel Buscombe, Nov 2009
% modified apr 2012
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

ix=get(findobj('tag','PickImage'),'value');
sample=get(findobj('tag','current_image'),'userdata');

if sample(ix).istransformed==0 % not already transformed

sample(ix).data_orig=sample(ix).data;
sample(ix).axes_orig=[get(findobj('tag','im_axes1'),'Xlim'),...
    get(findobj('tag','im_axes1'),'Ylim')]; 
    
close(findobj('tag','untrans'))    
% make subfigure of untransformed image, for reference
funtrans = figure('Color',[.3 .7 .3],...
              'units','pixels',...
              'position',[200 200 500 500],...
              'menubar','none',...
              'name','Untransformed image',...
              'numbertitle','off',...
              'resize','on',...
              'visible','on',...
              'tag','untrans');
axuntran = axes('xlim',[0 1],'ylim',[0 1]);

imuntran = image('Parent',axuntran, ...
	'CData',[], ...
	'CDataMapping','scaled', ...
	'Tag','im_untrans');

set(imuntran,'userdata',sample);
set(imuntran,'cdata',sample(ix).data_orig); % show current image in new window

h=findobj('tag','im_untrans');
[Nv,Nu,c] = size(sample(ix).data_orig);  
set(h,'xdata',[1:Nu]);
set(h,'ydata',[1:Nv]);
set(axuntran,'xlim',get(findobj('tag','im_axes1'),'Xlim'),'ylim',...
get(findobj('tag','im_axes1'),'Ylim')); 
set(gca,'ydir','reverse')
xlabel('pixels'); ylabel('pixels')    
title(sample(ix).name)
maximise

    
% do transformation   
    if ~exist('Tdat','var')
    [T_name, T_path] = uigetfile({'*.mat';'*.*'},'Load transform data ...');	
    % get file, add it to path, and load it
    addpath(T_path)
    load(T_name)
    end

    index=floor(sample(ix).altitude); % round the altitude value 
    %down to nearest integer
    if index > max(floor(([sample.altitude])))
        index=max(floor(([sample.altitude])));
    end
    
    step_size = 1; % do transformation
    [imnew,axesofnew] = imgeomt(Tdat.H{index+1}, ...
        get(findobj('tag','current_image'),'CData'), 'cubic', step_size );

    fprintf(fid,'%s\n','%------------------------');
    fprintf(fid,'%s\n',['%Image transformed: ',sample(ix).name]);
    fprintf(fid,'%s\n',['%Transformation Altitude: ',num2str(index)]);
    
    [Nv,Nu,c] = size(imnew);  
    mmperpx=rectDims.dims{ix}; % mm per pixel in new transformed image
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
sample(ix).data=imnew;
sample(ix).istransformed=1;
sample(ix).res=mmperpx;
sample(ix).trans_data=imnew;


% no change
% if isfield(sample,'countall_names')
sample(ix).counttxt=sample(ix).counttxt;
sample(ix).confidence=sample(ix).confidence;
sample(ix).countall_names=sample(ix).countall_names;

% WHY DOESNT THIS WORK?
% for i=1:size(sample(ix).countall_coords,2)
% pts=sample(ix).countall_coords{i};
% 
% newpts = inv(Tdat.H{index+1})*[pts(1),pts(2),1]'; % geometric rectification
% % normalise
% newpts(1:2,:) = newpts(1:2,:) ./ repmat( newpts(3,:), 2, 1 );
% 
% newpts=(newpts(1:2)').*mmperpx;
% 
% plot(newpts(1),newpts(2),'r+')
% 
% sample(ix).countall_coords{i}=newpts;
% end

sample(ix).countall_coords= sample(ix).countall_coords;

sample(ix).count=sample(ix).count;
sample(ix).metatxt=sample(ix).metatxt;
% end

sample(ix).substrate1=sample(ix).substrate1; % no change
sample(ix).substrate2=sample(ix).substrate2; % no change
sample(ix).name=sample(ix).name; % no change
sample(ix).adate=sample(ix).adate;
sample(ix).atime=sample(ix).atime;
sample(ix).localX=sample(ix).localX;
sample(ix).localY=sample(ix).localY;
sample(ix).altitude=sample(ix).altitude;
sample(ix).lat=sample(ix).lat;
sample(ix).lon=sample(ix).lon;

sample(ix).area_coord=sample(ix).area_coord;   
sample(ix).area=sample(ix).area;   
sample(ix).length_coord=sample(ix).length_coord;   
sample(ix).length=sample(ix).length; 
        
% h=findobj('tag','current_image');
% set(h,'userdata',sample);
% set(h,'cdata',sample(ix).data);

set(findobj('tag','current_image'),'userdata',sample);
set(findobj('tag','current_image'),'cdata',sample(ix).data);


bat_labelson

end
close(findobj('tag','untrans'))    



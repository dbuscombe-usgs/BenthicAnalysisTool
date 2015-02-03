
% bat_gui_fileload
% loads images into the program
%
% Written by Daniel Buscombe, Nov 2009
% revised December 2010, and Apr 2012 so 1) preallocates structre array 'sample'; 
%and 2) only reads in first two images. bat_gui_swopsimages now makes sure there's 
% only ever 1 image loaded into memory (well, sample(ix).data) at one time; and 3) % if there is only 1 nav file in the current directory, it will load that
% instead of asking you to select it
%
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

 [image_name, image_path] = uigetfile({'*.*';'*.JPG';'*.BMP';'*.PNG';...
     '*.TIFF';'*.jpg';'*.bmp';'*.png';'*.tiff';'*.tif'},...
     'Load images ...', 'MultiSelect', 'on');	% get image names
 
if isequal(image_name,0) || isequal(image_path,0)
       disp('You pressed cancel') % msg if cancel button pressed
       
else % cancel button not pressed
    
     addpath(image_path) % add these to path so matlab can find them

ButtonName = questdlg('Do you want to apply geometric transformation to all images?',...
    'Transformation Question', ...
    'Yes','No', 'Yes');    
     
    if ~iscell(image_name) % only 1 image selected
    
    F{1}=[image_path,image_name];
    s=imfinfo(char(F));
    l=fieldnames(s);
        
    sample(1).data=imread([image_path image_name]);
    sample(1).name=image_name;
    
    else % more than 1 image
    
    % more efficient to preallocate
    sample = struct('data',cell(1,length(image_name)),'name',...
        cell(1,length(image_name)),'istransformed',cell(1,length(image_name)),...
        'substrate1',cell(1,length(image_name)),'substrate2',...
        cell(1,length(image_name)),'adate',cell(1,length(image_name)),...
        'atime',cell(1,length(image_name)),'localX',...
        cell(1,length(image_name)),'localY',cell(1,length(image_name)),...
        'altitude',cell(1,length(image_name)),'lat',...
        cell(1,length(image_name)),'lon',cell(1,length(image_name)),'res',...
        cell(1,length(image_name)),'data_orig',cell(1,length(image_name)),...
        'axes_orig',cell(1,length(image_name)),'trans_data',cell(1,length(image_name)),...
        'count',cell(1,length(image_name)), 'counttxt',cell(1,length(image_name)),...
        'countall_names',cell(1,length(image_name)), 'countall_coords',cell(1,length(image_name)),...
        'metatxt',cell(1,length(image_name)), 'area_coord',cell(1,length(image_name)),...
        'area',cell(1,length(image_name)), 'length_coord',cell(1,length(image_name)),...
        'length',cell(1,length(image_name)),'confidence',cell(1,length(image_name)));     
        
        for i=1:size(image_name,2)
            ff=fullfile(image_path, char(image_name(i)));
            disp(['User selected ', ff]);
            fprintf(fid,'%s\n',['%User selected ', ff]);
            F{i}=ff;
        end
  
    s=imfinfo(char(F(i)));
    l=fieldnames(s);
    
%h=waitbar(0,'Please wait. Reading images ...');

% load first two images only
    sample(1).data=imread([image_path char(image_name(1))]);
    
    for i=1:length(image_name)  
%         sample(i).data=imread([image_path char(image_name(i))]);
        sample(i).name=char(image_name(i));
%         waitbar(i/length(image_name),h);
    end
%     close(h)
    
    end
 
end

% if there is only 1 nav file in the current directory, it will load that
% instead of asking you to select it
use=[];
d=dir;
for i=1:length(d)
     if regexpi(d(i).name,'nav')
         use=[use;i];
     end
end

if length(use)==1
    navtxtin=d(use).name;
    navfolder=pwd;
else

[navtxtin,navfolder, filterindex] = uigetfile('*.txt',...
    'Text Files (*.txt)','Select Nav text file'); % get 'nav' data file
end
    
% if isequal(navtxtin,0) || isequal(navfolder,0)
%        disp('You pressed cancel') % msg if cancel button pressed
%        
% else % cancel button not pressed

auvdata = text2struct(navtxtin,'%s %s %f %f %f %f %f %f', ...
        'adate','atime','localX','localY','altitude','depth2','lat','lon'); 
                
fprintf(fid,'%s\n',['%navfile input: ',navtxtin]); % details to log file 

    [b,ix] = sort({sample.name}); % sort names
    for i=1:length(ix)
        sample(i).data=sample(ix(i)).data; % assign data to structure
        sample(i).name=sample(ix(i)).name;
        sample(i).istransformed=0;
        sample(i).substrate1=NaN;
        sample(i).substrate2=NaN;
        sample(i).adate=auvdata.adate(i,:);
        sample(i).atime=auvdata.atime(i,:);
        sample(i).localX=auvdata.localX(i,:);
        sample(i).localY=auvdata.localY(i,:);
        sample(i).altitude=auvdata.altitude(i,:);
        sample(i).lat=auvdata.lat(i,:);
        sample(i).lon=auvdata.lon(i,:);
        sample(i).res=1;
        sample(i).data_orig=[];
        sample(i).axes_orig=[];
        sample(i).count=[];   
        sample(i).counttxt=[];   
        sample(i).countall_names=[];   
        sample(i).countall_coords=[];   
        sample(i).metatxt=[]; 
        sample(i).area_coord=[];   
        sample(i).area=[];   
        sample(i).length_coord=[];   
        sample(i).length=[];           
        sample(i).confidence=[];   
       
         
        % write info to log file
        fprintf(fid,'%s\n','%------------------------');
        fprintf(fid,'%s\n',...
            ['%Timestamp',num2str(i),' ',[num2str(auvdata.adate(i,:)),' ',...
            num2str(auvdata.atime(i,:))]]);
        fprintf(fid,'%s\n',...
            ['%XY',num2str(i),' ',[num2str(auvdata.localX(i,:)),' ',...
            num2str(auvdata.localY(i,:))]]);
        fprintf(fid,'%s\n',...
            ['%Altitude',num2str(i),' ',[num2str(auvdata.altitude(i,:))]]);
        fprintf(fid,'%s\n',...
            ['%Lat/Long',num2str(i),' ',[num2str(auvdata.lat(i,:)),' ',...
            num2str(auvdata.lon(i,:))]]);
        fprintf(fid,'%s\n','%------------------------');
         
    end
%     sample=sample1;clear sample1; % rename and clear old

    h=findobj('tag','current_image');
    set(h,'userdata',sample);
    set(h,'cdata',sample(1).data); % make first image appear
    
    [Nv,Nu,c] = size(sample(1).data);  
    set(h,'xdata',[1:Nu]); % scales and labels
    set(h,'ydata',[1:Nv]);
    set(findobj('tag','im_axes1'),'xlim',[0.5 Nu+0.5],'ylim',[0.5 Nv+.5])
    % on axes and labels
    set(findobj('tag','image'),'xlim',[0.5 Nu+0.5],'ylim',[0.5 Nv+.5])
    grid on

    a=get(findobj('tag','im_axes1'),'title'); % add title
    set(a,'string',char(sample(1).name))
    
    a=get(findobj('tag','im_axes1'),'xlabel');
    b=get(findobj('tag','im_axes1'),'ylabel');
    set(a,'string','pixels')  
    set(b,'string','pixels')      

    h=findobj('tag','PickImage');
    set(h,'string',{sample.name}); % assign current image
    
% end

ix=1;

switch ButtonName
  case 'No'
        return
  case 'Yes'
        bat_transform_fileload    
end
   

    

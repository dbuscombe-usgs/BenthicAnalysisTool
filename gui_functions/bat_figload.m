
% bat_figload
% loads a previous session figure and associated data
%
% Written by Daniel Buscombe, Nov 2009
% modified Apr 2012
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

[image_name, image_path] = uigetfile({'*.fig'},...
     'Load fig file ...', 'MultiSelect', 'off');	% get figure
     
addpath(image_path) % add path to cd path
h1=hgload([image_path,image_name],'all'); % load fig, overrides the 
%default behavior of excluding
%non-serializable objects from the file

ax=gca;
close(h0) % close old figure
h0=h1;
  
% set toolbars again
set(h0,'toolbar','figure'); % adds usual matlab tools
hToolbar = findall(h0,'tag','FigureToolBar'); %get handle for toolbar
hButtons = findall(hToolbar); % get handle for button
set(hButtons(2:7),'Visible','off') % remove unneccessary buttons
movegui(h0,'center') 

icon = fullfile(matlabroot,'/toolbox/matlab/icons/webicon.gif');
[cdata,map] = imread(icon);
% Convert white pixels into a transparent background
map(map(:,1)+map(:,2)+map(:,3)==3) = NaN;
% Convert into 3D RGB-space
cdataFix = ind2rgb(cdata,map);

% Add the icon to the latest toolbar
hZoomFix = uipushtool('cdata',cdataFix, 'tooltip','fix zoom',...
    'ClickedCallback','zoomfix');
set(hZoomFix,'Parent',hToolbar) % moves it up onto the main toolbar
 
load([image_name(1:end-4),'.mat'])
sample=dat.UserData;

clear image_name image_path

image_name=cell(1,length(sample));
for k=1:length(sample)
[image_path name ext]=fileparts(which(sample(k).name));
image_name{k}=[name,ext];
end
image_path=[image_path,filesep];
 
 
 
 
 
 
 
 


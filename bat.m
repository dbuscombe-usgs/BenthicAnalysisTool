
% bat.m
% written by Daniel Buscombe, Aug-Nov09 (0.0 and 0.1)
% revision December 2010 (0.2)
% revised Mar-Apr 2012 (0.3 and 0.4 and 0.5)
% main program file for B.A.T. (Benthic Analysis Tool) version 0.5 (Apr
% 2012)

% clear all variables and close figures
clc; clear all; close all
addpath(genpath([pwd,filesep,'gui_functions'])) % add subfbations folder to path
addpath([pwd,filesep,'species_lists']) % add species lists folder to path
warning off all
%========================================================
%========================================================
%==================== MAIN WINDOWS ======================
%========================================================
%========================================================

if ~isdir('outputs')
    mkdir('outputs')
    mkdir(['outputs',filesep,'prints'])
    mkdir(['outputs',filesep,'data'])
    mkdir(['outputs',filesep,'session'])
end

sessionID=now; % matlab time which becomes session's unique identifier
% create and open log file and write header
fid=fopen([pwd,filesep,'outputs',filesep,'session',filesep,'bat_session',datestr(sessionID,30),'.txt'],'w');
fprintf(fid,'%s\n',['%session began at ',datestr(sessionID,31)]);
fprintf(fid,'%s\n','%------------------------');

% main figure window
h0 = figure('Color',[.7 .75 .7], ...
	'HitTest','off', ...
	'Doublebuffer','on', ...
	'MenuBar','none', ...
	'Name','      Benthic Analysis Tool [Version 0.5 (April 2012)].', ...
	'NumberTitle','off', ...
	'PaperType','a4letter', ...
	'units','normalized', ...
	'Position',[0.05 0.05 0.9 0.9], ...
	'RendererMode','manual', ...
    'Tag','uw_fig');

set(h0,'toolbar','figure'); % adds usual matlab tools
hToolbar = findall(h0,'tag','FigureToolBar'); %get handle for toolbar
hButtons = findall(hToolbar); % get handle for button
set(hButtons(2:7),'Visible','off') % remove unneccessary buttons

% create a new button to fix zoom problems
% load icon from matlab root icon store
icon = fullfile(matlabroot,'/toolbox/matlab/icons/webicon.gif'); 
[cdata,map] = imread(icon); % read icon
% Convert white pixels into a transparent background
map(map(:,1)+map(:,2)+map(:,3)==3) = NaN;
% Convert into 3D RGB-space
cdataFix = ind2rgb(cdata,map);
% Add the icon to the latest toolbar
% assign the fnction 'zoomfix' to the button
hZoomFix = uipushtool('cdata',cdataFix, 'tooltip','fix zoom',...
    'ClickedCallback','zoomfix');
set(hZoomFix,'Parent',hToolbar) % moves it up onto the main toolbar

% added Apr 2012 in attempt to prevent gui window sliding off into another
% screen in multi screen arranegements, or worse, being spliced!
movegui(h0,'center') 

Lprint=0; % for the bat_print function - 
%keep track of what's been printed & update

% add a little picture to the bottom right
[iconData,iconCmap]=imread('bat.jpg');
him1=axes('position',[.89 .03 0.1 0.2],'Xtick',[],'Ytick',[],'box','on');
ic1=imagesc(iconData); axis image off

        h1 = uicontrol('Parent',h0, ...
    	'units','normalized', ...
        'Position',[.67 .03 .5 .02], ...
        'fontname','Times', ...
        'fontsize',12, ...
        'horizontalalignment','left', ...
        'BackgroundColor',[.7 .75 .7],...
        'ForegroundColor',[1 1 1],...
        'style','text', ...
    	'string',{'Benthic Analysis Tool v0.5. Dan Buscombe, Apr 2012'}, ...
    	'tag','instructions');
    
    % image view top left window - main window
ax = axes('Parent',h0, ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'FontName','Times', ...
	'FontSize',12, ...
	'Layer','top', ...
	'NextPlot','add', ...
	'Position',[0.01 0.28 0.66 0.68],...
	'Tag','im_axes1', ...
	'XColor',[1 1 1], ...
	'YColor',[1 1 1], ...
	'YDir','reverse', ...
	'YLimMode','manual', ...
	'ZColor',[1 1 1]);
%set(findobj(gcf,'type','axes'),'hittest','off')

% assign space for image 
    set(get(ax,'title'),'string',' ')
h2 = image('Parent',ax, ...
	'CData',[], ...
	'CDataMapping','scaled', ...
	'Tag','current_image');
    axis equal
    %xlabel('mm');    ylabel('mm');
%========================================================


%========================================================
%========================================================
%==================== MENUS =============================
%========================================================
%========================================================

hm1 = uimenu('Parent',h0, ...             % File menu
	'Label','File', ...
	'Tag','file_menu');

	hm2a = uimenu('Parent',hm1, ...
		'Callback','bat_gui_fileload', ...
		'Label','Load images', ...
		'Tag','Fileuimenu1');   % option 1: load images
    
    	hm2b = uimenu('Parent',hm1, ...
		'Callback','bat_figload', ...
		'Label','Load previous session', ...
		'Separator','on', ...
		'Tag','Fileuimenu1b'); % option 2: load previous session
    
	hm2c = uimenu('Parent',hm1, ...
		'Callback','bat_quit', ...
		'Label','Quit', ...
		'Separator','on', ...
		'Tag','Fileuimenu4'); % option 3: quit 
    
 % add 'help' option to toolbar, next to 'file'
 hm5 = uimenu('Parent',h0, ...             % Help menu
	'Label','Help', ...
	'Tag','help_menu'); 
 hm2c = uimenu('Parent',hm5, ...
		'Callback','bat_Help', ...
		'Label','How to Use This Program', ...
		'Tag','Fileuimenu99');  % callback funtion
 
    
  % add 'zoom help' option to toolbar, next to 'file'
 hm5b = uimenu('Parent',h0, ...             % Help menu
	'Label','Zoom Help', ...
	'Tag','help_zoom'); 
 hm2cb = uimenu('Parent',hm5b, ...
		'Callback','bat_zoominstructions', ...
		'Label','How to Use The Interactive Zoom', ...
		'Tag','Fileuimenu99');  % callback funtion   
    
    
 % add 'about' option to toolbar, next to 'file'
 hm6 = uimenu('Parent',h0, ...             % About menu
	'Label','About', ...
	'Tag','about');  
 hm2d = uimenu('Parent',hm6, ...
		'Callback','bat_About', ...
		'Label','About', ...
		'Tag','Fileuimenu999'); % callbac function
    


%========================================================
%========================================================
%============ BUTTONS ===================================
%========================================================
%========================================================

%========================================================
hp0 = uipanel('Title','Swap Images','FontSize',10,...
                'BackgroundColor','white',...
                'Position',[.53 .15 .35 .08]); % make panel for uicontrol
    
hb1 = uicontrol('Parent',hp0, ...			% swop images region
	'Callback','bat_gui_swopsimages', ...
	'units','normalized', ...
	'Position',[.05 .1 .9 .8], ...
	'string',' ', ...
	'userdata',[], ...
	'style','popup', ...
	'Tag','PickImage');
%========================================================

 
%========================================================
try
txtmain=importdata('Categories.txt');
catch
   uiwait(msgbox({'File ''Categories.txt'' not found.'},...
       {'Program will close ...'}))
   close(findobj('tag','uw_fig')) % close main figure
end

numlist=max(size(txtmain)); % number of categories

if numlist>0
hp2a = uipanel('Title',txtmain(1,:),'FontSize',10,... 
                'BackgroundColor','white',...
                'Position',[.66 .28 .33 .11]); % make panel for uicontrol
            
    hc1 = uicontrol('Parent',hp2a, ...			% count1
	'Callback','bat_gui_count(1,fid,h0)', ...
	'units','normalized', ...
	'Position',[.72 .125 .25 .75], ...
            'fontname','Times', ...
	'string','Count', ...
	'style','pushbutton', ...
	'tag','count1');

fid2=fopen([char(txtmain(1,:)),'.txt'],'r');
C=textscan(fid2,'%q','delimiter','\n');
txt1=C{:}; clear C
fclose(fid2);

% txt1=importdata([char(txtmain(1,:)),'.txt']);
% if isstruct(txt1) % i.e. complicated
%     txt1=txt1.textdata;
% end

hk1 = uicontrol('Parent',hp2a, ...			% make panels for assign species
	'Callback','', ...
	'units','normalized', ...
	'Position',[.01 .6 .68 .2], ...
	'string',txt1, ...
	'userdata',[], ...
	'style','popup', ...
	'Tag','Pick1');
index=get(findobj('tag','Pick1'),'Value'); 
sp=char(txt1(index,:)); sp1=sp(1:regexp(sp,'\W','once')-1); %sp(1:6); % just OTU

else % closes proram if file is empty 
   uiwait(msgbox({'No categories found in file ''Categories.txt''.'},...
   {'Program will close ...'}))
   close(findobj('tag','uw_fig')) % close main figure
   
end % if

            
if numlist>1           
hp2b = uipanel('Title',txtmain(2,:),'FontSize',10,...  
                'BackgroundColor','white',...
                'Position',[.66 .40 .33 .11]); % make panel for uicontrol
            
     hc2 = uicontrol('Parent',hp2b, ...			% count2
	'Callback','bat_gui_count(2,fid,h0)', ...
	'units','normalized', ...
	'Position',[.72 .125 .25 .75], ...
            'fontname','Times', ...
	'string','Count', ...
	'style','pushbutton', ...
	'tag','count2');

fid2=fopen([char(txtmain(2,:)),'.txt'],'r');
C=textscan(fid2,'%q','delimiter','\n');
txt2=C{:}; clear C
fclose(fid2);

% txt2=importdata([char(txtmain(2,:)),'.txt']);
% if isstruct(txt2) % i.e. complicated
%     txt2=txt2.textdata;
% end

hk2 = uicontrol('Parent',hp2b, ...			% assign species
	'Callback','', ...
	'units','normalized', ...
	'Position',[.01 .6 .68 .2], ...
	'string',txt2, ...
	'userdata',[], ...
	'style','popup', ...
	'Tag','Pick2');
index=get(findobj('tag','Pick2'),'Value'); 
sp=char(txt2(index,:)); sp2=sp(1:regexp(sp,'\W','once')-1); %sp(1:6); % just OTU
end

if numlist>2            
hp2c = uipanel('Title',txtmain(3,:),'FontSize',10,...  
                'BackgroundColor','white',...
                'Position',[.66 .52 .33 .11]); % make panel for uicontrol
            
     hc3 = uicontrol('Parent',hp2c, ...			% count3
	'Callback','bat_gui_count(3,fid,h0)', ...
	'units','normalized', ...
	'Position',[.72 .125 .25 .75], ...
            'fontname','Times', ...
	'string','Count', ...
	'style','pushbutton', ...
	'tag','count3');

fid2=fopen([char(txtmain(3,:)),'.txt'],'r');
C=textscan(fid2,'%q','delimiter','\n');
txt3=C{:}; clear C
fclose(fid2);

% txt3=importdata([char(txtmain(3,:)),'.txt']);
% if isstruct(txt3) % i.e. complicated
%     txt3=txt3.textdata;
% end

hk3 = uicontrol('Parent',hp2c, ...			% assign species
	'Callback','', ...
	'units','normalized', ...
	'Position',[.01 .6 .68 .2], ...
	'string',txt3, ...
	'userdata',[], ...
	'style','popup', ...
	'Tag','Pick3');
index=get(findobj('tag','Pick3'),'Value'); 
sp=char(txt3(index,:)); sp3=sp(1:regexp(sp,'\W','once')-1); %sp(1:6); % just OTU
end

if numlist>3            
hp2d = uipanel('Title',txtmain(4,:),'FontSize',10,...  
                'BackgroundColor','white',...
                'Position',[.66 .64 .33 .11]); % make panel for uicontrol
            
     hc4 = uicontrol('Parent',hp2d, ...			% count4
	'Callback','bat_gui_count(4,fid,h0)', ...
	'units','normalized', ...
	'Position',[.72 .125 .25 .75], ...
            'fontname','Times', ...
	'string','Count', ...
	'style','pushbutton', ...
	'tag','count4');

fid2=fopen([char(txtmain(4,:)),'.txt'],'r');
C=textscan(fid2,'%q','delimiter','\n');
txt4=C{:}; clear C
fclose(fid2);

% txt4=importdata([char(txtmain(4,:)),'.txt']);
% if isstruct(txt4) % i.e. complicated
%     txt4=txt4.textdata;
% end

hk4 = uicontrol('Parent',hp2d, ...			% assign species
	'Callback','', ...
	'units','normalized', ...
	'Position',[.01 .6 .68 .2], ...
	'string',txt4, ...
	'userdata',[], ...
	'style','popup', ...
	'Tag','Pick4');
index=get(findobj('tag','Pick4'),'Value'); 
sp=char(txt4(index,:)); sp4=sp(1:regexp(sp,'\W','once')-1); %sp(1:6); % just OTU
end

if numlist>4
hp2e = uipanel('Title',txtmain(5,:),'FontSize',10,...  
                'BackgroundColor','white',...
                'Position',[.66 .76 .33 .11]); % make panel for uicontrol
            
     hc5 = uicontrol('Parent',hp2e, ...			% count5
	'Callback','bat_gui_count(5,fid,h0)', ...
	'units','normalized', ...
	'Position',[.72 .125 .25 .75], ...
            'fontname','Times', ...
	'string','Count', ...
	'style','pushbutton', ...
	'tag','count5');

fid2=fopen([char(txtmain(5,:)),'.txt'],'r');
C=textscan(fid2,'%q','delimiter','\n');
txt5=C{:}; clear C
fclose(fid2);

% txt5=importdata([char(txtmain(5,:)),'.txt']);
% if isstruct(txt5) % i.e. complicated
%     txt5=txt5.textdata;
% end

hk5 = uicontrol('Parent',hp2e, ...			% assign species
	'Callback','', ...
	'units','normalized', ...
	'Position',[.01 .6 .68 .2], ...
	'string',txt5, ...
	'userdata',[], ...
	'style','popup', ...
	'Tag','Pick5');

end

if numlist>5
hp2f = uipanel('Title',txtmain(6,:),'FontSize',10,...  
                'BackgroundColor','white',...
                'Position',[.66 .88 .33 .11]);  % make panel for uicontrol
            
     hc6 = uicontrol('Parent',hp2f, ...			% count6
	'Callback','bat_gui_count(6,fid,h0)', ...
	'units','normalized', ...
	'Position',[.72 .125 .25 .75], ...
            'fontname','Times', ...
	'string','Count', ...
	'style','pushbutton', ...
	'tag','count6');

fid2=fopen([char(txtmain(6,:)),'.txt'],'r');
C=textscan(fid2,'%q','delimiter','\n');
txt6=C{:}; clear C
fclose(fid2);

% txt6=importdata([char(txtmain(6,:)),'.txt']);
% if isstruct(txt6) % i.e. complicated
%     txt6=txt6.textdata;
% end

hk6 = uicontrol('Parent',hp2f, ...			% assign species
	'Callback','', ...
	'units','normalized', ...
	'Position',[.01 .6 .68 .2], ...
	'string',txt6, ...
	'userdata',[], ...
	'style','popup', ...
	'Tag','Pick6');
index=get(findobj('tag','Pick6'),'Value'); 
sp=char(txt6(index,:)); sp(1:regexp(sp,'\W','once')-1); %sp6=sp(1:6); % just OTU
end

if numlist>6 % closes program if there are more than 6 categories
   uiwait(msgbox({'B.A.T does not support more than 6 categories.'},...
       {'Edit file ''Categories.txt''. Program will close ...'}))
   close(findobj('tag','uw_fig')) % close main figure
end


%========================================================
 
%========================================================
hp6 = uipanel('Title','Main Substrate','FontSize',10,...
                'BackgroundColor','white',...
                'Position',[.53 .06 .15 .08]); 
            
hsub1 = uicontrol('Parent',hp6, ...			% choose substrates
	'Callback','bat_gui_substrate', ...
	'units','normalized', ...
	'Position',[.05 .1 .9 .8], ...
	'string',' ', ...
	'userdata',[], ...
	'style','popup', ...
	'Tag','PickSubstrate1');

try
list=importdata('Substrate_main.txt'); % load substrate file- can be any length
catch
   uiwait(msgbox({'File ''Substrate_main.txt'' not found.'},...
       {'Program will close ...'}))
   close(findobj('tag','uw_fig')) % close main figure
end
list{end+1}='unassigned'; % add 'unassigned' category to end
list=[' ';list]; % add empty to front

h=findobj('Tag','PickSubstrate1');
set(h,'string',list);



hp7 = uipanel('Title','Secondary Substrate','FontSize',10,...
                'BackgroundColor','white',...
                'Position',[.73 .06 .15 .08]); 
            
hsub2 = uicontrol('Parent',hp7, ...			% choose substrates
	'Callback','bat_gui_substrate2', ...
	'units','normalized', ...
	'Position',[.05 .1 .9 .8], ...
	'string',' ', ...
	'userdata',[], ...
	'style','popup', ...
	'Tag','PickSubstrate2');

try
list=importdata('Substrate_sub.txt'); % load substrate file- can be any length
catch
   uiwait(msgbox({'File ''Substrate_sub.txt'' not found.'},...
       {'Program will close ...'}))
   close(findobj('tag','uw_fig')) % close main figure
end
list{end+1}='unassigned'; % add 'unassigned' category to end
list=[' ';list]; % add empty to front

h=findobj('Tag','PickSubstrate2');
set(h,'string',list);




%========================================================           
    
% ================ TOOLS
%========================================================  
%========================================================
hp1 = uipanel('Title','Tools','FontSize',10,...
                'BackgroundColor','white',...
                'Position',[.01 .06 .51 .16]); % make panel for uicontrol

hl1 = uicontrol('Parent',hp1, ...			% labels toggle on/off
	'Callback','bat_labelson', ...
	'units','normalized', ...
	'Position',[.02 .1 .25 .3], ...
            'fontname','Times', ...
	'string','Labels On', ...
	'style','pushbutton', ...
	'tag','length');

ha1 = uicontrol('Parent',hp1, ...			% 
	'Callback','bat_labelsoff', ...
	'units','normalized', ...
	'Position',[.02 .5 .25 .3], ...
            'fontname','Times', ...
	'string','Labels Off', ...
	'style','pushbutton', ...
	'tag','area');
            
% hsv1 = uicontrol('Parent',hp1, ...			% button 1: save
% 	'Callback','bat_save', ...
% 	'units','normalized', ...
% 	'Position',[.3 .5 .25 .3], ...
%             'fontname','Times', ...
% 	'string','Save', ...
% 	'style','pushbutton', ...
% 	'tag','length');


hsv1 = uicontrol('Parent',hp1, ...			% button 1: save
	'Callback','bat_zoombox', ...
	'units','normalized', ...
	'Position',[.3 .5 .25 .3], ...
            'fontname','Times', ...
	'string','Zoom', ...
	'style','pushbutton', ...
	'tag','length');


hpr1 = uicontrol('Parent',hp1, ...			% button 2: print
	'Callback','bat_print', ...
	'units','normalized', ...
	'Position',[.3 .1 .25 .3], ...
            'fontname','Times', ...
	'string','Print Figure', ...
	'style','pushbutton', ...
	'tag','length');

hsv1 = uicontrol('Parent',hp1, ...			% area
	'Callback','bat_area', ...
	'units','normalized', ...
	'Position',[.59 .5 .25 .3], ...
            'fontname','Times', ...
	'string','Area', ...
	'style','pushbutton', ...
	'tag','length');

hpr1 = uicontrol('Parent',hp1, ...			% length
	'Callback','bat_length', ...
	'units','normalized', ...
	'Position',[.59 .1 .25 .3], ...
            'fontname','Times', ...
	'string','Length', ...
	'style','pushbutton', ...
	'tag','length');

ht2 = uicontrol('Parent',hp1, ...			% button 2: apply
	'Callback','bat_transform', ...
	'units','normalized', ...
	'Position',[.87 .1 .12 .7], ...
            'fontname','Times', ...
	'string','Transform', ...
	'style','pushbutton', ...
	'tag','trans');
            
 %========================================================
%  hp4 = uipanel('Title','Save & Print','FontSize',10,...
%                 'BackgroundColor','white',...
%                 'Position',[.18 .06 .15 .18]); % make panel for uicontrol 
% 
%  hp4 = uipanel('Title','Length & Area','FontSize',12,...
%                 'BackgroundColor','white',...
%                 'Position',[.03 .05 .15 .18]);
%========================================================         
%  hp5 = uipanel('Title','Perspective Transformation','FontSize',9,...
%                 'BackgroundColor','white',...   % for notes
%                 'Position',[.34 .06 .15 .18]); % make panel for uicontrol
%             
%  ht1 = uicontrol('Parent',hp5, ...			% button 1: load file
% 	'Callback','bat_loadTmatrix', ...
% 	'units','normalized', ...
% 	'Position',[.1 .5 .75 .3], ...
%             'fontname','Times', ...
% 	'string','Load T-matrix', ...
% 	'style','pushbutton', ...
% 	'tag','loadT');
 
 
    


function bat_gui_count(flag,fid,h0)
% main counting program. The bizniss!!
% sp = list of species (text)
% flag = which button has been pressed in gui
% fid = file identifier of the txt log
% h0 = main gui handle
%
% Written by Daniel Buscombe, Nov 2009
% revised december 2010, 
% revised Apr 2012 so only the last point is deleted when right click
% (rather than all of them)
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

txtmain=importdata('Categories.txt');

fid2=fopen([char(txtmain(flag,:)),'.txt'],'r');
C=textscan(fid2,'%q','delimiter','\n');
txt=C{:}; clear C
fclose(fid2);

index=get(findobj('tag',['Pick',num2str(flag)]),'Value'); 
sp=char(txt(index,:)); 
sp=sp(1:6); % just OTU

try
txtmain=importdata('Categories.txt');
catch
uiwait(msgbox('File ''Categories.txt'' not found. Program will close ...'))
close(findobj('tag','uw_fig')) % close main figure
end

menu=char(txtmain(flag,:));

% initialising structure 'S' which will be passed to subfunctions
S.main=h0;
S.menu1=menu;
S.menu2=sp;

% make subfigure
S.fh = figure('Color',[.3 .7 .3],...
              'units','pixels',...
              'position',[200 200 500 500],...
              'menubar','none',...
              'name','UCT',...
              'numbertitle','off',...
              'resize','on',...
              'visible','off',...
              'tag','fh');
S.ax = axes('xlim',[0 1],'ylim',[0 1]);

ix=get(findobj('tag','PickImage'),'value');
sample=get(findobj('tag','current_image'),'userdata');

if ~isempty(sample)

if ~isfield(sample(ix),'count') % if needed from before
S.ln = [];  % This holds the handles to the points.
else
S.ln=sample(ix).count;    
end

set(S.fh,'visible','on')

else
    uiwait(msgbox('Please load image(s) first!!!!'))
    close(S.fh)
    return

end

S.txt=[]; % holds text
S.maintxt=[]; % same for the main fig (replicate plots and text)
S.mainplot=[];
S.Cnt=0; % holds the number of counts
S.counttext=[];
S.confidence=[];
S.countall_names=[];
S.countall_coords=[];

set(S.ax,'tag','out_im')

set(S.fh,'toolbar','figure'); % adds usual matlab tools
hToolbar = findall(S.fh,'tag','FigureToolBar'); %get handle for toolbar
hButtons = findall(hToolbar); % get handle for button
set(hButtons(2:7),'Visible','off') % remove unneccessary buttons


maximise

f1 = uimenu('Parent',S.fh, ...             % File menu
	'Label','File', ...
	'Tag','file_menu');  
    
	f2 = uimenu('Parent',f1, ...
		'Callback','count_quit', ...
		'Label','Quit', ...
		'Separator','on', ...
		'Tag','cnt_quit'); % calls quit function which closes 2ndary window

movegui(f1,'center') 


h2 = image('Parent',S.ax, ...
	'CData',[], ...
	'CDataMapping','scaled', ...
	'Tag','im');

set(h2,'userdata',sample);
set(h2,'cdata',sample(ix).data); % show current image in new window

S.imh=h2;

fprintf(fid,'%s\n','%------------------------');
fprintf(fid,'%s\n',['%Counts made on image: ',sample(ix).name]);
fprintf(fid,'%s\n',['%Count type: ',menu]);

set(h2, 'HitTest', 'off') % allows cursor to function properly
hold on, axis image  
grid

if sample(ix).istransformed==0 % not transformed
    h=findobj('tag','im');
    [Nv,Nu,c] = size(sample(ix).data);  
    
    set(h,'xdata',[1:Nu]);
    set(h,'ydata',[1:Nv]);
    set(S.ax,'xlim',get(findobj('tag','im_axes1'),'Xlim'),'ylim',...
        get(findobj('tag','im_axes1'),'Ylim')); 

    a=get(findobj('tag','out_im'),'xlabel');
    b=get(findobj('tag','out_im'),'ylabel');
    set(a,'string','pixels')  
    set(b,'string','pixels') 
    
else % 1, transformed

    h=findobj('tag','im');
    [Nv,Nu,c] = size(sample(ix).data);
    res=sample(ix).res;
    set(h,'xdata',[1:Nu].*res)
    set(h,'ydata',[1:Nv].*res)
    
    set(S.ax,'xlim',get(findobj('tag','im_axes1'),'Xlim'),'ylim',...
        get(findobj('tag','im_axes1'),'Ylim')); 
    
    a=get(findobj('tag','out_im'),'xlabel');
    b=get(findobj('tag','out_im'),'ylabel');
    set(a,'string','mm')  
    set(b,'string','mm')
    
end
set(gca,'ydir','reverse')

S.fid=fid;

 hp5 = uipanel('Title','Notes','FontSize',12,...
                'BackgroundColor','white',...
                'Position',[.82 .5 .17 .5]);
    
   txt1= uicontrol('Parent',hp5, ...
    	'units','normalized', ...
	    'Position',[.05 .05 .93 .93], ...
        'fontname','Times', ...
        'max',10,...
        'stri',{'For notes ...'},'fonts',12,...
        'sty','ed',...
        'backg',[1 1 1]);
    
    S.txtbox=txt1;

title(menu,'fontw','bold')
S.cm = uicontextmenu;
S.um(1) = uimenu(S.cm,...
                 'label','Delete Last Point',...
                 'Callback', {@um1_call,S}); % first button assigns points           
set(S.ax,'buttondownfcn',{@ax_bdfcn,S},'uicontextmenu',S.cm) % add points
    

    
%     set(S.zx,'xdata',[1:Nu]);
%     set(S.zx,'ydata',[1:Nv]);    
% S.um(2) = uimenu(S.cm,...
%                  'label','Assign',...
%                  'Callback', {@um2_call,S}); % second button deletes them    
%set(findobj('tag','out_im'),'xlim',[0.5 Nu+0.5],'ylim',[0.5 Nv+.5])
%set(S.ax,'xlim',[0.5 Nu+0.5],'ylim',[0.5 Nv+.5])
    
%set(findobj('tag','out_im'),'xlim',[0.5 (Nu*res)+0.5],'ylim',[0.5 (Nv*res)+.5])    
     %========================================================            
%  hp4 = uipanel('Title','Length & Area','FontSize',12,...
%                 'BackgroundColor','white',...
%                 'Position',[.03 .05 .15 .18]);
%             
% hsv1 = uicontrol('Parent',hp4, ...			% area
% 	'Callback',{@uct_area,S}, ...
% 	'units','normalized', ...
% 	'Position',[.1 .5 .75 .3], ...
%             'fontname','Times', ...
% 	'string','Area', ...
% 	'style','pushbutton', ...
% 	'tag','length');
% 
% 
% hpr1 = uicontrol('Parent',hp4, ...			% length
% 	'Callback',{@uct_length,S}, ...
% 	'units','normalized', ...
% 	'Position',[.1 .1 .75 .3], ...
%             'fontname','Times', ...
% 	'string','Length', ...
% 	'style','pushbutton', ...
% 	'tag','length');

% if flag==1
%     menu='Cnidaria';
% elseif flag==2
%     menu='Echinodermata';
% elseif flag==3
%     menu='Porifera';
% elseif flag==4
%     menu='Chordata';
% elseif flag==5
%     menu='Invertebrates';
% else
%     menu='Other';
% end


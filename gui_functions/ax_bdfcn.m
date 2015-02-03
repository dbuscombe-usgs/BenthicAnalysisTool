
function [] = ax_bdfcn(varargin)
% ax_bdfcn (short for: axes button down function)
% called by bat_gui_count.m
% 1. puts the points on the sub-window, 
% 2. updates structure accordingly
%
% Written by Daniel Buscombe, Nov 2009
% revised December 2010, Apr 2012
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

ix=get(findobj('tag','PickImage'),'value');
sample=get(findobj('tag','current_image'),'userdata');

% Serves as the buttondownfcn for the axes.
S = varargin{3};  % Get the structure.
seltype = get(S.fh,'selectiontype'); % Right-or-left click?
L = length(S.ln);

if strmatch(seltype,'normal') % i.e. left click
    p = get(S.ax, 'currentpoint'); % Get the position of the mouse.
    S.ln(L+1) = line(p(1),p(3),'Marker','+','MarkerSize',...
        12,'LineWidth',3);  
    % Make our plot.
    set(S.ln(L+1),'uicontextmenu',S.cm)  % So user can click a point too.
    S.Cnt = S.Cnt+ 1;  % Increment the counter.
    %fprintf(S.fid,'%6.2f\n',S.Cnt);
    S.txt(L+1)=text(p(1),p(3),S.menu2,'Color','y');
    
     str = {'v. high';'high';'medium';'low';'v. low';'none'};
      [s,v] = listdlg('PromptString','Assign Confidence?:',...
                      'SelectionMode','single',...
                      'ListString',str);
                  
    fprintf(S.fid,'%s\n','%------------------------');
    fprintf(S.fid,'%s\n',['%Class: ',S.menu1]);
    fprintf(S.fid,'%s\n',['%Count: ',S.menu2]);
    fprintf(S.fid,'%6.3f %6.3f\n',[p(1),p(3)]);
    fprintf(S.fid,'%s\n',['%Confidence: ',str{s}]);
    
    figure(S.main) % main figure
    S.mainplot(L+1)=line(p(1),p(3),'Marker','+','MarkerSize',...
        12,'LineWidth',3);  
    % Make our plot.
    fprintf(S.fid,'%6.2f\n',S.Cnt);
    fprintf(S.fid,'%6.3f %6.3f\n',[p(1),p(3)]);
    S.maintxt(L+1)=text(p(1),p(3),S.menu2,'Color','y');
    
    figure(S.fh) % back to subfigure
    
%=====================
% change
sample(ix).counttxt{L+1}=S.menu2;
sample(ix).confidence{L+1}=str{s};
sample(ix).countall_names{L+1}=[S.menu1,S.menu2];
sample(ix).countall_coords{L+1}=[p(1),p(3)];

sample(ix).metatxt{L+1}=get(S.txtbox,'string');

% if isfield(sample,'data_orig')
sample(ix).data_orig=sample(ix).data_orig;
sample(ix).axes_orig=sample(ix).axes_orig;
% end

% no change
sample(ix).count=S.ln;
sample(ix).substrate1=sample(ix).substrate1; % no change
sample(ix).substrate2=sample(ix).substrate2; % no change

sample(ix).data=sample(ix).data; % no change
sample(ix).name=sample(ix).name; % no change
sample(ix).istransformed=sample(ix).istransformed; % no change
sample(ix).adate=sample(ix).adate;
sample(ix).atime=sample(ix).atime;
sample(ix).localX=sample(ix).localX;
sample(ix).localY=sample(ix).localY;
sample(ix).altitude=sample(ix).altitude;
sample(ix).lat=sample(ix).lat;
sample(ix).lon=sample(ix).lon;
sample(ix).res=sample(ix).res;

sample(ix).trans_data=sample(ix).trans_data;                
        
% set data structure again
set(findobj('tag','current_image'),'userdata',sample);
set(findobj('tag','current_image'),'cdata',sample(ix).data);
    
end
% Update structure.
set(S.ax,'ButtonDownFcn',{@ax_bdfcn,S}) 
set(S.um(:),{'callback'},{{@um1_call,S}})



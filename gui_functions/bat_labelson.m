
% bat_labelson
% does exacterly what to says on the tin
%
% Written by Daniel Buscombe, Nov 2009
% revised Apr 2012
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

% get current image index
ix=get(findobj('tag','PickImage'),'value');
% and current image data
sample=get(findobj('tag','current_image'),'userdata');

% has anything been counted yet?
% if isfield(sample,'countall_names')

if ~isempty(sample(ix).countall_names)

for i=1:size(sample(ix).countall_names,2)
    if ~isempty(sample(ix).countall_coords{i})
    pts=sample(ix).countall_coords{i}; % get point coordinates
    label=sample(ix).countall_names{i}; % get point names
    otu=label(regexp(label,'OTU'):end); %label(end-5:end); % 6-digit otu number
    grp= label(1:2); %label(1:end-6); % 'category' name
    hold on
    end

try % retrieve text file wih categories
txtmain=importdata('Categories.txt');
catch
uiwait(msgbox('File ''Categories.txt'' not found. Program will close ...'))
close(findobj('tag','uw_fig')) % close main figure
end
menu=char(txtmain); % assign character variable

if strmatch(grp,menu(1,1:2)) % annotate accordingly
    plot(pts(1),pts(2),'Marker','+','MarkerSize',12,'LineWidth',3,...
        'Color','y');
    text(pts(1)+1,pts(2)+1,[grp,otu],'Color','y');
elseif strmatch(grp,menu(2,1:2))
    plot(pts(1),pts(2),'Marker','+','MarkerSize',12,'LineWidth',3,...
        'Color','g');
    text(pts(1)+1,pts(2)+1,[grp,otu],'Color','g');
elseif strmatch(grp,menu(3,1:2))
    plot(pts(1),pts(2),'Marker','+','MarkerSize',12,'LineWidth',3,...
        'Color','b');
    text(pts(1)+1,pts(2)+1,[grp,otu],'Color','b');
elseif strmatch(grp,menu(4,1:2))
    plot(pts(1),pts(2),'Marker','+','MarkerSize',12,'LineWidth',3,...
        'Color','r');
    text(pts(1)+1,pts(2)+1,[grp,otu],'Color','r');
elseif strmatch(grp,menu(5,1:2))
    plot(pts(1),pts(2),'Marker','+','MarkerSize',12,'LineWidth',3,...
        'Color','m');
    text(pts(1)+1,pts(2)+1,[grp,otu],'Color','m');
elseif strmatch(grp,menu(6,1:2))
    plot(pts(1),pts(2),'Marker','+','MarkerSize',12,'LineWidth',3,...
        'Color','c');
    text(pts(1)+1,pts(2)+1,[grp,otu],'Color','c');
% else
%     uiwait(msgbox('Warning: No data to display'));
end

end

% else % warning messgae if no data yet
%     uiwait(msgbox('Warning: No data to display'));
end

% length annotations
if ~isempty(sample(ix).length_coord) %isfield(sample,'length_coords')
    for i=1:size(sample(ix).length_coord,2)
       pts=sample(ix).length_coord{i}; % get point coordinates 
       if ~isempty(pts)
        line(pts(:,1),pts(:,2),'color','m','LineWidth',2) % draw line 
       end
    end
end

% areal annotations
if ~isempty(sample(ix).area_coord) %isfield(sample,'area_coords')
    for i=1:size(sample(ix).area_coord,2)
       pts=sample(ix).area_coord{i}; % get point coordinates 
       if ~isempty(pts)
        plot(pts(1,:),pts(2,:),'b-');
       end
    end
end


%------------------
% update substrate text
h=findobj('Tag','PickSubstrate1');
list=get(h,'string');
subval=sample(ix).substrate1;
if isnan(subval) % no substrate yet assigned
txt=list(1); % assign appropriate text
else % substrate assigned
txt=list(subval);    
end
text(.02,.04,char(txt),'units','normalized','tag','subtxt1');
set(findobj('tag','subtxt1'),'Color','y','FontSize',12)


h=findobj('Tag','PickSubstrate2');
list=get(h,'string');
subval=sample(ix).substrate2;
if isnan(subval) % no substrate yet assigned
txt=list(1); % assign appropriate text
else % substrate assigned
txt=list(subval);    
end
text(.02,.02,char(txt),'units','normalized','tag','subtxt2');
set(findobj('tag','subtxt2'),'Color','g','FontSize',12)
%------------------



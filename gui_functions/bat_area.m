
% tool for measuring area of wee beasties
%
% Written by Daniel Buscombe, Nov 2009
% modified apr 2012
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

ix=get(findobj('tag','PickImage'),'value');
sample=get(findobj('tag','current_image'),'userdata');
seltype=get(h0,'selectiontype');

if ~isempty(sample) % avoid error when user presses button 
    %before images loaded

if strmatch(seltype,'normal') % i.e. left click
zoom on
            k=waitforbuttonpress;

            point1 = get(gca,'CurrentPoint');    % button down detected
            finalRect = rbbox;                % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1 = min(point1,point2);             % calculate locations
            offset = abs(point1-point2);         % and dimensions
            x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
            y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
            axis([min(x) max(x) min(y) max(y)]) % reset axes
            zoom off

            [xii,yii]=meshgrid([1:size(sample(ix).data,1)],...
                [1:size(sample(ix).data,2)]); %for IN
            xy = [];
            n0 = 0;
            % Loop, picking up the points.
            b = 1;

            while b==1
                [xi,yi,b] = ginput(1); % Note: 'b' detects whether 
                %right or left click
                plot(xi,yi,'r.')
                n0 = n0+1; % update counter
                xy(:,n0) = [xi;yi];
            end
            xy(:,n0+1)=[xy(1,1);xy(2,1)];
            % Plot the polygon.
            plot(xy(1,:),xy(2,:),'b-');

            IN = inpolygon(yii,xii,xy(1,:),xy(2,:)); 
            % binary image size of im - 1=area just selected
            A=sum(IN(:))*sample(ix).res; % *res
            cent=[mean(xy(1,:)),mean(xy(2,:))]; % centre of the polygon
            
                         
% annotate log           
if exist('A')
    if sample(ix).istransformed==0 % not transformed   
    fprintf(fid,'%s\n',['%Area (pixels^{2}): ']);
    else
    fprintf(fid,'%s\n',['%Area (mm^{2}): ']);   
    end
    fprintf(fid,'%6.3f\n',A);
end

end

pause(1.5)    
bat_setaxes


if ~isempty(sample(ix).countall_names)
    % find closest counted point to cent
    allcoords=sample(ix).countall_coords;
    D=zeros(max(size(allcoords)),2);
    for i=1:max(size(allcoords))
        if ~isempty(allcoords{i})
        D(i,:)=allcoords{i}-cent;
        end
    end
    dist=sqrt(D(:,1).^2+D(:,2).^2);
    [val,indx]=min(dist);

    sample(ix).area{indx}=A; % assign area meast to appropriate cell
    
    sample(ix).area_coords{indx}=xy;
end

% no change
sample(ix).metatxt=sample(ix).metatxt;
sample(ix).counttxt=sample(ix).counttxt;
sample(ix).confidence=sample(ix).confidence;
sample(ix).countall_names=sample(ix).countall_names;
sample(ix).countall_coords=sample(ix).countall_coords;
sample(ix).count=sample(ix).count;
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

if isfield(sample,'data_orig')
sample(ix).data_orig=sample(ix).data_orig;
sample(ix).axes_orig=sample(ix).axes_orig;
end
        
h=findobj('tag','current_image');
set(h,'userdata',sample);
set(h,'cdata',sample(ix).data);

else % no sample yet
    uiwait(msgbox('No image loaded yet ... '))

end






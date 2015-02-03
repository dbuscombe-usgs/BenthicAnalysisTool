% bat_setaxes.m
% to set axes of main figure/annotation window after changes have
% been made
% 
% Written by Daniel Buscombe, Nov 2009
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

if sample(ix).istransformed==0 %is not transformed
    h=findobj('tag','current_image');
    [Nv,Nu,c] = size(sample(ix).data);  
    set(h,'xdata',[1:Nu],'visible','on');
    set(h,'ydata',[1:Nv],'visible','on');
    set(findobj('tag','im_axes1'),'xlim',[0.5 Nu+0.5],'ylim',...
        [0.5 Nv+.5],'visible','on')
    
    % appropriate annotation
    a=get(findobj('tag','im_axes1'),'xlabel');
    b=get(findobj('tag','im_axes1'),'ylabel');
    set(a,'string','pixels','visible','on')  
    set(b,'string','pixels','visible','on') 
    
else % is transformed
        
    h=findobj('tag','current_image');
    [Nv,Nu,c] = size(sample(ix).data);
    res=sample(ix).res;
    set(h,'xdata',[1:Nu].*res,'visible','on')
    set(h,'ydata',[1:Nv].*res,'visible','on')
    set(findobj('tag','im_axes1'),'xlim',[0.5 (Nu*res)+0.5],...
        'ylim',[0.5 (Nv*res)+.5],'visible','on')

    % appropriate annotation
    a=get(findobj('tag','im_axes1'),'xlabel');
    b=get(findobj('tag','im_axes1'),'ylabel');
    set(a,'string','mm','visible','on')  
    set(b,'string','mm','visible','on') 
end


function zoomfix
% for fixing zoom problems, should they arise, in bat.m
% sometimes the 'zoom to full extent' button doesn't do the job
% in these cases, press the 'globe' icon on the main figure toolbar
% this function is activated when the 'globe' icon is pressed
%
% Written by Daniel Buscombe, Nov 2009
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

% get current image
ix=get(findobj('tag','PickImage'),'value');
% and current image data
sample=get(findobj('tag','current_image'),'userdata');

if ~isempty(sample) % avoid error when user presses button 
    %before images loaded
    
% new image(obj,evd)
bat_setaxes


else
    disp('No image loaded yet ... ')

end

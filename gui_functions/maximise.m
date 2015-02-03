function maximise
% maximises figure window
%
% Written by Daniel Buscombe, Nov 2009
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

units=get(gcf,'units');
set(gcf,'units','normalized','outerposition',[0.6 0.6 .6 .6]);
set(gcf,'units',units)


% bat_zoombox
% creates a movable box to allow zooming anywhere on the image
% uses the on figure magnifer tool
% (http://www.mathworks.com/matlabcentral/fileexchange/26007)
%
% Written by Daniel Buscombe, Apr 2012
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

bat_labelsoff    

% uiwait(msgbox('Ctrl+D to exit, then press any key'));
mag=magnifyOnFigure(ax,'mode','interactive');


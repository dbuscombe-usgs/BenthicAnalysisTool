
% bat_labelsoff.m
% turns dem labels off, init
%
% Written by Daniel Buscombe, Nov 2009
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

% remove plotted points from previous image
chx = get(gca,'Children');
chx2= chx;
if length(chx)>=2
chx(end)=[];
delete(chx)
end

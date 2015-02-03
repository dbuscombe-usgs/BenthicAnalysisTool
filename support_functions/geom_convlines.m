
%geom_convlines
function [imnew,axesofnew,H,mmperpix_x,mmperpix_y]=geom_convlines(files)

% user-interactive function to geometrically transform an image by correcting converging lines, and
% then work out the spatial resolutions in the x- and y- directions
%
% written by DB aug09
% using functions from: % CMP Vision Algorithms http://visionbook.felk.cvut.cz
% Tomas Svoboda, 2007 (u2Hdlt, imgeomt, pointnorm)

% read in images
if iscell(files)
    files=char(files);
    for i=1:size(files,1)
        eval(['im{',num2str(i),'}=imread(files(',num2str(i),',:));'])
    end % for
else
    for i=1:size(files,1)
        eval(['im{',num2str(i),'}=imread(files(',num2str(i),',:));'])
    end % for 
end %  end if iscell(files)
    
% make font size slightly bigger than default
set(0,'DefaultAxesFontSize',12)

U1=cell(1,4); U2=cell(1,4);
for i=1:size(im,2) % im is a now cell 

figure % loads images in 1-by-1
imagesc(im{i}); axis image
title('click 4 points clockwise from top-left [top-left; top-right; bottom-right; bottom-left]')
hold on; axis on;
xlabel('x-axis'); ylabel('y-axis');
maximise % fill the screen

X=[]; Y=[];
for j=1:4 % user selects 4 points as directed
    [x,y] = ginput(1);
    plot(x,y,'r+','MarkerSize',10)
    X=[X;x];
    Y=[Y;y];
end
close
%plot(X,Y,'ro')
U1{i}=[X,Y];
U2{i}=[[X(1);X(2);X(2);X(1)],Y];
%plot(U2(:,1),U2(:,2),'go')

end

U1(cellfun(@isempty,U1))=[];
U2(cellfun(@isempty,U2))=[];


h = waitbar(0,'Computing Transformations. Please wait...');    
for k=1:size(U1,2)
% Compute the geometrical transform between set of corresponding points 
[H{k},T1,T2] = u2Hdlt( U1{k}', U2{k}', 1 );
  waitbar(k/size(U1,2),h)
end
close(h)

h = waitbar(0,'Applying Transformations. Takes yonks...go make a cuppa');
step_size = 1;
for k=1:size(U1,2)
[imnew{k},axesofnew{k}] = imgeomt( H{k}, im{k}, 'cubic', step_size );
  waitbar(k/size(U1,2),h)
end
close(h)

for k=1:size(U1,2)
figure
% Displaying the new image with its true spatial coordinates.
imagesc(axesofnew{k}.x,axesofnew{k}.y,imnew{k})
title('transformed image')
axis on;
xlabel('x-axis'); ylabel('y-axis');
maximise

%=================
prompt={'What is the distance in the X direction, in mm, you will measure?'};
name='';
numlines=1;
defaultanswer={'49'};
step_size = 1;
answer=inputdlg(prompt,name,numlines,defaultanswer); answer=char(answer);
mm_x=str2num(answer);
    
disp(['Click on two points, ',num2str(mm_x),...
    ' mm apart, then hit ENTER on the keyboard']);

d=ginput(2); d=d(:);
x1=d(1); x2=d(2); y1=d(3); y2=d(4);
 
hold on, h=line([x1 x2],[y1 y2]); 
set(h,'Color','r','LineWidth',3)

pixlength=sqrt(((x2-x1).*(x2-x1))+((y2-y1).*(y2-y1)));
mmperpix_x{k}=mm_x/pixlength;
%==============


%=================
prompt={'What is the distance in the Y direction, in mm, you will measure?'};
name='';
numlines=1;
defaultanswer={'55'};

answer=inputdlg(prompt,name,numlines,defaultanswer); answer=char(answer);
mm_y=str2num(answer);
    
disp(['Click on two points, ',num2str(mm_y),...
    ' mm apart, then hit ENTER on the keyboard']);

d=ginput(2); d=d(:);
x1=d(1); x2=d(2); y1=d(3); y2=d(4);
 
hold on, h=line([x1 x2],[y1 y2]); 
set(h,'Color','r','LineWidth',3)

pixlength=sqrt(((x2-x1).*(x2-x1))+((y2-y1).*(y2-y1)));
mmperpix_y{k}=mm_y/pixlength;
%==============

end

close all


%==========================
% begin subfunctions

%=======================
function maximise
units=get(gcf,'units');
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gcf,'units',units)
%====================

function [H,T1,T2] = u2Hdlt(u1,u2,do_norm)
% u2Hdlt  linear estimation of the Homography matrix
% CMP Vision Algorithms http://visionbook.felk.cvut.cz
% Tomas Svoboda, 2007
% Function u2Hdlt estimates homography from point correspondences
% by using the direct linear transformation (DLT)
% with (optional) point normalization. The homography is also known as 
% collineation
% or projective transform
% The function accepts coordinates of N corresponding image points 
% and returns a calculated [3 x 3] homography matrix H such that
% u_2 = H u_1  
% for all N points. At least 4 corresponding points are requested. The function
% estimates a least squares (LSQ) solution.
% 
% The 2D homography is widely used
% in consumer oriented applications, e.g.,
% Hugin (http://hugin.sourceforge.net).
%
% Usage: [H,T1,T2] = u2Hdlt(u1,u2,do_norm)
% Inputs:
%   u1,u2  [2|3 x N]  Coordinates (homogeneous) of the corresponding points.
%   do_norm  (default 1)  If set to 1 perform isotropic normalization of points.
%     Disabling normalization may be useful for speed reasons
%     when points are already normalized.
% Outputs:
%   H  [3 x 3]  Homography matrix.
%   T1,T2  [3 x 3]  Transformation matrices used in normalization.
% See also: imgeomt, pointnorm, u2Fdlt.
%

if nargin < 3
  do_norm=1;
end

if size(u1,2)~=size(u2,2)
  error('The number of corresponding points si not the same')
end
if size(u1,2)<4
  error('Too few correspondences')
end
if size(u1,1) == 2,
  u1(3,:) = 1;
end
if size(u2,1) == 2,
  u2(3,:) = 1;
end

% Do isotropic normalization using function pointnorm.
if do_norm
  [u1,T1] = pointnorm(u1);
  [u2,T2] = pointnorm(u2);
end

% Compose the data matrix from point correspondences. 
% The implementation closely follows .
% This is a decent example of Matlab\/, allowing very
% elegant implementation of algebraic expressions.
A = zeros( 3*size(u1,2), 9 );
for i=1:size(u1,2) % all points
  A(3*i-2:3*i,:) = kron( u1(:,i)', G(u2(:,i)) );
end

% Function G forms a skew symmetric matrix from a given vector, see below.
% Function kron computes Kronecker tensor product. It returns an array
% formed by taking all possible products between the elements u1(:,i)' and those
% of G(u2(:,i)).
% Now, compute the LSQ solution using SVD.
[U,S,V] = svd(A);
H = reshape( V(:,end), 3, 3 );

% Undo the point normalization if it was applied.
if do_norm
  H = inv(T2)*H*T1;
end
return % end of u2Hdlt

%=============================
function mat = G(u)
% Usage: mat = G(u)
% Inputs:
%   u  [3 x 1]  Vector of values.
% Outputs:
%   mat  [3 x 3]  Skew symmetric matrix containing the vector values.
mat = [0 -u(3) u(2); u(3) 0 -u(1); -u(2) u(1) 0];
return % end of G


%=======================================
function [u2,T] = pointnorm(u);
% POINTNORM   Isotropic point normalization
% CMP Vision Algorithms http://visionbook.felk.cvut.cz
% Tomas Svoboda, 2006-2007
%
% Usage: [u2,T] = pointnorm(u)
% Inputs:
%   u  [3 x N]  Matrix of unnormalized coordinates of N points.
% Outputs:
%   u2  [3 x N]  Normalized coordinates.
%   T   [3 x 3]  Transformation matrix, u2 = Tu.
% See also: u2Fdlt, u2Hdlt.

% how many points
n=size(u,2);

% Center the coordinates.
centroid = mean( u(1:2,:)' )';
u2 = u;
u2(1:2,:) = u(1:2,:) - repmat(centroid,1,n);

% Scale points to have average distance from the origin .
scale = sqrt(2) / mean( sqrt(sum(u2(1:2,:).^2)) );
u2(1:2,:) = scale*u2(1:2,:);

% Composition of the normalization matrix.
T = diag([scale scale 1]);
T(1:2,3) = -scale*centroid;
return  % end of pointnorm


%=========================================
function [im_out,axesofnew] = imgeomt(T,im,method,step,axesoforig)
% IMGEOMT 2D geometrical transformation by backward mapping
% CMP Vision Algorithms http://visionbook.felk.cvut.cz
% Tomas Svoboda, 2006-2007
% Usage: [newimage,axesofnew] = imgeomt(T,im,method,step)
% Inputs:
%   T  [3 x 3]  Transformation matrix.
%   im  [m x n x l]  Image to be transformed. It can be
%                    multilayer, such as an RGB image.
%   method    Method of interpolation, defaults to 'linear'.
%     See interp2 for more details about interpolation.
%   step  (default 1)  1/sampling factor. Determines the resolution of the
%     output image. If set to 2 only each second pixel (in both x
%     and y direction) from the output image will be rendered. Also
%     useful when transforming image to get a quick preview of
%     the transformed image.
%   axesoforig  struct  Structure containing .x and .y
%     spatial coordinates of the input image. Defaults to 
%     .x=1:n and .y=1:m.
% Outputs:
%   im_out  [? x ? x l] Transformed image. The size of the output
%     image is not determined at the time of calling the
%     function. The output image will contain the original image
%     completely. No cropping is applied.
%   axesofnew  struct  Structure containing .x and .y
%     spatial coordinates of the new image. Useful for 
%     displaying image in true spatial coordinates.
% See also: u2Hdlt, interp2.

% History:
% $Id: imgeomt_decor.m 1074 2007-08-14 09:45:42Z kybic $
%
% 2007-03-07: Tomas Svoboda, created, based on hist own old implementation
%             previously named rectify2D
% 2007-05-02: TS new decor
% 2007-05-14: TS decor updated
% 2007-05-24: VZ typo
% 2007-08-09: TS refinement for better looking of m-file

if nargin<4
  step=1;
end
if nargin<3
  method='linear';
end
  
% First, precompute the range of the output image by a forward mapping  
% of the corner coordinates. The coordinates are conveniently
% arranged in [3 x N] matrices, where N
% is the number of points, which allows computation of the transformation by
% u=T*x. It is more efficient
% than looping over all coordinates and performing
% T*x for each grid point separately.
r = size(im,1);
c = size(im,2);
% compute the range of the original image
try xrange = axesoforig.x; yrange = axesoforig.y;
catch xrange=1:c; yrange=1:r; end
[orig.xi,orig.yi] = meshgrid(xrange,yrange);
% corner points of the image
orig.u = [[min(xrange),min(yrange)]',[min(xrange) max(yrange)]', ...
          [max(xrange) min(yrange)]',[max(xrange) max(yrange)]'];
% make homogeneous
orig.u(3,:) = 1;
% map forward
forward.x = T*orig.u;
% compute the limits of the output image (bounding box)
forward.x(1:2,:) = forward.x(1:2,:)./repmat(forward.x(3,:),2,1);
maxx = max( forward.x(1,:) );
minx = min( forward.x(1,:) );
maxy = max( forward.x(2,:) );
miny = min( forward.x(2,:) );

% Then prepare a grid of spatial coordinates for the new
% image, see meshgrid.
axesofnew.x = minx:step:maxx;
axesofnew.y = miny:step:maxy;
[u,v] = meshgrid( axesofnew.x, axesofnew.y );
x2 = [u(:) v(:) ones(size(v(:)))]';

% Perform the backward mapping of the new coordinates. It essentially
% traverses the grid of the new image and looks back for the 
% counterpart in the original image. 
x1 = inv(T) * x2;
% normalization
x1(1:2,:) = x1(1:2,:) ./ repmat( x1(3,:), 2, 1 );

% Put the back-mapped coordinates into interp2 to
% perform the interpolation.
% Do it for each image layer separately. 
new.xi = reshape( x1(1,:), size(u) );
new.yi = reshape( x1(2,:), size(v) );
layers = size(im,3);
if layers>1
  im_out = zeros( length(axesofnew.y), length(axesofnew.x), layers );

  for i=1:layers
    im_out(:,:,i) = ...
      interp2( orig.xi, orig.yi, double(im(:,:,i)), new.xi, new.yi, method );
  end

else
  im_out = interp2( orig.xi, orig.yi, double(im), new.xi, new.yi, method );  
end

im_out = uint8(round(im_out));
 
return; % end of imgeomt





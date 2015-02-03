% bat_loadTmatrix
% loads transformation matrix for image transformation
%
% Written by Daniel Buscombe, Nov 2009
% School of Marine Science and Engineering, University of Plymouth, UK
% daniel.buscombe@plymouth.ac.uk

clear Tdat 
[T_name, T_path] = uigetfile({'*.mat';'*.*'},'Load transform data ...');	
% get file 
addpath(T_path) % add to path
load(T_name) % load

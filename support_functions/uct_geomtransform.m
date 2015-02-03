
% uct_geomtransform
% DB aug09

close all;clear all;clc

 [image_name, image_path] = uigetfile({'*.*';'*.JPG';'*.BMP';'*.PNG';'*.TIFF';'*.jpg';'*.bmp';'*.png';'*.tiff';'*.tif'},...
     'Load images ...', 'MultiSelect', 'on');	% get image names
    
 addpath(image_path)
 
        if isequal(image_name,0) || isequal(image_path,0)
       disp('You pressed cancel')
        else

            if iscell(image_name)
            
            for i=1:size(image_name,2)
            
            ff=fullfile(image_path, char(image_name(i)));
            disp(['You selected ', ff]);
            F{i}=ff;
            end % end for
            
            num_lines = 1;
            for i=1:size(image_name,2)
            prompt = {'Image','Enter distance to object (m):'};
            dlg_title = 'Input:';
            def = {image_name{i},'1'};
            answer{i} = inputdlg(prompt,dlg_title,num_lines,def);
            end % end for
            
            else
            
            ff=fullfile(image_path, char(image_name));
            disp(['You selected ', ff]);
            F=ff;
            num_lines = 1;
            prompt = {'Image','Enter distance to object (m):'};
            dlg_title = 'Input:';
            def = {image_name,'1'};
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            
            end % end if iscell(image_name)
            
        end % end if isequal(image_name,0) || isequal(image_path,0)
  
        
[imnew,axesofnew,H,mmperpix_x,mmperpix_y]=geom_convlines(F);

Tdat.H=H;
Tdat.dist=answer;

rectIms.ims=imnew;
rectIms.dist=answer;

rectDims.dims=[mmperpix_x,mmperpix_y];
rectDims.dist=answer;

Files.list=F;
Files.dist=answer;

save(['GeomTransform_',datestr(now,30)],'Files','rectDims','Tdat')

if iscell(image_name)
                
for i=1:size(imnew,2)
    imwrite(uint8(imnew{i}), [image_path(1,:),filesep,char(image_name{i}),'_rect.tif'], 'tif');
end

else
    
    imwrite(uint8(imnew), [image_path(1,:),filesep,char(image_name),'_rect.tif'], 'tif');

end







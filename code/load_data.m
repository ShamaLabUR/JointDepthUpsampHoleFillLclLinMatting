 %________________________________________________________________________
 % This file is part of the source distribution provided with
 % the following publication:
 % Y. Zhang, L. Ding and G. Sharma, ''Local-linear-fitting-based matting approach for joint hole filling and depth upsampling of RGB-D images,'' Journal of Electronic Imaging, 2019
 % 
 % The code is copyrighted by the authors. Permission to copy and use
 % this software for noncommercial use is hereby granted provided this
 % notice is retained in all copies and the papers and the distribution
 % are clearly cited.
 % 
 % The software code is provided "as is" with ABSOLUTELY NO WARRANTY
 % expressed or implied. Use at your own risk.
 % ________________________________________________________________________


function [color,gt_depth,init_depth] = load_data(opt)
    
    data_path = '../data';
    if strcmpi(opt.dataset, 'tof')
        image_name = 'shark';
        
        data_name = ['benchmarking_dataset_',image_name];
        init_name = ['init_',image_name,'_',num2str(opt.init)];
        tof_data = load(fullfile(data_path,'ToF',data_name));
        init_data = load(fullfile(data_path,'ToF',init_name));
        
        color = tof_data.intensity_img;
        color = mat2gray(cat(3,color,color,color));
        
        gt_depth = tof_data.gt_depth;
        
        mask = (tof_data.tof_depth_mapped == 0);
        init_depth = init_data.esti_depth;
        init_depth(mask) = 0;
        
    elseif strcmpi(opt.dataset, 'middlebury')
        image_name = 'art';
        
        upsample = opt.upsample_rate;
        gt_depth = imread(fullfile(data_path,'Middlebury',[image_name,'_depth.png']));
        color = imread(fullfile(data_path,'Middlebury',[image_name,'_color.png']));
        gt_depth = double(gt_depth(1:1104,1:1376));
        color = im2double(color(1:1104,1:1376,:));
        
        [h,w] = size(gt_depth);
        init_depth = zeros(h,w);
        low_depth = imresize(gt_depth,1/upsample,'nearest');
        init_depth((1:h/upsample)*upsample-fix((upsample-1)/2),(1:w/upsample)*upsample-fix((upsample-1)/2)) = low_depth;
        
    elseif strcmpi(opt.dataset,'quick_demo')
        image_name = 'art_cropped';
        upsample = opt.upsample_rate;
        gt_depth = imread(fullfile(data_path,'Middlebury',[image_name,'_depth.png']));
        color = imread(fullfile(data_path,'Middlebury',[image_name,'_color.png']));
        color = im2double(color);
        gt_depth = double(gt_depth);
        
        [h,w] = size(gt_depth);
        init_depth = zeros(h,w);
        low_depth = imresize(gt_depth,1/upsample,'nearest');
        init_depth((1:h/upsample)*upsample-fix((upsample-1)/2),(1:w/upsample)*upsample-fix((upsample-1)/2)) = low_depth;
    else
        error('invalid dataset name')
    end
    
end
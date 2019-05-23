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


function [init_depth_norm,norm_fac] = normalize_depth(init_depth,opt)
    
    if strcmpi(opt.dataset,'tof')
        d_min = min(init_depth(init_depth>0));
        d_max = max(init_depth(init_depth>0));
        init_depth_norm = (init_depth - d_min)/(d_max-d_min);

        init_depth_norm(init_depth_norm<0) = 0;

        norm_fac = [d_max,d_min];
        
    elseif strcmpi(opt.dataset, 'middlebury') || strcmpi(opt.dataset,'quick_demo')
        init_depth_norm = init_depth/255.0;
        norm_fac = [255,0];
        
    else
        error('invalid dataset name')
    end

    
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


function esti_depth = denormalize_depth(esti_depth_norm,norm_fac)

    d_max = norm_fac(1);
    d_min = norm_fac(2);
    
    esti_depth = esti_depth_norm * (d_max-d_min) + d_min;
end
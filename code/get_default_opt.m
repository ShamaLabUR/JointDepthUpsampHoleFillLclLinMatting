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


function opt = get_default_opt(dataset)
% opt.dataset: 'ToF', 'Middlebury', or 'quick_demo'
% opt.lambda: controls the relation of fidelity and smoothness (eq. 1)
% opt.win_radius: neighbor radius win_radius = 4 --> 9x9 patch
% opt.upsample_rate: middlebury only. upsampling rate: 2,4,8,16. 
% opt.init: tof only. 1 or 2: different denoised low-resolution depth map as input
% opt.wMode: weighting function. 'rgb','lap','max', 'depth'. (sec 2.4) 
    opt.dataset = dataset;
    if strcmpi(dataset,'tof')
        opt.lambda = 1e5; 
        opt.win_radius = 4; 
        opt.init = 2;
        opt.wMode = 'rgb';        
    elseif strcmpi(dataset,'middlebury') || strcmpi(dataset,'quick_demo')
        opt.lambda = 1e5; 
        opt.win_radius = 3; 
        opt.upsample_rate = 4;
        opt.wMode = 'depth';      
    else
        error('invalid dataset, please set parameters manually')
    end

end


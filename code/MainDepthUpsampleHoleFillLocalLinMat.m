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


clear;close all;

%% set parameters
% 'quick_demo': runs on a cropped image (fast)
% 'ToF' or 'Middlebury': run for a full-size image
opt = get_default_opt('quick_demo');

% %Or manually set parameters
% opt.dataset = 'ToF'; % ToF or Middlebury
% opt.lambda = 1e5; % lambda that controls the relation of fidelity and smoothness (eq. 1)
% opt.win_radius = 4; % neighbor radius win_radius = 4 --> 9x9 patch
% opt.upsample_rate = 2; % middlebury only. upsampling rate: 2,4,8,16. 
% opt.init = 2; % tof only. 1 or 2: different denoised low-resolution depth map as input
% opt.wMode = 'rgb';

%% load and pre-processing data
[color,gt_depth,init_depth] = load_data(opt);
[init_depth_norm,norm_fac] = normalize_depth(init_depth,opt);

%% run 
esti_depth_norm = run_depth_upsample(init_depth_norm,color,opt);

%% evaluate and save
esti_depth = denormalize_depth(esti_depth_norm,norm_fac);

mae = eval_depth_results(esti_depth,gt_depth);
fprintf('dataset: %s, MAE: %.4f\n', opt.dataset,mae)

save_name = ['result_', opt.dataset];
save(fullfile('../results/',save_name),'esti_depth')
imwrite(esti_depth_norm,fullfile('../results/',[save_name,'.png']))
fprintf('Upsampled and hole-filled depth map has been saved in: ../results/%s.png\n', save_name)
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


function win_weight = comp_kernal_new(wMode,current_win,current_dm,win_radius)
sig_win_2 = 0.01;
[h,w,c] = size(current_win);
current_win_diff = bsxfun(@minus,current_win,current_win(win_radius+1,win_radius+1,:));
current_win_diff_norm = reshape(sum(reshape(current_win_diff,h*w,c).^2,2),h,w);

if strcmp(wMode,'rgb')
    sig_win = 0;
    for i = 1:3
        sig_win = sig_win+var(reshape(current_win(:,:,i),(win_radius*2+1)^2,1));
    end
    kernal_win = exp(-current_win_diff_norm/(2*max(sig_win,sig_win_2)*3/win_radius^2));
end

if strcmp(wMode,'lap')
    sig_win = 0;
    for i = 1:3
        sig_win = sig_win+var(reshape(current_win(:,:,i),(win_radius*2+1)^2,1));
    end
    kernal_win = exp(-current_win_diff_norm.^0.5/(2*max(sig_win,sig_win_2)*3/win_radius^2)^0.5);
end

if strcmp(wMode,'max')
    current_win_diff_norm = max(abs(current_win_diff),[],3);
    sig_win = 0;
    for i = 1:3
        sig_win = sig_win+var(reshape(current_win(:,:,i),(win_radius*2+1)^2,1));
    end
    kernal_win = exp(-current_win_diff_norm.^0.5/(2*max(sig_win,sig_win_2)*3/win_radius^2)^0.5);
end

if strcmp(wMode,'depth')
sig_win = 0;
    for i = 1:3
        sig_win = sig_win+var(reshape(current_win(:,:,i),(win_radius*2+1)^2,1));
    end
    kernal_win = exp(-current_win_diff_norm/(2*max(sig_win,sig_win_2)*3/win_radius^2));
    current_dm_diff = current_dm-current_dm(win_radius+1,win_radius+1);
    current_dm_diff_norm = reshape(sum(reshape(current_dm_diff,h*w,1).^2,2),h,w);
    sig_dm = var(reshape(current_dm(:,:),(win_radius*2+1)^2,1));
    kernal_win = kernal_win.*exp(-current_dm_diff_norm/(2*max(sig_dm,sig_win_2)*3/win_radius^2));
end
kernal_win(win_radius+1,win_radius+1) = 0.01;
win_weight = kernal_win.^2;
end
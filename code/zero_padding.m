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


function b = zero_padding(a,pos_new,size_new)

b = zeros(size_new);
size_old = size(a);
if length(size_old)==2
    b(pos_new(1):min(pos_new(1)+size_old(1)-1,size_new(1)),pos_new(2):min(pos_new(2)+size_old(2)-1,size_new(2))) = a(1:min(size_old(1),size_new(1)-pos_new(1)+1),1:min(size_old(2),size_new(2)-pos_new(2)+1));
elseif length(size_old)==3
    b(pos_new(1):min(pos_new(1)+size_old(1)-1,size_new(1)),pos_new(2):min(pos_new(2)+size_old(2)-1,size_new(2)),:) = a(1:min(size_old(1),size_new(1)-pos_new(1)+1),1:min(size_old(2),size_new(2)-pos_new(2)+1),:);
end

end
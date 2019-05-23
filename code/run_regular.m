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


function d_esti = run_regular(imDepth,I,lambda_rate,win_radius,wMode)

global  sum_c idx_row idx_col idx_val
    
        [h,w,c] = size(I);
        sum_c = 0;

        win_size = 2*win_radius+1;
        idx_size = win_size^2;idx_size2 = idx_size^2;
       
        L = spalloc((h+win_size-1)*(w+win_size-1),(h+win_size-1)*(w+win_size-1),idx_size*2*(h+win_size-1)*(w+win_size-1));
        L_size = (h+win_size-1)*(w+win_size-1);

        idx_row = zeros(idx_size*h*w,1);
        idx_col = zeros(idx_size*h*w,1);
        idx_val = zeros(idx_size*h*w,1);
        
        imDepth = zero_padding(imDepth,[win_radius+1,win_radius+1],[h+win_size-1,w+win_size-1]);
        dCol = im2col(imDepth,[win_size,win_size]);
        dCol(dCol==0) = nan;
        dMedian = reshape(median(dCol,'omitnan'),[h,w]);
        [medX,medY] = meshgrid(1:w,1:h);
        dMedian = griddata(medX(find(1-isnan(dMedian))),medY(find(1-isnan(dMedian))),dMedian(find(1-isnan(dMedian))),medX,medY,'nearest');
        dMT = zero_padding(dMedian,[win_radius+1,win_radius+1,c],[h+2*win_radius,w+2*win_radius]);
        dMedian0 = num2cell(im2col(dMT,[win_size,win_size]),1);
        
        I_padding = zero_padding(I,[win_radius+1,win_radius+1,c],[h+2*win_radius,w+2*win_radius,c]);

        I0 = zeros(win_size^2,3,numel(I(:,:,1)));
        I0(:,1,:) = im2col(I_padding(:,:,1),[win_size,win_size]);I0(:,2,:) = im2col(I_padding(:,:,2),[win_size,win_size]);I0(:,3,:) = im2col(I_padding(:,:,3),[win_size,win_size]);
        I0 = reshape(num2cell(I0,[1,2]),1,h*w);
        [pos_y,pos_x] = meshgrid(1:w,1:h);
        [d_y,d_x] = meshgrid(-win_radius:win_radius,-win_radius:win_radius);
        win_g = [reshape(d_x,1,numel(d_x));reshape(d_y,1,numel(d_y));ones(1,numel(d_y))];
        pos_x_ = num2cell(im2col(pos_x,[1,1]),1);
        pos_y_ = num2cell(im2col(pos_y,[1,1]),1);
        img_idx = reshape(1:(h+win_size-1)*(w+win_size-1),(h+win_size-1),(w+win_size-1));
        
        fprintf('calculating pixelwise weights:\n');
        tic
        for i = 1:length(I0)
            ii = I0{i};
            jj = dMedian0{i};
            x = pos_x_{i};
            y = pos_y_{i};
            block_kernal_new(ii,jj,x,y,win_size,win_g,img_idx,idx_size,idx_size2,d_x,d_y,win_radius,wMode);
        end        
        toc
        
        fprintf('generating Laplacian matrix:\n');
        tic
        n = numel(idx_row);
        for i = 0:fix(numel(idx_row)/(4*1e8))
            idx = i*4*1e8+1:min((i+1)*4*1e8,n);
            x = idx_row(idx);
            y = idx_col(idx);
            v = idx_val(idx);
            L = L+sparse(x,y,v,L_size,L_size);
        end
        toc
        
        tic
        fprintf('solving the linear equation:\n');
        affirm = imDepth==0;
        affirm = sparse(1:numel(affirm),1:numel(affirm),reshape(1-affirm,numel(affirm),1));
        tol = 1e-10;maxit = 5e3;
        d_interp = cgs(1/lambda_rate*L+affirm,affirm*reshape(imDepth,numel(imDepth),1),tol,maxit);
        d_interp = reshape(d_interp,h+win_size-1,w+win_size-1);
        toc
        
        d_esti = d_interp(win_radius+1:h+win_radius,win_radius+1:w+win_radius);

end
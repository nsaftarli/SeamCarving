function NewImg = MySeamCarving(img,h,w),

    img = double(img);
    img_size = size(img);
    img_height = img_size(1);
    img_width = img_size(2);


    kernel = imfilter(fspecial('gaussian'),fspecial('sobel'), 'conv');
    d_img = imfilter(img,kernel,'conv');

    E = sum(d_img,3);


    num_reduce_w = img_width - w;
    num_reduce_h = img_height - h;

    NewImg = img;

    %Decides whether to add or remove edges
    if num_reduce_w > 0,
    %Match width
        for i=1:num_reduce_w,
                img_size = size(NewImg);
                img_height = img_size(1);
                img_width = img_size(2);

                d_img = imfilter(NewImg,kernel,'conv');
                E = sum(d_img,3);

                seam = CarvingHelper(E);
                Result = zeros(img_height, img_width-1,3);

                for j=1:img_height,
                    row = NewImg(j,:,:);
                    ind = seam(j);
                    row_l = NewImg(j,1:ind-1,:);
                    row_r = NewImg(j,ind+1:end,:);
                    Result(j,:,:) = [row_l row_r];
                end
                NewImg = Result;
        end

    %Image expansion of width
    elseif num_reduce_w < 0,
        %Insertion of cols
        num_reduce_w = abs(num_reduce_w);
        seams = [];
        OrigImg = img;
        for i=1:num_reduce_w,
            img_size = size(NewImg);
            img_height = img_size(1);
            img_width = img_size(2);

            d_img = imfilter(NewImg,kernel,'conv');
            E = sum(d_img,3);

            %Get a bunch of optimal seams
            seam = CarvingHelper(E);
            seams = [seams seam];
            Result = zeros(img_height, img_width-1,3);

            for j=1:img_height,
                row = NewImg(j,:,:);
                ind = seam(j);
                row_l = NewImg(j,1:ind-1,:);
                row_r = NewImg(j,ind+1:end,:);
                Result(j,:,:) = [row_l row_r];
            end
            NewImg = Result;
        end

        NewImg = OrigImg;
        for i=1:num_reduce_w,
            img_size = size(NewImg);
            img_height = img_size(1);
            img_width = img_size(2);

            d_img = imfilter(NewImg,kernel,'conv');
            E = sum(d_img,3);

            seam = CarvingHelper(E);
            Result = zeros(img_height, img_width+1,3);

            for j=1:img_height,
                row = NewImg(j,:,:);
                ind = seam(j);
                if ind ~= 1 & ind ~= img_width,
                    l_p = NewImg(j,ind-1,:);
                    r_p = NewImg(j,ind+1,:);
                elseif ind == 1,
                    l_p = NewImg(j,ind,:);
                    r_p = NewImg(j,ind+1,:);
                elseif ind == img_width,
                    l_p = NewImg(j,ind-1,:);
                    r_p = NewImg(j,ind,:);
                end
                c_p = NewImg(j,ind,:);
                av_p = (l_p + r_p + c_p) / 3;
                row_l = NewImg(j,1:ind-1,:);
                row_r = NewImg(j,ind+1:end,:);

                Result(j,:,:) = [row_l av_p c_p row_r];
            end
            NewImg = Result;
        end
    end

    %Transpose image
    NewImg = permute(NewImg,[2 1 3]);

    %Match height
    if num_reduce_h > 0,
        for i=1:num_reduce_h,
            img_size = size(NewImg);
            img_height = img_size(1);
            img_width = img_size(2);

            d_img = imfilter(NewImg,kernel,'conv');
            E = sum(d_img,3);


            seam = CarvingHelper(E);
            Result = zeros(img_height, img_width-1,3);

            for j=1:img_height,
                row = NewImg(j,:,:);
                ind = seam(j);
                row_l = NewImg(j,1:ind-1,:);
                row_r = NewImg(j,ind+1:end,:);
                Result(j,:,:) = [row_l row_r];
            end
            NewImg = Result;
        end
        
    %Image expansion of height
    elseif num_reduce_h < 0,

        %Insertion of rows
        num_reduce_h = abs(num_reduce_h);
        seams = [];
        OrigImg = NewImg;
        for i=1:num_reduce_h,
            img_size = size(NewImg);
            img_height = img_size(1);
            img_width = img_size(2);

            d_img = imfilter(NewImg,kernel,'conv');
            E = sum(d_img,3);

            %Get a bunch of optimal seams
            seam = CarvingHelper(E);
            seams = [seams seam];
            Result = zeros(img_height, img_width-1,3);

            for j=1:img_height,
                row = NewImg(j,:,:);
                ind = seam(j);
                row_l = NewImg(j,1:ind-1,:);
                row_r = NewImg(j,ind+1:end,:);
                Result(j,:,:) = [row_l row_r];
            end
            NewImg = Result;
        end

        NewImg = OrigImg;
        for i=1:num_reduce_h,
            img_size = size(NewImg);
            img_height = img_size(1);
            img_width = img_size(2);

            d_img = imfilter(NewImg,kernel,'conv');
            E = sum(d_img,3);

            seam = CarvingHelper(E);
            Result = zeros(img_height, img_width+1,3);

            for j=1:img_height,
                row = NewImg(j,:,:);
                ind = seam(j);
                if ind ~= 1 & ind ~= img_width,
                    l_p = NewImg(j,ind-1,:);
                    r_p = NewImg(j,ind+1,:);
                elseif ind == 1,
                    l_p = NewImg(j,ind,:);
                    r_p = NewImg(j,ind+1,:);
                elseif ind == img_width,
                    l_p = NewImg(j,ind-1,:);
                    r_p = NewImg(j,ind,:);
                end
                c_p = NewImg(j,ind,:);
                av_p = (l_p + r_p + c_p) / 3;
                row_l = NewImg(j,1:ind-1,:);
                row_r = NewImg(j,ind+1:end,:);
                
                Result(j,:,:) = [row_l av_p c_p row_r];
            end
            NewImg = Result;
        end
    end
    
    NewImg = uint8(permute(NewImg, [2 1 3]));




function seam = CarvingHelper(E),
    img_size = size(E);
    img_height = img_size(1);
    img_width = img_size(2);

    scores = zeros(img_size);
    scores(1,:) = E(1,:);

    %Forward phase
    for i=2:img_height,
        for j=1:img_width,
            if j ~= 1 && j ~= img_width,
                scores(i,j) = E(i,j) + min([scores(i-1,j-1), scores(i-1,j), scores(i-1,j+1)]);
            
            elseif j == 1,
                scores(i,j) = E(i,j) + min([scores(i-1,j), scores(i-1,j+1)]);
               
            elseif j == img_width,
                scores(i,j) = E(i,j) + min([scores(i-1,j-1), scores(i-1,j)]);
            end
         end
     end


     ind = fliplr(1:img_height-1);

     %Take minimum in bottom row
     bottom_row = scores(img_height,:);
     min_val = min(bottom_row);

     seam = [];

     %Get minimum index in bottom row.
    for j=1:img_width,
        bottom_row(j);
        if bottom_row(j) == min_val,
            seam = [seam j];
            break;
        end
    end


    %Backtrack
    for i=ind,
        last_ind = seam(end);
        if last_ind ~= 1 & last_ind ~= img_width,
            l = last_ind - 1;
            r = last_ind + 1;
            curr_min = scores(i,last_ind);
            curr_min_ind = last_ind;
            for j=[l r],
                if scores(i,j) < curr_min,
                    curr_min = scores(i,j);
                    curr_min_ind = j;
                end
            end
            seam = [seam curr_min_ind];
        
        elseif last_ind == 1,
            r = last_ind + 1;
            curr_min = scores(i,last_ind);
            curr_min_ind = last_ind;
            if scores(i,r) < curr_min,
                curr_min = scores(i,r);
                curr_min_ind = r;
            end
            seam = [seam curr_min_ind];

        elseif last_ind == img_width,
            l = last_ind - 1;
            curr_min = scores(i,last_ind);
            curr_min_ind = last_ind;
            if scores(i,l) < curr_min,
                curr_min = scores(i,l);
                curr_min_ind = l;
            end
            seam = [seam curr_min_ind];
        end
    end

    seam = fliplr(seam);



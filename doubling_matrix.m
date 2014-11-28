function new_m = doubling_matrix(src)

no_dim = ndims(src);

if no_dim == 2
    [cur_max, cur_col] = size(src);
    new_m = zeros(2*cur_max,cur_col);
    new_m(1:cur_max,:) = src(:,:);
else
    [cur_max, cur_col, cur_depth] = size(src);
    new_m = zeros(2*cur_max,cur_col, cur_depth);
    new_m(1:cur_max,:,:) = src(:,:,:);
    
end
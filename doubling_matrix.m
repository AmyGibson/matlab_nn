function new_m = doubling_matrix(src)

[cur_max, cur_col] = size(src);
new_m = zeros(2*cur_max,cur_col);
new_m(1:cur_max,:) = src(:,:);
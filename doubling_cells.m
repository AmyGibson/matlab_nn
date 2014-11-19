function new_cells = doubling_cells(src)

[cur_max, cur_col] = size(src);
new_cells = cell(2*cur_max,cur_col);
new_cells(1:cur_max,:) = src(:,:);

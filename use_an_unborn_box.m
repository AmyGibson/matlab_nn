function [unborn_box, unborn_box_status, usable_box_ind] = use_an_unborn_box(event, unborn_box, unborn_box_status, max_box_limit)

usable_box_ind = find(unborn_box_status == 0,1);

if isempty(usable_box_ind)
    fprintf('unborn box full\n');
    return;
end


unborn_box_status(usable_box_ind) = 1;

no_dim = numel(event);

box_limit = zeros(no_dim, 2);

for d = 1:no_dim    
    if d ~= 2
        box_limit(d,1) = event(d) - floor(max_box_limit(d)/2);
        box_limit(d,2) = event(d) + ceil(max_box_limit(d)/2);
    else
        box_limit(d,1) = event(d);
        box_limit(d,2) = event(d) + max_box_limit(d);
    end
end

unborn_box{usable_box_ind,1} = box_limit;
unborn_box{usable_box_ind,2} = event;


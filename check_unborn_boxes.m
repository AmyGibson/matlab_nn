function [new_unbourn, unborn_boxes_memory] = check_unborn_boxes(unborn_boxes_para, ...
            unborn_boxes_memory, unborn_box_index, event)
        
% unborn_boxes_memory = cell(max_box,1); %memory
% unborn_boxes_para = zeros(max_box,6); % 6 limit

%%%% find those boxes that the event falls into
%%%% add the event to the memory of the box
new_unbourn = 1;
if unborn_box_index == 0
    return;
end

valid_box = event(1) >= unborn_boxes_para(1:unborn_box_index,1) & event(1) <= unborn_boxes_para(1:unborn_box_index,2) & ...
    event(2) >= unborn_boxes_para(1:unborn_box_index,3) & event(2) <= unborn_boxes_para(1:unborn_box_index,4);


valid_box_id = (1:unborn_box_index)';
valid_box_id = valid_box_id(valid_box);
if ~isempty(valid_box_id)
    new_unbourn = 0;

    for i = 1:length(valid_box_id)
        bid = valid_box_id(i);
        box_mem = unborn_boxes_memory{bid,1};
        box_mem = vertcat(box_mem, event);
        unborn_boxes_memory{bid,1} = box_mem;
    end
end

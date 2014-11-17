function [unborn_boxes_para, unborn_boxes_memory, unborn_box_index] = ...
    create_unborn(unborn_boxes_para, unborn_boxes_memory, unborn_box_index, event, unborn_default_details)


unborn_box_index = unborn_box_index + 1;
[max_box, ~] = size(unborn_boxes_para);

if unborn_box_index > max_box,
    fprintf('unbourn box full\n');
    return;
end

unborn_boxes_para(unborn_box_index,1) = max(1, event(1)-unborn_default_details(1));
unborn_boxes_para(unborn_box_index,2) = min(128, event(1)+unborn_default_details(1));
unborn_boxes_para(unborn_box_index,3) = max(1, event(2)-unborn_default_details(2));
unborn_boxes_para(unborn_box_index,4) = min(128, event(2)+unborn_default_details(2));
unborn_boxes_para(unborn_box_index,5) = event(end);
unborn_boxes_para(unborn_box_index,6) = event(end) + unborn_default_details(3);
unborn_boxes_para(unborn_box_index,7) = max(unborn_boxes_para(:,7)) + 1;   

unborn_boxes_memory{unborn_box_index,1} = event;
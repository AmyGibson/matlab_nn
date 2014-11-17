function [boxes_memory, boxes_para, new_box] = check_event_in_boxes(event, boxes_memory, boxes_para, box_index)
% boxes_memory = cell(max_box,1); %memory
% boxes_para = zeros(max_box,11); % mean and std, 7:threshold, 8:n,
% 9:status: 0 unused 1 in progress 10: current 11: count
%%%% find those boxes that the event falls into
%%%% add the event to the memory of the box

new_box = [];
if box_index == 0
    return;
end
no_std = 3;

valid_box = event(1) >= boxes_para(:,1)-no_std*boxes_para(:,4) & event(1) <= boxes_para(:,1)+no_std*boxes_para(:,4) & ...
    event(2) >= boxes_para(:,2)-no_std*boxes_para(:,5) & event(2) <= boxes_para(:,2)+no_std*boxes_para(:,5);
valid_box_id = (1:box_index)';
valid_box_id = valid_box_id(valid_box);

for i = 1:length(valid_box_id)
    bid = valid_box_id(i);
    
    if boxes_para(bid, 9) == 0
        new_box = vertcat(new_box, [bid event(end)+no_std*boxes_para(bid,6) 1]); % 1: conclude
        boxes_para(bid, 9) = 1;
    end
    
    box_mem = boxes_memory{bid,1};
    box_mem = vertcat(box_mem, event);
    boxes_memory{bid,1} = box_mem;
end























% 
% 
% new_box = [];
% usable_box = find(box_status >= 1);
% 
% 
% close_to_mean = zeros(size(box_status));
% 
% std_x = 8;
% std_y = 8;
% std_t = 100;
% 
% if ~isempty(usable_box)
%    
%     
%     for ub = 1:numel(usable_box)
%         b = usable_box(ub);
%        box_size = boxes{b,1}; % mean+std
%        box_mem = boxes{b,2};
%        if isempty(box_mem)
%            
%            
%            if abs(event(1) - box_size(1)) <= 3*box_size(4) && ...
%                 abs(event(2) - box_size(2)) <= 3*box_size(5)            
%                 boxes{b,2} = vertcat(boxes{b,2}, event);   
%                 new_box = vertcat(new_box, b);
%            end
%            
%            
%        else           
%            time_ref = box_mem(1,3);
%            if abs(event(1) - box_size(1)) <= 3*box_size(4) && ...
%                abs(event(2) - box_size(2)) <= 3*box_size(5) && ...
%                abs(event(3) - time_ref) <= 3*box_size(6)                 
%                 
%                 boxes{b,2} = vertcat(boxes{b,2}, event);  
%            end 
%        end
% 
%        if abs(event(1) - box_size(1)) <= box_size(4) || ...
%                abs(event(2) - box_size(2)) <= box_size(5) 
%            close_to_mean(b) = 1;   
%        end
% 
%     end
% end    
% 
%     if sum(close_to_mean) == 0
%         % need to create new box
%         new_box_i = find(box_status == 0,1);
%         if isempty(new_box_i)
%            %%% need to expand box 
%            fprintf('max boxes doubling the size\n');
%             [max_box,~] =size(boxes);
%             new_boxes = cell(2*max_box, 2);
%             new_boxes{1:max_box,:} = boxes{1:max_box,:};
%             new_box_i = max_box + 1;
%             new_box_status = zeros(2*max_box,1);
%             new_box_status(1:max_box,1) = box_status(1:max_box,1);
%             boxes = new_boxes;
%             box_status = new_box_status;
%         end
% %         fprintf('here\n');
%         boxes{new_box_i,1} = [event(1) event(2) event(3) std_x std_y std_t];
%         boxes{new_box_i,2} = event;
%         box_status(new_box_i) = 2;
%         new_box = vertcat(new_box, new_box_i);
%     end
% 
%     
% 

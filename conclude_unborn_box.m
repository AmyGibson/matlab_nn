function [unborn_boxes_memory, unborn_boxes_para, unborn_box_index, boxes_para, box_index] ...
    = conclude_unborn_box(unborn_boxes_memory, unborn_boxes_para, ...
    unborn_box_index, boxes_para, box_index, pe, no_nn)

% boxes_para = zeros(max_box,11); % mean and std, 7:threshold, 8:n,
% 9:status: 0 unused 1 in progress 10: current 11: count

ubi = find(unborn_boxes_para(:,7) == pe(3),1);

mem = unborn_boxes_memory{ubi,1};
no_std = 1;
[no_mem, ~] = size(mem);
% no_mem
if no_mem >= no_nn,
   
    std_d = std(mem);
    converted_mem = zeros(size(mem));
    converted_mem(:,1) = mem(:,1)/std_d(1);
    converted_mem(:,2) = mem(:,2)/std_d(2);
    converted_mem(:,3) = mem(:,3)/std_d(3);
    
    dist = zeros(no_mem,2);
    dist(:,2) = 1:no_mem;
%     core = converted_mem(:,1);
    core = mean(mem);
    dist(:,1) = sqrt((converted_mem(:,1)-core(1)).^2 + ...
        (converted_mem(:,2)-core(2)).^2 + (converted_mem(:,3)-core(3)).^2);
    
    dist = sortrows(dist,1);
%     keep = dist(1:no_nn,2);
    keep = dist(1:ceil(no_mem*0.8),2);
%     mu = mean(mem);
    
    
    
%      mu = mean(mem);
%     std_d = std(mem);
%     keep = abs(mem(:,1) - mu(1)) <= no_std * std_d(1) & abs(mem(:,2) - mu(2)) <= no_std * std_d(2) ...
%         & abs(mem(:,3) - mu(3)) <= no_std * std_d(3);
    
    mem = mem(keep,:);

    [no_mem, ~] = size(mem);
    mu = mean(mem);
    std_d = std(mem);
    
    if sum(abs(mu(1) - boxes_para(1:box_index,1)) < 1 & abs(mu(2) - boxes_para(1:box_index,2)) < 1) == 0
    
        [max_box,~] = size(boxes_para);
        box_index = box_index + 1;
        if box_index > max_box,
            fprintf('boxes para is full\n');
        else
            boxes_para(box_index,1:3) = mu;
            boxes_para(box_index,4:6) = std_d;
            boxes_para(box_index,7) = 0.8;
            boxes_para(box_index,8) = no_mem;        
            boxes_para(box_index,11) = 1;
        end    
    end

end
    

 unborn_boxes_para(ubi:unborn_box_index-1,:) = unborn_boxes_para(ubi+1:unborn_box_index,:);
 unborn_boxes_memory(ubi:unborn_box_index-1,:) = unborn_boxes_memory(ubi+1:unborn_box_index,:);
 
 unborn_boxes_memory{unborn_box_index,1} = [];
 unborn_boxes_para(unborn_box_index,:) = 0;
 
 unborn_box_index = unborn_box_index -1;
 
 

function [unborn_boxes_memory, unborn_boxes_para, unborn_box_index, ...
    boxes_para, box_index, box_history, box_history_index, box_evolve_history, bei] ...
    = conclude_unborn_box(unborn_boxes_memory, unborn_boxes_para, ...
    unborn_box_index, boxes_para, box_index, pe, no_nn, box_history, box_history_index,...
    box_evolve_history, bei)

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
%     core = mean(mem);
    core = mean(converted_mem);
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
        
    no_box_to_create = floor(no_mem/no_nn);
    
%     start_i = 1;
    new_mem = mem;
    for bc = 1:no_box_to_create,
        
        if bc == no_box_to_create
            temp_mem = new_mem;
        else
            [no_mem, ~] = size(new_mem);
            std_d = std(new_mem);
            converted_mem = zeros(size(new_mem));
            converted_mem(:,1) = new_mem(:,1)/std_d(1);
            converted_mem(:,2) = new_mem(:,2)/std_d(2);
            converted_mem(:,3) = new_mem(:,3)/std_d(3);

            core = converted_mem(1,:);
            dist = zeros(no_mem,2);
            dist(:,2) = 1:no_mem;
            dist(:,1) = sqrt((converted_mem(:,1)-core(1)).^2 + ...
                (converted_mem(:,2)-core(2)).^2 + (converted_mem(:,3)-core(3)).^2);

            dist = sortrows(dist,1);
            
            keep = dist(1:no_nn,2);
            temp_mem = new_mem(keep,:);
%             temp_mem = new_mem; % if only on dist for whole lot
            new_mem(keep,:) = [];            
        end
        

    
        mu = mean(temp_mem);
        std_d = std(temp_mem);

        if sum(abs(mu(1) - boxes_para(1:box_index,1)) < 0.5 & abs(mu(2) - boxes_para(1:box_index,2)) < 0.5) == 0
%         if 1

            [max_box,~] = size(boxes_para);
            box_index = box_index + 1;
            if box_index > max_box,
                fprintf('boxes para is full\n');
            else
                [no_mem, ~] = size(temp_mem);
                boxes_para(box_index,1:3) = mu;
                boxes_para(box_index,4:6) = std_d;
                boxes_para(box_index,7) = 0.85;
                boxes_para(box_index,8) = no_mem;        
                boxes_para(box_index,11) = 1;
                box_history_index = box_history_index + 1;
                box_history(box_history_index,:) = [box_index, pe(1)];
                
                
                bei = bei + 1;
                 [max_be, ~] = size(box_evolve_history);
                 if bei > max_be
                     box_evolve_history = doubling_matrix(box_evolve_history);
                 end

                 box_evolve_history(bei,1:2) = [box_index, pe(1)];
                 box_evolve_history(bei,3:5) = mu;
                 box_evolve_history(bei,6:8) = std_d;
                
                
            end    
        end
%         break; % if only on dist for whole lot
    end

end
    

 unborn_boxes_para(ubi:unborn_box_index-1,:) = unborn_boxes_para(ubi+1:unborn_box_index,:);
 unborn_boxes_memory(ubi:unborn_box_index-1,:) = unborn_boxes_memory(ubi+1:unborn_box_index,:);
 
 unborn_boxes_memory{unborn_box_index,1} = [];
 unborn_boxes_para(unborn_box_index,:) = 0;
 
 unborn_box_index = unborn_box_index -1;
 
 

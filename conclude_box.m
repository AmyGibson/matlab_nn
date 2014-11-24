function [boxes_memory, boxes_para, box_history, box_history_index, box_evolve_history, bei] = ...
    conclude_box(boxes_para, boxes_memory, pe, box_history, box_history_index, e, no_nn, box_evolve_history, bei)

% boxes_para = zeros(max_box,11); % mean and std, 7:threshold, 8:n,
% 9:status: 0 unused 1 in progress 10: current 11: count



box_id = pe(3);
box_mem = boxes_memory{box_id,1};
% just the density?

[no_mem, ~] = size(box_mem);

current = 0;

old_mu = (boxes_para(box_id,1:3))';
old_mu(3) = 0;
mtime = mean(box_mem(:,3));
box_mem(:,3) = box_mem(:,3) - mean(box_mem(:,3));
sig = zeros(3,3);
for i = 1:3
    sig(i,i) = boxes_para(box_id,3+1) ^2;
end

furthest_pt = old_mu + (3*boxes_para(box_id,4:6))';
max_dist = sqrt((furthest_pt-old_mu)' * sig * (furthest_pt-old_mu));
for m = 1:no_mem
   md = sqrt((box_mem(m,:)'-old_mu)' * sig * (box_mem(m,:)'-old_mu));
   % md 0 sould = 1, what is the max?
   md = min(md, max_dist);
   current = current + (1-(md/max_dist));
end

current = current / no_mem;

if current > boxes_para(box_id,7) && no_mem >= no_nn
    
    %%% it fires
    boxes_para(box_id,11) = boxes_para(box_id,11) + 1;
    box_history_index = box_history_index + 1;
    box_history(box_history_index,:) = [box_id, pe(1)];
    

    old_C = zeros(3,3);
    for i = 1:3
        old_C(i,i) = boxes_para(box_id, i+3) ^2;
    end

    
    %%% learnt
    
    n = boxes_para(box_id,8);
    m = no_mem;    
    mem_mu = mean(box_mem);
    
    box_mem(:,3) = box_mem(:,3) - mem_mu(3);
    mem_mu = mean(box_mem);
    mem_std = std(box_mem);
    
    mem_C = zeros(3,3);
    for i = 1:3
        mem_C(i,i) = mem_std(i) ^2;
    end

     
     bei = bei + 1;
     [max_be, ~] = size(box_evolve_history);
     if bei > max_be
         box_evolve_history = doubling_matrix(box_evolve_history);
     end
     
     
     
    
    new_mu = zeros(1,3);
    new_mu(1) = (n*old_mu(1) + m*(mem_mu(1))) / (m+n);
    new_mu(2) = (n*old_mu(2) + m*(mem_mu(2))) / (m+n);
    
    new_sig = zeros(1,3);
    
    for i = 1:3        
        part1 = n*(old_C(i,i) + old_mu(i)^2);
        part2 = m*(mem_C(i,i) + mem_mu(i)^2);        
        new_sig(i) = (part1 + part2)/(m+n) - new_mu(i)^2;
    end
     
    boxes_para(box_id,1:2) = new_mu(1:2);
    boxes_para(box_id,4:6) = sqrt(new_sig);
    boxes_para(box_id,8) = m+n;
    
    boxes_para(box_id,7) = boxes_para(box_id,7)*1.01;
    
    box_evolve_history(bei,1:2) = [box_id, pe(1)];
     box_evolve_history(bei,3:8) = boxes_para(box_id,1:6);
     box_evolve_history(bei,5) = mtime;
    
end

boxes_memory{box_id,1} = [];
boxes_para(box_id,9) = 0;
boxes_para(box_id,10) = 0;    
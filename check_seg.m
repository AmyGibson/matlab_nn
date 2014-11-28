function [seg_history, seg_history_index, segs_para, segs_memory, ...
    segs_th_count, fired_seg, seg_prediction_stat] = check_seg(seg_history, ...
    seg_history_index, segs_para, seg_index, segs_memory, segs_th_count, ...
    just_fired, cur_time, seg_prediction_stat)

fired_seg = [];

if seg_index == 0
    return;
end
no_fired = length(just_fired);
[~,seg_len, ~] = size(segs_para);

to_process = zeros(seg_index,1);
to_process = to_process == 1;

for nf = 1:no_fired
    for s = 1:seg_len,       
        to_process = to_process | segs_para(1:seg_index,s,1) == just_fired(nf);
    end
end

no_to_process = sum(to_process);
to_process_i = (1:seg_index)';
to_process_i = to_process_i(to_process);


for pi = 1:no_to_process
    si = to_process_i(pi);
    seg_mem = segs_memory{si};
    cur_seg_len = seg_len - sum(squeeze(segs_para(si,:,1)) == 0);
    for nf = 1:no_fired
        if sum(squeeze(segs_para(si,:,1)) == just_fired(nf)) > 0
            seg_mem = vertcat(seg_mem, [just_fired(nf) cur_time]);
        end
    end

    [mem_len, ~] = size(seg_mem);
    currents = zeros(seg_len,1);
    for m = 1:mem_len,        
        t = seg_mem(m,2) - cur_time;
                
        dist_pos = find(squeeze(segs_para(si,:,1)) == seg_mem(m,1));
        for dp = 1:length(dist_pos)
            
            tmean =segs_para(si,dist_pos(dp),2);
            ts =segs_para(si,dist_pos(dp),3);
            if abs(t) > tmean+3*ts
                continue;
            end
            
            furthest = sqrt((tmean+3*ts -tmean)^2/ts);
            md = sqrt((t -tmean)^2/ts);
            currents(dist_pos(dp)) = currents(dist_pos(dp)) + (1 - md/furthest) * segs_para(si,s,4);
        end
    end
    
    if sum(currents)/cur_seg_len >= segs_th_count(si,1)
        fired_seg = vertcat(fired_seg, si);
        
        segs_th_count(si,2) = segs_th_count(si,2) + 1;
        seg_mem(:,2) = cur_time - seg_mem(:,2);
        [means, stds, weights, th, counts] = update_seg(seg_mem, ...
            currents, squeeze(segs_para(si,:,:)), segs_th_count(si,1));
        segs_para(si,:,2) = means'; 
        segs_para(si,:,3) = stds'; 
        segs_para(si,:,4) = weights';
        segs_para(si,:,5) = counts';
        segs_th_count(si,1) = th;
        seg_mem = [];
        seg_history_index = seg_history_index + 1;
        seg_history(seg_history_index,1) = si;
        seg_history(seg_history_index,2) = cur_time;
    end
    segs_memory{si,1} = seg_mem;
end






% function [seg_history, seg_history_index, segs_para, seg_index, usable_seg, seg_prediction_stat] = ...
%                 check_seg(seg_history, seg_history_index, segs_para, seg_index,...
%                 box_history, cur_time, seg_prediction_stat, seg_len)
%             
% %%%% need to check if any fire, should we only check curt time if an input fires? 
% 
% %   fprintf('just fire\n');          
% cur_seg = box_history(:,1)';
% cur_seg_time = box_history(:,2)';
% cur_seg_time = cur_seg_time - cur_seg_time(end);
% 
% cur_seg_len = length(cur_seg);
% 
% 
% % seg_len = length(cur_seg);
% 
% 
% 
% seg_sum = zeros(seg_index, seg_len);
% max_time_diff = 500;
% 
% if seg_history_index  < seg_len
%     recent_history = seg_history(1: seg_history_index,1);
% else
%     recent_history = seg_history(seg_history_index-seg_len + 1: seg_history_index,1);
% end
% 
% for s = 1:seg_index
%     if sum(recent_history == s) > 0
%         continue;
%     end
% 
%     seg_times = segs_para(s,seg_len+1:seg_len*2);
%     seg_times = seg_times - seg_times(end);    
%     seg_status = zeros(seg_len, 1);
%     for ss = 1:cur_seg_len
%         pos = find(segs_para(s,1:seg_len) == cur_seg(ss));        
%         if isempty(pos)
%             continue;
%         end
%         
%         actual_pos = find(seg_status(pos) == 0,1);
%         if isempty(actual_pos)
%             continue;
%         end
%             
%         seg_status(actual_pos) = 1;    
%         
%         time_diff = abs(cur_seg_time(ss) - seg_times(actual_pos));
%         seg_sum(s,ss) = 1-time_diff/max_time_diff;
%     end
% 
% 
%     
% end
% 
% 
% 
% 
% 
% % for ss = 1:seg_len
% %    valid_pos = segs_para(1:seg_index,ss) == cur_seg(ss); 
% %    seg_sum(valid_pos,ss) = abs(cur_seg_time(ss) - segs_para(valid_pos,seg_len+ss)); 
% %    seg_sum(valid_pos,ss) = 1-seg_sum(valid_pos,ss)/max_time_diff;
% % end
% 
% 
% 
% % for s = 1:seg_index
% %     seg_times = segs_para(s,seg_len+1:seg_len*2);
% %     seg_times = seg_times - seg_times(1);    
% %     seg_status = zeros(seg_len, 1);
% %     for ss = 1:seg_len
% %         pos = find(segs_para(s,1:seg_len) == cur_seg(ss));
% %         if ~isempty(pos)
% %             actual_pos = 0;
% %            for i = 1:length(pos)
% %                if seg_status(pos(i)) == 0
% %                    seg_status(pos(i)) = 1;
% %                    actual_pos = pos(i);
% %                    break;
% %                end
% %            end
% %            if actual_pos ~= 0
% %                 time_diff = abs(cur_seg_time(ss) - seg_times(actual_pos));
% %                 seg_sum(s,ss) = 1-time_diff/max_time_diff;
% %            end
% %            
% %         end
% %     end
% % end
% 
% 
% % for s = 1:seg_len
% %     for ss = 1:seg_len
% %         seg_sum(segs_para(1:seg_len,s) == seg(ss),s) = 1; 
% %     end
% % end
% 
% % size(seg_sum)
% seg_sum = sum(seg_sum,2);
% 
% 
% % size(seg_sum)
% usable_seg = (1:seg_index)';
% % seg_index
% % seg_sum
% usable_seg = usable_seg(seg_sum > 0.5 * seg_len);
% 
% if isempty(usable_seg)
%     seg_index = seg_index + 1;
%     [max_seg,~] = size(segs_para);
%     if seg_index > max_seg             
%         segs_para = doubling_matrix(segs_para);
%         seg_prediction_stat = doubling_cells(seg_prediction_stat);
%     end
%         
%     
%     
%     
%    segs_para(seg_index,1:seg_len) = cur_seg(cur_seg_len -seg_len + 1:end);
%    for i = 2:seg_len       
%        segs_para(seg_index,seg_len + i) = box_history(i,2) - box_history(i-1,2);
%    end
% else
%     segs_para(usable_seg,end) =  segs_para(usable_seg,end) + 1;
%     
%     seg_history(seg_history_index+1:seg_history_index+length(usable_seg), 1) = usable_seg(:);
%     seg_history(seg_history_index+1:seg_history_index+length(usable_seg), 2) = cur_time;    
%     seg_history_index = seg_history_index + length(usable_seg);
%     
% 
% end
% 

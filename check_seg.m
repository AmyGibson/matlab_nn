function [seg_history, seg_history_index, segs_para, seg_index, usable_seg, seg_prediction_stat] = ...
                check_seg(seg_history, seg_history_index, segs_para, seg_index,...
                box_history, cur_time, seg_prediction_stat)
            
%%%% need to check if any fire, should we only check curt time if an input fires? 

%   fprintf('just fire\n');          
cur_seg = box_history(:,1)';
cur_seg_time = box_history(:,2)';
cur_seg_time = cur_seg_time - cur_seg_time(1);




seg_len = length(cur_seg);

% uni = 1;

seg_sum = zeros(seg_index, seg_len);
max_time_diff = 1000;

for s = 1:seg_index
    seg_times = segs_para(s,seg_len+1:seg_len*2);
    seg_times = seg_times - seg_times(1);    
    seg_status = zeros(seg_len, 1);
    for ss = 1:seg_len
        pos = find(segs_para(s,1:seg_len) == cur_seg(ss));
        if ~isempty(pos)
            actual_pos = 0;
           for i = 1:length(pos)
               if seg_status(pos(i)) == 0
                   seg_status(pos(i)) = 1;
                   actual_pos = pos(i);
                   break;
               end
           end
           if actual_pos ~= 0
                time_diff = abs(cur_seg_time(ss) - seg_times(actual_pos));
                seg_sum(s,ss) = 1-time_diff/max_time_diff;
           end
           
        end
    end
end


% for s = 1:seg_len
%     for ss = 1:seg_len
%         seg_sum(segs_para(1:seg_len,s) == seg(ss),s) = 1; 
%     end
% end

% size(seg_sum)
seg_sum = sum(seg_sum,2);


% size(seg_sum)
usable_seg = (1:seg_index)';
% seg_index
% seg_sum
usable_seg = usable_seg(seg_sum > 0.7 * seg_len);

if isempty(usable_seg)
    seg_index = seg_index + 1;
    [max_seg,~] = size(segs_para);
    if seg_index > max_seg             
        segs_para = doubling_matrix(segs_para);
        seg_prediction_stat = doubling_cells(seg_prediction_stat);
    end
        
    
    
    
   segs_para(seg_index,1:seg_len) = cur_seg;
   for i = 2:seg_len       
       segs_para(seg_index,seg_len + i) = box_history(i,2) - box_history(i-1,2);
   end
else
    segs_para(usable_seg,end) =  segs_para(usable_seg,end) + 1;
    
    seg_history(seg_history_index+1:seg_history_index+length(usable_seg), 1) = usable_seg(:);
    seg_history(seg_history_index+1:seg_history_index+length(usable_seg), 2) = cur_time;    
    seg_history_index = seg_history_index + length(usable_seg);
    

end


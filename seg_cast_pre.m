function [seg_prediction, seg_prediction_e, seg_pre_index] = seg_cast_pre( ...
    seg_prediction_stat, fired_seg, seg_prediction, cur_time, e, ...
    seg_prediction_e, seg_pre_index, segs_th_count)

no_fired = length(fired_seg);

cur_pre_id = [];
cur_pre_time = [];
cur_pre_prob = [];

has_prediction = 0;
for fs = 1:no_fired
    if segs_th_count(fired_seg(fs,1), 2) == 0 || isempty(seg_prediction_stat{fired_seg(fs,1),1})
        continue;
    end
   
    cur_stat = seg_prediction_stat{fired_seg(fs,1),1};
    
    
    if ~isempty(cur_stat)
%         fprintf('fired %d \n', fired_seg(fs,1));
        cur_pre_id = vertcat(cur_pre_id, cur_stat(:,1));
        cur_pre_time = vertcat(cur_pre_time, cur_stat(:,2) + cur_time);
        cur_pre_prob = vertcat(cur_pre_prob, cur_stat(:,3)/segs_th_count(fired_seg(fs,1), 2));
        has_prediction = 1;
        
    end
    
end

%%%% should i find repeated prediction here? no that's output neuron
if has_prediction == 1
    seg_pre_index = seg_pre_index + 1;
    seg_prediction{seg_pre_index,1} = horzcat(cur_pre_id, cur_pre_time, cur_pre_prob);
    seg_prediction_e(seg_pre_index,1) = e;
    seg_prediction_e(seg_pre_index,2) = cur_time;
end

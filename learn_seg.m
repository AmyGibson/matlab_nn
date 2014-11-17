function [seg_prediction_stat] = learn_seg(seg_history, seg_history_index, fired_seg, ...
   seg_prediction_stat, cur_time, min_future_prediction)

if seg_history_index <= min_future_prediction
    return;
end

no_fired = length(fired_seg);


for fs = 1:no_fired
    fs_id = fired_seg(fs,1);
    tar_id = seg_history(seg_history_index - min_future_prediction, 1); 
    % thinnk about multiple spiking neuron at that stage or a rand time
    time_dif = cur_time - seg_history(seg_history_index - min_future_prediction, 2);
    
    tar_prediction_stat = seg_prediction_stat{tar_id,1};
    
    % see if this tar already has 
    % to do: there may be multiple entries for the same prediction if they
    % are very apart in time
    
    if isempty(tar_prediction_stat)
        tar_prediction_stat = vertcat(tar_prediction_stat, [fs_id, time_dif, 1]);
    else
        fs_pos = find(tar_prediction_stat(:,1),1);

        if isempty(fs_pos)
            tar_prediction_stat = vertcat(tar_prediction_stat, [fs_id, time_dif, 1]);
        else
            cur_count = tar_prediction_stat(fs_pos, 3);
            tar_prediction_stat(fs_pos, 2) = (cur_count * tar_prediction_stat(fs_pos, 2) ...
                + time_dif) / (cur_count + 1);

            tar_prediction_stat(fs_pos, 3) = cur_count + 1;
        end
    end
    seg_prediction_stat{tar_id,1} = tar_prediction_stat;
    
    
end
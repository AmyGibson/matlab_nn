function [cur_output] = generate_prediction_output(cur_pre, segs_para)

cur_output_max = 1000;
cur_output = zeros(cur_output_max,3); % box id, time, prob
cur_output_index = 0;
overlap_time_buffer = 10;


[no_pre,~] = size(cur_pre);
[~,seg_len,~] = size(segs_para);
seg_len = ceil((seg_len-1)/2);
% fprintf('no_pre %d\n', no_pre);
for cp = 1:no_pre,
   cur_seg_id = cur_pre(cp,1); 
   
   cur_seg_len = seg_len - sum(squeeze(segs_para(cur_seg_id,:,1)) == 0);
   pre_box_id = segs_para(cur_seg_id,1:cur_seg_len,1);
   pre_box_time = segs_para(cur_seg_id,1:cur_seg_len,2); 
   pre_box_time = pre_box_time - max(pre_box_time) + cur_pre(cp,2); % because it is predicing the end
   
   for i = 1:length(pre_box_id)
       exist = 0;
       if cur_output_index > 0
           same_ids = find(cur_output(1:cur_output_index,1) == pre_box_id(i));
           
           for j = 1:length(same_ids)
               if abs(cur_output(same_ids(j),2) - pre_box_time(i)) < overlap_time_buffer,
                   %%% too close count as one prediction
                   exist = 1;
                   cur_output(same_ids(j),2) = (cur_output(same_ids(j),2) + pre_box_time(i))/2;
                   cur_output(same_ids(j),3) = max(cur_output(same_ids(j),3), cur_pre(cp,3));
                   break;
               end
           end
       end          
       if exist == 0
           cur_output_index = cur_output_index + 1;
           if cur_output_index > cur_output_max
               new_cur_output = zeros(2*cur_output_max,3);
               new_cur_output(1:cur_output_max,:) = cur_output_max(:,:);
               cur_output_max = new_cur_output;
               cur_output_max = 2*cur_output_max;                   
           end
           cur_output(cur_output_index,:) = [pre_box_id(i) pre_box_time(i) cur_pre(cp,3)];
       end
   end
               
end
cur_output = cur_output(1:cur_output_index,:);
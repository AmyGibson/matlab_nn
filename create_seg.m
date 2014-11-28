function [segs_para, segs_th_count, seg_prediction_stat, seg_index] = create_seg(...
    box_history, cur_time, seg_prediction_stat, segs_para, segs_th_count, seg_index)


seg_index = seg_index + 1;

[max_seg,~] = size(segs_para);
if seg_index > max_seg             
	segs_para = doubling_matrix(segs_para);
    segs_th_count = doubling_matrix(segs_th_count);
    seg_prediction_stat = doubling_cells(seg_prediction_stat);
end

segs_para(seg_index,:,1) = box_history(:,1)';
segs_para(seg_index,:,2) = cur_time - box_history(:,2)';
segs_para(seg_index,:,3) = 30;
segs_para(seg_index,:,4) = 1;
segs_th_count(seg_index,1) = 0.5;


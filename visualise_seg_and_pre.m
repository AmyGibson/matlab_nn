close all;
no_to_show = 9;
to_visualise = randi(seg_index, no_to_show);

figure
no_plot_per_row = ceil(sqrt(no_to_show));
no_plot_per_col = ceil(no_to_show/no_plot_per_row);
for i = 1:no_to_show
    subplot(no_plot_per_row, no_plot_per_col, i);
   cur_seg = segs_para(to_visualise(i),1:seg_len);
   cur_time_dif = segs_para(to_visualise(i),seg_len+1:seg_len*2);
   for j = 1:seg_len
       cur_did = cur_seg(j);
       cur_m = boxes_para(cur_did,1:3);
       cur_C = zeros(3,3);
       for k = 1:3
           cur_C(k,k) = boxes_para(cur_did,k+3) ^2;
       end
       cur_m(3) = cur_time_dif(j);
       hold on
        plot_gaussian_ellipsoid_contouronly(cur_m, cur_C, 1, 4, [0 0 1])
        
        
   end
   
   cur_pred_seg = seg_prediction_stat{to_visualise(i)};
   [no_pre,~] = size(cur_pred_seg);
   
   for p = 1:no_pre       
       cur_pre_seg_id = cur_pred_seg(p,1);
       cur_pre_seg = segs_para(cur_pre_seg_id,1:seg_len);
       cur_pre_seg_time_dif = segs_para(to_visualise(i),seg_len+1:seg_len*2);
       
       for j = 1:seg_len
           cur_did = cur_pre_seg(j);
           cur_m = boxes_para(cur_did,1:3);
           cur_C = zeros(3,3);
           for k = 1:3
               cur_C(k,k) = boxes_para(cur_did,k+3) ^2;
           end
           cur_m(3) = cur_time_dif(end) + cur_pred_seg(p,2) + cur_pre_seg_time_dif(j);
           c = 1 - cur_pred_seg(p,3)/sum(cur_pred_seg(:,3));
           hold on
            plot_gaussian_ellipsoid_contouronly(cur_m, cur_C, 1, 4, [c c c])
       end
       view(3)
       grid on;
       xlim([0 128])
       ylim([0 128])
        
        
   end
   title(sprintf('seg %d', to_visualise(i)));
    
end
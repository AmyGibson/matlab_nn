cur_seg = find(segs_para(:,end) == max(segs_para(:,end)));

cur_seg_i = cur_seg(1);

valid_hist = seg_history(:,1) == cur_seg_i;
temp_seg_history = seg_history(valid_hist,:);

dist_ids = segs_para(cur_seg_i,1:seg_len);
dist_times = segs_para(cur_seg_i,seg_len+1:seg_len*2);

dist_m = zeros(seg_len,3);
dist_C = zeros(3,3,seg_len);
for i = 1:seg_len,
    dist_m(i,:) = boxes_para(dist_ids(i),1:3);
    for j = 1:3
        dist_C(j,j,i) = boxes_para(dist_ids(i),j+3) ^2;
    end
end
    figure

for i = 1:sum(valid_hist)
    
    for j = 1:seg_len
        cur_m = dist_m(j,:);
        cur_m(3) = temp_seg_history(i,2) - (dist_times(end) - dist_times(j));
        cur_C = squeeze(dist_C(:,:,j));
        hold on
        plot_gaussian_ellipsoid_contouronly(cur_m, cur_C, 1, 4, [1 0 0])
    end
%     break
    
end

% figure
plot3(temp(:,1),temp(:,2), temp(:,3),'b.', 'MarkerSize', 1);
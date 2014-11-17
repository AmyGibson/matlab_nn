function [seg_history, seg_history_index, segs_para, seg_index, usable_seg] = ...
                check_seg(seg_history, seg_history_index, segs_para, seg_index,...
                box_history, cur_time)
            
%%%% need to check if any fire, should we only check curt time if an input fires? 

%   fprintf('just fire\n');          
seg = box_history(:,1)';

seg_len = length(seg);

% uni = 1;

seg_sum = zeros(seg_index, seg_len);
for s = 1:seg_len
    for ss = 1:seg_len
        seg_sum(segs_para(:,s) == seg(ss),s) = 1; 
    end
end

seg_sum = sum(seg_sum,2);


usable_seg = (1:seg_index)';
usable_seg = usable_seg(seg_sum > 0.7 * seg_len);

if isempty(usable_seg)
    seg_index = seg_index + 1;
   segs_para(seg_index,1:seg_len) = seg;
   for i = 2:seg_len       
       segs_para(seg_index,seg_len + i) = box_history(i,2) - box_history(i-1,2);
   end
else
    segs_para(usable_seg,end) =  segs_para(usable_seg,end) + 1;
    
    seg_history(seg_history_index+1:seg_history_index+length(usable_seg), 1) = usable_seg(:);
    seg_history(seg_history_index+1:seg_history_index+length(usable_seg), 2) = cur_time;    
    seg_history_index = seg_history_index + length(usable_seg);
    
%     for us = 1:length(usable_seg)
%         si = usable_seg(us);
%         segs_para(si,end) =  segs_para(si,end) + 1;
%         seg_history_index = seg_history_index + 1;
%         seg_history(seg_history_index, 1) = si;
%         seg_history(seg_history_index, 2) = cur_time;
%         
%     end
end

% return
% 
% for si = 1:seg_index,
% %        same_seg = 1;
%    same_amount = 0;
%    seg_para = segs_para(si, 1:seg_len);
%    for s = 1:seg_len,
% %             if seg(k) ~= seg_count(j,k) 
%         if sum(seg_para(:) == seg(s)) > 0 
% %                 same_seg = 0;
%             same_amount = same_amount + 1;
% %                 break;
%         end
%    end
% %        if same_seg == 1
%    if same_amount > 0.7 * seg_len
%        segs_para(si,end) =  segs_para(si,end) + 1;
%        seg_history_index = seg_history_index + 1;
%        seg_history(seg_history_index, 1) = si;
%        seg_history(seg_history_index, 2) = cur_time;
%        uni = 0;
%        break;
%    end
% end
% 
% if uni == 1
%     
%    seg_index = seg_index + 1;
%    segs_para(seg_index,1:seg_len) = seg;
%    for i = 2:seg_len       
%        segs_para(seg_index,seg_len + i) = box_history(i,2) - box_history(i-1,2);
%    end
% end

seg_len = 5;
seg_count = zeros(box_history_index, seg_len+1);
sc_i = 0;

for i = 1:box_history_index - seg_len
    
   seg =  box_history(i:i+seg_len -1,1);
   uni = 1;
   for j = 1:sc_i,
       same_seg = 1;
       same_amount = 0;
       for k = 1:seg_len,
%             if seg(k) ~= seg_count(j,k) 
            if sum(seg_count(j, 1:seg_len) == seg(k)) > 0 
%                 same_seg = 0;
                same_amount = same_amount + 1;
%                 break;
            end
       end
%        if same_seg == 1
        if same_amount > 0.7 * seg_len
           seg_count(j,seg_len + 1) =  seg_count(j,seg_len + 1) + 1;
           uni = 0;
           break;
       end
   end
    
   if uni == 1
       sc_i = sc_i + 1;
       seg_count(sc_i,1:seg_len) = seg';
   end
    
    
end
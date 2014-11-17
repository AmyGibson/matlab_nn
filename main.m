close all
% [inputs] = get_input('filename'); % [x y pol time]


% no_letter = length(text);
% short_text = text(1:ceil(no_letter/2));
% letters_input = load_letters(short_text,letter, letter_id);
% inputs = generate_events_from_letter(letters_input);

% endt = find(inputs(:,3) > 1, 1)-1;
% first_letter = inputs(1:endt, :);
% frame = zeros(16,8);
% for i = 1:endt,
%     frame(first_letter(i,2), first_letter(i,1)) = 1;    
% end
% figure
% imagesc(frame);
% figure
% imagesc((reshape(mean(letter(letter_id == 97,:)), 8,16))');
% return

% imagesc(letters_input(:,1:8*10));


% addpath ./load_data
% 
% data_name = 'Sidetoside';
% data_name = 'ball';
% [inputs, ~, ~] = load_data(data_name, 0);
% inputs = inputs(:,[1 2 4]);
% warning off
clearvars -except 'inputs'

temp = inputs(1:50000,:);
temp = inputs;
[no_inputs,~] = size(temp);


init_max_pseudo_events = 1000;
pseudo_events = zeros(init_max_pseudo_events, 3); % [time, status, neuron_no]
% status 1: box conclude 2 unborn conclude
pseudo_events_index = 0;

max_box = 1000;
boxes_memory = cell(max_box,1); %memory
boxes_para = zeros(max_box,11); % mean and std, 7:threshold, 8:n, 9:status: 0 unused 1 in progress 10: current 11:count
box_index = 0;

unborn_boxes_memory = cell(max_box,1); %memory
unborn_boxes_para = zeros(max_box,7); % 6 dim limit 7 id
unborn_box_index = 0;
unborn_default_details = [16 16 250 100]; %x y time no

temp_history = zeros(max_box,7);
temp_memory = cell(max_box,1);
temp_history_i = 0;

box_history = zeros(5000,2);
box_history_index = 0;

seg_len = 5;
max_seg = 10000;
segs_para = zeros(max_seg, seg_len*2 + 1);
seg_index = 0;
seg_history = zeros(5000,2);
seg_history_index = 0;


seg_prediction = cell(no_inputs,1); 
seg_prediction_e = zeros(no_inputs,2);
seg_pre_index = 0;
prediction_output = cell(no_inputs,1); 
prediction_output_e = zeros(no_inputs,2);
pre_output_index = 0;

min_future_prediction = 10;
seg_prediction_stat = cell(max_seg,1); 


% start_prediction = no_inputs - 10;
start_prediction = min_future_prediction;
% specific_box_history = cell(500, 3);
% sbi = 0;

for e = 1:no_inputs,
    event = temp(e,:);
    
    if pseudo_events_index > 0 && event(end) > pseudo_events(pseudo_events_index,1)
       % execute pseudo events 
       
       
        pe = pseudo_events(pseudo_events_index,:);
        
%         fprintf('remove pseudo event %d boxid %d\n', pseudo_events_index, pe(3));
        pseudo_events(pseudo_events_index,:) = 0;
        if sum(pseudo_events(:,1)) == 0
            pseudo_events_index = 0;
        else
            pseudo_events_index = pseudo_events_index + 1;
        end
        if pe(2) == 1
            % concluding a box
            last_bi = box_history_index;
           [boxes_memory, boxes_para, box_history, box_history_index] = ...
               conclude_box(boxes_para, boxes_memory, pe, box_history, box_history_index, e, unborn_default_details(4));   
           
%            if box_history_index > last_bi
%                fprintf('just fired bhi %d\n', box_history_index);
%            end
           if box_history_index >= seg_len + 1 && box_history_index > last_bi
                [seg_history, seg_history_index, segs_para, seg_index, fired_seg] = ...
                    check_seg(seg_history, seg_history_index, segs_para, seg_index,...
                    box_history(box_history_index-seg_len +1:box_history_index,:), event(3));
               
                if ~isempty(fired_seg)                    
                    [seg_prediction_stat] = learn_seg(seg_history, ...
                        seg_history_index, fired_seg, seg_prediction_stat, ...
                        event(3), min_future_prediction);    
                        
                    if e > start_prediction
                        [seg_prediction, seg_prediction_e, seg_pre_index] = seg_cast_pre(seg_prediction_stat, ...
                            fired_seg, seg_prediction, segs_para, event(3),  e,  seg_prediction_e, seg_pre_index);

                        if seg_pre_index > 0
                            [cur_output] = generate_prediction_output(seg_prediction{seg_pre_index,1}, ...
                                segs_para);
                            if ~isempty(cur_output)
                                pre_output_index = pre_output_index + 1;
                                prediction_output_e(pre_output_index,1) = e;
                                prediction_output_e(pre_output_index,2) = event(3);                            
                                prediction_output{pre_output_index,1} = cur_output;
                            end
                        end
                    end
                    
                    
                    
                end
           
           
           end
           
           
            
           
%            if box_history_index > last_bi
%                 if box_history(box_history_index,1) == 1
%                     sbi = sbi + 1;
%                     specific_box_history(sbi,:) = boxes_para(1,:);
%                 end
%            end
           
%            if e > 50000 && box_history_index > last_bi
%                return;
%            end
        elseif pe(2) == 2
%             return
            % concluding an unborn box
%             last_bi = box_index;
%             
%             temp_history_i = temp_history_i + 1;
%             ubi = find(unborn_boxes_para(:,7) == pe(3),1);
%             mem = unborn_boxes_memory{ubi,1};
%             temp_memory{temp_history_i,1} = mem;
%             temp_history(temp_history_i,1:3) = mean(mem);            
%             temp_history(temp_history_i,4:6) = std(mem);
%             temp_history(temp_history_i,7) = pe(1);
            
            [unborn_boxes_memory, unborn_boxes_para, unborn_box_index, boxes_para, box_index] ...
                = conclude_unborn_box(unborn_boxes_memory, unborn_boxes_para, ...
                unborn_box_index, boxes_para, box_index, pe, unborn_default_details(4));
            
%             if box_index == last_bi
%                 temp_memory{temp_history_i,1} = [];
%                 temp_history(temp_history_i,:) = 0; 
%                 temp_history_i = temp_history_i -1;
%             end
        end

        e = e-1;
   
    else % just a normal input
        
        % 1. check if event is in any box, if so add to the memory
        % also check if it is close to any mean of the box, if not create
        % its own box        
        
        [boxes_memory, boxes_para, new_box] = check_event_in_boxes(event, boxes_memory, boxes_para, box_index);
        
        
        % 2. if a box has just been triggered add pseudo event
        [no_box_trigger,~] = size(new_box);
        
        if ~isempty(new_box)
            [pseudo_events, pseudo_events_index] = add_pseudo_event(pseudo_events, ...
                 pseudo_events_index, new_box);
        end
       

        % 3. check if it is within any unborn box
        [new_unborn, unborn_boxes_memory] = check_unborn_boxes(unborn_boxes_para, ...
            unborn_boxes_memory, unborn_box_index, event);
      
        if new_unborn == 1
            % create new unborn and add psuedo event accordingly
            [unborn_boxes_para, unborn_boxes_memory, unborn_box_index] = create_unborn(unborn_boxes_para, ...
                unborn_boxes_memory, unborn_box_index, event, unborn_default_details);
            
            [pseudo_events, pseudo_events_index] = add_pseudo_event(pseudo_events, ...
                 pseudo_events_index, [unborn_boxes_para(unborn_box_index,7), unborn_boxes_para(unborn_box_index,6) 2]);
%             
%         else
           
            
        end
        
        
        
        
    end
    
    
    
end
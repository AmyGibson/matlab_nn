function [pseudo_events, pseudo_events_index] = add_pseudo_event(pseudo_events, pseudo_events_index, new_box)
% new_box: 1 = id, 2 = time, 3=status


[no_pseudo_event,~] = size(new_box);
[max_pseudo_event, ~] = size(pseudo_events);

if pseudo_events_index == 0
    next_empty_pe = find(pseudo_events(:,1) == 0,1);
    pseudo_events_index = 1;
else
%     [pseudo_events] = shift_pseudo_event(pseudo_events);
%     pseudo_events_index = 1; % where the first pseudo event is
%     next_empty_pe = find(pseudo_events(:,1) == 0,1);
    next_empty_pe = find(pseudo_events(pseudo_events_index:end,1) == 0,1) + pseudo_events_index -1;
end

if isempty(next_empty_pe) || no_pseudo_event> (max_pseudo_event - next_empty_pe),
    [pseudo_events] = shift_pseudo_event(pseudo_events, no_pseudo_event);
    pseudo_events_index = 1; % where the first pseudo event is
    next_empty_pe = find(pseudo_events(:,1) == 0,1);
end

  
%%% find out where to add to the pseudo event put in the input 
for pe = 1:no_pseudo_event,
               
    if next_empty_pe == 1
        insert_pt = 1;
    else
%         fprintf('pseudo_events_index %d next_empty_pe %d time %.2f\n', pseudo_events_index, next_empty_pe, new_box(pe,2));
            
        insert_pt = find(pseudo_events(pseudo_events_index:next_empty_pe-1,1) > new_box(pe,2),1)+ pseudo_events_index -1;
        if isempty(insert_pt)
            % nth is later than this pseudo event just add at the end
            insert_pt = next_empty_pe;
        end
    end
    if insert_pt < max_pseudo_event
        pseudo_events(insert_pt+1:end,:) = pseudo_events(insert_pt:end-1,:);
    end
%         fprintf('%d insert_pt\n', insert_pt);
    pseudo_events(insert_pt,1) = new_box(pe,2); %time
    pseudo_events(insert_pt,2) = new_box(pe,3);
    pseudo_events(insert_pt,3) = new_box(pe,1); %box/neuron id

%         fprintf('add pseudo event %d boxid %d\n', insert_pt, details(pe,1));

    next_empty_pe = next_empty_pe + 1;

end
        
       

    
    
    
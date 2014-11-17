function [add_event, neurons] = check_event_in_dendrites(event, neurons, neurons_status)

usable_neuron = find(neurons_status == 1);
no_dim = numel(event);
add_event = [];
for n = usable_neuron,
    total_related = 0;
    neuron_gm_parameters = neurons{n,1};
    [no_gm,~] = size(neuron_gm_parameters);
    for g = 1:no_gm,
       m = neuron_gm_parameters(g,1:no_dim);
       s = neuron_gm_parameters(g,no_dim+1:end);
       s = reshape(s,no_dim, no_dim);
       related = 1;
       for d = 1:no_dim,
          if event(d) < m(d) - 3*s(d,d) || event(d) > m(d) + 3*s(d,d)
              related = 0;
              break;
          end
       end
       total_related = total_related + related;
    end
    
    if total_related > 0
       % at least within one dendrite        
       [no_memory,~] = size(neurons{n,2});
       if no_memory == 0,
           latest_time =  neuron_gm_parameters(:,no_dim) + 3* neuron_gm_parameters(:,end);
           add_event = vertcat(add_event, [n event(2) + max(latest_time)]);
           
       end
        neurons{n,2} = vertcat(neurons{n,2}, event);
    end
end

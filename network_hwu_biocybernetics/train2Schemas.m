clearNeurons;
initializeWeights;
scoresA = zeros(days,num_rats);
scoresC = zeros(days,num_rats);
schema_activity = [];
active_schema = [];
mPFC_activity = [];
vHPC_activity = [];
dHPC_activity = [];
fprintf('Running day ');
for d = 1:days
    fprintf('%i,', d);
    e = 1;
    LC_max = zeros(1,num_rats);
    epochs = 100;
    while e < max(floor(epochs))
        % Clear neurons again to avoid interference
        clearNeurons;
        % Alternate contexts, train random pair from that context
        %context = mod(e,2)+1;
        context = (d > (days/2))+1;
        if context == 1
            schema = schemaA;
        else
            schema = schemaC;
        end
        p = randi(size(schema,1),num_rats,1); % pick random pair
        explore;
        chl;
        e = e+1;
    end
    schema = schemaA;
    testSchema;
    scoresA(d,:) = score;
    schema = schemaC;
    testSchema;
    scoresC(d,:) = score; 
end
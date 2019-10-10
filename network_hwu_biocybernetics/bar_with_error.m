function bar_with_error(data,err)
    ctrs = 1:size(data,1);
    hBar = bar(ctrs, data);
    ctr = [];
    ydt = [];
    for k1 = 1:size(data,2)
        ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
        ydt(k1,:) = hBar(k1).YData;
    end
    hold on
    errorbar(ctr', ydt', err, '.r')
    hold off
end
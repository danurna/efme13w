dispstat(repmat('#',1,30),'keepprev','keepthis');
dispstat('PERCEPTRON','keepthis');


inputs = load('data/perceptrondata.dat');
target = cell(2,1);
target{1} = load('data/perceptrontarget1.dat');
target{2} = load('data/perceptrontarget2.dat');

target{1}(target{1} == 0) = -1;
target{2}(target{2} == 0) = -1;


TWOBIT = [
    0 0
    1 0
    0 1
    1 1
    ];

logic = cell(3,1);

logic{1}.name = 'AND';
logic{1}.target = [-1; -1; -1; 1];

logic{2}.name = 'OR';
logic{2}.target = [-1; 1; 1; 1];

logic{3}.name = 'XOR';
logic{3}.target = [-1; 1; 1; -1];

range = [-0.5 1.5 -0.5 1.5];

for i = 1 : numel(logic)
    figure(figH); figH = figH+1;
    
    [w, count] = perco(TWOBIT,logic{i}.target,100,true);
    gscatter(TWOBIT(:,1),TWOBIT(:,2),logic{i}.target); hold on;
    ezplot(@(x,y) w(1) + w(2)*x + w(3)*y);
    axis(range);
    title(logic{i}.name);
    hold off;
    
end


range = [0 1 0 1];

%LOADED DATA
for i = 1 : numel(target);
    [w, count] = perco(inputs,target{i},100);
    
    figure(figH); figH = figH+1;
    gscatter(inputs(:,1),inputs(:,2),target{i}); hold on;
    ezplot(@(x,y) w(1) + w(2)*x + w(3)*y, range); hold off;
end

dispstat('Ergebnisse und so');
dispstat(repmat('#',1,60),'keepprev','keepthis');
dispstat('PERCEPTRON','keepthis');


inputs = load('data/perceptrondata.dat');

entities = size(inputs,1);
homogen = ones(1,entities);
inputs = vertcat(homogen,inputs');

target = cell(2,1);
target{1} = load('data/perceptrontarget1.dat');
target{2} = load('data/perceptrontarget2.dat');

target{1}(target{1} == 0) = -1;
target{2}(target{2} == 0) = -1;


TWOBIT = [ 
    1 1 1 1
    0 1 0 1
    0 0 1 1
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
    figure;
    
    [w, count] = perco(TWOBIT,logic{i}.target,100,true);
    gscatter(TWOBIT(2,:),TWOBIT(3,:),logic{i}.target); hold on;
    ezplot(@(x,y) w(1) + w(2)*x + w(3)*y);
    axis(range);
    title(logic{i}.name);
    hold off;
    
end


range = [0 1 0 1];

%LOADED DATA
for i = 1 : numel(target);
    [w, count] = perco(inputs,target{i},100, true);
    
    figure;
    gscatter(inputs(2,:),inputs(3,:),target{i}); hold on;
    ezplot(@(x,y) w(1) + w(2)*x + w(3)*y);
    axis(range);
    title(sprintf('%s%d','Target #',i));
    
    hold off;
end


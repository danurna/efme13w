inputs = load('data/perceptrondata.dat');
target1 = load('data/perceptrontarget1.dat');
target2 = load('data/perceptrontarget2.dat');

inputs = horzcat(ones(size(inputs,1),1),inputs);
target1(target1 == 0) = -1;
target2(target2 == 0) = -1;

inputs = inputs';

TWOBIT = [  1 1 1 1
            0 1 0 1
            0 0 1 1  ];

AND = [-1, -1, -1, 1];
OR = [-1, 1, 1, 1];
XOR = [-1, 1, 1, -1];

[w1, out1] = perco(inputs,target1,1000);
%[w2, out2] = perco(inputs,target2,1000);

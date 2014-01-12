inputs = load('data/perceptrondata.dat');
target1 = load('data/perceptrontarget1.dat');
target2 = load('data/perceptrontarget2.dat');

inputs = horzcat(ones(size(inputs,1),1),inputs);
target1(target1 == 0) = -1;
target2(target2 == 0) = -1;

inputs = inputs';

[w, out] = perco(inputs,target1,1000);
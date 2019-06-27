% test file to load hdf5 data in matlab

clear all

% file name to load in
filename = 'data.h5';

% load in hdf5 data
arr1 = h5read(filename,'/arr1');
arr2 = h5read(filename,'/arr2');
mat1 = h5read(filename,'/mat1');
f1   = h5read(filename,'/f1');
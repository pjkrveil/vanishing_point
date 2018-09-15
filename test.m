%%% test.m (for Assignment 2 - 1)

clear all;
close all;
clc;

img1 = imread('image1.jpg');
img2 = imread('image2.jpg');
thr = 0.5;
rho = 1;

% Convert the images to Grayscale
gimg1 = rgb2gray(img1);
gimg2 = rgb2gray(img2);

% Find the Vanishing lines and drawing it.
findVanPoint(img1, gimg1, thr, rho, 5, 5, 100, [8 8]);
findVanPoint(img2, gimg2, thr, rho, 7, 3, 80, [8 8]);
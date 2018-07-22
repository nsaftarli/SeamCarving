%Seam Carving 
%Algorithm is slow, so images shown are saved outputs. 
%Uncomment function calls to run algorithm.
fprintf('**********Seam Removal**********\n')
img = imread('ryerson.jpg');
fprintf('Original Image: 720x480\n')
imshow(img,[]);
pause;
%Uncomment to actually run the algorithm
% new_img = MySeamCarving(img,480,640);
new_img = imread('ryerson640x480.jpg');
fprintf('Resized: 640x480\n')
imshow(new_img,[]);
pause;

%Uncomment to actually run the algorithm
% new_img = MySeamCarving(img,320,720);
new_img = imread('ryerson720x320.jpg');
fprintf('Resized: 720x320\n');
imshow(new_img,[]);
fprintf('******************************\n')
pause;

%3.2 Image expansion/Seam Insertion
fprintf('**********Seam Insertion**********\n')
img = imread('niagara.jpg');
fprintf('Original Image: 800x381\n');
imshow(img,[]);
pause;

%Uncomment to actually run the algorithm
% new_img = MySeamCarving(img,400,800);
new_img = imread('niagara800x400.jpg');
fprintf('Resized: 800x400\n');
imshow(new_img,[]);
pause;

%Uncomment to actually run the algorithm
% new_img = MySeamCarving(img,400,900);
new_img = imread('niagara900x400.jpg');
fprintf('Resized: 900x400\n');
imshow(new_img,[]);
fprintf('******************************\n')
pause;








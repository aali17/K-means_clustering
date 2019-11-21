clc
clear
close all

% initial image reading
img = imread('shaua1.jpg');
init_img = rgb2gray(img);
init_img_temp = double(init_img);
figure;
imshow(init_img);

% choosing k centroids
k = 80; %randi([8 12],1,1);
[x, y] = size(init_img);
x1 = x*rand(k,1);
y1 = y*rand(k,1);
centroid = [x1 y1];
distance = zeros(k,x,y);
assign_pixels = 255*zeros(k,x,y);
final_img = 255*zeros(x,y, 'uint8');
Final_image = 255*zeros(x,y, 'uint8');
iter = 1;

tic
while iter <= 20
    assign_pixels = 255*zeros(k,x,y);
    for i = 1:1:k % for all centroids
        for j1 = 1:1:x % for x values of images
            for j2 = 1:1:y % for y values of images
                distance(i,j1,j2) = norm([j1,j2] - centroid(i,:));
            end
        end
    end

    % calculate nim distance to assign pixels to center
    for ii = 1:1:k % for all centroids
        for j11 = 1:1:x % for x values of images
            for j22 = 1:1:y % for y values of images
                if distance(ii,j11,j22) == min(distance(:,j11,j22))
                    assign_pixels(ii,j11,j22) = min(distance(:,j11,j22));
                end
            end
        end
    end

    for l1 = 1:k
        if round(centroid(l1,1)) >= x-1 
            centroid(l1,1) = x-1;
        elseif round(centroid(l1,2)) >= y-1
            centroid(l1,2) = y-1;
        end
        if round(centroid(l1,1)) == 0 
            temp_gray = init_img_temp(round(centroid(l1,1))+1,round(centroid(l1,2)));
        elseif round(centroid(l1,2)) == 0
            temp_gray = init_img_temp(round(centroid(l1,1)),round(centroid(l1,2))+1);
        else 
            temp_gray = init_img_temp(round(centroid(l1,1)),round(centroid(l1,2)));
        end
        for l2 = 1:1:x % for x values of images
            for l3 = 1:1:y
                if assign_pixels(l1,l2,l3) ~= 0 
                    if temp_gray >=200
                        Final_image(l2,l3) = 255 - 255;
                    elseif temp_gray >=150 && temp_gray <=200
                        Final_image(l2,l3) = 255 - 150;
                    elseif temp_gray >=100 && temp_gray <=150
                        Final_image(l2,l3) = 255 - 100;
                    elseif temp_gray >=50 && temp_gray <=100
                        Final_image(l2,l3) = 255 - 50;
                    else
                        Final_image(l2,l3) = 255 - 0;
                    end
                end
            end
        end
    end

    for k1 = 1:k 
        centroid_temp = centroid;
        
        s_x = 0;
        s_y = 0;
        sum_x = 0;
        sum_y = 0;
        for y5 = 1:y
            if max(max(assign_pixels(k1,:,y5))) ~= 0
                sum_x = sum_x + y5;
                s_x = s_x + 1;
            end
        end
        for x5 = 1:x
            if max(max(assign_pixels(k1,x5,:))) ~= 0
                sum_y = sum_y + x5;
                s_y = s_y + 1;
            end
        end
        centroid(k1,1) = sum_x/s_x;
        centroid(k1,2) = sum_y/s_y;
        if isnan(centroid(k1,1))
            centroid(k1,1) = centroid_temp(k1,1);
        end
        if isnan(centroid(k1,2))
            centroid(k1,2) = centroid_temp(k1,2);
        end
    end
    iter = iter + 1;
    
    
    Final_image = imcomplement(Final_image);
    figure
    imshow(Final_image);
end
toc




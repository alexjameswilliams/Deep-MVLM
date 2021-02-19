function [re,le,ch,nose_tip,mouth,w1_r, w1_l, w2_r, w2_l, w3_r, w3_l, c, a, sig_est, n_angle]  = process_profile(filename)
%% Main Function to Import STL of Face Scan & Extract Key Paramters:
% - Indentify Bridge of Nose 
% - Fit Gaussian Curve 
% - Identify Co-ordinates for Facial landmarks


%% Processing Constants:
%y Offset of profile from eyeline
y_1 = -10;

%Resolution of Extracted Profile
res = 0.2;

%Length of Nose profile
x_t = 60;

%% STL Import
tri_in = stlread (filename);
tri_in = stl_check(tri_in);

%Take user Reference Points and Align Face to X-Y Plane
%ch  (2) is the new y_coordinate of the user indicated chin point
[re, le, ch] = userinput_refpoints(tri_in);
[tri_in, re, le, ch] = align_face(tri_in, re, le, ch);

%Find Chin location (gradient >= 1) from chin point down
ch (1) = 0;
c_points = take_cprofile(tri_in, ch (2), res);
c_points  = [c_points(:,2), c_points(:,3)];
c_points = add_grad (c_points);
for i = 1 : length (c_points)
    if c_points (length (c_points)-i,3) >= 1
        ch  (2) = c_points (length (c_points)-i,1);
        ch  (3) = c_points (length (c_points)-i,2);
        break
    end
end

%Find Tip of Nose index(greatest Z vertex value)
[~, nt_ind] = max (tri_in.Points (:,3));

%Find mouth coordinates
mouth = find_mouth(tri_in, nt_ind, ch, res);

%Face Width Points
[w1_r, w1_l, w2_r, w2_l, w3_r, w3_l] = find_width2(tri_in, nt_ind, mouth, res);

%Nose Plane: Find Axis along Bridge, rotate STL and take profile
%find axis along bridge of nose, take 2 bridge points 10 mm apart
y_2 = y_1 - 10;
points_1 = take_profile(tri_in, y_1, (0-(x_t/2)),(x_t/2), res);
points_2 = take_profile(tri_in, y_2, (0-(x_t/2)),(x_t/2), res);
t_points_1 = [points_1(:,1), points_1(:,3)];
t_points_2 = [points_2(:,1), points_2(:,3)];
t_points_1 = add_grad(t_points_1);
t_points_2 = add_grad(t_points_2);
x_1 = find_bridge(t_points_1);
x_2 = find_bridge(t_points_2);
clear t_points_1 t_points_2
for i = 1:length (points_1)
    if points_1 (i,1) > x_1
        z_1 = point_int(points_1 (i-1,1),points_1 (i,1),points_1(i-1,3),points_1(i,3),x_1);
        break
    end
end
for i = 1:length (points_2)
    if points_2 (i,1) > x_2
        z_2 = point_int(points_2 (i-1,1),points_2 (i,1),points_2(i-1,3),points_2(i,3),x_1);
        break
    end
end

%Rotate about 'x' to make nose plane flat and extract profile from translated top
n_angle = 360 - atand((z_2 - z_1)/(y_2-y_1));
tri_in = tri_rotate (tri_in, n_angle, "x");

%Correct extracted points of interest
[~, y_1] = point_transl(n_angle, z_1, y_1);
[ch(3), ch(2)] = point_transl(n_angle, ch(3),ch(2));
[mouth(3), mouth(2)] = point_transl(n_angle, mouth(3),mouth(2));
[w1_r(3), w1_r(2)] = point_transl(n_angle, w1_r(3),w1_r(2));
[w1_l(3), w1_l(2)] = point_transl(n_angle, w1_l(3),w1_l(2));
[w2_r(3), w2_r(2)] = point_transl(n_angle, w2_r(3),w2_r(2));
[w2_l(3), w2_l(2)] = point_transl(n_angle, w2_l(3),w2_l(2));
[w3_r(3), w3_r(2)] = point_transl(n_angle, w3_r(3),w3_r(2));
[w3_l(3), w3_l(2)] = point_transl(n_angle, w3_l(3),w3_l(2));
[re(3), re(2)] = point_transl(n_angle, re(3),re(2));
[le(3), le(2)] = point_transl(n_angle, le(3),le(2));
if n_angle > 360
    n_angle = n_angle - 360;
end

%Extract Nose_tip Coordinates (after rotation)
nose_tip = tri_in.Points (nt_ind,:);

%Extract profile for 2-D fitting
points = take_profile(tri_in, y_1, (0-(x_t/2)),(x_t/2), res);
profile = [points(:,1), points(:,3)];
profile = add_grad(profile,2);

%Figure Update - Face STL Plot
fig = figure;
subplot (2,1,1);
trimesh(tri_in);
hold;
f = plot3 (points (:,1), points (:,2), points (:,3));
f.LineWidth = 3;
f.Color = "Red";

%mark points of interest
plot3 (0, ch  (2), ch  (3), '.', 'Color', 'Red', 'LineWidth', 2, 'MarkerSize', 12);
plot3 (nose_tip(1), nose_tip(2), nose_tip(3),'.', 'Color', 'Green', 'LineWidth', 2, 'MarkerSize', 12);
plot3 (mouth (1), mouth(2), mouth(3), '.', 'Color', 'Blue', 'LineWidth', 2, 'MarkerSize', 12);
plot3 (re(1), re(2), re(3), '.', 'Color', 'Red', 'LineWidth', 2, 'MarkerSize', 12);
plot3 (le(1), le(2), le(3), '.', 'Color', 'Red', 'LineWidth', 2, 'MarkerSize', 12);
plot3 (w1_r(1), w1_r(2), w1_r(3), '.', 'Color', 'Red', 'LineWidth', 2, 'MarkerSize', 12);
plot3 (w1_l(1), w1_l(2), w1_l(3), '.', 'Color', 'Red', 'LineWidth', 2, 'MarkerSize', 12);
plot3 (w2_r(1), w2_r(2), w2_r(3), '.', 'Color', 'Green', 'LineWidth', 2, 'MarkerSize', 12);
plot3 (w2_l(1), w2_l(2), w2_l(3), '.', 'Color', 'Green', 'LineWidth', 2, 'MarkerSize', 12);
plot3 (w3_r(1), w3_r(2), w3_r(3), '.', 'Color', 'Blue', 'LineWidth', 2, 'MarkerSize', 12);
plot3 (w3_l(1), w3_l(2), w3_l(3), '.', 'Color', 'Blue', 'LineWidth', 2, 'MarkerSize', 12);

title ("Imported Face & Extracted Features")
ylabel ("mm");
xlabel ("mm");
zlabel ("mm");
view (-30,60);
hold;

%Correct and centre profile
profile = correct_profile(profile);

%Calculate mean half profile
profile_mean = mean_profile(profile, res);

%Fit Gasussian curve to data
%Mirror the Data
p_len = length (profile_mean);
profile_fit = nan ((2*p_len)-1,4);
for i = 1 : p_len
    profile_fit (i,1) = 0 - profile_mean (p_len +1 - i, 1);
    profile_fit (i,2) = profile_mean (p_len +1 - i, 2);
end
for i = 2 : p_len
    profile_fit (i - 1 + p_len,1) = profile_mean (i,1);
    profile_fit (i - 1 + p_len,2) = profile_mean (i,2);
end

%Gaussian Fit
ymax=max(profile_fit(:,2));
xnew=[];
ynew=[];
for n=1:length(profile_fit (:,1))
    if profile_fit(n,2)>ymax*0.2
        xnew=[xnew,profile_fit(n,1)];
        ynew=[ynew,profile_fit(n,2)];
    end
end
ynew=log(ynew);
p=polyfit(xnew,ynew,2);
c=sqrt(-1/(2*p(1)));
%Force a to be peak 
%c = sigma
%Force b to be exactly 0 (mu)
a = profile_mean (1,2);
for i = 1:length(profile_fit)
    profile_fit (i,3) = a * exp( -(profile_fit (i,1))^2 / (2*c^2) );
    profile_fit (i,4) = (profile_fit (i,2) - profile_fit (i,3))^2;
end

%Standard error of estimate calculation
%sigma est = sqrt (sum diff squared / N)
sig_est = sqrt(sum (profile_fit (:,4))/length (profile_fit));

%Figure Update - Fit Profile
subplot (2,1,2);
f = plot (profile (:,1),(profile (:,2)));
f.LineWidth = 1;
hold
f = plot (profile_fit (:,1),(profile_fit (:,2)));
f.LineWidth = 1;
f = plot (profile_fit (:,1),(profile_fit (:,3)));
f.LineWidth = 2;
title ("Gaussian Fit")
ylabel ("mm");
xlabel ("mm");
legend ('Original Profile', 'Mean Profile', 'Fit');
UL_x = min (profile (:,1));
UL_y = max (profile (:,2));
text(UL_x,UL_y,texlabel('sigma')+" ="+c,'Color','black','FontSize',14);
text(UL_x,UL_y - 2, "A = "+a, 'Color','black','FontSize',14);
text(UL_x,UL_y - 6, texlabel ('sigma')+"_e_s_t ="+sig_est, 'Color','red','FontSize',14);
fig.Position = [813,116,517,866];
hold
fig_n =  replace (filename, '.','_');
fig_n = append (fig_n, '.jpg');
saveas(gcf,fig_n);


%% Excel export for automatic CAD update
% %Export values to linking Excel Sheets
% disp(' ')
% disp('Export CAD Parameters to File?:')
% disp('(G) - Nose Guard (ng_com.xlsx)')
% disp('(N) - Finish without export')
% exp_opt = input ("Selection: ",'s');
% if (exp_opt == "g") || (exp_opt == "G")
%     xlswrite("ng_com.xlsx",{'Sigma','A_fit';c,a;'ul','mm'})
% end

end



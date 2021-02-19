%Batch Run Script for Facial Parameter Extraction
%
%Luke Carter, University of Birmingham 
%Version: 20/5/20
%Functions Required: 
% add_grad.m
% align_face.m
% correct_profile.m
% find_bridge.m
% find_mouth.m
% find_width2.m
% find_z_coord.m
% mean_profile.m
% point_int.m
% point_transl.m
% process_profile.m
% stl_check.m
% take_cprofile.m
% tri_rotate.m
% userinput_refpoints.m

%Loops until leave and export selected
%Creates Table of data and exports to excel sheet

%If the script finishes due to an error all data will remain in 'f_data'
%and can be saved manually!
while (true)

while (true)
    disp (" ")
    filename = input ("Enter STL Filename: ",'s');
    if isfile (filename)
        disp ("File Found")
        disp (" ")
        break
    else
        disp ("FILE NOT FOUND (Remember correct capitalisation & '.stl')")
    end
end

[re,le,ch,nose_tip,mouth,w1_r, w1_l, w2_r, w2_l, w3_r, w3_l, c, a, sig_est, n_angle] = process_profile(filename);
d_new = {filename re(1) re(2) re(3) le(1) le(2) le(3) ch(1) ch(2) ch(3) nose_tip(1) nose_tip(2) nose_tip(3) mouth(1) mouth(2) mouth(3) w1_r(1) w1_r(2) w1_r(3) w1_l(1) w1_l(2) w1_l(3) w2_r(1) w2_r(2) w2_r(3) w2_l(1) w2_l(2) w2_l(3) w3_r(1) w3_r(2) w3_r(3) w3_l(1) w3_l(2) w3_l(3) c a sig_est n_angle};

if exist ('f_data', 'var') == 0
    f_data = cell2table(d_new, 'VariableNames',{'Filename' 'Right_Eye_X' 'Right_Eye_Y' 'Right_Eye_Z' 'Left_Eye_X' 'Left_Eye_Y' 'Left_Eye_Z' 'Chin_X' 'Chin_Y' 'Chin_Z' 'Nose_Tip_X' 'Nose_Tip_Y' 'Nose_Tip_Z' 'Mouth_X' 'Mouth_Y' 'Mouth_Z' 'Width_1R_X' 'Width_1R_Y', 'Width_1R_Z' 'Width_1L_X' 'Width_1L_Y', 'Width_1L_Z' 'Width_2R_X' 'Width_2R_Y' 'Width_2R_Z' 'Width_2L_X' 'Width_2L_Y' 'Width_2L_Z' 'Width_3R_X' 'Width_3R_Y' 'Width_3R_Z' 'Width_3L_X' 'Width_3L_Y' 'Width_3L_Z' 'Sigma' 'A' 'Sigma_est' 'Nose_angle'}); 
else
    f_data = [f_data;d_new];
end

    disp (" ")
    c_check = input ("Another File? (Y/N): ",'s');
    if c_check == "N" || c_check == "n"
        break
    end

end

t_name = string(datetime('now'))+'.xlsx';
t_name = replace (t_name, '-','_');
t_name = replace (t_name, ' ','_');
t_name = replace (t_name, ':','_');
writetable (f_data,t_name)
clear f_data

disp ("Data Exported to "+t_name)



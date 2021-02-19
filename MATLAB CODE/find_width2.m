function [w1_r, w1_l, w2_r, w2_l, w3_r, w3_l] = find_width2(tri_in, nt_ind, mouth, res)
%Extracts face width points
%Edge of face defined as profile gradient == 2.7475 (65 Deg) from 'face-plane'
%V2 assumed face symettry following initial alignment and looks for
%coresponding gradients and points each side (working with each side in
%isolation gave inconsistent results)

grad_t =  2.1445;
% - W1 = Eyelevel
% - W2 = 'Nose Tip' level
% - W3 = Mouth Level

w1_r = [nan nan nan];
w1_l = [nan nan nan];
w2_r = [nan nan nan];
w2_l = [nan nan nan];
w3_r = [nan nan nan];
w3_l = [nan nan nan];

%Eyeline points (W1)
%Right eye
points_r = take_profile(tri_in, 0, -100, -30, res);
profile_r (:,1) = points_r (:,1);
profile_r (:,2) = points_r (:,3); 
profile_r = add_grad (profile_r);
%Left Eye
points_l = take_profile(tri_in, 0, 30, 100, res);
profile_l (:,1) = points_l (:,1);
profile_l (:,2) = points_l (:,3);
profile_l = add_grad (profile_l);

loop_i = min ([length(profile_l) length(profile_r)]);
for i = 1 : loop_i
    if (profile_r (length (profile_r) - i + 1, 3) > grad_t)&&(profile_l (i, 3) < - grad_t)
        w1_r = points_r (length (profile_r) - i + 1,:);
        w1_l = points_l (i,:);
        break
    end
end
clear profile_r profile_l points_r points_l;

%Nose Tip points (W2)
%Right
points_r = take_profile(tri_in, tri_in.Points (nt_ind,2), -100, -30, res);
profile_r (:,1) = points_r (:,1);
profile_r (:,2) = points_r (:,3);
profile_r = add_grad (profile_r);
%Left
points_l = take_profile(tri_in, tri_in.Points (nt_ind,2), 30, 100, res);
profile_l (:,1) = points_l (:,1);
profile_l (:,2) = points_l (:,3);
profile_l = add_grad (profile_l);

loop_i = min ([length(profile_l) length(profile_r)]);
for i = 1 : loop_i
    if (profile_r (length (profile_r) - i + 1, 3) > grad_t)&&(profile_l (i, 3) < - grad_t)
        w2_r = points_r (length (profile_r) - i + 1,:);
        w2_l = points_l (i,:);
        break
    end
end
clear profile_r profile_l points_r points_l;

%Mouth points (W3)
if ~isnan (mouth (1))
    %Right
    points_r = take_profile(tri_in, mouth (2), -100, -30, res);
    profile_r (:,1) = points_r (:,1);
    profile_r (:,2) = points_r (:,3);
    profile_r = add_grad (profile_r);
    %Left
    points_l = take_profile(tri_in, mouth (2), 30, 100, res);
    profile_l (:,1) = points_l (:,1);
    profile_l (:,2) = points_l (:,3);
    profile_l = add_grad (profile_l);
    
    loop_i = min ([length(profile_l) length(profile_r)]);
    for i = 1 : loop_i
        if (profile_r (length (profile_r) - i + 1, 3) > grad_t)&&(profile_l (i, 3) < - grad_t)
            w3_r = points_r (length (profile_r) - i + 1,:);
            w3_l = points_l (i,:);
            break
        end
    end
    clear profile_r profile_l points_r points_l;
end


end


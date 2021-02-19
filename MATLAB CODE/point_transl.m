function [opp_out, adj_out] = point_transl(angle, opp, adj)
% Simple rotational translation for a single point 
% (bacause I got bored of writing it out longhand in each function)
s_angle = sind(angle);
c_angle = cosd(angle);
adj_out = (adj*c_angle) - (opp*s_angle);
opp_out = (opp*c_angle) + (adj*s_angle);
end


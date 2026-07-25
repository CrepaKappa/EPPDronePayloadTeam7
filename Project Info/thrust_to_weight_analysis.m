%%Thrust vs Weight analysis
load('droneArmMaterials.mat')
%Design 1
thrust=1*4;%thrust in kg
t_to_w_ratio=2;
drone_body_weight=1;%kg
max_weight=thrust/t_to_w_ratio;%max weight of drone+payload
volume=.2;%m^3
density = [materials.rho_kg_m3];
arm_weight= volume*density;
drone_weight=drone_body_weight+4*arm_weight;
payload_capacity=max_weight-drone_weight;
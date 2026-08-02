clear,clc
 
%%Thrust vs Weight analysis
load('droneArmMaterials.mat')
%Design 1
fv=stlread('DroneArmA.stl');
shp = alphaShape(fv.Points);
vol = volume(shp);
thrust=1*4;%thrust in kg
t_to_w_ratio=2;
drone_body_weight=1;%kg
max_weight=thrust/t_to_w_ratio;%max weight of drone+payload
arm_volume=vol; %m^3
density = [materials.rho_kg_m3];
arm_weight= arm_volume*density;
drone_weight=drone_body_weight+4*arm_weight;
payload_capacity=max_weight-drone_weight;
%Design 2
fv2=stlread('DroneArmB.stl');
shp2 = alphaShape(fv2.Points);
vol2 = volume(shp2);
arm_volume2=vol2; %m^3
arm_weight2=arm_volume2*density;
drone_weight2=drone_body_weight+4*arm_weight2;
payload_capacity2=max_weight-drone_weight2;
%Design 3
fv3=stlread('DroneArmC.stl');
shp3 = alphaShape(fv3.Points);
vol3 = volume(shp3);
arm_volume3=vol3; %m^3
arm_weight3=arm_volume3*density;
drone_weight3=drone_body_weight+4*arm_weight3;
payload_capacity3=max_weight-drone_weight3;

%%Tabulate
% Create a table to summarize the results
    
payloadTable = table( ...
    payload_capacity.', ...
    payload_capacity2.', ...
    payload_capacity3.', ...
    'VariableNames', {'Design_A','Design_B','Design_C'}, ...
    'RowNames', { ...
        'Carbon_Fiber_CFRP', ...
        'Aluminum_Alloy', ...
        'Fiberglass_GFRP', ...
        'PLA_Plastic', ...
        'ABS_Plastic', ...
        'Wood_Birch'});
fprintf('\n                              Payload Capacity (kg)\n\n')

disp(payloadTable)

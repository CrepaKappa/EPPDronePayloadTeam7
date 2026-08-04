clear,clc

%%Thrust vs Weight analysis
load('droneArmMaterials.mat') %Load in materials data
%Design 1
fv=stlread('DroneArmA.stl'); %Creates triangulation of geometry
P1=fv.Points;
T1=fv.ConnectivityList;
vol1=0;
for i=1:size(T1,1)
    p1=P1(T1(i,1),:);
    p2=P1(T1(i,2),:);
    p3=P1(T1(i,3),:);
    vol1=vol1+dot(p1,cross(p2,p3))/6;
end
vol1=abs(vol1);
thrust_kg=1*4;%thrust in kg
t_to_w_ratio=2; %Defines required thrust to weight ratio
drone_body_mass=1; %Mass of all non-arm components of drone
max_mass=thrust_kg/t_to_w_ratio;%max mass capacity of drone+payload
density = [materials.rho_kg_m3]; %Extracts density of materials into an array
arm_mass= vol1*density; %Calculates mass of a single drone arm in kg
drone_mass=drone_body_mass+4*arm_mass; %Calculates mass of entire drone in kg
payload_capacity=max_mass-drone_mass; %Calculates payload capacity in kg
%Design 2
fv2=stlread('DroneArmB.stl'); %Creates triangulation of geometry
P2=fv2.Points;
T2=fv2.ConnectivityList;
vol2=0;
for i=1:size(T2,1)
    p1=P2(T2(i,1),:);
    p2=P2(T2(i,2),:);
    p3=P2(T2(i,3),:);
    vol2=vol2+dot(p1,cross(p2,p3))/6;
end
vol2=abs(vol2);
arm_mass2=vol2*density; %Calculates mass of a single drone arm in kg
drone_mass2=drone_body_mass+4*arm_mass2; %Calculates mass of entire drone in kg
payload_capacity2=max_mass-drone_mass2; %Calculates payload capacity in kg
%Design 3
fv3=stlread('DroneArmC.stl'); %Creates triangulation of geometry
P3=fv3.Points;
T3=fv3.ConnectivityList;
vol3=0;
for i=1:size(T3,1)
    p1=P3(T3(i,1),:);
    p2=P3(T3(i,2),:);
    p3=P3(T3(i,3),:);
    vol3=vol3+dot(p1,cross(p2,p3))/6;
end
vol3=abs(vol3);
arm_mass3=vol3*density; %Calculates mass of a single drone arm in kg
drone_mass3=drone_body_mass+4*arm_mass3; %Calculates mass of entire drone in kg
payload_capacity3=max_mass-drone_mass3; %Calculates payload capacity in kg

%%Tabulate
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

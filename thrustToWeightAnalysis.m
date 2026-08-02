clear,clc

%%Thrust vs Weight analysis
load('droneArmMaterials.mat') %Load in materials data
%Design 1
fv=stlread('DroneArmA.stl'); %Creates triangulation of geometry
shp = alphaShape(fv.Points); %Creates a bounding volume
vol1 = volume(shp); %calculates volume of geometry
thrust=1*4;%thrust in kg
t_to_w_ratio=2; %Defines required thrust to weight ratio
drone_body_mass=1; %Mass of all non-arm components of drone
max_mass=thrust/t_to_w_ratio;%max mass capacity of drone+payload
arm_volume=vol1; %m^3
density = [materials.rho_kg_m3]; %Extracts density of materials into an array
arm_mass= arm_volume*density; %Calculates mass of a single drone arm in kg
drone_mass=drone_body_mass+4*arm_mass; %Calculates mass of entire drone in kg
payload_capacity=max_mass-drone_mass; %Calculates payload capacity in kg
%Design 2
fv2=stlread('DroneArmB.stl'); %Creates triangulation of geometry
shp2 = alphaShape(fv2.Points); %Creates a bounding volume
vol2 = volume(shp2); %calculates volume of geometry
arm_volume2=vol2; %m^3
arm_mass2=arm_volume2*density; %Calculates mass of a single drone arm in kg
drone_mass2=drone_body_mass+4*arm_mass2; %Calculates mass of entire drone in kg
payload_capacity2=max_mass-drone_mass2; %Calculates payload capacity in kg
%Design 3
fv3=stlread('DroneArmC.stl'); %Creates triangulation of geometry
shp3 = alphaShape(fv3.Points); %Creates a bounding volume
vol3 = volume(shp3); %calculates volume of geometry
arm_volume3=vol3; %m^3
arm_mass3=arm_volume3*density; %Calculates mass of a single drone arm in kg
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

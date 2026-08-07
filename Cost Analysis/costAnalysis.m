clear,clc
%%Cost Analysis 
%Load cost per meter data
load('droneArmMaterials.mat') %Load in materials data
costPerM = [materials.cost_USD_per_m]; %Extracts cost of materials into an array
costPerM = costPerM.^3; %converts to cost per meters^3
%calculate volumes of arms
%arm A
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
%arm B
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
%arm C
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
% Calculate total costs for each arm
costArmA = 4* vol1 * costPerM; % Calculates material cost of arm designA
costArmB = 4*vol2 * costPerM; % Assuming costPerM(2) corresponds to arm B
costArmC = 4*vol3 * costPerM; % Assuming costPerM(3) corresponds to arm C
%tabulate
costTable = table( ...
    costArmA.', ...
    costArmB.', ...
    costArmC.', ...
    'VariableNames', {'Design_A','Design_B','Design_C'}, ...
    'RowNames', { ...
        'Carbon_Fiber_CFRP', ...
        'Aluminum_Alloy', ...
        'Fiberglass_GFRP', ...
        'PLA_Plastic', ...
        'ABS_Plastic', ...
        'Wood_Birch'});
fprintf('\n                              Cost of 4 arms (USD)\n\n')

disp(costTable)

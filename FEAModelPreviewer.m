% Finite Element Analysis Model Previewer
% Open relevant files
model = femodel(AnalysisType="structuralStatic", Geometry="DroneArmC.STL");
load("droneArmMaterials.mat");

% Plotting Drone Arm
figure
pdegplot(model,FaceLabels="on");
view(30,30);
title("Drone Arm with Face Labels")

figure
pdegplot(model,FaceLabels="on");
view(-134,-32);
title("Drone Arm with Face Labels, Rear View")

% Mesh Generation
model = generateMesh(model);

figure
pdemesh(model);
title ("Mesh preview")




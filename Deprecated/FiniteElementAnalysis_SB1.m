% Finite Element Analysis
% Open relevant files
model = femodel(AnalysisType="structuralStatic", Geometry="DroneArmA.STL");
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

% Material Properties
model.MaterialProperties = materialProperties(YoungsModulus=materials(1).E_Pa,PoissonsRatio=materials(1).nu);

% Boundary Conditions and Loads
model.FaceBC(5) = faceBC(Constraint="fixed"); % Fixed to drone body
model.FaceLoad(7) = faceLoad("SurfaceTraction",[0,0,-0.065]); % Weight of motor
model.FaceLoad(1) = faceLoad("SurfaceTraction",[0,0,1]); % Force of propeller pull

% Mesh Generation
model = generateMesh(model);

figure
pdemesh(model);
title ("Mesh with motor forces")

% Solving and Analysis
result = solve(model);
minUz = min(result.Displacement.uz);
% fprintf("Maximal deflection in the z-direction is %g meters.",minUz)


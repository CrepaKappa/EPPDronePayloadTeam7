% Finite Element Analysis
% Open relevant files
model = femodel(AnalysisType="structuralStatic", Geometry="DroneArmA.STL");
load("droneArmMaterials.mat");

% Constants
g = 9.81; % gravity in m/s^2
thrust = 1; % thrust in kg force
thrust = thrust*g; % Converted to Newtons
motorMass = 65; % in grams
propMass = 10; % in grams
weight = (motorMass + propMass)*g/1000; % Weight of the objects attached to the drone arm in Newtons

% Boundary Conditions and Loads
model.FaceBC(5) = faceBC(Constraint="fixed"); % Fixed to drone body

% Surface Traction in units of N/m^2, T = F/A 
% Weight provided in grams and thrust in kilograms
% Circle spot used for force alignment is 1" in diameter = 0.0254 m
alignmentArea = pi*(0.0127)^2; % drone arm models will have a slightly inset face of negligible depth to assist in proper alignment of forces
weightTraction = weight/alignmentArea;
thrustTraction = thrust/alignmentArea;

model.FaceLoad(1) = faceLoad("SurfaceTraction",[0,0,-weightTraction]); % Weight of motor
model.FaceLoad(6) = faceLoad("SurfaceTraction",[0,0,thrustTraction]); % Force of propeller pull
model.FaceLoad(3) = faceLoad("Gravity",[0,0,-g]);

% Material Properties
model.MaterialProperties = materialProperties(YoungsModulus=materials(1).E_Pa,PoissonsRatio=materials(1).nu);

% Solving and Analysis
model = generateMesh(model);
result = solve(model);

% Data visualization
t = tiledlayout(2,2,"TileSpacing","compact");
title(t,'Drone Arm made of',materials(1).name);

nexttile % x-displacement
pdeplot3D(result.Mesh,ColorMapData=result.Displacement.ux);
title("x-displacement")
colormap("jet")

nexttile % y-displacement
pdeplot3D(result.Mesh,ColorMapData=result.Displacement.uy)
title("y-displacement")
colormap("jet")

nexttile % z-displacement
pdeplot3D(result.Mesh,ColorMapData=result.Displacement.uz)
title("z-displacement")
colormap("jet")

nexttile % von Mises stress
pdeplot3D(result.Mesh,ColorMapData=result.VonMisesStress)
title("von Mises stress")
colormap("jet")

% Outputting data
yield = max(result.Stress.szz);
vonMis = max(result.VonMisesStress);
FoS = yield/vonMis;
fprintf("The yield strength is %g Pa\n", yield)
fprintf("The von Mises strength is %g\n", vonMis)
fprintf("The factor of safety is %g\n", FoS)
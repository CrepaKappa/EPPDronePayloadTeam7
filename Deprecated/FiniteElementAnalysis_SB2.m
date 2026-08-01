% Finite Element Analysis
% Open relevant files
model = femodel(AnalysisType="structuralStatic", Geometry="DroneArmA.STL");
load("droneArmMaterials.mat");

% Material Properties
model.MaterialProperties = materialProperties(YoungsModulus=materials(1).E_Pa,PoissonsRatio=materials(1).nu);

% Boundary Conditions and Loads
model.FaceBC(5) = faceBC(Constraint="fixed"); % Fixed to drone body
model.FaceLoad(1) = faceLoad("SurfaceTraction",[0,0,-0.065]); % Weight of motor
model.FaceLoad(6) = faceLoad("SurfaceTraction",[0,0,1]); % Force of propeller pull

% Solving and Analysis
model = generateMesh(model);

result = solve(model);
minUz = min(result.Displacement.uz);
% fprintf("Maximal deflection in the z-direction is %g meters.",minUz)

% Data visualization
tiledlayout(2,2)

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

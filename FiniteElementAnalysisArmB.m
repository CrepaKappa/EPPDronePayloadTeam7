% Finite Element Analysis Arm B
% Open relevant files
model = femodel(AnalysisType="structuralStatic", Geometry="DroneArmB.STL");
load("droneArmMaterials.mat");

% Constants
g = 9.81; % gravity in m/s^2
thrust = 1; % thrust in kg force
thrust = thrust*g; % Converted to Newtons
motorMass = 65; % in grams
propMass = 10; % in grams
weight = (motorMass + propMass)*g/1000; % Weight of the objects attached to the drone arm in Newtons

% Boundary Conditions and Loads
model.FaceBC(6) = faceBC(Constraint="fixed"); % Fixed to drone body

% Surface Traction in units of N/m^2, T = F/A 
% Weight provided in grams and thrust in kilograms
% Circle spot used for force alignment has a radius of 0.005 meters
alignmentArea = pi*(0.005)^2; % drone arm models will have a slightly extruded face of 0.1 mm to assist in proper alignment of forces
weightTraction = weight/alignmentArea;
thrustTraction = thrust/alignmentArea;

model.FaceLoad(11) = faceLoad("SurfaceTraction",[0,0,-weightTraction]); % Weight of motor
model.FaceLoad(14) = faceLoad("SurfaceTraction",[0,0,thrustTraction]); % Force of propeller pull
model.FaceLoad(12) = faceLoad("Gravity",[0,0,-g]);

% Defining results vectors
Material = [materials(1).name; materials(2).name; materials(3).name; materials(4).name; materials(5).name; materials(6).name];
massResult = zeros(6,1);
yieldResult = zeros(6,1);
vonMisesResult = zeros(6,1);
FOSResult = zeros(6,1);

% Defining volume for mass calculation
massModel = createpde;
importGeometry(massModel,"DroneArmB.STL");
mesh = generateMesh(massModel);
vol = volume(mesh);

% Simulation loop
for n = 1:6
    % Material Properties
    model.MaterialProperties = materialProperties(YoungsModulus=materials(n).E_Pa,PoissonsRatio=materials(n).nu);

    % Solving and Analysis
    model = generateMesh(model);
    result = solve(model);

    % Data visualization
    figure(Name=materials(n).name)
    t = tiledlayout(2,2,"TileSpacing","compact");
    title(t,'Drone Arm made of',materials(n).name);

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
    
    % Calculating mass
    den = materials(n).rho_kg_m3;
    mass = den*vol;
    % Outputting data
    yield = materials(n).yieldStrength_Pa;
    vonMis = max(result.VonMisesStress);
    FoS = yield/vonMis;
    
    massResult(n) = mass;
    yieldResult(n) = yield;
    vonMisesResult(n) = vonMis;
    FOSResult(n) = FoS;
end

% Creating results table
resultsTable = table();
resultsTable.("Drone Arm Material") = Material;
resultsTable.("Mass of Drone Arm (kg)") = massResult;
resultsTable.("Yield Strength (Pa)") = yieldResult;
resultsTable.("Von Mises Strength (Pa)") = vonMisesResult;
resultsTable.("Factor of Safety") = FOSResult % outputs table to Command Window

%% Final Project: Crater Lake
% MATH 312: Numerical Methods
% Julia Wenndt, Jacob Samuelson, Katie James, TJ Trout
% 5/2/2019

%% Sample data
SAMPLE_SIZE = 1000;
nRows = 12936068; % total number of data points
nSample = SAMPLE_SIZE; % desired sample size
rndIDX = randperm(nRows);
Sample = craterlake(rndIDX(1:nSample), :); % saved this new sample as a file name "newSample.mat"

%% Load data
load('newSample.mat')
Lon = newSample(:,1); % longitude
Lon(1:4) = [-122.18 -122.04 -122.18 -122.04]'; % add extreme values of region
Lat = newSample(:,2); % latitude
Lat(1:4) = [42.9 42.9 42.98 42.98]'; % add extreme values of region
Dep = newSample(:,3); % depth


Dep = Dep';
for i=1:SAMPLE_SIZE
    Dep(i) = Dep(i) - max(Dep); % shifts depth so that surface level is at 0
end
Dep(1:4) = [0 0 0 0]; % make the extreme values of region have depth 0
Dep = Dep';

%% Exploratory Scatter Plot
% use a scatter plot to confirm sample is an accurate representation
figure();
plot3(Lon,Lat,Dep,'.')
grid on
title('Exploratory Plot')

OptionZ.FrameRate=50;OptionZ.Duration=7.5;OptionZ.Periodic=true;
CaptureFigVid([-20,15;-110,45;-190,80;-290,45;-380,15],'ExploratoryPlot',OptionZ)

%% Initial attempt to calculate volume
% xLon = linspace(min(Lon), max(Lon), 1E+3); 
% yLat = linspace(min(Lat), max(Lat), 1E+3);
% 
% [X,Y] = meshgrid(xLon,yLat);
% 
% zDep = griddata(Lon,Lat,Dep,X,Y);
% 
% interpZ = @ (X,Y) griddata(Lon,Lat,Dep,X,Y); 
% vol = quad2d(interpZ,min(xLon),max(xLon),min(yLat),max(yLat)),
% %produces volume in terms of latitude and longitude (not very helpful)

%% Calculate volume in terms of meters
LatM = zeros(SAMPLE_SIZE,1)';
LonM = zeros(SAMPLE_SIZE,1)';

lat0 = min(Lat);
lon0 = min(Lon);

%convert latitude and longitude vectors into meters with the origin set at
%(0,0)
for i=1:SAMPLE_SIZE
    LatM(i) = convertToM(lat0, lon0, Lat(i), lon0); 
    LonM(i) = convertToM(lat0, lon0, lat0, Lon(i));
end

%find volume in terms of meters (same process as before)
xLonM = linspace(min(LonM), max(LonM), 1E+3); 
yLatM = linspace(min(LatM), max(LatM), 1E+3);

[XM,YM] = meshgrid(xLonM,yLatM);

zDepM = griddata(LonM,LatM,Dep,XM,YM);

interpZM = @ (XM,YM) griddata(LonM,LatM,Dep,XM,YM);

volM = abs(quad2d(interpZM,min(xLonM),max(xLonM),min(yLatM),max(yLatM))),
%true 1.86985e+10

%% Analyze Error
trueVolume = 1.86985e+10;
Error = trueVolume - volM;
RelError = Error/trueVolume,

%% Mesh plot
figure();
mesh(XM,YM,zDepM)
grid on
title('Mesh Plot')

OptionZ.FrameRate=30;OptionZ.Duration=5.5;OptionZ.Periodic=true;
CaptureFigVid([-20,15;-110,45;-190,80;-290,45;-380,15],'MeshPlot',OptionZ)

% Contour plot
figure();
contour3(XM,YM,zDepM,50)
grid on
title('Contour Plot')

OptionZ.FrameRate=30;OptionZ.Duration=5.5;OptionZ.Periodic=true;
CaptureFigVid([-20,15;-110,45;-190,80;-290,45;-380,15],'ContourPlot',OptionZ)

% Mesh plot with contours
figure();
mesh(XM,YM,zDepM)
hold on
contour3(XM,YM,zDepM,30,'k','LineWidth',1)
hold off
grid on
title('Mesh Plot with Contours')

OptionZ.FrameRate=30;OptionZ.Duration=5.5;OptionZ.Periodic=true;
CaptureFigVid([-20,15;-110,45;-190,80;-290,45;-380,15],'MeshPlotWithContours',OptionZ)

% Dotted contour plot
figure();
contour3(XM,YM,zDepM,30,'LineStyle',':','LineWidth',1)
grid on
title('Dotted Contour Plot')

OptionZ.FrameRate=30;OptionZ.Duration=5.5;OptionZ.Periodic=true;
CaptureFigVid([-20,15;-110,45;-190,80;-290,45;-380,15],'DottedContourPlot',OptionZ)

close all; clc;
start = 250;
final = 300;
numPts = 800;

% Sources: https://nghiaho.com/?page_id=671

truth = [-0.18;0];

% Find reference and scan data (polar)
refTheta  = angles.signals.values(start, 1:numPts);
refRho    = distances.signals.values(start, 1:numPts);
scanTheta = angles.signals.values(final, 1:numPts);
scanRho   = distances.signals.values(final, 1:numPts);

% Find reference and scan data (cartesian)
refX  = refRho.*cos(refTheta);
refY  = refRho.*sin(refTheta);
scanX = scanRho.*cos(scanTheta);
scanY = scanRho.*sin(scanTheta);

% Find reference and scan data (cartesian vectors)
ptsOri = [refX', refY', ones(numPts, 1)];
ptsNew = [scanX', scanY', ones(numPts, 1)];
% Find centroids
cenOri = mean(ptsOri);
cenNew = mean(ptsNew);

% Normalize the points w.r.t. centroids
normPtsOri = ptsOri - cenOri;
normPtsNew = ptsNew - cenNew;

figure;
hold on;
plot(refX, refY, 'bx');
plot(scanX, scanY, 'rx');
plot(normPtsOri(:,1), normPtsOri(:,2), 'b.');
plot(normPtsNew(:,1), normPtsNew(:,2), 'r.');
hold off;

H = (normPtsOri)'*(normPtsNew);
[U, S, V] = svd(H);
R = V*U'
t = cenNew' - R*(cenOri')

[RR, tt, ss] = rigid_transform(ptsOri, ptsNew, 1)

ptsModel1 = (R*ptsOri' + t)'
ptsModel2 = (RR*ptsOri' + tt)'

figure;
hold on;
plot(refX, refY, 'b.');
plot(scanX, scanY, 'r.');
plot(ptsModel1(:,1), ptsModel1(:,2), 'g.');
plot(ptsModel2(:,1), ptsModel2(:,2), 'c.');
plot(refX + truth(1), refY + truth(2), 'k.')
hold off;

% figure;
% dispMatrix = sqrt((refX-scanX').^2 + (refY-scanY).^2);
% surfc(dispMatrix);
% 
% mean(refX - scanX)
% mean(refY - scanY)
% 
% mean(sqrt((refX - scanX).^2 + (refY - scanY).^2))
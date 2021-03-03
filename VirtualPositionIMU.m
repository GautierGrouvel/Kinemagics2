% function IMUPosition = VirtualPositionIMU(QualisysData,C3D)
% Author       : G. Grouvel
% Date         : March 2021
% -------------------------------------------------------------------------
% Description  :
% This function determines the virtual position of the IMU for each frame 
% and for each segment
%
% -------------------------------------------------------------------------

function IMUPosition = VirtualPositionIMU(QualisysData,C3D)

% Sacrum-same position as the SACR marker
IMUSacrum=C3D.data.SACR;
IMUPosition.IMUSacrum=IMUSacrum;

% Initialisation
% Right Thigh
IMURThigh=[];
Lrt=1;
Mrt=-1.5;
Nrt=1;
% Right Shank
IMURShank=[];
Lrs=2;
Mrs=2;
Nrs=2;
% Right Foot
IMURFoot=[];
Lrf=2;
Mrf=2;
Nrf=2;
% Left Thigh
IMULThigh=[];
Llt=2;
Mlt=2;
Nlt=2;
% Left Shank
IMULShank=[];
Lls=2;
Mls=2;
Nls=2;
% Left Foot
IMULFoot=[];
Llf=2;
Mlf=2;
Nlf=2;

for i=1:length(QualisysData.SacrumSystems)
   % Right Thigh
   IMURThigh=[IMURThigh;{[Lrt*C3D.data.RKJC(i,1) Mrt*C3D.data.RKJC(i,2) Nrt*C3D.data.RKJC(i,3)]}];
   IMUPosition.IMURThigh=IMURThigh;
   % Right Shank
   IMURShank=[IMURShank;{[Lrs*C3D.data.RAJC(i,1) Mrs*C3D.data.RAJC(i,2) Nrs*C3D.data.RAJC(i,3)]}];
   IMUPosition.IMURShank=IMURShank;
   % Right Foot
   IMURFoot=[IMURFoot;{[Lrf*C3D.data.RTOE(i,1) Mrf*C3D.data.RTOE(i,2) Nrf*C3D.data.RTOE(i,3)]}];
   IMUPosition.IMURFoot=IMURFoot;
   % Left Thigh
   IMULThigh=[IMULThigh;{[Llt*C3D.data.LKJC(i,1) Mlt*C3D.data.LKJC(i,2) Nlt*C3D.data.LKJC(i,3)]}];
   IMUPosition.IMULThigh=IMULThigh;
   % Left Shank
   IMULShank=[IMULShank;{[Lls*C3D.data.LAJC(i,1) Mls*C3D.data.LAJC(i,2) Nls*C3D.data.LAJC(i,3)]}];
   IMUPosition.IMULShank=IMULShank;
   % Left Foot
   IMULFoot=[IMULFoot;{[Llf*C3D.data.LTOE(i,1) Mlf*C3D.data.LTOE(i,2) Nlf*C3D.data.LTOE(i,3)]}];
   IMUPosition.IMULFoot=IMULFoot;
   
end

figure; scale=2; col_axis='rgb';

for mm = 1:3
    quiver3(C3D.data.RKJC(60,1),C3D.data.RKJC(60,2),C3D.data.RKJC(60,3),QualisysData.RThighSystems{60}(1,mm),QualisysData.RThighSystems{60}(2,mm),QualisysData.RThighSystems{60}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
    hold on
    plot3(IMURThigh{60}(1),IMURThigh{60}(2),IMURThigh{60}(3),'-o','Color','b','MarkerSize',10)
    
    
end
end

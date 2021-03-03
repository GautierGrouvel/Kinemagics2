% function Quaternion = QuatSegments(QualisysData)
% Author       : G. Grouvel
% Date         : March 2021
% -------------------------------------------------------------------------
% Description  :
% This function creates the quaternions corresponding to the segment 
% systems for each frame 
%
% -------------------------------------------------------------------------

function Quaternion = QuatSegments(QualisysData)
QuatSacrum=[];
QuatRThigh=[];
QuatRShank=[];
QuatRFoot=[];
QuatLThigh=[];
QuatLShank=[];
QuatLFoot=[];

for i=1:length(QualisysData.SacrumSystems)
    
    % Quaternions
    QuatSacrum=[QuatSacrum;{matrix2quat(QualisysData.SacrumSystems{i})}];
    QuatRThigh=[QuatRThigh;{matrix2quat(QualisysData.RThighSystems{i})}];
    QuatRShank=[QuatRShank;{matrix2quat(QualisysData.RShankSystems{i})}];
    QuatRFoot=[QuatRFoot;{matrix2quat(QualisysData.RFootSystems{i})}];
    QuatLThigh=[QuatLThigh;{matrix2quat(QualisysData.LThighSystems{i})}];
    QuatLShank=[QuatLShank;{matrix2quat(QualisysData.LShankSystems{i})}];
    QuatLFoot=[QuatLFoot;{matrix2quat(QualisysData.LFootSystems{i})}];
    
    % Store quaternions frames
    Quaternion.QuatSacrum=QuatSacrum;
    Quaternion.QuatRThigh=QuatRThigh;
    Quaternion.QuatRShank=QuatRShank;
    Quaternion.QuatRFoot=QuatRFoot;
    Quaternion.QuatLThigh=QuatLThigh;
    Quaternion.QuatLShank=QuatLShank;
    Quaternion.QuatLFoot=QuatLFoot;
      
end    
end

% Author       : G. Grouvel
% Date         : Feb. 2021
% -------------------------------------------------------------------------
% Description  :
% This program retrieves the path of the necessary functions
%
% ------------------------------------------------------------------------

% Add path of the necessary functions
addpath(genpath('C:\Users\GGRU\Desktop\KLab\Kinemagics\Codes\Codes_documentation'));

% Calculations of segment coordinate systems

static_data=Get_C3D_BTK_Anonyme('C:\Users\GGRU\Desktop\KLab\Kinemagics\Codes\Codes_documentation\','03367_05136_20200604-SBNNN-VDEF-02.C3D',1);
gait_data=Get_C3D_BTK_Anonyme('C:\Users\GGRU\Desktop\KLab\Kinemagics\Codes\Codes_documentation\','03367_05136_20200604-GBNNN-VDEF-01.C3D',1);

% Verification of static frame1 data and calculations of static segment coordinate systems
if (isnan(static_data.data.RASI(1,:)) & isnan(static_data.data.midASIS(1,:)) & isnan(static_data.data.SACR(1,:)) & isnan(static_data.data.RHJC(1,:)) & isnan(static_data.data.RKJC(1,:)) & isnan(static_data.data.RKNE(1,:)) & isnan(static_data.data.RAJC(1,:)) & isnan(static_data.data.RANK(1,:)) & isnan(static_data.data.RHEE(1,:)) & isnan(static_data.data.RTOE(1,:)) & isnan(static_data.data.LHJC(1,:)) & isnan(static_data.data.LKJC(1,:)) & isnan(static_data.data.LKNE(1,:)) & isnan(static_data.data.LAJC(1,:)) & isnan(static_data.data.LANK(1,:)) & isnan(static_data.data.LHEE(1,:)) & isnan(static_data.data.LTOE(1,:)))
    disp('Frame 2');
    static_system_frame2={static_systems.SacrumSystems{2};static_systems.RThighSystems{2};static_systems.RShankSystems{2};static_systems.RFootSystems{2};static_systems.LThighSystems{2};static_systems.LShankSystems{2};static_systems.LFootSystems{2}};
else
    disp('Frame 1');
    static_systems=SegmentOrientationISB(static_data);
    static_system_frame1={static_systems.SacrumSystems{1};static_systems.RThighSystems{1};static_systems.RShankSystems{1};static_systems.RFootSystems{1};static_systems.LThighSystems{1};static_systems.LShankSystems{1};static_systems.LFootSystems{1}};
end

% Calculations of dynamic segment coordinate systems
gait_systems=SegmentOrientationISB(gait_data);

% Calculations of quaternions for each coordinate systems
static_quat=QuatSegments(static_systems);
gait_quat=QuatSegments(gait_systems);

% function QualisysData = SegmentOrientation(C3D)
% Author       : L. Carcreff & F. Moissenet
% Date         : Nov. 2020
% -------------------------------------------------------------------------
% Description  :
% This function computes the lower limb segments orientation from markers
% trajectories and store the results in the output structure
%
% Author : G. Grouvel
%
% Modification :
% Adaptation of the code to obtain the segment systems and their display
% for each frame
% -------------------------------------------------------------------------
% Dependencies : - R2mobile***_array3 functions from R. Dumas

function QualisysData = SegmentOrientationISB(C3D)
SacrumSystems=[];
RThighSystems=[];
RShankSystems=[];
RFootSystems=[];
LThighSystems=[];
LShankSystems=[];
LFootSystems=[];

for i=1:length(C3D.data.RASI)
    
    % SACRUM
    % Get current landmarks positions :
    RASI    = C3D.data.RASI(i,:);
    midASIS = C3D.data.midASIS(i,:);
    SACR    = C3D.data.SACR(i,:);
    % Segment coordinate system :
    SegmFrame.Z_TF_Sacrum = (RASI-midASIS)/...
        norm(RASI-midASIS);
    SegmFrame.Y_TF_Sacrum = cross(SACR-midASIS,RASI-midASIS)/...
        norm(cross(SACR-midASIS,RASI-midASIS));
    SegmFrame.X_TF_Sacrum = cross(SegmFrame.Y_TF_Sacrum,SegmFrame.Z_TF_Sacrum)/...
        norm(cross(SegmFrame.Y_TF_Sacrum,SegmFrame.Z_TF_Sacrum));
    SegmFrame.R_TF_Sacrum = [SegmFrame.X_TF_Sacrum' SegmFrame.Y_TF_Sacrum' SegmFrame.Z_TF_Sacrum'];
    SacrumSystems=[SacrumSystems;{SegmFrame.R_TF_Sacrum}];
    
    % RIGHT THIGH
    % Get current landmarks positions :
    RHJC = C3D.data.RHJC(i,:);
    RKJC = C3D.data.RKJC(i,:);
    RKNE = C3D.data.RKNE(i,:);
    % Segment coordinate system :
    SegmFrame.Y_TF_RThigh = (RHJC-RKJC)/...
        norm(RHJC-RKJC);
    SegmFrame.X_TF_RThigh = cross(RKJC-RKNE,RHJC-RKJC)/...
        norm(cross(RKJC-RKNE,RHJC-RKJC));
    SegmFrame.Z_TF_RThigh = cross(SegmFrame.X_TF_RThigh,SegmFrame.Y_TF_RThigh)/...
        norm(cross(SegmFrame.X_TF_RThigh,SegmFrame.Y_TF_RThigh));
    SegmFrame.R_TF_RThigh = [SegmFrame.X_TF_RThigh' SegmFrame.Y_TF_RThigh' SegmFrame.Z_TF_RThigh'];
    RThighSystems=[RThighSystems;{SegmFrame.R_TF_RThigh}];
    
    % RIGHT SHANK
    % Get current landmarks positions :
    RKJC = C3D.data.RKJC(i,:);
    RAJC = C3D.data.RAJC(i,:);
    RANK = C3D.data.RANK(i,:);
    % Segment coordinate system :
    SegmFrame.Y_TF_RShank = (RKJC-RAJC)/...
        norm(RKJC-RAJC);
    SegmFrame.X_TF_RShank = cross(RAJC-RANK,RKJC-RAJC)/...
        norm(cross(RAJC-RANK,RKJC-RAJC));
    SegmFrame.Z_TF_RShank = cross(SegmFrame.X_TF_RShank,SegmFrame.Y_TF_RShank)/...
        norm(cross(SegmFrame.X_TF_RShank,SegmFrame.Y_TF_RShank));
    SegmFrame.R_TF_RShank = [SegmFrame.X_TF_RShank' SegmFrame.Y_TF_RShank' SegmFrame.Z_TF_RShank'];
    RShankSystems=[RShankSystems;{SegmFrame.R_TF_RShank}];
    
    % RIGHT FOOT
    % Get current landmarks positions :
    RAJC = C3D.data.RAJC(i,:);
    RHEE = C3D.data.RHEE(i,:);
    RTOE = C3D.data.RTOE(i,:);
    % Segment coordinate system :
    SegmFrame.Y_TF_RFoot = (RAJC-RTOE)/...
        norm(RAJC-RTOE);
    SegmFrame.Z_TF_RFoot = cross(RTOE-RHEE,RAJC-RHEE)/...
        norm(cross(RTOE-RHEE,RAJC-RHEE));
    SegmFrame.X_TF_RFoot = cross(SegmFrame.Y_TF_RFoot,SegmFrame.Z_TF_RFoot)/...
        norm(cross(SegmFrame.Y_TF_RFoot,SegmFrame.Z_TF_RFoot));
    SegmFrame.R_TF_RFoot = [SegmFrame.X_TF_RFoot' SegmFrame.Y_TF_RFoot' SegmFrame.Z_TF_RFoot'];
    RFootSystems=[RFootSystems;{SegmFrame.R_TF_RFoot}];
    
    % LEFT THIGH
    % Get current landmarks positions :
    LHJC = C3D.data.LHJC(i,:);
    LKJC = C3D.data.LKJC(i,:);
    LKNE = C3D.data.LKNE(i,:);
    % Segment coordinate system :
    SegmFrame.Y_TF_LThigh = (LHJC-LKJC)/...
        norm(LHJC-LKJC);
    SegmFrame.X_TF_LThigh = cross(LKNE-LKJC,LHJC-LKJC)/...
        norm(cross(LKJC-LKNE,LHJC-LKJC));
    SegmFrame.Z_TF_LThigh = cross(SegmFrame.X_TF_LThigh,SegmFrame.Y_TF_LThigh)/...
        norm(cross(SegmFrame.X_TF_LThigh,SegmFrame.Y_TF_LThigh));
    SegmFrame.R_TF_LThigh = [SegmFrame.X_TF_LThigh' SegmFrame.Y_TF_LThigh' SegmFrame.Z_TF_LThigh'];
    LThighSystems=[LThighSystems;{SegmFrame.R_TF_LThigh}];
    
    % LEFT SHANK
    % Get current landmarks positions :
    LKJC = C3D.data.LKJC(i,:);
    LAJC = C3D.data.LAJC(i,:);
    LANK = C3D.data.LANK(i,:);
    % Segment coordinate system :
    SegmFrame.Y_TF_LShank = (LKJC-LAJC)/...
        norm(LKJC-LAJC);
    SegmFrame.X_TF_LShank = cross(LANK-LAJC,LKJC-LAJC)/...
        norm(cross(LAJC-LANK,LKJC-LAJC));
    SegmFrame.Z_TF_LShank = cross(SegmFrame.X_TF_LShank,SegmFrame.Y_TF_LShank)/...
        norm(cross(SegmFrame.X_TF_LShank,SegmFrame.Y_TF_LShank));
    SegmFrame.R_TF_LShank = [SegmFrame.X_TF_LShank' SegmFrame.Y_TF_LShank' SegmFrame.Z_TF_LShank'];
    LShankSystems=[LShankSystems;{SegmFrame.R_TF_LShank}];
    
    % LEFT FOOT
    % Get current landmarks positions :
    LAJC = C3D.data.LAJC(i,:);
    LHEE = C3D.data.LHEE(i,:);
    LTOE = C3D.data.LTOE(i,:);
    % Segment coordinate system :
    SegmFrame.Y_TF_LFoot = (LAJC-LTOE)/...
        norm(LAJC-LTOE);
    SegmFrame.Z_TF_LFoot = cross(LTOE-LHEE,LAJC-LHEE)/...
        norm(cross(LTOE-LHEE,LAJC-LHEE));
    SegmFrame.X_TF_LFoot = cross(SegmFrame.Y_TF_LFoot,SegmFrame.Z_TF_LFoot)/...
        norm(cross(SegmFrame.Y_TF_LFoot,SegmFrame.Z_TF_LFoot));
    SegmFrame.R_TF_LFoot = [SegmFrame.X_TF_LFoot' SegmFrame.Y_TF_LFoot' SegmFrame.Z_TF_LFoot'];
    LFootSystems=[LFootSystems;{SegmFrame.R_TF_LFoot}];
    
    % STORE SEGMENT FRAMES
    QualisysData.SacrumSystems=SacrumSystems;
    QualisysData.RThighSystems=RThighSystems;
    QualisysData.RShankSystems=RShankSystems;
    QualisysData.RFootSystems=RFootSystems;
    QualisysData.LThighSystems=LThighSystems;
    QualisysData.LShankSystems=LShankSystems;
    QualisysData.LFootSystems=LFootSystems;
    
end

%%Plot segment coordinate systems for each frame and for each segment

% figure; scale=2; col_axis='rgb';
% 
% subplot(4,2,1);
% for k=1:length(QualisysData.SacrumSystems) 
%     for mm = 1:3
%         quiver3(C3D.data.SACR(k,1),C3D.data.SACR(k,2),C3D.data.SACR(k,3),SacrumSystems{k}(1,mm),SacrumSystems{k}(2,mm),SacrumSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('Sacrum');
% 
% subplot(4,2,3); 
% for k=1:length(QualisysData.SacrumSystems) 
%     for mm = 1:3
%         quiver3(C3D.data.LKJC(k,1),C3D.data.LKJC(k,2),C3D.data.LKJC(k,3),LThighSystems{k}(1,mm),LThighSystems{k}(2,mm),LThighSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('LThigh');
% 
% subplot(4,2,4);
% for k=1:length(QualisysData.SacrumSystems) 
%     for mm = 1:3
%         quiver3(C3D.data.RKJC(k,1),C3D.data.RKJC(k,2),C3D.data.RKJC(k,3),RThighSystems{k}(1,mm),RThighSystems{k}(2,mm),RThighSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('RThigh');
% 
% subplot(4,2,5);
% for k=1:length(QualisysData.SacrumSystems) 
%     for mm = 1:3
%         quiver3(C3D.data.LAJC(k,1),C3D.data.LAJC(k,2),C3D.data.LAJC(k,3),LShankSystems{k}(1,mm),LShankSystems{k}(2,mm),LShankSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('LShank');
% 
% subplot(4,2,6);
% for k=1:length(QualisysData.SacrumSystems) 
%     for mm = 1:3
%         quiver3(C3D.data.RAJC(k,1),C3D.data.RAJC(k,2),C3D.data.RAJC(k,3),RShankSystems{k}(1,mm),RShankSystems{k}(2,mm),RShankSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('RShank');
% 
% subplot(4,2,7); 
% for k=1:length(QualisysData.SacrumSystems) 
%     for mm = 1:3
%         quiver3(C3D.data.LTOE(k,1),C3D.data.LTOE(k,2),C3D.data.LTOE(k,3),LFootSystems{k}(1,mm),LFootSystems{k}(2,mm),LFootSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('LFoot');
% 
% subplot(4,2,8);
% for k=1:length(QualisysData.SacrumSystems) 
%     for mm = 1:3
%         quiver3(C3D.data.RTOE(k,1),C3D.data.RTOE(k,2),C3D.data.RTOE(k,3),RFootSystems{k}(1,mm),RFootSystems{k}(2,mm),RFootSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('RFoot');
% 
% suptitle(['ISB - ' C3D.filename ' -Segment coordinate systems']);

%%Plot segment coordinate systems for n (n=200) frame and for each segment

% figure; scale=2; col_axis='rgb';
% 
% subplot(4,2,1);
% for k=1:200
%     for mm = 1:3
%         quiver3(C3D.data.SACR(k,1),C3D.data.SACR(k,2),C3D.data.SACR(k,3),SacrumSystems{k}(1,mm),SacrumSystems{k}(2,mm),SacrumSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('Sacrum');
% 
% subplot(4,2,3); 
% for k=1:200
%     for mm = 1:3
%         quiver3(C3D.data.LKJC(k,1),C3D.data.LKJC(k,2),C3D.data.LKJC(k,3),LThighSystems{k}(1,mm),LThighSystems{k}(2,mm),LThighSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('LThigh');
% 
% subplot(4,2,4);
% for k=1:200
%     for mm = 1:3
%         quiver3(C3D.data.RKJC(k,1),C3D.data.RKJC(k,2),C3D.data.RKJC(k,3),RThighSystems{k}(1,mm),RThighSystems{k}(2,mm),RThighSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('RThigh');
% 
% subplot(4,2,5);
% for k=1:200
%     for mm = 1:3
%         quiver3(C3D.data.LAJC(k,1),C3D.data.LAJC(k,2),C3D.data.LAJC(k,3),LShankSystems{k}(1,mm),LShankSystems{k}(2,mm),LShankSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('LShank');
% 
% subplot(4,2,6);
% for k=1:200
%     for mm = 1:3
%         quiver3(C3D.data.RAJC(k,1),C3D.data.RAJC(k,2),C3D.data.RAJC(k,3),RShankSystems{k}(1,mm),RShankSystems{k}(2,mm),RShankSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('RShank');
% 
% subplot(4,2,7); 
% for k=1:200
%     for mm = 1:3
%         quiver3(C3D.data.LTOE(k,1),C3D.data.LTOE(k,2),C3D.data.LTOE(k,3),LFootSystems{k}(1,mm),LFootSystems{k}(2,mm),LFootSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('LFoot');
% 
% subplot(4,2,8);
% for k=1:200
%     for mm = 1:3
%         quiver3(C3D.data.RTOE(k,1),C3D.data.RTOE(k,2),C3D.data.RTOE(k,3),RFootSystems{k}(1,mm),RFootSystems{k}(2,mm),RFootSystems{k}(3,mm),scale,'LineWidth',1,'color',col_axis(mm));       
%         hold on
%     end
% end
% title('RFoot');
% 
% suptitle(['ISB - ' C3D.filename ' -Segment coordinate systems']);

end
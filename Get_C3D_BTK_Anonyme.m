function C3D = Get_C3D_BTK_Anonyme(C3D_path,C3D_filename,analog)
% This function opens C3D files that are anonymized. It reads the
% information stored in the metadata and writes it in the C3D variable
% Author : Anne
% Modifications:
% Lena - 04.11.2020 : Add the reading of the field 'TRIAL' of the metadata
% Lena - 09.11.2020 : Add LCycle and RCycle empty field if no CYCLES
% detected
warning off;
file = [C3D_path C3D_filename];
C3D.filename = C3D_filename;
C3D.pathname = C3D_path;
acq=btkReadAcquisition(strcat(C3D_path,C3D_filename));%'\',
[C3D.data C3D.dataInfo]=btkGetPoints(acq);
dataname=fieldnames(C3D.data);
mda   = btkGetMetaData(acq);
md = btkFindMetaData(acq, 'MANUFACTURER', 'COMPANY');

if isstruct(md)==1
    MANUFACTURER=char(md.info.values);
    C3D.Manufacturer=MANUFACTURER;
else
    MANUFACTURER='Vicon';
end

ms = btkFindMetaData(acq, 'COMPUTATION', 'Model_Software');

compute_done=sum(cell2mat(strfind(dataname,'Angles')));
if isstruct(ms)==1
    C3D.Model.Software=char(ms.info.values);
else
    if compute_done>0
        if strcmp(MANUFACTURER,'Vicon')
            C3D.Model.Software='Nexus';
            Already_processed=regexp(dataname,'Vicon');% re-processed with Visual3D
            if sum([Already_processed{:}])>0
                C3D.Model.Software='V3D';
            end
        end
        if strcmp(MANUFACTURER,'Qualisys')
            C3D.Model.Software='V3D';
        end
    else C3D.Model.Software='None';
    end
end
C3D.acq=acq;
C3D.StartFrame = btkGetFirstFrame(acq);
C3D.EndFrame = btkGetLastFrame(acq);
C3D.fRate.Point = btkGetPointFrequency(acq);
C3D.fRate.Analog = btkGetAnalogFrequency(acq);
EventFrame=struct();
E=btkGetEvents(acq);
if isempty(E)==0
    a=fieldnames(E);
    if isempty(a)==0
        for i=1:length(a)
            Event.(char(a{i}))=sort(E.(char(a{i})));
            %             for j=1:length(Event.(char(a{i})))
            %                 if   Event.(char(a{i}))(j)<1
            %                     Event.(char(a{i}))(j)=1;
            %                 end
            %             end
            EventFrame.(char(a{i}))=round(Event.(char(a{i}))*C3D.fRate.Point+1-single(C3D.StartFrame)+1);%+1 pour la convertion temporelle  et +1 pour la différence entre frame
            %EventFrame.(char(a{i}))=round(single(Event.(char(a{i})))*C3D.fRate.Point-single(C3D.StartFrame)+1);%+single(C3D.StartFrame)
            for j=1:length( EventFrame.(char(a{i})))
                if    EventFrame.(char(a{i}))(j)<1
                    EventFrame.(char(a{i}))(j)=1;
                end
            end
        end
        C3D.Event=Event;
        C3D.EventFrame=EventFrame;
    end
end
[C3D.Spatio_temp.data C3D.Spatio_temp.info]=btkGetAnalysis(acq);

% Pour vieux fichier que Nexus ne relie pas correctement - fréquence:120Hz
% au lieu de 50Hz
% Correction des données spatio-temp
var_name={'Left_Cadence','Left_Walking_Speed','Right_Walking_Speed','Right_Cadence'};
if C3D.fRate.Point==120
    if isfield(C3D,'Spatio_temp')==1
        if isfield(C3D.Spatio_temp,'data')==1
            for i=1:length(var_name)
                if isfield(C3D.Spatio_temp.data,var_name{i})==1
                    C3D.Spatio_temp.data.(var_name{i})=C3D.Spatio_temp.data.(var_name{i})/2.4;
                end
            end
        end
    end
end

temp=struct();
temp=btkGetMetaData(acq);
C3D.MetaData=temp;
a=struct();
%% Search subjects field in metadata
Subject=0;
if isfield(temp.children,'SUBJECTS')==1
    a=fieldnames(temp.children.SUBJECTS.children);
    for i=1:length(a)
        if strcmp(a{i},'SEX')
            if strcmp(temp.children.SUBJECTS.children.(a{i}).info.values,'M')
                C3D.SubjectParam.(a{i})=-1;
            else
                C3D.SubjectParam.(a{i})=1;
            end
        elseif  strcmp(a{i},'AFFECTED_SIDE')
            if strcmp(temp.children.SUBJECTS.children.(a{i}).info.values,'Right')
                C3D.SubjectParam.(a{i})=-1;
            elseif strcmp(temp.children.SUBJECTS.children.(a{i}).info.values,'Left')
                C3D.SubjectParam.(a{i})=1;
            else
                C3D.SubjectParam.(a{i})=2;
            end
        else
            C3D.SubjectParam.(a{i})=str2num(char(temp.children.SUBJECTS.children.(a{i}).info.values));
        end
    end
    if isfield(C3D.SubjectParam,'ID_FM_Patient')==1
        Subject=1;
    end
end
%% Search trial field in metadata
Subject=0;
if isfield(temp.children,'TRIAL')==1
    a=fieldnames(temp.children.TRIAL.children);
    for i=1:length(a)
        C3D.Trial_info.(a{i})=char(temp.children.TRIAL.children.(a{i}).info.values);
    end
end
%% if no subject fiel not find, search subject param in processing field
% Processing
%if Subject==1
Process=0;
if isfield(temp.children,'PROCESSING')==1
    a=fieldnames(temp.children.PROCESSING.children);
    for i=1:length(a)
        C3D.SubjectParam.(a{i})=temp.children.PROCESSING.children.(a{i}).info.values;
    end
    if isfield(C3D.SubjectParam,'BodyMass')==1
        Process=1;
    end
    
    %end
end

% if strcmp(MANUFACTURER,'Qualisys')
%     if isfield(temp.children,'ANALYSIS')==1
%         if isfield(temp.children.ANALYSIS.children,'VALUES')==1
%             VAL=temp.children.ANALYSIS.children.VALUES.info.values;
%             Names=temp.children.ANALYSIS.children.NAMES.info.values;
%             for i=1:length(VAL)
%                 C3D.SubjectParam.(Names{i})=VAL(i);
%             end
%         end
%     end
% end
% % C3D.SubjectParam=1;




Loc_str=[];
Loc_str=findstr('\', C3D_path);

% C3D.EndFrame=length(C3D.data.(name{1}));

if analog==1
    C3D.analog=btkGetAnalogs(acq);
end

% C3D.Patient_Name=C3D_path(Loc_str(end-2)+1:Loc_str(end-1)-1);
% C3D.Session_Name=C3D_path(Loc_str(end-1)+1:Loc_str(end)-1);

C3D.Patient_Name=C3D.filename(1:5);
C3D.Session_Name=C3D.filename(7:11);
%file info dans enf
% d=dir(C3D_path);
% index=-1;
%
% for i=1:length(d)
%     if strmatch(C3D_filename(1:end-4),d(i).name)==1% '.' C3D_filename(1:end-4) '.enf'
%         Ns=findstr('.',d(i).name);
%         if sum(strcmpi(d(i).name(1:Ns-1),C3D_filename(1:end-4)))==1
%             if strmatch('enf',d(i).name(end-2:end))==1
%                 index =i;
%             end
%         end
%     end
% end
% if index~=-1
%     C3D=get_enf(C3D, char(d(index).name));
% else disp('Pas de fichier .enf');
% end




if isfield(mda.children,'CYCLES')
    % Info gait cycles
    if isfield(mda.children.CYCLES.children,'Left_cycle')
        C3D.LCycle= str2num(mda.children.CYCLES.children.Left_cycle.info.values{1});
    end
    if isfield(mda.children.CYCLES.children,'Right_cycle')
        C3D.RCycle=str2num(mda.children.CYCLES.children.Right_cycle.info.values{1});
    end
else
    C3D.Event= []; % Added Lena 09.11.20202
    C3D.EventFrame= []; % Added Lena 09.11.20202
    C3D.LCycle= []; % Added Lena 09.11.20202
    C3D.RCycle= []; % Added Lena 09.11.20202
    
    % disp('Problem in CYCLES'); % Commented Lena 04.11.2020
    
    % passe_filename=0;
    % if length(C3D_filename)==26
    %     if strcmp(C3D_filename(end-6),'1')==1
    %         file_num=str2num(C3D_filename(end-6:end-4));
    %         passe_filename=1;
    %     else
    %         file_num=str2num(C3D_filename(end-5:end-4));
    %         passe_filename=1;
    %     end
    % end
    % if length(C3D_filename)==27
    %     file_num=str2num(C3D_filename(end-6:end-4));
    %     passe_filename=1;
    % end
    %
    %
    % if passe_filename==1
    %     if strcmp(MANUFACTURER,'Qualisys')
    %         enf_file=[C3D_path C3D_filename(1:end-4) '.qtf'];
    %     else
    %         enf_file=[C3D_path C3D_filename(1:end-4) '.Trial' num2str(file_num) '.enf'];
    %     end
    %     a=fopen(enf_file);
    %     file_num=0;
    %
    %
    %     while a<0
    %         file_num=file_num+1;
    %         if file_num<10
    %             enf_file=[C3D_path C3D_filename(1:end-4) '.Trial0' num2str(file_num) '.enf'];
    %         else
    %             enf_file=[C3D_path C3D_filename(1:end-4) '.Trial' num2str(file_num) '.enf'];
    %         end
    %         a=fopen(enf_file);
    %         if file_num==150
    %             a=0;
    %         end
    %     end
    %
    %     if a>0
    %         C3D.Trial_info=Get_Enf_General(enf_file);
    %         if isfield(C3D.Trial_info,'RCycle')
    %             C3D.RCycle= C3D.Trial_info.RCycle;
    %             if length(C3D.RCycle)==length(C3D.Event.Right_Foot_Strike)-1
    %                 C3D.Valid.R =1;
    %             else disp('Probleme de correspondance dans les cycles selectionnes a droite');
    %             end
    %         end
    %         if isfield(C3D.Trial_info,'LCycle')
    %             C3D.LCycle= C3D.Trial_info.LCycle;
    %             if length(C3D.LCycle)==length(C3D.Event.Left_Foot_Strike)-1
    %                 C3D.Valid.L =1;
    %             else disp('Probleme de correspondance dans les cycles selectionnes a gauche');
    %             end
    %         end
    %
    %     end
    % else disp('Problem in C3D name to read ENF, QTF');
end

%file info enf sur patient
% Separ=findstr('\',C3D_path);
% Patient_Path=C3D_path(1:Separ(end-1));
% d=struct();
% d=dir(Patient_Path);
% index=-1;
%
% for i=3:length(d)
%     Ns=findstr('.',d(i).name);
%     if strmatch('enf',d(i).name(end-2:end))==1
%         index =i;
%     end
% end
% if index~=-1
%     C3D=get_enf_patient(C3D, [Patient_Path d(index).name]);
% else disp('Pas de fichier .enf');
% end
%info patient dans mp
d=struct();
d=dir([C3D_path,'*.mp']);
if  Subject==1 && Process==0;
    passe=0;
    for i=1:length(d)
        if strcmpi(strcat(C3D.SubjectParam.name,'.mp'),d(i).name)==1 % '.' C3D_filename(1:end-4) '.enf'
            C3D=get_mp(C3D, char(d(i).name));
            passe=1;
        end
    end
    if passe==0
        disp('No mp file');
    end
end
%btkDeleteAcquisition(acq);
%fclose(a);
d=[];
d=dir([C3D_path,'*session.qtf']);
if isempty(d)==0
    C3D.Session_info=Get_Enf_General([C3D_path d.name]);
end
a=strfind(C3D(1).pathname,'\');
path_patient=C3D.pathname(1:a(end-1));

d=[];
d=dir([path_patient,'*patient.qtf']);
if isempty(d)==0
    C3D.Patient_info=Get_Enf_General([path_patient d.name]);
end

%end
fclose('all');
clear acq;
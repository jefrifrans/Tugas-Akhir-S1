function varargout = TA(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TA_OpeningFcn, ...
                   'gui_OutputFcn',  @TA_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function TA_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = TA_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)

[namefile,namepath]=uigetfile({'*.*'},'Pick Image LR');

LR=imread([namepath,namefile]);

[rows, column, numberOfColorChannels] = size(LR);

if numberOfColorChannels > 1
    LR = rgb2gray(LR);
end
if mod(rows, 2) == 1
    baris=rows+1;
    LR=imresize(LR,[baris, column],'bilinear');
end
if mod(column,2) == 1
    kolom = column+1;
    LR = imresize(LR, [rows, kolom], "bilinear");
end
if mod(column, 2)==1 && mod(rows,2)==1
    baris =rows+1;
    kolom = column+1;
    LR= imresize(LR, [baris, kolom], 'bilinear');
end

handles.LR=LR;
guidata(hObject,handles);

set(handles.edit1,'String',[namepath,namefile]);
axes(handles.axes1);
colormap gray;
imshow(LR);
title(handles.axes1,'LR');

function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton2_Callback(hObject, eventdata, handles)

[namefile,namepath]=uigetfile({'*.*'},'Pick Image HR');
HR=imread([namepath,namefile]);
[~, ~, numberOfColorChannels] = size(HR);
if numberOfColorChannels > 1
    HR = rgb2gray(HR);
end
handles.HR=HR;
guidata(hObject,handles);
set(handles.url,'String',[namepath,namefile])

function url_Callback(hObject, eventdata, handles)

function url_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function wavelet_Callback(hObject, eventdata, handles)

function wavelet_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function menu_Callback(hObject, eventdata, handles)

function menu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function perbesaran_Callback(hObject, eventdata, handles)

function perbesaran_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valuepsnr_Callback(hObject, eventdata, handles)

function valuepsnr_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valuecorr_Callback(hObject, eventdata, handles)

function valuecorr_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valuessim_Callback(hObject, eventdata, handles)

function valuessim_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pushbutton3_Callback(hObject, eventdata, handles)

LR=handles.LR;
HR=handles.HR;

wavelet_ = get(handles.wavelet, 'value');
if wavelet_ == 1
    wavelet_family = 'haar';
elseif wavelet_ ==2
    wavelet_family = 'sym2';
end

interpolasi_metode = get(handles.menu, 'value');

if interpolasi_metode == 1
    interpolasi ='bicubic';
elseif interpolasi_metode == 2
    interpolasi ='bilinear';
elseif interpolasi_metode == 3
    interpolasi = 'nearest';
end

besar=get(handles.perbesaran, 'value');

%perbesaran 2 kali
if besar==1
%dekomposisi wavelet
    [~, LH_s, HL_s, HH_s] = swt2(LR,1,wavelet_family);

    [~, LH_d, HL_d, HH_d] = dwt2(LR,wavelet_family);

%interpolasi citra
    LH_d = imresize(LH_d, size(LR), interpolasi);
    HL_d = imresize(HL_d, size(LR), interpolasi);
    HH_d = imresize(HH_d, size(LR), interpolasi);

%estimasi citra
    LL_est = imresize(LR, size(LH_d),interpolasi)*2;
    LH_est = imadd(LH_d,LH_s);
    HL_est = imadd(HL_d, HL_s);
    HH_est = imadd(HH_d, HH_s);

%rekontruksi
    sr_img = idwt2(LL_est, LH_est, HL_est, HH_est, wavelet_family, size(HR));

%uint8
    sr_image = uint8(sr_img);
    handles.sr_image=sr_image;

%perbesaran 4 kali

elseif besar == 2

%dekomposisi wavelet
    [~, LH_s, HL_s, HH_s] = swt2(LR,1,wavelet_family);

    [~, LH_d, HL_d, HH_d] = dwt2(LR,wavelet_family);

%interpolasi citra
    LH_d = imresize(LH_d, size(LR), interpolasi);
    HL_d = imresize(HL_d, size(LR), interpolasi);
    HH_d = imresize(HH_d, size(LR), interpolasi);

%estimasi citra
    LL_est = imresize(LR, size(LH_d),interpolasi)*2;
    LH_est = imadd(LH_d,LH_s);
    HL_est = imadd(HL_d, HL_s);
    HH_est = imadd(HH_d, HH_s);

%rekontruksi pertama
    sr_img = idwt2(LL_est, LH_est, HL_est, HH_est, wavelet_family, size(HR));
    sr_img2 = uint8(sr_img);
    
    [~, LH_s, HL_s, HH_s] = swt2(sr_img2,1,wavelet_family);

    [~, LH_d, HL_d, HH_d] = dwt2(sr_img2,wavelet_family);

%interpolasi citra
    LH_d = imresize(LH_d, size(sr_img2), interpolasi);
    HL_d = imresize(HL_d, size(sr_img2), interpolasi);
    HH_d = imresize(HH_d, size(sr_img2), interpolasi);

%estimasi citra
    LL_est = imresize(sr_img2, size(LH_d),interpolasi)*2;
    LH_est = imadd(LH_d,LH_s);
    HL_est = imadd(HL_d, HL_s);
    HH_est = imadd(HH_d, HH_s);

%rekontruksi
    sr_image = idwt2(LL_est, LH_est, HL_est, HH_est, wavelet_family, size(HR));
    sr_image= uint8(sr_image);

    handles.sr_image = sr_image;
    guidata(hObject,handles);
end

if size(HR)==size(sr_image)
   %psnr
    peaksnr=psnr(HR, sr_image);
    set(handles.valuepsnr,'String',peaksnr);

    %ssim
    R=corr2(sr_image, HR);
    set(handles.valuecorr, 'String',R);

    %corr
    ssimval = ssim(sr_image,HR);
    set(handles.valuessim, 'String', ssimval);
else
    set(handles.valuepsnr,'String',"None");
    set(handles.valuecorr, 'String',"None");
    set(handles.valuessim, 'String',"None");
end

%show image SR
sr_image=handles.sr_image;
guidata(hObject,handles);
axes(handles.axes2);
imshow(sr_image,[]);
title(handles.axes2,'SR');

function axes3_CreateFcn(hObject, eventdata, handles)
imshow('ITS.jpg');

function axes4_CreateFcn(hObject, eventdata, handles)
imshow('MTK_ITS.jpg')

function pushbutton4_Callback(hObject, eventdata, handles)
sr_image=handles.sr_image;
sr_image=uint8(sr_image);

[filename, foldername] = uiputfile('Where do you want the file saved?');
complete_name = fullfile(foldername, filename);
imwrite(sr_image, complete_name);

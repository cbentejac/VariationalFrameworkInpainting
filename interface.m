function varargout = interface(varargin)
% INTERFACE MATLAB code for interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface

% Last Modified by GUIDE v2.5 20-Dec-2017 11:26:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface (see VARARGIN)

% Choose default command line output for interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback( ~, ~, ~)
% ===================== Median ============================
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback( ~, ~, ~)
% ====================== Mean ============================
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback( ~, ~, ~)
% ==================== Poisson ===========================
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes during object creation, after setting all properties.
function uibuttongroup1_CreateFcn( ~,  ~, ~)
% ================= Method ===========================
% hObject    handle to uibuttongroup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback( ~, ~, handles)
%==================  Start ====================
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%recuperation méthode
median = 0;
mean = 0;
poisson = 0;
choix1 = get (handles.uibuttongroup1, 'SelectedObject');
choix2 = char (get (choix1, 'String'));
if (strcmp (choix2, 'Median'))
    median = 1;
end
if (strcmp (choix2, 'Mean'))
    mean = 1;
end
if (strcmp (choix2, 'Poisson'))
    poisson = 1;
end
%récupération image et mask
name_image = get(handles.edit1,'string');
if (~exist (char(name_image)))
    errordlg ('Impossible to read the image', 'Error', 'modal');
    return
end
I = imread(char(name_image));
choix1_mask = get(handles.uibuttongroup2,'SelectedObject');
choix2_mask = char (get (choix1_mask, 'String'));
name_mask = get(handles.edit2,'string');
if (strcmp(choix2_mask,'Yes'))
    if (~exist (char(name_mask)))
        errordlg ('Impossible to read the mask', 'Error', 'modal');
        return
    end
    M = imread(char(name_mask));
else
    figure
    M = roipoly(I);
    close
end
%récupération paramètres + vérification entrées de l'utilisateur
[m,n,~] = size(I);
size_patch = str2double(get(handles.edit6, 'string'));
if (isnan(size_patch))
    errordlg ('The size of the patch must be an integer','Error','modal');
    return
end
if (mod(size_patch,2) == 0)
   errordlg ('The size of the patch must be odd','Error','modal');
   return
end
if (size_patch > m || size_patch > n || size_patch < 0)
    errordlg ('The size of the patch must be an integer greater than or equal to 0','Error','modal');
    return
end
L = str2double(get(handles.edit5, 'string'));
if (isnan(L) || L <= 0)
    errordlg ('The number of level for multiscale scheme must be an integer greater than or equal to 1','Error','modal');
    return
end
lambda = str2double(get(handles.edit3, 'string'));
if (isnan(lambda))
    errordlg ('Lambda must be real','Error','modal');
    return
end
if (lambda > 1 || lambda < 0)
    errordlg ('Lambda must be real between 0 and 1','Error','modal');
    return
end
msgbox ('In process');
%appel de la fonction variationnal framework
[I_final,~] = variational_framework (I, M, size_patch, L, median, average, poisson);
msgbox ('It''s done :)');
figure
imagesc (I_final)



function edit1_Callback(~, ~, ~)
% ================ Image =========================
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, ~)
% ================ Image =========================
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(~, ~, ~)
% ================ Mask =========================
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~)
% ================ Mask =========================
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(~, ~, ~)
% ================== lambda =======================
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, ~, ~)
% ================== lambda =======================
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback( ~, ~, ~)
% ================== multiscale =======================
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, ~, ~)
% ================== multiscale =======================
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback( ~, ~, ~)
% =============== size_patch ==================
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, ~, ~)
% =============== size_patch ==================
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function uibuttongroup2_CreateFcn(hObject, eventdata, handles)
%===================== Yes/No mask =========================
% hObject    handle to uibuttongroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msg =  {'Usage for Variational Framework for Non-Local Inpainting',...
    '',...
    'The panel method allow to choose the patch error function between Median, Mean and Poisson.',...
    'The panel parameters allows to choose differents parameters :',...
    '   -Lambda must be a real number between 0 et 1.',...
    '   -The number of level for the multiscale scheme must be a integer greater than or equal to 1.',...
    '   -The size of the patch must be an odd integer greater than or equal to 1 and lower than the size of the image.',...
    'The panel image allows to give the name of the input image.',...
    'The panel mask allows to give the name of the file of the input mask. Given a mask is optinal, the user have to precise if he gives a mask or not using the radio button Yes and No.'};
helpdlg (msg, 'Usage');

function varargout = Viewer(varargin)
% VIEWER MATLAB code for Viewer.fig
%      VIEWER, by itself, creates a new VIEWER or raises the existing
%      singleton*.
%
%      H = VIEWER returns the handle to a new VIEWER or the handle to
%      the existing singleton*.
%
%      VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWER.M with the given input arguments.
%
%      VIEWER('Property','Value',...) creates a new VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Viewer_OpeningFcn via varargin. 
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Viewer

% Last Modified by GUIDE v2.5 13-Mar-2019 09:44:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Viewer_OpeningFcn, ...
    'gui_OutputFcn',  @Viewer_OutputFcn, ...
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
end
% End initialization code - DO NOT EDIT

% --- Executes just before Viewer is made visible.
function Viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Viewer (see VARARGIN)

% Choose default command line output for Viewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

hold(handles.BscanPlot,'on');
hold(handles.EnFace,'on');
hold(handles.Angio,'on');

set(hObject, ...
    'WindowButtonDownFcn',   @mouseDownCallback, ...
    'WindowButtonUpFcn',     @mouseUpCallback,   ...
    'WindowButtonMotionFcn', @mouseMotionCallback);


% UIWAIT makes Viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = Viewer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on selection change in size.
function size_Callback(hObject, ~, handles)
contents = cellstr(get(hObject,'String'));
selectedSize = contents{get(hObject,'Value')};
switch selectedSize
    case '3 x 3'
        handles.scanSize  = 3;
    case '6 x 6'
        handles.scanSize = 6;
end
guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function size_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
%% ====================================== Load ====================================== %%
%% ======================================= // ======================================= %%
function Load_Callback(hObject, eventdata, handles)
%% syntax %%
%%if the file name ends with ... then load the saved state
%first load the images and then map the drawing handles, areas of drawn
% [handles.filename_1, handles.path1] = uigetfile('*.*', 'multiselect', 'off');
% [~,~,EXT] = fileparts(handles.filename_1);
% if ~strcmp(EXT, '.mat')
%     [handles.filename_2, handles.path2] = uigetfile('*.*', 'multiselect', 'on');
%     [handles.filename_3, handles.path3] = uigetfile('*.*', 'multiselect', 'on');
%     handles.numSaved = 0;
%     guidata(hObject, handles);
% else
%     close;
%     load (handles.filename_1);
%     return;
% end


[fnames, path] = uigetfile('*.*', 'multiselect', 'on');
if size(fnames,2) == 2
    handles.filename_1 = fnames{1};
    handles.filename_2 = fnames{2};
    handles.path1 = path;
    handles.path2 = path;
    [handles.filename_3, handles.path3] = uigetfile('*.*', 'multiselect', 'on');
else
    [~,~,EXT] = fileparts(fnames);
    if ~strcmp(EXT,'.mat')
        handles.filename_1 = fnames;
        handles.path1 = path;
        [handles.filename_2, handles.path2] = uigetfile('*.*', 'multiselect', 'on');
        [handles.filename_3, handles.path3] = uigetfile('*.*', 'multiselect', 'on');
    else
        close;
        load (fnames);
%         load(fullfile(path,fnames));
        return;
    end
end


%  set(handles(1).edit1, 'string', unp_path);
%     guidata(hObject, handles);

img1 = imread([handles.path1 handles.filename_1]);
img1 = imresize(img1, [500 500]);
axes(handles.BscanPlot);
imshow(img1);%,'XData',[0 100],'YData',[0 100]);
hold on
a=size(img1,1)/2;
line1=line([a,a],[0,500],'Color','red','LineWidth',1);
y1 = line([0,500],[a,a],'Color','green','LineWidth',1);
% line1=line([a,a],get(handles.BscanPlot,'Xlim'),'Color','red','LineWidth',1);
% y1 = line(get(handles.BscanPlot,'Ylim'),[a,a],'Color','green','LineWidth',1);
handles.plotHandles = [];
handles.plotHandles = [handles.plotHandles ; line1 ; y1];
guidata(hObject, handles);
hold off

img2 = imread([handles.path2 handles.filename_2]);
img2 = imresize(img2, [500 500]);
axes(handles.EnFace)
imshow(img2);%,'XData',[0 100],'YData',[0 100]);
hold on
line2 = line([a a],[0 500],'Color','red','LineWidth',1);
y2 = line([0 500],[a a],'Color','green','LineWidth',1);
% line2=line([a,a],get(handles.EnFace,'Xlim'),'Color','red','LineWidth',1);
% y2 = line(get(handles.EnFace,'Xlim'),[a,a],'Color','green','LineWidth',1);
handles.plotHandles = [handles.plotHandles ; line2 ; y2];
guidata(hObject, handles);
hold off

%save images into handles
handles.images = [];
pixels1 = numel(img1);
handles.images = pixels1;

options.numAscans   = 1536;
% 6x6 options:
if handles.scanSize == 6
    options.numPoints   = 500;
    options.numBscans   = 500;
% For the 3x3 data:
elseif handles.scanSize == 3
    options.numPoints   = 300;
    options.numBscans   = 300;
end

ProcdData = proCplxOCT_Zeiss2([handles.path3 handles.filename_3], options);
handles.volume = [];

%img3 = imread([path3 filename_3]);
%img3 = imresize(img3, [600 600]);
axes(handles.Angio)
%imshow(img3)%,'XData',[0 100],'YData',[0 100]);
for i = 1:size(ProcdData, 3)
    volume(:, :, i) = flip(mat2gray(imresize(ProcdData(:, :, i),[500 500])),2);
end
handles.volume = volume;

imshow(mat2gray(volume(:,:,a))); colormap(gray);
hold on
line3 = line([a,a],[0,500],'Color','red','LineWidth',1);
%y3 = line([0 600],[a a],'Color','green','LineWidth',1);
handles.plotHandles = [handles.plotHandles ; line3];

guidata(hObject, handles);
hold off

guidata(hObject, handles);
disp('placeholder');
end

% --- Executes on button press in scroll.
function scroll_Callback(hObject, eventdata, handles)
% hObject    handle to scroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button_state = get(hObject,'Value');
handles.bstate = button_state;

guidata(hObject, handles);
end

function mouseDownCallback(figHandle,varargin)
% get the handles structure
handles = guidata(figHandle);
% get the position where the mouse button was pressed (not released)
% within the GUI

%if handles.bstate == 1

    currentPoint = get(figHandle, 'CurrentPoint');
    x            = currentPoint(1,1);
    y            = currentPoint(1,2);
    
    % get the position of the axes within the GUI

    % DIFFERENT AXES
    axesPos1 = get(handles.BscanPlot,'Position');
    %axesPos = get(handles.EnFace,'Position');

    minx1    = axesPos1(1);
    miny1    = axesPos1(2);
    maxx1    = minx1 + axesPos1(3);
    maxy1    = miny1 + axesPos1(4);

    % is the mouse down event within the axes?
    if x>=minx1 && x<=maxx1 && y>=miny1 && y<=maxy1
        % do we have graphics objects?
        if isfield(handles,'plotHandles')
            % get the position of the mouse down event within the axes

            % DIFF AXES
            currentPoint = get(handles.BscanPlot, 'CurrentPoint');
            %currentPoint = get(handles.EnFace, 'CurrentPoint');

            x            = currentPoint(2,1);
            y            = currentPoint(2,2);
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            minDist      = Inf;
            minHndl      = 0;
            for k=1:2
                xData = get(handles.plotHandles(k),'XData');
                yData = get(handles.plotHandles(k),'YData');
                dist  = min((xData-x).^2+(yData-y).^2);
                if dist<minDist
                    minHndl = handles.plotHandles(k);
                    minDist = dist;
                end
            end
            % if we have a graphics handle that is close to the mouse down
            % event/position, then save the data
            if minHndl~=0
                handles.mouseIsDown     = true;
                handles.movingPlotHndle = minHndl;
                handles.prevPoint       = [x y];
                guidata(figHandle,handles);
            end
        end
    end

    % get the position of the axes within the GUI

    % DIFFERENT AXES
    axesPos2 = get(handles.EnFace,'Position');

    minx2    = axesPos2(1);
    miny2    = axesPos2(2);
    maxx2    = minx2 + axesPos2(3);
    maxy2    = miny2 + axesPos2(4);

    % is the mouse down event within the axes?
    if x>=minx2 && x<=maxx2 && y>=miny2 && y<=maxy2
        % do we have graphics objects?
        if isfield(handles,'plotHandles')
            % get the position of the mouse down event within the axes

            % DIFF AXES
            currentPoint = get(handles.EnFace, 'CurrentPoint');

            x            = currentPoint(2,1);
            y            = currentPoint(2,2);
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            minDist      = Inf;
            minHndl      = 0;
            for k=3:4
                xData = get(handles.plotHandles(k),'XData');
                yData = get(handles.plotHandles(k),'YData');
                dist  = min((xData-x).^2+(yData-y).^2);
                if dist<minDist
                    minHndl = handles.plotHandles(k);
                    minDist = dist;
                end
            end
            % if we have a graphics handle that is close to the mouse down
            % event/position, then save the data
            if minHndl~=0
                handles.mouseIsDown     = true;
                handles.movingPlotHndle = minHndl;
                handles.prevPoint       = [x y];
                guidata(figHandle,handles);
            end
        end
    end


    % DIFFERENT AXES
    axesPos1 = get(handles.Angio,'Position');
    %axesPos = get(handles.EnFace,'Position');

    minx1    = axesPos1(1);
    miny1    = axesPos1(2);
    maxx1    = minx1 + axesPos1(3);
    maxy1    = miny1 + axesPos1(4);

    % is the mouse down event within the axes?
    if x>=minx1 && x<=maxx1 && y>=miny1 && y<=maxy1
        % do we have graphics objects?
        if isfield(handles,'plotHandles')
            % get the position of the mouse down event within the axes

            % DIFF AXES
            currentPoint = get(handles.Angio, 'CurrentPoint');
            %currentPoint = get(handles.EnFace, 'CurrentPoint');

            x            = currentPoint(2,1);
            y            = currentPoint(2,2);
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            minDist      = Inf;
            minHndl      = 0;
            xData = get(handles.plotHandles(5),'XData');
            yData = get(handles.plotHandles(5),'YData');
            dist  = min((xData-x).^2+(yData-y).^2);
            if dist<minDist
                minHndl = handles.plotHandles(5);
            end
            % if we have a graphics handle that is close to the mouse down
            % event/position, then save the data
            if minHndl~=0
                handles.mouseIsDown     = true;
                handles.movingPlotHndle = minHndl;
                handles.prevPoint       = [x y];
                guidata(figHandle,handles);
            end
        end
    end
end

function mouseUpCallback(figHandle,varargin)
% get the handles structure
handles = guidata(figHandle);

if isfield(handles,'bstate')
    
if handles.bstate == 1
 
    if isfield(handles,'mouseIsDown')
        if handles.mouseIsDown
            % reset all moving graphic fields
            handles.mouseIsDown     = false;
            handles.movingPlotHndle = [];
            handles.prevPoint       = [];
            % save the data
            guidata(figHandle,handles);
        end
    end
end
end
end

function mouseMotionCallback(figHandle,varargin)
% get the handles structure
handles = guidata(figHandle);

if isfield(handles,'bstate')

if handles.bstate == 1
    
    if ( isfield(handles, 'volume'))
        volume = handles.volume;
    end

    if isfield(handles,'mouseIsDown')
        if handles.mouseIsDown

            if handles.movingPlotHndle == handles.plotHandles(1) || handles.movingPlotHndle == handles.plotHandles(2)

                %DIFF AXES
                currentPoint = get(handles.BscanPlot, 'CurrentPoint');
                %currentPoint = get(handles.EnFace, 'CurrentPoint');

                x            = currentPoint(2,1);
                y            = currentPoint(2,2);
                % compute the displacement from previous position to current
                xDiff = x - handles.prevPoint(1);
                yDiff = y - handles.prevPoint(2);
                % adjust this for the data corresponding to movingPlotHndle
                xData = get(handles.movingPlotHndle,'XData');
                yData = get(handles.movingPlotHndle,'YData');
                %set(handles.movingPlotHndle,'YData',yData+yDiff,'XData',xData+xDiff);
                if handles.movingPlotHndle == handles.plotHandles(2) % || handles.movingPlotHndle == handles.plotHandles(4)
                    if (yData(1)+yDiff < 500 && yData(1)+yDiff > 0)
                        set(handles.movingPlotHndle,'YData',round(yData+yDiff));
                        set(handles.plotHandles(4),'YData',round(yData+yDiff));
                        yval = yData + yDiff;
                        round(yval);
                        axes(handles.Angio)
                        %                     volume(:,:,round(yval(1))) = imresize(volume(:,:,round(yval(1))),[500 500]);
                        hold on
                        imshow(volume(:,:,round(yval(1)))); colormap(gray);
                        line3 = line(get(handles.plotHandles(1),'XData'),[0,500],'Color','red','LineWidth',1);
                        handles.plotHandles(5) = line3;
                    end
                end
                if handles.movingPlotHndle == handles.plotHandles(1) % || handles.movingPlotHndle == handles.plotHandles(3)
                    if (xData(1)+xDiff < 500 && xData(1)+xDiff > 0)
                        set(handles.movingPlotHndle,'XData',xData+xDiff);
                        set(handles.plotHandles(3),'XData',xData+xDiff);
                        set(handles.plotHandles(5),'XData',xData+xDiff);
                    end
                end
                handles.prevPoint = [x y];
                % save the data
                guidata(figHandle,handles);

            end

            if handles.movingPlotHndle == handles.plotHandles(3) || handles.movingPlotHndle == handles.plotHandles(4)

                %DIFF AXES
                currentPoint = get(handles.EnFace, 'CurrentPoint');

                x            = currentPoint(2,1);
                y            = currentPoint(2,2);

                % compute the displacement from previous position to current
                xDiff = x - handles.prevPoint(1);
                yDiff = y - handles.prevPoint(2);

                % adjust this for the data corresponding to movingPlotHndle
                xData = get(handles.movingPlotHndle,'XData');
                yData = get(handles.movingPlotHndle,'YData');
                %set(handles.movingPlotHndle,'YData',yData+yDiff,'XData',xData+xDiff);

                if handles.movingPlotHndle == handles.plotHandles(4)
                    if (yData(1)+yDiff < 500 && yData(1)+yDiff > 0)
                        set(handles.movingPlotHndle,'YData',round(yData+yDiff));
                        set(handles.plotHandles(2),'YData',round(yData+yDiff));
                        yval = yData + yDiff;
                        round(yval);
                        axes(handles.Angio)
                        %                     volume(:,:,round(yval(1))) = imresize(volume(:,:,round(yval(1))),[500 500]);
                        hold on
                        imshow(volume(:,:,round(yval(1)))); colormap(gray);
                        line3 = line(get(handles.plotHandles(1),'XData'),[0,500],'Color','red','LineWidth',1);
                        handles.plotHandles(5) = line3;
                        %hold off
                        %                     line3 = line([xData+xDiff,xData+xDiff],[0,500],'Color','red','LineWidth',1);
                        %                     handles.plotHandles(5) = line3;
                    end
                end

                if handles.movingPlotHndle == handles.plotHandles(3)
                    if (xData(1)+xDiff < 500 && xData(1)+xDiff > 0)
                        set(handles.movingPlotHndle,'XData',xData+xDiff);
                        set(handles.plotHandles(1),'XData',xData+xDiff);
                        set(handles.plotHandles(5),'XData',xData+xDiff);
                    end
                end

                handles.prevPoint = [x y];
                % save the data
                guidata(figHandle,handles);

            end

            if handles.movingPlotHndle == handles.plotHandles(5)

                %DIFF AXES
                currentPoint = get(handles.Angio, 'CurrentPoint');
                x            = currentPoint(2,1);
                y            = currentPoint(2,2);

                % compute the displacement from previous position to current
                xDiff = x - handles.prevPoint(1);
                yDiff = y - handles.prevPoint(2);

                % adjust this for the data corresponding to movingPlotHndle
                xData = get(handles.movingPlotHndle,'XData');
                yData = get(handles.movingPlotHndle,'YData');

                %set(handles.movingPlotHndle,'YData',yData+yDiff,'XData',xData+xDiff);
                %             if handles.movingPlotHndle == handles.plotHandles(5) % || handles.movingPlotHndle == handles.plotHandles(4)
                %                 if (yData(1)+yDiff < 600 && yData(1)+yDiff > 0)
                %                     set(handles.movingPlotHndle,'YData',yData+yDiff);
                %                     set(handles.plotHandles(2),'YData',yData+yDiff);
                %                     set(handles.plotHandles(4),'YData',yData+yDiff);
                %                     yval = yData + yDiff
                %                 end
                %             end

                if (xData(1)+xDiff < 500 && xData(1)+xDiff > 0)
                    set(handles.movingPlotHndle,'XData',xData+xDiff);
                    set(handles.plotHandles(1),'XData',xData+xDiff);
                    set(handles.plotHandles(3),'XData',xData+xDiff);
                end

                handles.prevPoint = [x y];
                % save the data
                guidata(figHandle,handles);

            end

        end
    end
end
end
end

% --- Executes on button press in save.


% --- Executes on button press in draw.
function draw_Callback(hObject, eventdata, handles)
% hObject    handle to draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'drawings')
    handles.drawings = [];
end

image1 = handles.images;

% if handles.movingPlotHndle == handles.plotHandles(5)
%     axes(handles.Angio)
% elseif handles.movingPlotHndle == handles.plotHandles(3) || handles.movingPlotHndle == handles.plotHandles(4)
%     axes(handles.EnFace)
% else
%     axes(handles.BscanPlot)
% end

%h = drawfreehand('LineWidth',1,'FaceAlpha',0,'Color','y','DrawingArea','unlimited');
h = imfreehand();
handles.binaryImage = h.createMask();
numOfPixels = bwarea(handles.binaryImage);
% assignin('base','handles.binaryImage',handles.binaryImage)
handles.drawings = [handles.drawings,h];
guidata(hObject,handles);

%Changes made to calculation of areaPerPixel
%OLD: areaPerPixel = (handles.scanSize / image1)^2;
%NEW: 
areaPerPixel = handles.scanSize^2 / image1;

[z,countDrawings] = size(handles.drawings);

if isfield(handles,'numSaved')
    if (countDrawings == 0 && handles.numSaved == 0)
        handles.areaOfDrawn = zeros(1, 1);
    end
    handles.areaOfDrawn(countDrawings+handles.numSaved) = areaPerPixel * numOfPixels;
else
    if countDrawings == 0
        handles.areaOfDrawn = zeros(1, 1);
    end
    handles.areaOfDrawn(countDrawings) = areaPerPixel * numOfPixels;
end

set(handles.areaOfDrawnRegion2,'String',num2str(handles.areaOfDrawn));
guidata(hObject,handles);
end

function save_Callback(hObject, eventdata,handles)
defaultFileName = fullfile(userpath, '*.*');
[fileName] = uiputfile(defaultFileName, 'Save as');
if fileName == 0
  %User clicked the Cancel button
  return;
end
set(handles.save,'value',0);
[~,handles.numSaved] = size(handles.drawings);
guidata(hObject, handles);
save(fileName, 'handles');
end

% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
[z,last] = size(handles.drawings);
delete(handles.drawings(last));
handles.areaOfDrawn(last) = [];
guidata(hObject,handles);
set(handles.areaOfDrawnRegion2,'String',num2str(handles.areaOfDrawn));
end

% --- Executes on button press in actualclear.
function actualclear_Callback(hObject, eventdata, handles)
delete(handles.drawings);
handles.drawings = [];
if isfield(handles,'numSaved')
    if (handles.numSaved ~= 0)
        temp = handles.areaOfDrawn(:, 1:handles.numSaved);
        handles.areaOfDrawn = [];
        handles.areaOfDrawn = temp;
        set(handles.areaOfDrawnRegion2,'String', handles.areaOfDrawn);
    else
        handles.areaOfDrawn = [];
        set(handles.areaOfDrawnRegion2,'String', '');
    end
else
    handles.areaOfDrawn = [];
    set(handles.areaOfDrawnRegion2,'String', '');
end
    
guidata(hObject,handles);
end
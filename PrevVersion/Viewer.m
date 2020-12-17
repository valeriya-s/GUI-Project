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

% Last Modified by GUIDE v2.5 01-Feb-2019 15:33:59

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


% --- Outputs from this function are returned to the command line.
function varargout = Viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% ====================================== Load ====================================== %%
%% ======================================= // ======================================= %%
function Load_Callback(hObject, eventdata, handles)
%% syntax %%

[filename_1, path1] = uigetfile('*.*', 'multiselect', 'on');
[filename_2, path2] = uigetfile('*.*', 'multiselect', 'on');
[filename_3, path3] = uigetfile('*.*', 'multiselect', 'on');

%  set(handles(1).edit1, 'string', unp_path);
%     guidata(hObject, handles);

img1 = imread([path1 filename_1]);
%img1 = imresize(img1, [600 600]);
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

img2 = imread([path2 filename_2]);
%img2 = imresize(img2, [600 600]);
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

% 6x6 options:
options.numPoints   = 500;
options.numAscans   = 1536;
options.numBscans   = 500;

% For the 3x3 data:
% options.numPoints   = 300;
% options.numAscans   = 1536;
% options.numBscans   = 300;

ProcdData = proCplxOCT_Zeiss2([path3 filename_3], options);
handles.volume = [];

%img3 = imread([path3 filename_3]);
%img3 = imresize(img3, [600 600]);
axes(handles.Angio)
%imshow(img3)%,'XData',[0 100],'YData',[0 100]);
for i = 1:size(ProcdData, 3)
    volume(:, :, i) = mat2gray(imresize(ProcdData(:, :, i),[500 500]));
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


function mouseDownCallback(figHandle,varargin)
    % get the handles structure
    handles = guidata(figHandle);
    % get the position where the mouse button was pressed (not released)
    % within the GUI
    currentPoint = get(figHandle, 'CurrentPoint');
    x            = currentPoint(1,1);
    y            = currentPoint(1,2);
    
%     % get the position of the axes within the GUI
%     
%     % DIFFERENT AXES
%     axesPos = get(handles.BscanPlot,'Position');
%     %axesPos = get(handles.EnFace,'Position');
%     
%     minx    = axesPos(1);
%     miny    = axesPos(2);
%     maxx    = minx + axesPos(3);
%     maxy    = miny + axesPos(4);
%     
%     % is the mouse down event within the axes?
%     if x>=minx && x<=maxx && y>=miny && y<=maxy 
%         % do we have graphics objects?
%         if isfield(handles,'plotHandles')
%             % get the position of the mouse down event within the axes
%             
%             % DIFF AXES
%             currentPoint = get(handles.BscanPlot, 'CurrentPoint');
%             %currentPoint = get(handles.EnFace, 'CurrentPoint');
%             
%             x            = currentPoint(2,1);
%             y            = currentPoint(2,2);
%             % we are going to use the x and y data for each graphic object
%             % and determine which one is closest to the mouse down event
%             minDist      = Inf;
%             minHndl      = 0;
%            for k=1:length(handles.plotHandles)
%                xData = get(handles.plotHandles(k),'XData');
%                yData = get(handles.plotHandles(k),'YData');
%                dist  = min((xData-x).^2+(yData-y).^2);
%                if dist<minDist
%                    minHndl = handles.plotHandles(k);
%                    minDist = dist;
%                end
%            end
%            % if we have a graphics handle that is close to the mouse down
%            % event/position, then save the data
%            if minHndl~=0
%                handles.mouseIsDown     = true;
%                handles.movingPlotHndle = minHndl;
%                handles.prevPoint       = [x y];
%                guidata(figHandle,handles);
%            end
%         end
%     end

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

function mouseUpCallback(figHandle,varargin)
    % get the handles structure
    handles = guidata(figHandle);
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
    
function mouseMotionCallback(figHandle,varargin)
    % get the handles structure
    handles = guidata(figHandle);
    
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


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in draw.
function draw_Callback(hObject, eventdata, handles)
% hObject    handle to draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.BscanPlot);
h = drawfreehand('LineWidth',1,'FaceAlpha',0);

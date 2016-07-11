function [handles] = imshow4(varargin)
% Function for 2D, 3D or 4D image display. Required Matlab version 2012a
% or newer. Recomended Matlab 2013a or newer.
% -------------------------------------------------------------------------
% imshow4(im) - show 2D, 3D or 4D image with default settings
% imshow4(im,slice) - show 3D or 4D image with default settings with
% started at slice number
% imshow4(im,slice,ref_time) - show 3D or 4D image with default settings
% with started at slice number and reference time sample
% imshow4(im,slice,ref_time,range) - show 4D image with default settings
% with started at slice number and reference time sample with specified
% intensity range settings
% imshow4(im,slice,ref_time,range,colormaps) - show 4D image with default
% settings with started at slice number and reference time sample with
% specified intensity range and colormap settings
% imshow4(im,slice,ref_time,range,colormaps,time) - show 4D image time
% fusion, where time is second image inital time sample
% imshow4(im,slice,ref_time,range,colormaps,time,method) - show 4D image
% time fusion, method is same as method in imfuse function
% -------------------------------------------------------------------------
% im - input image 2D/3D/4D
% slice - number of slice (default = 1)
% ref_time - number of reference time sample (default = 1)
% range - intensity range - 'all'/0/[x,y]/'norm'
% (default = 'all' - same as imshow(im,[]))
% colormaps - same as colormap function parameters - 'jet',...0 - def.
% (default = 'gray')
% time - number of time sample (default = 1)
% method - method from imfuse function -
% 'falsecolor'/'blend'/'diff'/'montage' (default = 'falsecolor')
global slice time im mode_out inter colormaps isfused contexte_image

im = varargin{1};
N = nargin;
slice = 1;
time = 1;
ref_time = 1;
range = 'all';
mode_out = 0;
method = 'falsecolor';
inter = 0;
%h = figure('Position',get(0,'ScreenSize'),'WindowStyle','docked','Interruptible','off');
colormaps = colormap('gray');
isfused = 0;

%Ajout ci-dessous
imzobr = im(:,:,slice,time);

contexte_image = varargin{2};
handles = varargin{3};

%set(handles.image,'UserData',imzobr);
%set(handles.image.Children,'CData',imzobr);
%set(handles.image.Children,'CDataMapping','direct');
delete(get(handles.image, 'Children'));

hIm = image(flipud(imzobr));

copyobj(hIm,handles.image);

uicontextmenu = get(handles.image,'UIContextMenu');
set(handles.image.Children,'UIContextMenu',uicontextmenu);

%Ajout
axes(handles.image);

%figure(h)
%set(h,'Name',['Z=' num2str(slice) '/' num2str(size(im,3)) ', t=' num2str(time) '/' num2str(size(im,4))])




xlabel('Axe des X')
ylabel('Axe des Y')
title('Transversal view: \leftarrow\rightarrow = Z-axis, \uparrow\downarrow = t-axis, 0-5 = view')
%set(h,'Colormap',colormaps);
if size(im,3)>1 || size(im,4)>1
    %set(h,'KeyPressFcn',{@kresli,h,range,N,ref_time,method})
    set(handles.figure1,'KeyPressFcn',{@kresli,handles.figure1,range,N,ref_time,method,handles})
end;
end

function kresli(~,eventdata,h,range,N,ref_time,method,handles)
global slice time im mode_out inter colormaps isfused
rng=size(im,3);
rng=[1 rng];
rng_t=size(im,4);
rng_t=[1 rng_t];
if slice>=min(rng) && slice<=max(rng) && time>=min(rng_t) && time<=max(rng_t)
    switch eventdata.Key
        case  'rightarrow'
            slice=slice+1;
            if slice>max(rng)
                slice=max(rng);
            end
        case 'leftarrow'
            slice=slice-1;
            if slice<min(rng)
                slice=min(rng);
            end
        case 'downarrow'
            time=time-1;
            if time<min(rng_t)
                time=min(rng_t);
            end
        case 'uparrow'
            time=time+1;
            if time>max(rng_t)
                time=max(rng_t);
            end
        case {'0','numpad0'}
            if mode_out ~= 0;
            im = ipermutation(im,mode_out);
            end;
            mode_out = 0;
            inter = 0;
        case {'1','numpad1'}
            mode_in = 1;
            if mode_in ~= mode_out
            im = ipermutation(im,mode_out);
            im = permutation(im,mode_in);
            end;
            mode_out = 1;
            inter = 0;
        case {'2','numpad2'}
            mode_in = 2;
            if mode_in ~= mode_out
            im = ipermutation(im,mode_out);
            im = permutation(im,mode_in);
            end;
            mode_out = 2;
            inter = 0;
        case {'3','numpad3'}
            mode_in = 3;
            if mode_in ~= mode_out
            im = ipermutation(im,mode_out);
            im = permutation(im,mode_in);
            end;
            mode_out = 3;
            inter = 1;
        case {'4','numpad4'}
            mode_in = 4;
            if mode_in ~= mode_out
            im = ipermutation(im,mode_out);
            im = permutation(im,mode_in);
            end;
            mode_out = 4;
            inter = 1;
        case {'5','numpad5'}
            mode_in = 5;
            if mode_in ~= mode_out
            im = ipermutation(im,mode_out);
            im = permutation(im,mode_in);
            end;
            mode_out = 5;
            inter = 1;
        case {'f'}
            if isfused==0
                close(h)
                imshow4(im,slice,ref_time,range,colormaps,1)
                isfused = 1;
            elseif isfused==1
                close(h)
                imshow4(im,slice,ref_time,range,colormaps)
                isfused = 0;
            end;
    end
end

if rng(end)~=size(im,3) || rng_t(end)~=size(im,4)
    rng=size(im,3);
    rng=[1 rng];
    rng_t=size(im,4);
    rng_t=[1 rng_t];
    if slice>max(rng)
        slice=max(rng);
    end
    if slice<min(rng)
        slice=min(rng);
    end
    if time<min(rng_t)
        time=min(rng_t);
    end
    if time>max(rng_t)
        time=max(rng_t);
    end
end;
%figure(h)

imzobr = im(:,:,slice,time);

%axes(handles.image);

%imshow(imzobr);

% Delete previous image(s)

%set(handles.image, 'xlim', [1 size(imzobr, 2)]);
%set(handles.image, 'ylim', [1 size(imzobr, 1)]);

%Ajout ci-dessous
set(handles.image,'UserData',imzobr);
set(handles.image.Children,'CData',imzobr);
set(handles.image.Children,'CDataMapping','direct');
uicontextmenu = get(handles.image,'UIContextMenu');
set(handles.image.Children,'UIContextMenu',uicontextmenu);

if size(imzobr,2)<200 && inter==1
    imzobr = imresize(imzobr,[size(imzobr,1),200]);
end;

%Ajout ci-dessous
guidata(h,handles);

switch mode_out
    case 0
        xlabel('Axe des X')
        ylabel('Axe des Y')
        %title('Transversal view: \leftarrow\rightarrow = Z-axis; \uparrow\downarrow = t-axis, 0-5 = view')
        title({'Vue transversale', ['Z=' num2str(slice) '/' num2str(rng(2)) ', t=' num2str(time) '/' num2str(rng_t(2))]});
        %set(h,'Name',['Z=' num2str(slice) '/' num2str(rng(2)) ', t=' num2str(time) '/' num2str(rng_t(2))],'Colormap',colormaps)
    case 1
        xlabel('X-axis')
        ylabel('Z-axis')
        %title('Frontal view: \leftarrow\rightarrow = Y-axis; \uparrow\downarrow = t-axis, 0-5 = view')
        title(['Y=' num2str(slice) '/' num2str(rng(2)) ', t=' num2str(time) '/' num2str(rng_t(2))]);
        %set(h,'Name',['Y=' num2str(slice) '/' num2str(rng(2)) ', t=' num2str(time) '/' num2str(rng_t(2))],'Colormap',colormaps)
    case 2
        xlabel('Y-axis')
        ylabel('Z-axis')
        %title('Sagital view: \leftarrow\rightarrow = X-axis; \uparrow\downarrow = t-axis, 0-5 = view')
        set(h,'Name',['X=' num2str(slice) '/' num2str(rng(2)) ', t=' num2str(time) '/' num2str(rng_t(2))],'Colormap',colormaps)
    case 3
        xlabel('t-axis')
        ylabel('X-axis')
        title('X-time view: \leftarrow\rightarrow = Z-axis; \uparrow\downarrow = Y-axis, 0-5 = view')
        set(h,'Name',['Z=' num2str(slice) '/' num2str(rng(2)) ', Y=' num2str(time) '/' num2str(rng_t(2))],'Colormap',colormaps)
    case 4
        xlabel('t-axis')
        ylabel('Y-axis')
        title('Y-time view: \leftarrow\rightarrow = Z-axis; \uparrow\downarrow = X-axis, 0-5 = view')
        set(h,'Name',['Z=' num2str(slice) '/' num2str(rng(2)) ', X=' num2str(time) '/' num2str(rng_t(2))],'Colormap',colormaps)
    case 5
        xlabel('t-axis')
        ylabel('Z-axis')
        title('Z-time view: \leftarrow\rightarrow = Y-axis; \uparrow\downarrow = X-axis, 0-5 = view')
        set(h,'Name',['Y=' num2str(slice) '/' num2str(rng(2)) ', X=' num2str(time) '/' num2str(rng_t(2))],'Colormap',colormaps)
end;
end

function [im_out] = permutation(im_in,mode_in)
    switch mode_in
        case 0
            mode_in = [1,2,3,4]; % transversal
        case 1
            mode_in = [3,2,1,4]; % frontal
        case 2
            mode_in = [3,1,2,4]; % sagital
        case 3
            mode_in = [2,4,3,1]; % x-time
        case 4
            mode_in = [1,4,3,2]; % y-time
        case 5
            mode_in = [3,4,1,2]; % z-time
    end;
    im_out = permute(im_in,mode_in);
end

function [im_out] = ipermutation(im_in,mode_in)
    switch mode_in
        case 0
            mode_in = [1,2,3,4]; % transversal
        case 1
            mode_in = [3,2,1,4]; % frontal
        case 2
            mode_in = [3,1,2,4]; % sagital
        case 3
            mode_in = [2,4,3,1]; % x-time
        case 4
            mode_in = [1,4,3,2]; % y-time
        case 5
            mode_in = [3,4,1,2]; % z-time
    end;
    im_out = ipermute(im_in,mode_in);
end


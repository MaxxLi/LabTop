function [] = RT_stoplog(actxobject, type)
QNXrealterm = actxobject;
if (type == 1)
    invoke(QNXrealterm, 'stopcapture');
elseif (type == 2)
    invoke(QNXrealterm, 'close');
    pause(0.5);
    delete(QNXrealterm);
end

% QNXrealterm = actxobject;
% invoke(QNXrealterm, 'stopcapture');
% invoke(QNXrealterm, 'close');
% delete(QNXrealterm);



function [] = RT_StartLog(actxobject)
QNXrealterm = actxobject;
invoke(QNXrealterm, 'startcapture');
end


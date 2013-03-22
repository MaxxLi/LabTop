function [] = P_startlog(actxobject)
QNXrealterm = actxobject;
invoke(QNXrealterm, 'startcapture');
end


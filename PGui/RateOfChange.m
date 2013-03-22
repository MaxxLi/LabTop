function [roc] = Roc(obj)

roc = 0;
RT_StartLog(obj);
pause(2);
RT_stoplog(obj);
firstdata = RT_logparse('checklog.txt');
pause(10);
RT_StartLog(obj,1);
pause(2);
RT_stoplog(obj,1);
seconddata = RT_logparse('checklog.txt');
pause(0.5);
RT_stoplog(obj,2);

roc = seconddata - firstdata;

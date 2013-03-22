dutobj = RT_init('169.254.140.109');
RT_log(dutobj);
RT_startlog(dutobj);
pause(1800);
RT_stoplog(dutobj,1);
FileInit('new.csv');
RT_dataparse(1, 'new.csv');
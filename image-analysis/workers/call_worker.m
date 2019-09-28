function call_worker(workerFuncName, varargin)
try
    fh = str2func(workerFuncName);
    fh(varargin{:})
 catch ME
    [msg,msgID] = lastwarn;
    fprintf(2, [msg, ': ', msgID]);
    fprintf(2, [ME.identifier, ': ', ME.message]);
    rethrow(ME)
end  
quit();
end
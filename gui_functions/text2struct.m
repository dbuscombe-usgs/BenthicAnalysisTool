
function [my_struct] = text2struct(filename, parse_format, varargin)
%History
%Date          Who        Comment
%----------    ---        -----------------------------------
%2001/06/20    rme        Create

%determine the number of expected fields
num_args    = length(varargin);
num_scan    = length(findstr('%',parse_format));
num_skip    = length(findstr('%*',parse_format));
num_fields  = num_scan - num_skip;
num_options = num_args - num_fields;

%determine if optional TEXTREAD parameters were used
if num_fields == num_args
   fields = sprintf('%s ',varargin{:});
   cmd_str = sprintf('[%s] = textread(filename,''%s'');', fields, parse_format);
elseif num_fields < num_args
   fields = sprintf('%s ',varargin{(num_options+1):end});
   cmd_str = sprintf('[%s] = textread(filename,''%s'',varargin{1:num_options});', fields, parse_format);
else
   err_msg = sprintf('Parsing format does not match number of fields.');
   error(err_msg);
end
eval(cmd_str);

%convert TEXTREAD data to structure
cmd_str = 'my_struct = struct(';
for ii = (num_options+1):num_args
   buff = sprintf('iscell(%s)',varargin{ii});
   if eval(buff) %handle char arrays
      buff = sprintf('''%s'',str2mat(%s),', varargin{ii}, varargin{ii});
   else          %handle numerical arrays
      buff = sprintf('''%s'',%s,', varargin{ii}, varargin{ii});
   end
   cmd_str = strcat(cmd_str, buff);
end
%strip trailing comma and close command sring
cmd_str = strcat(cmd_str(1:end-1),');'); 
eval(cmd_str);
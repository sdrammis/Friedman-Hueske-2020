function [ new_struct ] = get_fields( struct, varargin )
%GET_FIELDS Apply Fields clause of LOOKUP function
%
%   INPUT  :: db          - database (a 1 x N struct)
%             varargin    - field names of fields to keep from db
%
%   OUTPUT :: new_struct  - database (a 1 x N struct) with only fields as
%                             described by fields in varargin

if ~isstruct(struct)
    error('Expected struct as input. Most likely caused by empty query.')
end

if isempty(varargin)
    new_struct = struct;
    return
end

struct_arr = cell(length(varargin), length(struct));
for j = 1:length(struct)
    entry = struct(j);

    for i = 1:length(varargin)
        field = varargin{i};
        struct_arr{i, j} = entry.(field);
    end
end

new_struct = transpose(cell2struct(struct_arr, varargin));

end


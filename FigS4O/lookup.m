function [ result_set ] = lookup( db, varargin )
%LOOKUP Lookup entries in database given certain criterion
%   Detailed explanation goes here
% 
%   INPUT    :: db         - database (a 1 x N struct)
%               varargin   - criterion to use in lookup; see below
%
%   OUTPUT   :: result_set - 1 x K struct (another DB) consisting of
%                               entries queried according to criterion
%
%   VARARGIN :: The lookup criterion are split into four options:
%                   (1) Key Clauses - these are the main criterion for
%                   determining which entries in DB are selected.
%
%                   (2) Order - you can choose to order your data by a
%                   certain field.
%
%                   (3) Uniqueness - you can choose to only extract entries
%                   that are unique in a given field.
%
%                   (4) Fields - you can choose which fields of the
%                   extracted entries you want to be returned.
%
%               Together, they make up the syntax for calling LOOKUP:
%
%                   lookup(db, {Key Clauses}, 'Order', {Order args}, 'Unique', {Uniqueness args}, 'Fields', {Fields args})
%
%               Note that each of these criterion are optional, but if a keyword
%               is given (i.e. 'Order'), then the correct arguments must follow. 
%
%               Additionally, when combining multiple options, they MUST
%               appear in the same relative order as shown above. For
%               example, if you want to just use Order and Fields options,
%               but not Key Clauses or Uniqueness, you would call:
%
%                   lookup(db, 'Order', {Order args}, 'Fields', {Fields args})
%
%               However, if you then wanted to add Key Clauses and
%               Uniqueness, but remove Order, you would call:
%
%                   lookup(db, {Key Clauses args}, 'Unique', {Uniqueness args}, 'Fields', {Fields args})
%
%   KEY CLAUSES ::  The juice of this function - determining which entries
%                   you want to be queried. Each Key Clause is composed of 3
%                   arguments,
%                       (1) Field Name
%                       (2) Relationship
%                       (3) Value
%
%                   in that order. For example, if you want all entries in a
%                   DB whose session number is less than 10, the Key Clause
%                   might look like:
%                       'sessionNumber', '<', 10
%
%                   The valid options for Field Name are any field name of
%                   the DB struct. 
%
%                   The valid options for Relationship are:
%                       '='    :: equality
%                       '!='   :: inequality
%                       '>'    :: greater-than
%                       '<'    :: less-than
%                       '>='   :: greater-than or equal to
%                       '<='   :: less-than or equal to
%                       '...'  :: in range (inclusive at both ends)
%                       '..<'  :: in range (inclusive at bottom, exclusive at top)
%
%                   The valid options for Value are dependent on both the
%                   given Field Name and Relationship. 
%                       (1) Value must be of the same type as the values in
%                           the DB field given by Field Name. If Field Name 
%                           is 'mouseID' then Value should be the same type 
%                           as DB.mouseID. The result of this function is 
%                           undefined if this provision is violated. Note 
%                           that this is a particular;y easy thing to mess 
%                           up when the DB stores a numerical value as char 
%                           arrays. 
%
%                       (2) If Relationship is a range ('...', '..<'), then
%                           Value must be a length-2 cell array, where the
%                           first element is the bottom of the range and
%                           the second element is the top of the range. If
%                           Relationship is not a range, Value is a single
%                           value.
%
%                   To use a Key Clauses in a call to LOOKUP, pass in the 3
%                   components of the clause as separate arguments, in the
%                   correct order. To use more than one clause, simply keep
%                   adding arguments. To call LOOKUP using the above example,
%                   we would write the following:
%
%                       lookup(db, 'sessionNumber', '<', 10)
%                   
%                   If we wanted all entries who (1) have session number in
%                   between 10 and 13 exclusive, and (2) have a mouse whose name
%                   comes after "Jared" lexicographically, we would write:
%
%                       lookup(db, 'sessionNumber', '..<', {10, 13}, 'mouseName', '>', 'Jared')
%
%
%   ORDER ::    You can also choose to order your entries by a certain
%               field. Note that this ordering happens after Key
%               Clauses (if there are any) are applied. An Order clause has
%               the following components:
%                   (1) the 'Order' keyword
%                   (2) Field Name
%                   (3) Relationship
%               
%               in that order. 
%               
%               The valid options for Field Name are any field name of
%                   the DB struct where the type of that field can be
%                   ordered (i.e. double, single, char, string). Please
%                   don't try and order by a field that contains tables.
%                   Like what does that even mean????
%               
%               The valid options for Relationship are 'ASC' for an ascending
%               ordering, and 'DESC' for a descending ordering.
%
%               To use an Order clause in a call to LOOKUP, pass in the 3
%               components of the clause as separate arguments, in the
%               correct order, AFTER any Key Clauses. Unlike the Key Clauses, 
%               each call to LOOKUP only supports ONE Order clause.
%
%               For example, to get all entries whose session number is
%               less than 10 ordered by increasing session date, we say:
%
%                   lookup(db, 'sessionNumber', '<', 10, 'Order', 'sessionDate', 'ASC')
%
%
%   UNIQUENESS ::   You can also choose to only extract entries that are
%                   unique in a given field. Note that applying this uniqeness
%                   happens after Key and Order clauses (if there are any) 
%                   are applied. A Uniqueness clause has the following 
%                   components:
%                       (1) the 'Unique' keyword
%                       (2) Field Name
%               
%                   in that order. 
%
%                   The valid options for Field Name are any field name of
%                       the DB struct where the type of that field can be
%                       compared for equality.
% 
%                   To use an Uniqueness clause in a call to LOOKUP, pass 
%                   in the 2 components of the clause as separate arguments
%                   in the correct order, AFTER any Key Clauses and Order 
%                   clauses. Unlike the Key Clauses, each call to LOOKUP 
%                   only supports ONE Uniqueness clause.
% 
%                   For example, to get all entries that have a unique
%                   session number, we would write:
% 
%                       lookup(db, 'Unique', 'sessionNumber')
%                   
%                   Note that in applying Uniqueness, this function returns
%                   the FIRST instance of any unique entry. 
%
%
%   FIELDS ::   You can also choose which fields of the extracted entries 
%               you want to be returned. This extraction happens after Key,
%               Order, and Uniqueness clauses (if there are any) are 
%               applied. A Fields clause has the following components:
%                   (1) the 'Field' keyword
%                   (2) 1 or more Field Names (as separate arguments)
%               
%               in that order. 
%               
%               The valid options for a Field Name are any field name of
%                   the DB struct.
%
%               To use an Fields clause in a call to LOOKUP, pass in the
%               components of the clause as separate arguments, in the
%               correct order, AFTER any Key, Order, and Uniqueness clauses.
%
%               For example, let's say you want only the trial data and 
%               session date of all entries whose session number is less 
%               than 10. In that case we can write:
%
%                   lookup(db, 'sessionNumber', '<', 10, 'Fields', 'trialData', 'sessionDate')
%
%               A particular use of the Fields criterion is to use it in
%               conjunction with the Uniqueness criterion to get a set of
%               all "types" of a certain field. For example, if we want a
%               list of the ID's of all mice, we would run:
%
%                   lookup(db, 'Unique', 'mouseID', 'Fields', 'mouseID')
%
%
%   EXAMPLE ::  As a final example, let's say we want the trial data for
%               the most recent Two-Tone session for each HD mouse that 
%               occured in September or October, ordered by mouseID. We
%               could achieve this by calling
%
%                   lookup(db, 'sessionType', '=', 'tt', sessionMonth, '...', {9, 10}, 'Health', 'HD',
%                               'Order', 'sessionDate', 'DESC',  
%                               'Unique', 'mouseID', 
%                               'Fields', 'mouseID', 'trialData')
%               
%               First, the function applies all Key Clauses and gets all 
%               entries whose session type is Two-Tone (tt), whose mouse is
%               HD, and occured in Sept/Oct. 
%
%               Next, Order is applied. This will cause the remaining 
%               entries to be sorted from most recent to earliest (due to 
%               DESC). 
%
%               Then, we specify to only extract the first instance of an 
%               entry with a unique mouseID using the Unique clause. 
%               
%               Finally, we return only the data we are interested in, 
%               along with the mouseID to keep track of who the data 
%               belongs to.
%


fields_index = find(strcmp(varargin, 'Fields'));

if isempty(fields_index)
    result_set = key_lookup(db, varargin{:});
    
    if isempty(result_set)
        result_set = struct()%create_empty_struct(db);
    end
else
    result_set = key_lookup(db, varargin{1:fields_index-1});
    if ~isempty(result_set)
        result_set = get_fields(result_set, varargin{fields_index + 1:end});
    else
        result_set = struct;%create_empty_struct(db);
    end
end


% Helper function to create empty struct with same fieldnames as db
function [s] = create_empty_struct(db)
    field_names = fieldnames(db);
    values = cell(length(field_names), 1);
    temp = reshape([field_names(:),values(:)].', [1, 2 * length(field_names)]);
    
    s = struct(temp{:});
end

end


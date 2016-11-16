classdef QTree < handle
    %QTree Summary of this class goes here
    
    properties
        size
        mother
        child = cell(1 ,4);
        mean
        delta
        mask = int32([0 0; 1 0; 0 1; 1 1]);
        depth
        isLeaf = false;
    end
    
    methods        
        function obj = QTree(size, depth)
            if nargin == 2
                obj.size = size;
                obj.depth = depth;
            end
        end
        function split(obj)
            if obj.size>=2
                newSize = obj.size/2; 
                for i = 1:4
                    obj.child{i} = QTree(newSize, obj.depth+1);
                end
                obj.isLeaf = false;
            else
                obj.isLeaf = true;
            end
        end
    end
    
end


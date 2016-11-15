classdef QTree < handle
    %QTree Summary of this class goes here
    
    properties
        pos
        size
        child = cell(1 ,4);
        mean
        delta
        mask = [0 0; 1 0; 0 1; 1 1];
        isLeaf = false;
    end
    
    methods        
        function obj = QTree(pos, size)
            if nargin == 2
                obj.pos = pos;
                obj.size = size;
            end
            obj.mask = int32(obj.mask);
        end
        function obj = split(obj)
            if obj.size>=2
                newSize = obj.size/2; 
                for i = 1:4
                    obj.child{i} = QTree(obj.pos + obj.mask(i,:).*newSize, newSize);
                end
                obj.isLeaf = false;
            else
                obj.isLeaf = true;
            end
        end
    end
    
end


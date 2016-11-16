function QtMain(img, depth, threshold)
%QT Summary of this function goes here
%   img - input duble image
%   depth - max depth of tree, if == 0 max posible depth
%   threshold - like in qtdecomp

root = QTree([int32(1) int32(1)],int32(size(img)));
if (depth == 0) || (depth > log2(size(img,1)))
    depth = log2(size(img));
end
   root.split();
   goDepth(img, root, depth, threshold);
   regions = zeros(size(img));
   regions = drawReg(regions,root);
   imshow(regions,[]);
   disp('done');
end

function img = drawReg(img, root)
    if (isemty(root)) || (root.isLeaf) 
        img(root.pos(1):(root.pos(1)+root.size(1)),root.pos(2):(root.pos(2)+root.size(1))) = root.mean;
        return
    else
        for i = 1:4
            img = drawReg(img, root.child{i});
        end
    end
end

function goDepth(img, root, depth, threshold )
    
    for i = 1:4
        cropImg = imcrop(img,[root.child{i}.pos root.child{i}.pos+root.child{i}.size]);
        %
%         testImg = img;
%         testImg(root.child{i}.pos(1),:)=1;
%         testImg(:,root.child{i}.pos(2))=1;
%         testImg(root.child{i}.pos(1)+root.child{i}.size,:)=1;
%         testImg(:,root.child{i}.pos(2)+root.child{i}.size)=1;
%         imshow(testImg);
%         title(size(cropImg));
        %
        root.child{i}.delta = abs(min(cropImg(:)) - max(cropImg(:)));
        root.child{i}.mean = mean(cropImg(:));
        root.child{i}.split();
        if (root.child{i}.delta <= threshold) || (root.child{i}.isLeaf) || (depth == 0)
            root.child{i}.isLeaf = true;
            return
        else
           goDepth(img, root.child{i}, depth-1, threshold); 
        end
    end
end


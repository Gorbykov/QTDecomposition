function QtMain(img, depth, threshold)
%QT Summary of this function goes here
%   img - входящие изображение должно быть размера 2^p на 2^p и типа double 
%   depth - максимальная глубина дреева, если 0 то неограничена
%   threshold - порог модуля разности максимального и минимльного пикселя
%   при котором область считается однородной

global regN
global regC
global k
k = 1;
root = QTree(int32(size(img,1)),0);
if (depth == 0) || (depth > log2(size(img,1)))
    depth = log2(size(img,1));
end
   root.split();
   figure
   goDepth(img, root, depth, threshold);
   regC = zeros(size(img));
   regN = regC;
   drawReg(root, 1, 1);
   imshow(regC);
   
   splitImg = img;
   for i = 1:size(img,1)
       for j = 1:size(img,1)
           splitImg(i,j) = (regN(i,j) == regN(i+1,j))*splitImg(i,j);
           splitImg(i,j) = (regN(i,j) == regN(i,j+1))*splitImg(i,j);
       end
   end
   figure;
   imshow(splitImg);
   figure;
   imshow(regN,[]);
   disp('done');
end

function goDepth(img, root, depth, threshold )
    root.delta = abs(min(img(:)) - max(img(:)));
    root.mean = mean(img(:));
    root.split;
    %imshow(img);
    if (root.delta <= threshold) || (root.isLeaf) || (depth ==0)
        root.isLeaf = true;
        return;
    else
        s = root.size/2;
        goDepth(img(1:s,1:s), root.child{1}, depth-1, threshold); 
        goDepth(img((s+1):(s*2),1:s), root.child{2}, depth-1, threshold);
        goDepth(img(1:s,(s+1):(s*2)), root.child{3}, depth-1, threshold);
        goDepth(img((s+1):(s*2),(s+1):(s*2)), root.child{4}, depth-1, threshold);
    end
end

function drawReg(root, x, y)
global regN
global regC
global k
    if(root.isLeaf)
        regN(x:(x+root.size),y:(y+root.size)) = k;
        k = k+1;
        regC(x:(x+root.size),y:(y+root.size)) = root.mean;
    else
        s = root.size/2;
        drawReg(root.child{1},x,y);
        drawReg(root.child{2},x+s,y);
        drawReg(root.child{3},x,y+s);
        drawReg(root.child{4},x+s,y+s);        
    end
end
% function img = drawReg(img, root)
%     if (isempty(root.child{1})) 
%         img(root.pos(1):(root.pos(1)+root.size(1)),root.pos(2):(root.pos(2)+root.size(1))) = root.mean;
%         %imshow(img);
%         return
%     else
%         for i = 1:4
%             img = drawReg(img, root.child{i});
%         end
%     end
% end

% function goDepth(img, root, depth, threshold )
%     root.split();
%     if ~root.isLeaf
%         for i = 1:4
%             cropImg = imcrop(img,[root.child{i}.pos root.child{i}.pos+root.child{i}.size]);
%             %
%             testImg(root.pos(1):(root.pos(1)+root.size(1)),root.pos(2):(root.pos(2)+root.size(1))) = 1;
%     %         testImg = img;
%     %         testImg(root.child{i}.pos(1),:)=1;
%     %         testImg(:,root.child{i}.pos(2))=1;
%     %         testImg(root.child{i}.pos(1)+root.child{i}.size,:)=1;
%     %         testImg(:,root.child{i}.pos(2)+root.child{i}.size)=1;
%              imshow(testImg);
%              title(size(cropImg));
%             %
%             root.child{i}.delta = abs(min(cropImg(:)) - max(cropImg(:)));
%             root.child{i}.mean = mean(cropImg(:));
% 
%             if (root.child{i}.delta <= threshold) || (depth == 0)
%                 root.child{i}.isLeaf = true;
%                 return
%             else
%                goDepth(img, root.child{i}, depth-1, threshold); 
%             end
%         end
%     end
% end


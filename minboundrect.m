function [rectx,recty,area,perimeter] = minboundrect(x,y,metric)
% minboundrect: 计算点的最小边界的平面矩形
% usage: [rectx,recty,area,perimeter] = minboundrect(x,y,metric)
%
% arguments: (input)
% x,y - 矢量点，描述在平面为（x，y）对。 x和y必须相同的长度。
%
% metric - (可选) - 单独字符标志位，可用于指出最少的面积或周长为的度量最小化。 度量可能是 'a' or 'p'，大写字母被忽略。
% 'area(区域)'的任何其他收缩或'perimeter(周边)'也是可以接受的。
% 默认: 'a' ('area') 'a'是按面积算的最小矩形，如果按边长用'p'
% 参数：（输出）
% rectx,recty - 5×1向量定义最小外接矩形点。
% area - 最小矩形本身的（标量）的区域。
% perimeter周长 - 发现的（标量）的最小矩形周长
% 原理：将物体的边界以每次3度左右的增量在90度范围内旋转，
% 每旋转一次记录一次其坐标系方向上的外接矩形边界点的最大和最小的x和y值，
% 旋转到某一角度后，外接矩形的面积达到最小，
% 取面积最小的外接矩形的参数为最小外接矩形……
if (nargin<3) || isempty(metric)
%nargin为“number of input arguments”的缩写。
%在matlab中定义一个函数时， 在函数体内部， nargin是用来判断输入变量个数的函数。
metric = 'a';
elseif ~ischar(metric)
error '如果被提供，flag必须是字符标志。'
else
% check for 'a' or 'p'
metric = lower(metric(:)');
ind = strmatch(metric,{'area','perimeter'});
if isempty(ind)
error 'metric does not match either ''area'' or ''perimeter'''
end
% just keep the first letter.
metric = metric(1);
end
% 数据预处理
x=x(:);
y=y(:);
n = length(x);
if n~=length(y)
error 'x and y must be the same sizes'
end
% 在开始时就只选择那些凸包的点，可以显着降低的问题。
% 请注意，永远不会需要凸包内部的任何点，所以我们把它们去掉。
if n>3
edges = convhull(x,y);
% convhull 函数可以画出坐标点的凸壳
% 排除内部不相关的点，并把外面的点排序，且形成到他们的凸包作为一个封闭的多边形
x = x(edges);
y = y(edges);
% 概率较少的点，现在，除非点是完全凸
nedges = length(x) - 1;
elseif n>1
% n 必须是 2 或 3
nedges = n;
x(end+1) = x(1);
y(end+1) = y(1);
else
% n 必须是 0 或 1
nedges = n;
end
% 现在我们必须找到那些仍然的边框。
% special case small numbers of points. If we trip any
% of these cases, then we are done, so return.
% 特例点的小的数字。如果我们跳闸任何情况下，我们都做了，因此返回。
switch nedges
case 0
% empty 产生 empty
rectx = [];
recty = [];
area = [];
perimeter = [];
return
case 1
% 只有有一点，其余的也很简单。
rectx = repmat(x,1,5);
recty = repmat(y,1,5);
area = 0;
perimeter = 0;
return
case 2
% 只有两点。也很简单。
rectx = x([1 2 2 1 1]);
recty = y([1 2 2 1 1]);
area = 0;
perimeter = 2*sqrt(diff(x).^2 + diff(y).^2);
return
end
% 3个或更多的点。
% 3个或更多需要通过一个角度theta点的2×2旋转矩阵。
Rmat = @(theta) [cos(theta) sin(theta);-sin(theta) cos(theta)];
% 得到壳体多边形的每个边缘的角度。
ind = 1:(length(x)-1);
edgeangles = atan2(y(ind+1) - y(ind),x(ind+1) - x(ind));
% 移动这些角度到第一象限。
edgeangles = unique(mod(edgeangles,pi/2));
% 现在只是检查壳体的每个边缘
nang = length(edgeangles);
area = inf;
perimeter = inf;
met = inf;
xy = [x,y];
for i = 1:nang
% 通过-theta数据进行旋转
rot = Rmat(-edgeangles(i));
xyr = xy*rot;
xymin = min(xyr,[],1);
xymax = max(xyr,[],1);
% 该区域简单，因为在外围
A_i = prod(xymax - xymin);
P_i = 2*sum(xymax-xymin);
if metric=='a'
M_i = A_i;
else
M_i = P_i;
end
% 当前间隔的新度量值。岂不是更好？
if M_i<met
% 保持这一个
met = M_i;
area = A_i;
perimeter = P_i;
rect = [xymin;[xymax(1),xymin(2)];xymax;[xymin(1),xymax(2)];xymin];
rect = rect*rot';
rectx = rect(:,1);
recty = rect(:,2);
end
end
% 获得最后的RECT
% 全部完成
end % 全部完成
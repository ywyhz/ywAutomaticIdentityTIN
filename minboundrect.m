function [rectx,recty,area,perimeter] = minboundrect(x,y,metric)
% minboundrect: ��������С�߽��ƽ�����
% usage: [rectx,recty,area,perimeter] = minboundrect(x,y,metric)
%
% arguments: (input)
% x,y - ʸ���㣬������ƽ��Ϊ��x��y���ԡ� x��y������ͬ�ĳ��ȡ�
%
% metric - (��ѡ) - �����ַ���־λ��������ָ�����ٵ�������ܳ�Ϊ�Ķ�����С���� ���������� 'a' or 'p'����д��ĸ�����ԡ�
% 'area(����)'���κ�����������'perimeter(�ܱ�)'Ҳ�ǿ��Խ��ܵġ�
% Ĭ��: 'a' ('area') 'a'�ǰ���������С���Σ�������߳���'p'
% �������������
% rectx,recty - 5��1����������С��Ӿ��ε㡣
% area - ��С���α���ģ�������������
% perimeter�ܳ� - ���ֵģ�����������С�����ܳ�
% ԭ��������ı߽���ÿ��3�����ҵ�������90�ȷ�Χ����ת��
% ÿ��תһ�μ�¼һ��������ϵ�����ϵ���Ӿ��α߽���������С��x��yֵ��
% ��ת��ĳһ�ǶȺ���Ӿ��ε�����ﵽ��С��
% ȡ�����С����Ӿ��εĲ���Ϊ��С��Ӿ��Ρ���
if (nargin<3) || isempty(metric)
%narginΪ��number of input arguments������д��
%��matlab�ж���һ������ʱ�� �ں������ڲ��� nargin�������ж�������������ĺ�����
metric = 'a';
elseif ~ischar(metric)
error '������ṩ��flag�������ַ���־��'
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
% ����Ԥ����
x=x(:);
y=y(:);
n = length(x);
if n~=length(y)
error 'x and y must be the same sizes'
end
% �ڿ�ʼʱ��ֻѡ����Щ͹���ĵ㣬�������Ž��͵����⡣
% ��ע�⣬��Զ������Ҫ͹���ڲ����κε㣬�������ǰ�����ȥ����
if n>3
edges = convhull(x,y);
% convhull �������Ի���������͹��
% �ų��ڲ�����صĵ㣬��������ĵ��������γɵ����ǵ�͹����Ϊһ����յĶ����
x = x(edges);
y = y(edges);
% ���ʽ��ٵĵ㣬���ڣ����ǵ�����ȫ͹
nedges = length(x) - 1;
elseif n>1
% n ������ 2 �� 3
nedges = n;
x(end+1) = x(1);
y(end+1) = y(1);
else
% n ������ 0 �� 1
nedges = n;
end
% �������Ǳ����ҵ���Щ��Ȼ�ı߿�
% special case small numbers of points. If we trip any
% of these cases, then we are done, so return.
% �������С�����֡����������բ�κ�����£����Ƕ����ˣ���˷��ء�
switch nedges
case 0
% empty ���� empty
rectx = [];
recty = [];
area = [];
perimeter = [];
return
case 1
% ֻ����һ�㣬�����Ҳ�ܼ򵥡�
rectx = repmat(x,1,5);
recty = repmat(y,1,5);
area = 0;
perimeter = 0;
return
case 2
% ֻ�����㡣Ҳ�ܼ򵥡�
rectx = x([1 2 2 1 1]);
recty = y([1 2 2 1 1]);
area = 0;
perimeter = 2*sqrt(diff(x).^2 + diff(y).^2);
return
end
% 3�������ĵ㡣
% 3���������Ҫͨ��һ���Ƕ�theta���2��2��ת����
Rmat = @(theta) [cos(theta) sin(theta);-sin(theta) cos(theta)];
% �õ��������ε�ÿ����Ե�ĽǶȡ�
ind = 1:(length(x)-1);
edgeangles = atan2(y(ind+1) - y(ind),x(ind+1) - x(ind));
% �ƶ���Щ�Ƕȵ���һ���ޡ�
edgeangles = unique(mod(edgeangles,pi/2));
% ����ֻ�Ǽ������ÿ����Ե
nang = length(edgeangles);
area = inf;
perimeter = inf;
met = inf;
xy = [x,y];
for i = 1:nang
% ͨ��-theta���ݽ�����ת
rot = Rmat(-edgeangles(i));
xyr = xy*rot;
xymin = min(xyr,[],1);
xymax = max(xyr,[],1);
% ������򵥣���Ϊ����Χ
A_i = prod(xymax - xymin);
P_i = 2*sum(xymax-xymin);
if metric=='a'
M_i = A_i;
else
M_i = P_i;
end
% ��ǰ������¶���ֵ�����Ǹ��ã�
if M_i<met
% ������һ��
met = M_i;
area = A_i;
perimeter = P_i;
rect = [xymin;[xymax(1),xymin(2)];xymax;[xymin(1),xymax(2)];xymin];
rect = rect*rot';
rectx = rect(:,1);
recty = rect(:,2);
end
end
% �������RECT
% ȫ�����
end % ȫ�����
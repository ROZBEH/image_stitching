function  T  = Affine( pts1, pts2 )

% prepare matrix A with pts1
A = zeros(size(pts1,1)*2,6);
A(1:2:end,5) = 1;
A(2:2:end,6) = 1;
A(1:2:end,1:2) = pts1;
A(2:2:end,3:4) = pts1;
% prepare matrix B with pts2
B = zeros(size(pts2,1)*2,1);
B(1:2:end)=pts2(:,1);
B(2:2:end)=pts2(:,2);
% solve A*x = B for x using least square error
x = A\B;
% reorder elements of x
X(1,1)=x(1); X(1,2)=x(3); X(2,1)=x(2); 
X(2,2)=x(4); X(3,1)=x(5); X(3,2)=x(6);
X(1,3)=0; X(2,3)=0; X(3,3)=1;
% Use 'imtransform' to creat the appropriate affine transformation
assignin('base', 'XT', X);
X(isnan(X))=0;
X(isinf(X))=0;
T = maketform('affine', X);
end


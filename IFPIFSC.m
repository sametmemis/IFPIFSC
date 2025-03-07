%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation:
% S. Memiş, B. Arslan, T. Aydın, S. Enginoğlu, Ç. Camcı, (2021). Distance
% and Similarity Measures of Intuitionistic Fuzzy Parameterized
% Intuitionistic Fuzzy Soft Matrices and Their Applications to Data
% Classification in Supervised Learning. Axioms 2023, 12, 463.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abbreviation of Journal Title: Axioms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://doi.org/10.3390/axioms12050463
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://www.researchgate.net/profile/Samet_Memis2
% https://www.researchgate.net/profile/Burak-Arslan-15
% https://www.researchgate.net/profile/Tugce-Aydin
% https://www.researchgate.net/profile/Serdar_Enginoglu2
% https://www.researchgate.net/profile/Cetin-Camci
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Demo: 
% clc;
% clear all;
% DM = importdata('Wine.mat');
% [x,y]=size(DM);
% 
% data=DM(:,1:end-1);
% class=DM(:,end);
% if prod(class)==0
%     class=class+1;
% end
% k_fold=5;
% cv = cvpartition(class,'KFold',k_fold);
%     for i=1:k_fold
%         test=data(cv.test(i),:);
%         train=data(~cv.test(i),:);
%         T=class(cv.test(i),:);
%         C=class(~cv.test(i),:);
%     
%         sIFPIFSC=IFPIFSC(train,C,test,5,0.5);
%         accuracy(i,:)=sum(sIFPIFSC==T)/numel(T);
%     end
% mean_accuracy=mean(accuracy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PredictedClass=IFPIFSC(train,C,test,lambda1,lambda2)
[em,en]=size(train);
[tm,n]=size(test);
  for j=1:en
      ifwP(1,j,1)=1-(1-abs(corr(train(:,j),C,'Type','Pearson','Rows','complete')))^lambda1;
      ifwP(1,j,2)=(1-abs(corr(train(:,j),C,'Type','Pearson','Rows','complete')))^(lambda1*(lambda1+1));
  end
  ifwP(isnan(ifwP))=0;

data=[train;test];
for j=1:n
    data(:,j,1)=(1-(1-normalise(data(:,j))).^lambda2);
    data(:,j,2)=(1-normalise(data(:,j))).^(lambda2*(lambda2+1));
end

clear train test;
train(:,:,:)=data(1:em,:,:);
test(:,:,:)=data(em+1:end,:,:);

for k=1:tm
    a(:,:,1)=[ifwP(1,:,1) ; test(k,:,1)];
    a(:,:,2)=[ifwP(1,:,2) ; test(k,:,2)];
    for l=1:em
        b(:,:,1)=[ifwP(1,:,1) ; train(l,:,1)];
        b(:,:,2)=[ifwP(1,:,2) ; train(l,:,2)];
        Sm(l,1)=ifpifsHs(a,b);
        Sm(l,2)=ifpifsEs(a,b);
        Sm(l,3)=ifpifsMs(a,b,3);
        Sm(l,4)=ifpifsHss(a,b);
        Sm(l,5)=ifpifsJacs(a,b);
        Sm(l,6)=ifpifsCoss(a,b);
    end
    for s=1:6
        [~,w(s)]=max(Sm(:,s));
    end
    PredictedClass(k,1)=C(mode(w));
end
end

function na=normalise(a)
[m,n]=size(a);
    if max(a)~=min(a)
        na=(a-min(a))/(max(a)-min(a));
    else
        na=ones(m,n);
    end
end                                                                                                                                                                  

% Hamming pseudo similarity over ifpifs-matrices
function X=ifpifsHs(a,b)
if size(a)~=size(b)
else
[m,n,~]=size(a);
d=0;
  for i=2:m
    for j=1:n
       d=d+abs(a(1,j,1)*a(i,j,1)-b(1,j,1)*b(i,j,1))+abs(a(1,j,2)*a(i,j,2)-b(1,j,2)*b(i,j,2))+abs((1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2))-(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2)));
    end
  end
  X=1-(d/(2*(m-1)*n));
end
end

% Euclidean pseudo similarity over ifpifs-matrices
function X=ifpifsEs(a,b)
if size(a)~=size(b)
    
else
[m,n,~]=size(a);
d=0;
  for i=2:m
    for j=1:n
       d=d+abs(a(1,j,1)*a(i,j,1)-b(1,j,1)*b(i,j,1))^2+abs(a(1,j,2)*a(i,j,2)-b(1,j,2)*b(i,j,2))^2+abs((1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2))-(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2)))^2;
    end
  end
  X=1-(sqrt(d)/sqrt(2*(m-1)*n));
end
end

% Minkowski pseudo similarity over ifpifs-matrices
function X=ifpifsMs(a,b,p)
if size(a)~=size(b)
else
[m,n,~]=size(a);
d=0;
  for i=2:m
    for j=1:n
       d=d+abs(a(1,j,1)*a(i,j,1)-b(1,j,1)*b(i,j,1))^p+abs(a(1,j,2)*a(i,j,2)-b(1,j,2)*b(i,j,2))^p+abs((1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2))-(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2)))^p;
    end
  end
  X=1-((d^(1/p))/((2*(m-1)*n)^(1/p)));
end
end

% Hausdorff pseudo similarity over ifpifs-matrices
function X=ifpifsHss(a,b)
if size(a)~=size(b)    
else
[m,n,~]=size(a);
  for i=2:m
    for j=1:n
       d(j,1)=abs(a(1,j,1)*a(i,j,1)-b(1,j,1)*b(i,j,1));
       d(j,2)=abs(a(1,j,2)*a(i,j,2)-b(1,j,2)*b(i,j,2));
       d(j,3)=abs((1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2))-(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2)));
    end
    e(i-1)=max(max(d));
  end
  X=1-(sum(e)/(m-1));
end
end

% Jaccard pseudo similarity over ifpifs-matrices
function X=ifpifsJacs(a,b)
if size(a)~=size(b)    
else
[m,n,~]=size(a);
d=0;
d1=0;
d2=0;
  for i=2:m
    for j=1:n
       d=d+a(1,j,1)*a(i,j,1)*b(1,j,1)*b(i,j,1)+a(1,j,2)*a(i,j,2)*b(1,j,2)*b(i,j,2)+(1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2))*(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2));
       d1=d1+a(1,j,1)*a(i,j,1)*a(1,j,1)*a(i,j,1)+a(1,j,2)*a(i,j,2)*a(1,j,2)*a(i,j,2)+(1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2))*(1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2));
       d2=d2+b(1,j,1)*b(i,j,1)*b(1,j,1)*b(i,j,1)+b(1,j,2)*b(i,j,2)*b(1,j,2)*b(i,j,2)+(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2))*(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2));
    end
    e(i-1)=d/(d1+d2-d);
  end
  X=sum(e)/(m-1);
end
end

% Cosine pseudo similarity over ifpifs-matrices
function X=ifpifsCoss(a,b)
if size(a)~=size(b)   
else
[m,n,~]=size(a);
d=0;
d1=0;
d2=0;
  for i=2:m
    for j=1:n
       d=d+a(1,j,1)*a(i,j,1)*b(1,j,1)*b(i,j,1)+a(1,j,2)*a(i,j,2)*b(1,j,2)*b(i,j,2)+(1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2))*(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2));
       d1=d1+a(1,j,1)*a(i,j,1)*a(1,j,1)*a(i,j,1)+a(1,j,2)*a(i,j,2)*a(1,j,2)*a(i,j,2)+(1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2))*(1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2));
       d2=d2+b(1,j,1)*b(i,j,1)*b(1,j,1)*b(i,j,1)+b(1,j,2)*b(i,j,2)*b(1,j,2)*b(i,j,2)+(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2))*(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2));
    end
    e(i-1)=d/(sqrt(d1)*sqrt(d2));
  end
  X=sum(e)/(m-1);
end
end
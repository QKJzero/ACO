% �Լ��������·���滮
clear;clc
close all;
tic
% g = rand(100,100);
% G = round(g);
G=[0 3 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
   2 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
   0 0 0 0 0 0 1 1 1 0 1 1 1 1 1 1 1 1 0 0; 
   0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 1 0 0; 
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0; 
   0 1 1 1 0 0 1 1 1 0 0 0 0 1 1 1 1 1 0 0; 
   0 1 1 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0;
   0 1 1 1 0 0 1 1 1 0 1 1 1 1 0 0 0 0 0 0; 
   0 1 1 1 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 1 1 0 1 1 1 1 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 1 1 0 1 1 1 1 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
   0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
   1 1 1 1 0 0 0 0 0 0 0 0 0 1 0 1 1 1 1 0; 
   1 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0 0 0 0 0; 
   0 0 0 0 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0; 
   0 1 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1 1 0; 
   0 0 0 0 0 1 0 0 0 0 1 1 0 0 1 0 0 0 0 0; 
   0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0;];
%���Ϊ���Ͻǣ��յ�Ϊ���½ǡ�
%��ͼ����
n=size(G,1);%n��ʾ��ͼ��С
m=50;    %% m ���ϸ���
Alpha=2;  %% Alpha ������Ϣ����Ҫ�̶ȵĲ���
Beta=1;  %% Beta ��������ʽ������Ҫ�̶ȵĲ���
Rho=0.5; %% Rho ��Ϣ������ϵ��
NC_max=100; %%����������
Q=100;         %%��Ϣ������ǿ��ϵ��
Tau=ones(n,n);     %TauΪ��Ϣ�ؾ���
NC=1;               %��������������¼��������
r_e=1;  c_e=20;%��ͼ�յ��ھ����е�λ��%����ͨ��position2rc��������
% s=n;%·����ʼ���ھ����е�λ��
s=n*(n-1)+1;%·����ʼ���ھ����е�λ��
% position_e=n*(n-1)+1;%·���յ��ھ����е�λ��
 position_e=20;%·���յ��ھ����е�λ��
min_PL_NC_ant=inf;%%������̵��н�����
min_ant=0;%%����н��������������
min_NC=0;%%����н�����ĵ�������
% �����ڽӾ�����������%%�ڽӾ��������Ǽ�����������
z=1;
for i=1:n
    for j=1:n
        if G(i,j)==0 
            D(i,j)=((i-r_e)^2+(j-c_e)^2)^0.5;
        else
            D(i,j)=inf;      %i=jʱ�����㣬Ӧ��Ϊ0�����������������Ҫȡ��������eps��������Ծ��ȣ���ʾ
        end
    end
end
D(r_e,c_e)=0.05;
Eta=1./D;          %EtaΪ�������ӣ�������Ϊ���յ����ĵ���
Tau=100.*Tau;
%Tau=10.*Eta;%%%%%���µ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%�����ƶ�����
 D_move=zeros(n*n,8);%��ȡÿ���ڵ����Χ�ڵ�%D_moveÿһ�д������б��ӦԪ�أ���400���ڵ㣩����ǰ������һ���ڵ��λ��
 for point=1:n*n
%      disp(G(point));
     if(point>=2)
%              kkkk=1;
             disp(G(point));
             [r,c]=position2rc(point,n);
             disp(G(r,c));
     end
     if G(point)==0
         [r,c]=position2rc(point,n);
         move=1;
         for k=1:n%�˴����Ż�
             for m1=1:n
                 im=abs(r-m1);
                 jn=abs(c-k); 
                 if im+jn==1||(im==1&&jn==1) 
                     if G(m1,k)==0
                         D_move(point,move)=(m1-1)*n+k;%����������8������Χ�˸��ڵ㡣
                         move=move+1;
                     end
                 end
             end
         end
     end 
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ƶ�������ڽӾ��������ɣ��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʼ����
routes=cell(NC_max,m);%%%%�洢ÿ�ε���ÿ�����ϵ�·��
PL=zeros(NC_max,m); %%%%%�洢ÿ�ε���ÿ�����ϵ�·������
while NC<=NC_max
    NC
    for ant=1:m
        current_position=s;%%%��ǰλ��Ϊ��ʼ��
        path=s;%%·����ʼ��
        PL_NC_ant=0;%%���ȳ�ʼ��
        Tabu=ones(1,n*n);   %%%%���ɱ��ų��Ѿ��߹���λ��
        Tabu(s)=0;%%�ų��Ѿ��߹��ĳ�ʼ��
        D_D=D_move;%%%%D_D��D_move���м����������Ϊ�˲���D_move������㣬Ҳ�ɲ���D_D����ֱ����D_move
        D_work=D_D(current_position,:);%%%�ѵ�ǰ�����ǰ������һ���ڵ����Ϣ���͸�D_work
        nonzeros_D_work=find(D_work);%%%�ҵ���Ϊ0��Ԫ�ص�λ��
        for i1=1:length(nonzeros_D_work)
            if Tabu(D_work(i1))==0
                D_work(nonzeros_D_work(i1))=[];%%�����ɱ������߹���Ԫ��ɾ������ֹ���Ѿ��߹���λ��
                D_work=[D_work,zeros(1,8-length(D_work))];%%%��֤D_work��������Ϊ8��ÿ�������������Χ��8�����ߣ���Ϊ����forѭ����׼��
            end
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ų��߹��ĵ�һ�㣨�ų���㣩%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        len_D_work=length(find(D_work));
        while current_position~=position_e&&len_D_work>=1%%��ǰ���Ƿ�Ϊ�յ�����߽�����ͬ
            p=zeros(1,len_D_work);
            for j1=1:len_D_work
                [r1,c1]=position2rc(D_work(j1),n);%%�����Լ���ĺ����ѿ���ǰ���ĵ����Ϊ���б�ʾ
                p(j1)=(Tau(r1,c1)^Alpha)*(Eta(r1,c1)^Beta);%%%%����ÿ������ǰ���Ľڵ�ĸ���
            end
            p=p/sum(p);%%%��һ��
            pcum=cumsum(p);%%%�����ۼ�
            select=find(pcum>=rand);%%%%���̶ķ�ѡ���¸��ڵ�
            to_visit=D_work(select(1));%%%ǰ����һ���ڵ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������һ���ڵ�%%%%%%%%%%%%%%%%%%%%%%%%
            path=[path,to_visit];%%%·���ۼ�
            dis=distance(current_position,to_visit,n);%%%���㵽�¸��ڵ�ľ���
            PL_NC_ant=PL_NC_ant+dis;%%�����ۼ�
            current_position=to_visit;%%%��ǰ����Ϊǰ����
            D_work=D_D(current_position,:);%%%%�ѵ�ǰ�ڵ����ǰ������һ���ڵ����Ϣ����D_work
            Tabu(current_position)=0;%%%���ɱ����ų��Ѿ����ĵ�
            for kk=1:400
                if Tabu(kk)==0
                    for i3=1:8
                        if D_work(i3)==kk
                           D_work(i3)=[];%%%%�ų����ɱ����Ѿ��߹��Ľڵ�
                           D_work=[D_work,zeros(1,8-length(D_work))];%%��֤����Ϊ8
                        end
                    end
                end
            end
            len_D_work=length(find(D_work));%%%���㵱ǰ�����ǰ������һ���ڵ������
        end
        %%%%%%%%%%%%%%%%%%%%%%%%����һ��������������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        routes{NC,ant}=path;%%%�������߹���·����¼����
        if path(end)==position_e
            z=z+1
            PL(NC,ant)=PL_NC_ant;%%��¼�����յ�����ϵ��н�����
            if PL_NC_ant<min_PL_NC_ant
                min_NC=NC;min_ant=ant;min_PL_NC_ant=PL_NC_ant;%%��¼·����̵����ϵĵ���������������һֻ
            end
        else
            PL(NC,ant)=0;
        end
    end
    delta_Tau=zeros(n,n);%%%��Ϣ�ر�����ʼ��
    for ant=1:m%j3=1:m
        if PL(NC,ant)
            rout=routes{NC,ant};
            tiaoshu=length(rout)-1;%%%�ҳ������յ�����ǰ���Ĵ���
            value_PL=PL(NC,ant);%%%%%%�����յ����ϵ��н�����
            for u=1:tiaoshu
                [r3,c3]=position2rc(rout(u+1),n);
                delta_Tau(r3,c3)=delta_Tau(r3,c3)+Q/value_PL;%%%%������Ϣ�ر�����ֵ
            end
        end
    end
%===================================
%     delta_Tau=zeros(n*n,n*n);%%%��Ϣ�ر�����ʼ��
%      for ant=1:m
%         if PL(NC,ant)
%             rout=routes{NC,ant};
%             tiaoshu=length(rout)-1;%%%�ҳ������յ�����ǰ���Ĵ���
%             value_PL=PL(NC,ant);%%%%%%�����յ����ϵ��н�����
%             for u=1:tiaoshu
%                 delta_Tau(rout(u),rout(u+1))=delta_Tau(rout(u),rout(u+1))+Q/value_PL;%%%%������Ϣ�ر�����ֵ
%             end
%         end
%     end
    Tau=(1-Rho).*Tau+delta_Tau;%%%%��Ϣ�ظ���
    NC=NC+1;
    %��Ϣ�ر仯���̡�
    rgb_r_max = 0;
    for i=1:n
        for j=1:n 
            if(rgb_r_max<Tau(i,j))
                    rgb_r_max = Tau(i,j);
            end
        end
    end
    figure(3);
    for i=1:n
        for j=1:n 
            x1=j-1;y1=n-i; 
            x2=j;y2=n-i; 
            x3=j;y3=n-i+1; 
            x4=j-1;y4=n-i+1; 
            if(Tau(i,j)>1)
                rgb_r = (Tau(i,j)/rgb_r_max);
                fill([x1,x2,x3,x4],[y1,y2,y3,y4],[0 rgb_r 0]); 
                hold on 
%                 pause(0.01);
            end
        end 
    end 
    grid on 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������������%%%%%%%%%%%%%%%%%%%%%%%%%%%
min_PL=ones(NC_max,1);%�������Ϣ�غ����·����һ�µ�����
for i=1:NC_max
    PL_1=PL(i,:);
    nonzero_PL_1=find(PL_1);%%%�ҵ������н�����λ��
    if isempty(nonzero_PL_1)
        min_PL(i)=min_PL(i-1);
    else
        min_PL(i)=min(PL_1(nonzero_PL_1));%%%�ҵ���i�ε����е����յ������н���̾���
    end
end
figure(1);
min(min_PL)
plot(min_PL);%%%%���������仯����
axis([0,200,0,100]) ;
hold on 
grid on 
title('�������߱仯����'); 
xlabel('��������'); 
ylabel('��С·������');
%%%%%%%%%%%%%%%%%%% ��������ͼ%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
for i=1:n
    for j=1:n 
        if G(i,j)==1 
            x1=j-1;y1=n-i; 
            x2=j;y2=n-i; 
            x3=j;y3=n-i+1; 
            x4=j-1;y4=n-i+1; 
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],'r'); 
            hold on 
        else 
            x1=j-1;y1=n-i; 
            x2=j;y2=n-i; 
            x3=j;y3=n-i+1; 
            x4=j-1;y4=n-i+1; 
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,1,1]); 
            hold on 
        end 
    end 
end 
hold on 
grid on 
% title('�������˶��켣'); 
% xlabel('����x'); 
% ylabel('����y');
%%%%%%%%%%%%%%%%%%%%%%%%�������·��·��ͼ%%%%%%%%%%%%%%%%%%%%%%%%%%%
ROUTES=routes{min_NC,min_ant}; 
LENGTH_ROUTES=length(ROUTES);
RX=ROUTES;
RY=ROUTES;
for i=1:LENGTH_ROUTES
    RX(i)=ceil(ROUTES(i)/n)-0.5;
    RY(i)=n-mod(ROUTES(i),n)+0.5;
    if RY(i)==n+0.5
        RY(i)=0.5;
    end
end
plot(RX,RY,'gx-','LineWidth',1.5,'markersize',6);
plot(0.5,0.5,'ro','MarkerSize',4,'LineWidth',4);   % ���
plot(19.5,19.5,'gs','MarkerSize',5,'LineWidth',5);   % �յ�

%ÿֻ������ʻ��·��
% for nc_num = 1:NC_max
%     for ant_num = 1:m
%         ant_routes = routes{nc_num,ant_num}; 
%         ant_LENGTH_ROUTES=length(ant_routes);
%         ant_RX=ant_routes;
%         ant_RY=ant_routes;
%         for i=1:ant_LENGTH_ROUTES
%             ant_RX(i)=ceil(ant_routes(i)/n)-0.5;
%             ant_RY(i)=n-mod(ant_routes(i),n)+0.5;
%             if ant_RY(i)==n+0.5
%                 ant_RY(i)=0.5;
%             end
%         end
%         plot(ant_RX,ant_RY,'LineWidth',1.5,'markersize',6);
%         pause(0.05);
%         disp((nc_num*50+ant_num));
%     end
% end

toc


    
    

    
    
    
    
    

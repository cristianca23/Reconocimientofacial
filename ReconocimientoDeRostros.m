clc, close all, clear all
%RECONOCIMIENTO FACIAL USANDO EL PROCESO DE EIGENFACES

%Cargamos la base de datos olivetti 
%Esta base de datos cuenta con 40 Sujetos, cada uno con 10 imagenes de
%ellos.

load orldata.mat

[N1,N2] = size(X);
figure(1)
imshow(reshape(X(87,:),112,92));title('Imagen de muestra','FontWeight','bold','Fontsize',16,'color','red');; %Se muestra una imagen para confirmar que la base de datos si cargo
%% Se saca el promedio y se quita de la matriz X

Xmean = mean(X);                 
Xmeanrep = repmat(Xmean,N1,1);
Xc = X - Xmeanrep ;             
%C= (1/N1)*(Xc*Xc');
figure(2)
imshow(reshape(Xmean(:),112,92));title('Media de la Imagen','FontWeight','bold','Fontsize',13,'color','red');

%% Cálculo de eingenvectors
K = (Xc*Xc');             %correlacion            
[R,S] = eig(K);
imagesc(K), colorbar;

%% Representación ortogonal por valores propios
Va = Xc'*R*real(S^(-0.5)); %se ponen las bases en columnas    
figure(3)
imagesc(reshape(Va(:,end-1),112,92));title('Bases con mas importancia','FontWeight','bold','Fontsize',13,'color','red');

%% Computar los M mejores eingenvectors
N=20;
R=R(:,end:-1:end-(N-1));

Z= Xc'*R;                    

Bases=Z/norm(Z);                

Y=Bases'*Xc';                      

%% Encontramos los valores propios más importantes
figure(4)
plot(cumsum(sort(diag(S),'descend'))) %Muestra la cuales son las bases que tienen más importancia.
%% Reconocimiento con ingreso de foto particular

imagen = imread('foto2.jpg');  %ingresamos una foto
imagen = rgb2gray(imagen);
imagen = im2double(imagen);
imagen = imresize(imagen,[112 92]);
cara=[imagen(:)]'; 
figure
subplot(1,2,1)
imshow(imagen);title('Buscando...','FontWeight','bold','Fontsize',16,'color','red');;

A = cara - Xmean;                              %Se quita la cara promedio 
YNew = A*Bases;                           %se multiplica por los valores propios

Dist=[]
for i=1:size(Y,2);
   Dist = [Dist,norm(Y(:,i)'-YNew)];
end
[a,i] = min(Dist)
xc=a*i   %distancia para comparar
%% puede ingresar al laboratorio?
subplot(1,2,2)
imshow(reshape(X(i,:),112,92));title('Encontrado, no puede ingresar al laboratorio','FontWeight','bold','Fontsize',16,'color','red');
if xc<70.000 %ponemos la distancia i  en un rango para que la persona pueda ingresar o no al laboratorio
    subplot(1,2,2)
imshow(reshape(X(i,:),112,92));title('Encontrado puede ingresar al laboratorio','FontWeight','bold','Fontsize',16,'color','red');
end

%%ingreso al laboratorio con base de datos
%% Reconocimiento con ingreso de foto de la base de datos olivetti

imagen = imread('s3.jpg');  %ingresamos una foto
imagen = im2double(imagen);
imagen = imresize(imagen,[112 92]);
cara=[imagen(:)]'; 
figure
subplot(1,2,1)
imshow(imagen);title('Buscando...','FontWeight','bold','Fontsize',16,'color','red');;

A = cara - Xmean;                              %Se quita la cara promedio 
YNew = A*Bases;                           %se multiplica por los valores propios

Dist=[]
for i=1:size(Y,2);
   Dist = [Dist,norm(Y(:,i)'-YNew)];
end
[a,i] = min(Dist)
xc=a*i %distancia para comparar
%% puede ingresar al laboratorio?
subplot(1,2,2)
imshow(reshape(X(i,:),112,92));title('Encontrado, no puede ingresar al laboratorio','FontWeight','bold','Fontsize',16,'color','red');
if xc<70.000   %ponemos la distancia i  en un rango para que la persona pueda ingresar o no al laboratorio
    subplot(1,2,2)
imshow(reshape(X(i,:),112,92));title('Encontrado puede ingresar al laboratorio','FontWeight','bold','Fontsize',16,'color','red');
end
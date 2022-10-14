%% Leer
nube_base = load('merged_red.txt');
ptCloud = pointCloud(nube_base(:,1:3));

%% Semillas
nube_markers = load('new_markers.txt');

% Buscar ids de puntos mas cercanos
[id_markers,d_markers] = knnsearch(ptCloud.Location,nube_markers(:,1:3),'K',1);

seeds = id_markers';
label_seeds = 1:length(nube_markers);

%% Calcular normales
k = 25;
normals = pcnormals(ptCloud,25);

% Orientaciones 
tilt1 = abs(atan(sqrt(normals(:,2).^2+normals(:,3).^2)./normals(:,1)))*180/pi;
tilt2 = abs(atan(sqrt(normals(:,3).^2+normals(:,1).^2)./normals(:,2)))*180/pi;
tilt3 = abs(atan(sqrt(normals(:,1).^2+normals(:,2).^2)./normals(:,3)))*180/pi;

% Guardado comprobación
% dlmwrite('pc_tilt.txt',[nube_base(:,1:3) tilt1 tilt2 tilt3],'delimiter',' ','precision', 12);

%% Vecindad
[ind,d] = knnsearch(ptCloud.Location,ptCloud.Location,'K',26);

% Correccion knn Matlab
ind = ind(:,2:26);
d = d(:,2:26);

%% Parámetros
th = 20; % Umbral de orientación en grados
thd = 0.25; % Umbral de distancia en metros

%% Growing
tic
% Registros de toda la nube
reg_total_segmentado = [];

% Etiquetas
labels = zeros(ptCloud.Count,1);

for i_marker = 1 : length(seeds)  
    
    % Region que se está generando
    reg = [];    
    
    % Registro de regiones pendientes
    reg_pend = seeds(i_marker);
    
    while true
        % Filtros de proximidad y orientación 
        filtro_dist = d(reg_pend(1),:) < thd;
        filtro_threshold1 = abs((tilt1(ind(reg_pend(1),:)) - tilt1(seeds(i_marker))));
        filtro_threshold2 = abs((tilt2(ind(reg_pend(1),:)) - tilt2(seeds(i_marker))));
        filtro_threshold3 = abs((tilt3(ind(reg_pend(1),:)) - tilt3(seeds(i_marker))));
        filtro_threshold = (filtro_threshold1 < th) & (filtro_threshold2 < th) & (filtro_threshold3 < th);
        reg_to_add = ind(reg_pend(1),:).*filtro_dist.*filtro_threshold';
        
        % Eliminar repetidos y ya segmentados
        repetidos_reg = ~ismember(reg_to_add,reg);
        repetidos_reg_temp = ~ismember(reg_to_add,reg_pend);
        repetidos_reg_total = ~ismember(reg_to_add,reg_total_segmentado);
        reg_to_add = reg_to_add.*repetidos_reg.*repetidos_reg_temp.*repetidos_reg_total;
                
        % Borrar indices 0
        ind_zeros = reg_to_add == 0;
        reg_to_add(ind_zeros)=[];
        
        % Añadir nuevas regiones al registro de pendientes
        reg_pend = [reg_pend reg_to_add];
         
        % Añadir region analizada al registro actual y borrarlo de regiones pendientes
        reg = [reg reg_pend(1)];
        reg_pend(1) = [];        
        
        % Si no hay nuevas reg pendientes, finalizar
        if isempty(reg_pend)
            break
        end
    end
    % Añadir al registro total las regiones ya segmentadas
    reg_total_segmentado = [reg_total_segmentado reg];
        
    %Asignar valores
    labels(reg) = label_seeds(i_marker);
     
end
toc

%% Guardar
dlmwrite('pc_seg_final_id.txt',[nube_base(:,1:3) labels],'delimiter',' ','precision', 12);

%% Color aleatorio
r = rand(length(nube_markers),3);
color_map = floor(255*r);
color_map = [0 0 0 ; color_map]; % Black for no labelled

dlmwrite('pc_seg_final_color.txt',[nube_base(:,1:3) color_map(labels+1,1:3)],'delimiter',' ','precision', 12);

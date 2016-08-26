classdef (Abstract) Volumes < handle
    % Classe abstraite contenant les propri�t�s et m�thodes communes aux
    % diff�rentes format de fichiers � charger contenant des volumes
    
    
    properties
        modele
        donnees % L'ensemble des donn�es, soit les donn�es 4D
        ordre_axes = [1,2,3,4] % 1 repr�sente X, 2 -> Y, 3 -> Z, 4 -> Temps
                                % L'ordre des axes est signifi� par l'ordre
                                % dans la liste.
                                % Par exemple, [1,2,3,4] correspond � une
                                % image affich�e avec en abscisses X, en
                                % ordonn�es Y, en 3�me dimension Z
                                % et en 4�me dimension le temps
        taille_axes_enregistree % Pour ne pas avoir � calculer toujours la
                                % taille des axes, on l'enregistre dans
                                % cette propri�t�
        coordonnee_axe3_selectionnee = 1
        coordonnee_axe4_selectionnee = 1
        chemin_a_afficher
        vue_choisie = 0
    end
    
    properties (Dependent)
        taille_axes
    end
    
    methods (Abstract)
        charger(soi) % La mani�re de charger est propre � chacun des formats
                    % cette m�thode est donc abstraite et impl�ment�e dans
                    % les classes concr�tes qui h�ritent de cette classe
    end
    
    methods
        
        function valeur = get.taille_axes(soi)
            % Pour obtenir la taille des axes actuelle � chaque appel de
            % soi.taille_axes (propri�t� calcul�e au moment o� on veut
            % savoir sa valeur)
           valeur=[size(soi.donnees,1),...
               size(soi.donnees,2),...
               size(soi.donnees,3),...
               size(soi.donnees,4)];
           % Pour �viter des calculs permanents, on l'enregistre dans une
           % propri�t�
           soi.taille_axes_enregistree=valeur;
        end
        
        
        
        function mettre_a_jour_image_clavier(soi,eventdata)
            % R�agit � une pression d'un bouton sur le clavier et met �
            % jour l'image en cons�quence
            
            donnees_4D = soi.donnees;
            
            orientation_plan_affichage_actuel = soi.vue_choisie;

            % On ajoute la possibilit� � l'utilisateur de choisir l'orientation de son plan et
            % naviguer entre les images au moyen des fl�ches multidirectionnelles
            if soi.coordonnee_axe3_selectionnee>=1 && soi.coordonnee_axe3_selectionnee<=soi.taille_axes(3) && soi.coordonnee_axe4_selectionnee>=1 && soi.coordonnee_axe4_selectionnee<=soi.taille_axes(4)
                switch eventdata.Key
                    %% Naviguer entre les images � l'aide des fl�ches multidirectionnelles
                    case  'rightarrow'
                        soi.coordonnee_axe3_selectionnee=soi.coordonnee_axe3_selectionnee+1;
                        if soi.coordonnee_axe3_selectionnee>soi.taille_axes(3)
                            soi.coordonnee_axe3_selectionnee=soi.taille_axes(3);
                        end
                    case 'leftarrow'
                        soi.coordonnee_axe3_selectionnee=soi.coordonnee_axe3_selectionnee-1;
                        if soi.coordonnee_axe3_selectionnee<1
                            soi.coordonnee_axe3_selectionnee=1;
                        end
                    case 'downarrow'
                        soi.coordonnee_axe4_selectionnee=soi.coordonnee_axe4_selectionnee-1;
                        if soi.coordonnee_axe4_selectionnee<1
                            soi.coordonnee_axe4_selectionnee=1;
                        end
                    case 'uparrow'
                        soi.coordonnee_axe4_selectionnee=soi.coordonnee_axe4_selectionnee+1;
                        if soi.coordonnee_axe4_selectionnee>soi.taille_axes(4)
                            soi.coordonnee_axe4_selectionnee=soi.taille_axes(4);
                        end
                    %% Naviguer entre les orientation de plans � l'aide des chiffres du clavier
                    % J'ai pris cette fonction quelque part, et j'ai eu
                    % beau renommer tous les noms de variables en des
                    % choses compr�hensibles, la logique du type qui l'a
                    % �crit m'�chappe. Recodez la fonction si vous en avez
                    % l'envie...
                    case {'0','numpad0'}
                        %% Si l'orientation du plan d'affichage n'est pas 0 (plan axial)
                        if orientation_plan_affichage_actuel ~= 0;
                            %% Ligne incompr�hensible due � un codage catastrophique de celui qui a
                            % originalement �crit la fonction de changement
                            % d'image... j'ai abandonn� la compr�hension et
                            % n'ai pas eu le courage de r��crire le code
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_actuel);
                        end;
                        %% apr�s modification, le plan d'affichage est 0
                        % (plan axial)
                        orientation_plan_affichage_actuel = 0;
                        %% L'ordre des axes a chang�, on le met � jour
                        soi.ordre_axes = [1,2,3,4]; % plan axial (x-y)
                    case {'1','numpad1'}
                        %% Si l'utilisateur a tap� 1 (plan lat�ral), 
                        % on choisit 1  comme plan d'affichage
                        orientation_plan_affichage_choisi = 1;
                        %% Si le plan d'affichage 1 n'a pas d�j� �t� choisi...
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            % On r�ordonne les axes des donn�es en
                            % [1,2,3,4]
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            % Puis on applique la permutation vers l'axe
                            % choisi
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        % L'orientation du plan de l'affichage est
                        % maintenant 1 (plan lat�ral)
                        orientation_plan_affichage_actuel = 1;
                        % L'ordre des axes a chang�, on le met � jour
                        soi.ordre_axes = [1,3,2,4]; % plan lat�ral (x-z)
                    case {'2','numpad2'}
                        %% Voir cas 1
                        orientation_plan_affichage_choisi = 2;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 2;
                        soi.ordre_axes = [2,3,1,4]; % plan transverse (y-z)
                    case {'3','numpad3'}
                        %% Voir cas 1
                        orientation_plan_affichage_choisi = 3;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 3;
                        soi.ordre_axes = [4,1,3,2]; % plan temps-x
                    case {'4','numpad4'}
                        %% Voir cas 1
                        orientation_plan_affichage_choisi = 4;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 4;
                        soi.ordre_axes = [4,2,3,1]; % plan temps-y
                    case {'5','numpad5'}
                        %% Voir cas 1
                        orientation_plan_affichage_choisi = 5;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 5;
                        soi.ordre_axes = [4,3,2,1]; % plan temps-z
                end
            end
            
            %% On donne � la propri�t� donnees le fruit de nos changements
            % d'axes
            soi.donnees = donnees_4D;
            
            %% Si apr�s le changement de vue on d�passe la taille des
            % nouveaux axes avec les coordonn�es s�lectionn�es, alors on
            % r�d�finit les coordonn�es s�lectionn�es comme �tant les
            % maximums de la taille des nouveaux axes
            if soi.coordonnee_axe3_selectionnee>soi.taille_axes(3)
                soi.coordonnee_axe3_selectionnee=soi.taille_axes(3);
            end
            
            if soi.coordonnee_axe4_selectionnee>soi.taille_axes(4)
                soi.coordonnee_axe4_selectionnee=soi.taille_axes(4);
            end
            
            %% On enregistre le r�sultat des changements
            soi.vue_choisie = orientation_plan_affichage_actuel;
            soi.modele.image = donnees_4D(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
        end
         
        function mettre_a_jour_image_bouton(soi,coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee)
            % Met � jour l'image si on a entr� les coordonn�es dans l'interface
            % graphique
            soi.coordonnee_axe3_selectionnee=coordonnee_axe3_selectionnee;
            soi.coordonnee_axe4_selectionnee=coordonnee_axe4_selectionnee;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
         end
        
    end
    
    methods (Static)
        
        function volumes_permutes = permuter(volumes_originaux,orientation_plan_affichage_choisi)
            % Permet de permuter les axes des volumes_originaux de sorte
            % qu'ils changent l'ordre de leurs axes de sorte que l'orientation du plan
            % affich� soit orientation_plan_affichage_choisi 
            % Les volumes ainsi permut�s seront retourn�s par la fonction.
            
            %% En fonction de l'orientation de plan choisie pour l'affichage,
            % on d�finit l'ordre des axes voulu par l'utilisateur
            switch orientation_plan_affichage_choisi
                case 0
                    ordre_axes_desire = [1,2,3,4]; % plan axial (x-y)
                case 1
                    ordre_axes_desire = [1,3,2,4]; % plan lat�ral (x-z)
                case 2
                    ordre_axes_desire = [2,3,1,4]; % plan transverse (y-z)
                case 3
                    ordre_axes_desire = [4,1,3,2]; % plan temps-x
                case 4
                    ordre_axes_desire = [4,2,3,1]; % plan temps-y
                case 5
                    ordre_axes_desire = [4,3,2,1]; % plan temps-z
            end;
            
            %% Op�ration qui permute les axes des volumes de sorte 
            % qu'ils correspondent � l'ordre des axes d�sir�
            volumes_permutes = ipermute(volumes_originaux,ordre_axes_desire);
            
        end
        
        function volumes_originaux = revenir_ordre_axes_original(volumes_permutes,orientation_plan_affichage_actuel)
            % Permet de restaurer les volumes_originaux � partir des
            % volumes_permutes et de l'orientation du plan affich�
            % actuellement. Les volumes originaux sont retourn�s par 
            % la fonction.
            
            %% En fonction de l'orientation de plan de l'affichage actuel,
            % on d�finit l'ordre des axes auquel il correspond
            switch orientation_plan_affichage_actuel
                case 0
                    ordre_axes_actuel = [1,2,3,4]; % plan axial (x-y)
                case 1
                    ordre_axes_actuel = [1,3,2,4]; % plan lat�ral (x-z)
                case 2
                    ordre_axes_actuel = [2,3,1,4]; % plan transverse (y-z)
                case 3
                    ordre_axes_actuel = [4,1,3,2]; % plan temps-x
                case 4
                    ordre_axes_actuel = [4,2,3,1]; % plan temps-y
                case 5
                    ordre_axes_actuel = [4,3,2,1]; % plan temps-z
            end;
            
            %% Op�ration qui permute les axes des volumes de sorte 
            % que les volumes_permutes selon l'ordre des axes actuel
            % reviennent � leur ordre des axes original
            volumes_originaux = permute(volumes_permutes,ordre_axes_actuel);
        end        
        
    end
    
end



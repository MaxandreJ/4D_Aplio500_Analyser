classdef Graphique < handle
    %Classe contenant les propri�t�s et m�thodes d'un graphique
    
    properties
        modele
        abscisses
        ordonnees
        axe_abscisses_choisi
        axe_moyenne_choisi
        pics
        largeurs_a_mi_hauteur
        une_seule_courbe
        noms_axes_legende_abscisses
        noms_axes
        chemin_enregistrement_export
    end
    
    properties (Dependent)
        titre
    end
    
    methods (Access = ?Modele)  % Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance du Graphique
        function soi = Graphique(modele,axe_abscisses_choisi,axe_moyenne_choisi)
            % Constructeur d'un graphique, il ne peut n'y en avoir qu'un
            
            %% On r�cup�re les arguments et on les passe en propri�t�s de l'instance
            soi.modele = modele;
            soi.axe_abscisses_choisi= axe_abscisses_choisi;
            soi.axe_moyenne_choisi= axe_moyenne_choisi;

            %% D�finition de propri�t�s utiles pour l'affichage
            soi.noms_axes_legende_abscisses={'X (en pixels)','Y (en pixels)','Z (en pixels)','Temps (en pas de temps)'};
            soi.noms_axes=['X','Y','Z','Temps'];
            
            %% On d�termine si une seule courbe est affich�e ou non
            if isa(soi.modele.region_interet,'Region_interet_rectangle')
                ROI_en_ligne = xor(soi.modele.region_interet.coordonnees_axe1_distinctes,soi.modele.region_interet.coordonnees_axe2_distinctes);
            else
                ROI_en_ligne = false;
            end

            %On a une seule courbe si la region d'inter�t est une ligne ou
            %si on a moyenn� les valeurs dans les r�gion d'int�r�t
            soi.une_seule_courbe = ROI_en_ligne || ~strcmp(soi.axe_moyenne_choisi,'pas de moyenne');
        
        end
    end

    methods
        
        function creer_pics(soi)
            % Instanciation des pics
            soi.pics = Pics(soi); %On indique � l'enfant son parent
        end
        
        function definir(soi)
            % Chargement des valeurs d'ordonn�es et d'abscisses du graphique
            
            %% Importation des param�tres n�cessaires
            volumes = soi.modele.volumes;
            region_interet = soi.modele.region_interet;
            donnees_ROI=region_interet.donnees_4D;
            image_ROI=region_interet.donnees_2D;
            taille_axes=volumes.taille_axes_enregistree;
            coordonnee_axe3_selectionnee=volumes.coordonnee_axe3_selectionnee;
            coordonnee_axe4_selectionnee=volumes.coordonnee_axe4_selectionnee;
            
            if isa(region_interet,'Region_interet_rectangle')
                coordonnee_axe1_debut_ROI = region_interet.coordonnee_axe1_debut;
                coordonnee_axe2_debut_ROI = region_interet.coordonnee_axe2_debut;
                coordonnee_axe1_fin_ROI = region_interet.coordonnee_axe1_fin;
                coordonnee_axe2_fin_ROI = region_interet.coordonnee_axe2_fin;
            end
            
            %% Moyennage des donn�es selon l'axe ou les axes choisis
            switch soi.axe_moyenne_choisi
                case '1'
                    image_ROI = mean(image_ROI,1);
                    %Enlever les dimensions inutiles laiss�es par la moyenne
                    image_ROI = squeeze(image_ROI);
                case '2'
                    image_ROI = mean(image_ROI,2);
                    %Pour avoir toujours des donn�es en ligne
                    image_ROI = image_ROI';
                    %Enlever les dimensions inutiles laiss�es par la moyenne
                    image_ROI = squeeze(image_ROI);
                case '1 et 2'
                    donnees_ROI=nanmean(nanmean(donnees_ROI,1),2);
                    %Enlever les dimensions inutiles laiss�es par les moyennes
                    donnees_ROI=squeeze(donnees_ROI);
                case 'pas de moyenne'
            end
            
            %% Selection des donn�es en fonctions de l'axe des abscisses
            % choisi pour l'affichage du graphique
            switch soi.axe_abscisses_choisi
                case 1
                    % Passage en vecteur colonne
                    soi.abscisses = (int16(coordonnee_axe1_debut_ROI):int16(coordonnee_axe1_fin_ROI))';
                    % Passage en vecteur colonne
                    soi.ordonnees = image_ROI';
                case 2
                    % Passage en vecteur colonne
                    soi.abscisses = (int16(coordonnee_axe2_debut_ROI):int16(coordonnee_axe2_fin_ROI))';
                    % Passage en vecteur colonne
                    soi.ordonnees = image_ROI';
                case 3
                    % Passage en vecteur colonne
                    soi.abscisses = (1:int16(taille_axes(3)))';
                    % D�j� en vecteur colonne
                    soi.ordonnees = donnees_ROI(:,coordonnee_axe4_selectionnee);
                case 4
                    % Passage en vecteur colonne
                    soi.abscisses = (1:int16(taille_axes(4)))';
                    % Passage en vecteur colonne
                    soi.ordonnees = donnees_ROI(coordonnee_axe3_selectionnee,:)';
            end
            
            %% Passage des propri�t�s locales aux propri�t�s du mod�le
            % pour observation par la vue
            soi.modele.ordonnees_graphique = soi.ordonnees;
            soi.modele.abscisses_graphique = soi.abscisses;
        end
        
        function exporter(soi)
            % Enregistrement d'une image du graphique dans un dossier choisi
            %% Choix du chemin d'enregistrement
            [nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
            %% Enregistreement du chemin en propri�t�s locales, et du mod�le
            % pour observation par la vue
            soi.chemin_enregistrement_export = fullfile(chemin,nom_du_fichier);
            soi.modele.chemin_enregistrement_export_graphique = soi.chemin_enregistrement_export;
        end
    
    end
end


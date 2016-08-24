classdef Modele < handle
    % Classe parente des autres classes du mod�le.
    % Le mod�le mod�lise la t�che � effectuer (cr�er un logiciel d'analyse
    % d'images ultrasonores 4D) en l'organisant en un syst�me d'objets
    % dot�s de propri�t�s (caract�ristiques) et capables de m�thodes
    % (actions) sur le reste des objets avec lesquels il est en
    % interaction.
    
    %% Propri�t�s observables : un changement dans ces propri�t�s pourra
    % notifier la vue. 
    % Le mod�le n'appelle jamais la vue mais la vue r�agit pourtant. 
    % C'est gr�ce � ce principe, appel� patron de conception
    % observ�/observeur que l'on rend le mod�le ind�pendant de la vue
    % (puisqu'elle n'y est jamais mentionn�e).
    properties (SetObservable)
        image
        chemin_donnees
        donnees_region_interet
        entropie_region_interet
        abscisses_graphique
        ordonnees_graphique
        largeur_a_mi_hauteur_pic_choisi
        distance_pic_a_pic_choisie
        vecteur_temps_echantillonnage_normal
        vecteur_temps_sous_echantillonnage
        chemin_enregistrement_export_graphique
        chemin_enregistrement_export_image
        chemin_enregistrement_export_interface
    end
    
    %% Propri�t�s qui sont les enfants du mod�le
    properties
        volumes
        region_interet
        graphique
        sous_echantillonnage
    end
        
    methods
%         function soi = Modele()
%             %obj.reset()
%         end
        
        
        function creer_volumes_fichier_mat(soi)
            % Instanciation des volumes 4D provenant d'un fichier .mat
            soi.volumes = Volumes_fichier_mat(soi); %On indique � l'enfant son parent
        end
        
        function creer_volumes_dossier_mat(soi)
            % Instanciation des volumes provenant d'un dossier de fichiers
            % .mat correspondant aux volumes 3D � diff�rents pas de temps
            % du volumes 4D � reconstituer
            soi.volumes = Volumes_dossier_mat(soi); %On indique � l'enfant son parent
        end
        
        function creer_volumes_RawData_bin(soi)
            % Instanciation des volumes provenant d'un dossier de
            % RawDataXXX.bin correspondant aux volumes 3D � diff�rents pas de temps
            % du volumes 4D � reconstituer
            soi.volumes = Volumes_RawData_bin(soi); %On indique � l'enfant son parent
        end
        
        function creer_volumes_VoxelData_bin(soi)
            % Instanciation des volumes provenant d'un dossier de
            % VoxelDataXXX.bin correspondant aux volumes 3D � diff�rents pas de temps
            % du volumes 4D � reconstituer
            soi.volumes = Volumes_VoxelData_bin(soi); %On indique � l'enfant son parent
        end
        

        
        function creer_region_interet_rectangle(soi)
            % Instanciation d'une r�gion d'int�r�t en forme de rectangle
            soi.region_interet = Region_interet_rectangle(soi); %On indique � l'enfant son parent
        end
        
        function creer_region_interet_polygone(soi)
            % Instanciation d'une r�gion d'int�r�t en forme de polygone
            soi.region_interet = Region_interet_polygone(soi); %On indique � l'enfant son parent
        end
        
        function creer_graphique(soi,axe_abscisses_choisi,axe_moyenne_choisi)
            % Instanciation du graphique
            soi.graphique = Graphique(soi,axe_abscisses_choisi,axe_moyenne_choisi); %On indique � l'enfant son parent
        end
        
        function creer_sous_echantillonnage(soi)
            % Instanciation du sous-echantillonnage
            soi.sous_echantillonnage = Sous_echantillonnage(soi); %On indique � l'enfant son parent
        end
        
        function exporter_image(soi)
            % Enregistrement de l'image en cours
            %% On demande le chemin o� enregistrer le fichier
            [nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
            %% On l'enregistre dans les propri�t�s du mod�le
            soi.chemin_enregistrement_export_image = fullfile(chemin,nom_du_fichier);
        end
        
        function exporter_interface(soi)
            % Enregistrement de l'interface enti�re dans son �tat actuel
            %% On demande le chemin o� enregistrer le fichier
            [nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
            %% On l'enregistre dans les propri�t�s du mod�le
            soi.chemin_enregistrement_export_interface = fullfile(chemin,nom_du_fichier);
        end
    end
end

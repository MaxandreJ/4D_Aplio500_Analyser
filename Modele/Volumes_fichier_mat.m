classdef Volumes_fichier_mat < Volumes
    % Classe concr�te contenant les propri�t�s et m�thodes particuli�res �
    % une volumes import� d'un fichier au format .mat
    % et h�ritant des propri�t�s et m�thodes de la classe abstraite Volumes
    
    properties
    end
    
    methods (Access = ?Modele)  % Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_fichier_mat
        function soi = Volumes_fichier_mat(modele)
            % Constructeur d'une instance de Volumes_fichier_mat, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    methods
        
        function charger(soi)
            % Chargement des volumes � partir d'un fichier au format .mat
            
            % On r�cup�re le fichier � charger
            [nom_du_fichier, chemin_du_dossier] = uigetfile({'*.mat'},'Choix des volumes 4D en format .mat');
            
            %% On enregistre le chemin dans les propri�t�s du volumes et du mod�le
            soi.chemin_a_afficher=[chemin_du_dossier, nom_du_fichier];
            soi.modele.chemin_donnees=soi.chemin_a_afficher;
            
            %% On charge le fichier qui est une structure
            cellules_donnees_4D = struct2cell(load([chemin_du_dossier, nom_du_fichier], '-mat'));
            
            %% On enregistre les donn�es dans les propri�t�s du volumes et du mod�le
            soi.donnees = cellules_donnees_4D{1}; 
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
        end
    end
    
end


classdef Volumes_dossier_mat < Volumes
    % Classe concr�te contenant les propri�t�s et m�thodes particuli�res �
    % une volumes import� d'un dossier contenant des fichiers au format
    % .mat (chaque fichier repr�sentant un pas de temps)
    % et h�ritant des propri�t�s et m�thodes de la classe abstraite Volumes
    
    properties
    end
    
    methods (Access = ?Modele)  % Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_dossier_mat
        function soi = Volumes_dossier_mat(modele)
            % Constructeur d'une instance de Volumes_dossier_mat, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    methods
        
        function charger(soi)
            % Chargement des volumes � partir d'un dossier de fichiers au
            % format .mat (chaque fichier repr�sentant un pas de temps)
            
            %% On r�cup�re le chemin du dossier � charger
            chemin_du_dossier = uigetdir;
            
            %% On le passe au mod�le pour affichage
            soi.modele.chemin_donnees=chemin_du_dossier;
            
            %% On pr�pare le terrain pour l'import
            % La fonction dir r�cup�re les donn�es du dossier s�lectionn�
            d = dir(chemin_du_dossier);
            
            % On calcule le nombre de fichiers dans le dossier
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            
            % Pr�allocations
            structure_fichiers = cell((nb_fichiers-2),1);
            fichiers = cell((nb_fichiers-2),1);

            barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');
            
            %% Import
            for ifichier = 1:nb_fichiers-2
                % On charge le fichier qui est une structure
                % Note : pour �viter les fichiers . .. (pr�sent dans tout dossier)
                % on commence au fichier num�ro 3 (cf. code ci-dessous "d(ifichier+2).name")
                structure_fichiers{ifichier} = struct2cell(load(fullfile(chemin_du_dossier,d(ifichier+2).name)));
                
                %On extrait les donn�es de la structure
                structure_fichier_traite = structure_fichiers{ifichier}; 
                fichiers{ifichier} = structure_fichier_traite{1}; 
                
                waitbar(ifichier/(nb_fichiers-2));
            end
            
            %% On concat�ne les diff�rents fichiers import�s selon le 4�me axe
            % qui est l'axe du temps. En effet les fichiers correspondent
            % chacun � un pas de temps particulier.
            donnees_4D = cat(4,fichiers{:});
            
            %% On enregistre les donn�es dans les propri�t�s du volumes et du mod�le
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            
            close(barre_attente);
        end
    end
    
end

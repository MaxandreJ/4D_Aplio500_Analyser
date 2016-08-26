classdef Volumes_VoxelData_bin < Volumes
    % Classe concr�te contenant les propri�t�s et m�thodes particuli�res �
    % une volumes import� d'un dossier contenant des fichiers au format
    % .bin format�s en VoxelData (chaque fichier repr�sentant un pas de temps)
    % et h�ritant des propri�t�s et m�thodes de la classe abstraite Volumes
    
    properties
        dossier_chargement_par_defaut = 'C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Dragonskin02_VoxelData'
    end
    
    methods (Access = ?Modele)  % Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_VoxelData_bin
        function soi = Volumes_VoxelData_bin(modele)
            % Constructeur d'une instance de Volumes_VoxelData_bin, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    methods
        function charger(soi)
            % Chargement des volumes � partir d'un dossier de fichiers au
            % fichiers au format .bin format�s en VoxelData 
            % (chaque fichier repr�sentant un pas de temps)
            
            %% On r�cup�re le chemin du dossier � charger
            chemin = uigetdir(soi.dossier_chargement_par_defaut,'Dossier contenant les volumes en .bin');
            
            soi.chemin_a_afficher=chemin;
            %% On le passe au mod�le pour affichage
            soi.modele.chemin_donnees=soi.chemin_a_afficher;
            
            %% On pr�pare le terrain pour l'import
            % La fonction dir r�cup�re les donn�es du dossier s�lectionn�
            d = dir(chemin);
            
            % On calcule le nombre de fichiers dans le dossier
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            
            % Pr�allocations
            identifiants_fichiers = cell((nb_fichiers-3),1);
            fichiers = cell((nb_fichiers-3),1);
            donnees_4D = zeros(256,256,256,nb_fichiers-3);

            barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');
            
            %% Import
            for ifichier = 1:nb_fichiers-3
                % On charge le fichier en cours de traitement
                % Note : pour �viter les fichiers . .. et PatientInfo.txt 
                % on commence au fichier num�ro 4 (cf. code ci-dessous "d(ifichier+3).name")
                
                % Ouverture du fichier
                identifiants_fichiers{ifichier}=fopen(fullfile(chemin,d(ifichier+3).name));
                
                % Lecture
                fichiers{ifichier} = fread(identifiants_fichiers{ifichier});
                
                % On utilise pour les Voxel Data une m�thode apparemment
                % plus basique pour importer les donn�es que dans les
                % m�thodes charger() des autres classes.
                % On n'utilise ici pas de grande concat�nation (fonction cat()) 
                % car on a remarqu� que cela faisait planter MATLAB
                % si le nombre de fichiers �tait sup�rieur � 45.
                % En passant par cette m�thode, MATLAB ne plante plus (il
                % est juste tr�s lent). Peut-�tre qu'augmenter la m�moire
                % virtuelle ou � d�faut changer d'ordinateur (aller sur la station
                % de St�phanie Pitre, tr�s puissante ?) permettrait de
                % lire des fichiers de plus de 45 pas de temps sans �norme 
                % ralentissement, comme actuellement.
                % On redimensionne �galement les donn�es pour �tre au
                % format 256 x 256 x 256 comme indiqu� par Toshiba Medical
                % Systems.
                donnees_4D(:,:,:,ifichier)= reshape(fichiers{ifichier},256,256,256);
                
                waitbar(ifichier/(nb_fichiers-3));
            end
            
            %% On enregistre les donn�es dans les propri�t�s du volumes et du mod�le
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            
            close(barre_attente);
        end
    end  
end


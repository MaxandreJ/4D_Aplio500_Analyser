classdef Volumes_RawData_bin < Volumes
    % Classe concr�te contenant les propri�t�s et m�thodes particuli�res �
    % une volumes import� d'un dossier contenant des fichiers au format
    % .bin format�s en RawData (chaque fichier repr�sentant un pas de temps)
    % et h�ritant des propri�t�s et m�thodes de la classe abstraite Volumes
    
    properties
        dossier_chargement_par_defaut = 'C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Raw'
    end
    
    methods (Access = ?Modele)  % Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_RawData_bin
        function soi = Volumes_RawData_bin(modele)
            % Constructeur d'une instance de Volumes_RawData_bin, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    methods
        function charger(soi)
            % Chargement des volumes � partir d'un dossier de fichiers au
            % fichiers au format .bin format�s en RawData 
            % (chaque fichier repr�sentant un pas de temps)
            
            %% On r�cup�re le chemin du dossier � charger
            chemin = uigetdir(soi.dossier_chargement_par_defaut,'Dossier contenant les volumes en .bin');
            
            
            soi.chemin_a_afficher=chemin;
            %% On le passe au mod�le pour affichage
            soi.modele.chemin_donnees=soi.chemin_a_afficher;
            
            %% On pr�pare le terrain pour l'import
            % La fonction dir r�cup�re les donn�es du dossier s�lectionn�
            d = dir(chemin);
            
            % On charge Patient_info.txt
            patient_info_id = fopen(fullfile(chemin,d(3).name));
            
            % On lit Patient_info.txt
            patient_info = textscan(patient_info_id,'%s',11);
            patient_info = patient_info{1,1};
            range = str2double(patient_info{5});
            azimuth = str2double(patient_info{8});
            elevation = str2double(patient_info{11});
            
            % On calcule le nombre de fichiers dans le dossier
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            
            % Pr�allocations
            identifiants_fichiers = cell((nb_fichiers-3),1);
            fichiers = cell((nb_fichiers-3),1);

            barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');
            
            %% Import
            for ifichier = 1:nb_fichiers-3
                % On charge le fichier en cours de traitement
                % Note : pour �viter les fichiers . .. et PatientInfo.txt 
                % on commence au fichier num�ro 4 (cf. code ci-dessous "d(ifichier+3).name")
                
                % Ouverture du fichier
                identifiants_fichiers{ifichier} = fopen(fullfile(chemin,d(ifichier+3).name));
                
                % Lecture
                fichiers{ifichier} = fread(identifiants_fichiers{ifichier});
                
                % Redimensionnement du fichier au format range x azimuth x
                % elevation conform�ment � la documentation de Toshiba pour
                % les fichiers RawData.
                % Les valeurs de range, azimuth et elevation ont �t� trouv�es
                % dans le fichier PatientInfo.txt
                fichiers{ifichier} =reshape(fichiers{ifichier},range,azimuth,elevation);
                
                waitbar(ifichier/(nb_fichiers-3));
            end
            
            %% On concat�ne les diff�rents fichiers import�s selon le 4�me axe
            % qui est l'axe du temps. En effet les fichiers correspondent
            % chacun � un pas de temps particulier.
            donnees_4D = cat(4,fichiers{:});
            
            % On permute les donn�es qui ne sont pas enregistr�es au bon
            % format
            donnees_4D = permute(donnees_4D,[2,1,3,4]);
            
            %% On enregistre les donn�es dans les propri�t�s du volumes et du mod�le
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            
            close(barre_attente);
        end
    end
    
end


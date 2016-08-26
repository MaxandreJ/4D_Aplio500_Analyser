classdef Sous_echantillonnage < handle
    % Classe contenant les propri�t�s et m�thodes d'un sous_echantillonnage
    
    properties
        vecteur_temps_echantillonnage_normal % Les pas de temps pour lesquels
                                                % l'�chantillonnage est normal
                                                % c'est-�-dire pour lesquels 
                                                % on les prend tous
        vecteur_temps_sous_echantillonnage % Les pas de temps pour lesquels
                                                % on sous-�chantillonne
                                                % c'est-�-dire pour lesquels 
                                                % on ne les prend pas tous
        modele
    end
    
    methods (Access = ?Modele)  %% Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance de Sous_echantillonnage
        function soi = Sous_echantillonnage(modele)
            % Constructeur d'une instance de Sous_echantillonnage, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    methods
        function definir(soi,facteur_temps_intensite_maximale,facteur_sous_echantillonnage)
            % Calcul des vecteurs de temps normaux et sous-echantillonnes
            % pour futur enregistrement
            
            %% On importe les donn�es utiles
            volumes = soi.modele.volumes;
            region_interet = soi.modele.region_interet;
            graphique = soi.modele.graphique;
            
            nombre_de_pics = soi.modele.graphique.pics.nombre;
            ordre_axes = volumes.ordre_axes;
            
            % On g�re les erreurs en utilisant un bloc try...catch
            try
                % L'axe des abscisses du graphique n'est pas le temps si
                % - soit le quatri�me axe n'est pas choisi (le temps est
                % toujours soit au 1er, soit au 2�me, soit au 4�me axe -- 
                % mais dans le cas d'une r�gion d'int�r�t polygonale, les 1er
                % et 2�me axes des abscisses ne sont pas s�lectionnables) ;
                % - soit le quatri�me axe n'est pas le temps.
                axe_abscisse_pas_temps = ~(soi.modele.graphique.axe_abscisses_choisi == 4)...
                    || ordre_axes(4)~=4;
                
                %% On engendre des erreurs si...
                % on a d�tect� plusieurs pics � l'�tape de d�tection :
                    % Il est n�cessaire d'avoir d�tect� un seul pic pour proc�der au sous-echantillonnage
                    % qui commence � partir d'un temps d�termin� par une
                    % relation avec le temps � l'intensit� maximale
                if nombre_de_pics ~= 1
                    erreur_trop_de_pics.message = 'Le nombre de pics d�tect�s est strictement sup�rieur � 1.';
                    erreur_trop_de_pics.identifier = 'sous_echantillonnage_Callback:trop_de_pics';
                    error(erreur_trop_de_pics);
                % la r�gion d'int�r�t n'est pas de forme polygonale :
                    % Pour plus de pr�cision, on demande que le sous-�chantillonnage
                    % soit effectu� uniquement si la r�gion d'int�r�t a �t�
                    % d�limit�e par un polygone et non par un rectangle
                elseif ~isa(region_interet,'Region_interet_polygone')
                    erreur_polygone_pas_choisi.message = 'La r�gion d''int�r�t n''a pas �t� choisie avec un polygone.';
                    erreur_polygone_pas_choisi.identifier = 'sous_echantillonnage_Callback:polygone_pas_choisi';
                    error(erreur_polygone_pas_choisi);
                % l'axe des abscisses du graphique choisi n'est pas le temps :
                    % L'echantillonnage doit se fonder sur une �chographie de constraste
                    % dont on extrait une courbe de r�haussement du signal 
                    % avec l'arriv�e de l'agent de contraste qui est par d�finition fonction du temps
                elseif axe_abscisse_pas_temps
                    erreur_axe_abscisse_pas_temps.message = 'L''axe des abscisses du graphique affich� n''est pas le Temps.';
                    erreur_axe_abscisse_pas_temps.identifier = 'sous_echantillonnage_Callback:axe_abscisse_pas_temps';
                    error(erreur_axe_abscisse_pas_temps);
                end
                %% On initialise des param�tres importants
                % le t_maximum correspond au dernier pas de temps pris
                 t_maximum=graphique.abscisses(end);
                 
                 t_du_maximum_global = graphique.pics.abscisses;
                 compteur_sous_echantillonnage = 0;
                 % On pr�alloue les vecteurs pour optimiser les
                 % performances de la boucle suivante
                 soi.vecteur_temps_echantillonnage_normal = NaN(1,t_maximum);
                 soi.vecteur_temps_sous_echantillonnage = NaN(1,t_maximum);
                 
                 %% Pour chacun des pas de temps, on proc�de � l'�chantillonnage
                 for t=1:t_maximum
                        % Si le pas de temps est inf�rieur au temps � l'intensit� maximale
                        % par le facteur choisi par l'utilisateur, alors
                        % l'echantillonnage est normal (on prend tous les
                        % pas de temps)
                        condition_echantillonnage_normal = t<facteur_temps_intensite_maximale*t_du_maximum_global;
                        if condition_echantillonnage_normal
                            soi.vecteur_temps_echantillonnage_normal(t)=t;
                        % sinon, on enregistre un sur
                        % $facteur_sous_echantillonnage images
                        elseif mod(compteur_sous_echantillonnage,facteur_sous_echantillonnage)==0
                            soi.vecteur_temps_sous_echantillonnage(t) = t;
                            compteur_sous_echantillonnage = compteur_sous_echantillonnage + 1;
                        else
                            compteur_sous_echantillonnage = compteur_sous_echantillonnage + 1;
                        end
                 end
                 
                 %% On enl�ve les valeurs NaN en effectuant un filtrage bool�en
                 soi.vecteur_temps_echantillonnage_normal(...
                     isnan(soi.vecteur_temps_echantillonnage_normal)) = [];
                 soi.vecteur_temps_sous_echantillonnage(...
                     isnan(soi.vecteur_temps_sous_echantillonnage)) = [];
                 
                 %% On enregistre nos vecteurs d'�chantillonnage dans les param�tres du mod�le
                 % pour d�clencher l'action d'affichage sur le graphique
                 soi.modele.vecteur_temps_echantillonnage_normal = ...
                     soi.vecteur_temps_echantillonnage_normal;
                 soi.modele.vecteur_temps_sous_echantillonnage = ...
                     soi.vecteur_temps_sous_echantillonnage;
             catch erreurs
                 %% On g�re les erreurs lev�es
                 
                 %% Il est n�cessaire d'avoir d�tect� un seul pic pour proc�der au sous-echantillonnage
                 % qui commence � partir d'un temps d�termin� par une
                 % relation avec le temps � l'intensit� maximale
                if (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:trop_de_pics'))
                    warndlg('Merci de choisir de d�tecter un seul pic � l''�tape pr�c�dente.');
                    causeException = MException(erreur_trop_de_pics.identifier,erreur_trop_de_pics.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                    
                %% Pour plus de pr�cision, on demande que le sous-�chantillonnage
                % soit effectu� uniquement si la r�gion d'int�r�t a �t�
                % d�limit�e par un polygone et non par un rectangle
                elseif (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:polygone_pas_choisi'))
                    warndlg('Merci de choisir une r�gion d''int�r�t de forme polygonale et de recommencer les �tapes jusqu''ici.');
                    causeException = MException(erreur_polygone_pas_choisi.identifier,erreur_polygone_pas_choisi.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                    
                %% L'echantillonnage doit se fonder sur une �chographie de constraste
                % dont on extrait une courbe de r�haussement du signal 
                % avec l'arriv�e de l'agent de contraste qui est par d�finition fonction du temps
                elseif (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:axe_abscisse_pas_temps'))
                    warndlg('Merci de choisir comme axe des abscisse le temps � l''�tape ''affichage du graphique''.');
                    causeException = MException(erreur_axe_abscisse_pas_temps.identifier,erreur_axe_abscisse_pas_temps.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                end
                %% On affiche les erreurs qui n'auraient pas �t� g�r�es
                rethrow(erreurs);
            end
        end
        
        function sauvegarder(soi)
            % Enregistre les images sous-echantillonnees
            
            
            % On transforme l'avertissement de taille de fichier .mat trop grand
            % en erreur
            etat_erreur_premodification=warning('error', 'MATLAB:save:sizeTooBigForMATFile');
            
            % On g�re les erreurs en utilisant un bloc try...catch
            try
                %% On demande � l'utilisateur le chemin de sauvegarde
                [nom_du_fichier,chemin_sauvegarde] = uiputfile({'*.*'});
                %% Si l'utilisateur a annul� son action de sauvegarde, on renvoie une erreur
                choix_annulation = isequal(nom_du_fichier,0) || isequal(chemin_sauvegarde,0);
                if choix_annulation
                    erreur_choix_annulation.message = 'L''utilisateur a annul� son action de sauvegarde.';
                    erreur_choix_annulation.identifier = 'sous_echantillonnage_Callback:choix_annulation';
                    error(erreur_choix_annulation);
                end
                
                %% On se place dans le bon dossier pour enregistrement
                dossier_principal=pwd;
                cd(chemin_sauvegarde);
                
                %% On s�lectionne les volumes que l'on echantillonne normalement
                volumes_ech_normal=soi.modele.volumes.donnees(:,:,:,soi.vecteur_temps_echantillonnage_normal);
                volumes_ech_normal=squeeze(volumes_ech_normal);
                
                %% On s�lectionne les volumes que l'on sous-echantillone
                volumes_ssech=soi.modele.volumes.donnees(:,:,:,soi.vecteur_temps_sous_echantillonnage);
                volumes_ssech=squeeze(volumes_ssech);
                
                %% On concat�ne les volumes echantillonn�s normalement et sous-�chantillonn�s
                volumes_a_enregistrer = cat(4,volumes_ech_normal,volumes_ssech);
                
                %% On enregistre le fichier sans compression gr�ce � l'argument -v6
                % pour �viter ses probl�mes (cf. Contrast ultrasonography: necessity
                % of linear data processing for the quantification of tumor vascularization
                % Peronneau et al. http://www.ncbi.nlm.nih.gov/pubmed/20577941)
                save([nom_du_fichier,'.mat'],'volumes_a_enregistrer','-mat','-v6');
                cd(dossier_principal);
            catch erreurs
                %% On g�re les erreurs lev�es
                if (strcmp(erreurs.identifier, 'sous_echantillonnage_Callback:choix_annulation'))
                    causeException = MException(erreur_choix_annulation.identifier,erreur_choix_annulation.message);
                    erreurs = addCause(erreurs,causeException);
                elseif (strcmp(erreurs.identifier, 'MATLAB:save:sizeTooBigForMATFile'))
                    % Si la taille du fichier est trop grande etre enregistree sous un seul fichier.mat
                    % on enregistre chacun des volumes correspondant �
                    % chaque pas de temps s�par�ment dans un dossier
                    % portant le nom du fichier initial
                    %% On g�re l'erreur
                    message_erreur = ['Les donn�es sont trop grosses pour �tre enregistr�es dans un seul fichier.',...
                        'Les donn�es seront enregistr�es dans un dossier � la place.'];
                    causeException = MException('MATLAB:save:sizeTooBigForMATFile',message_erreur);
                    erreurs = addCause(erreurs,causeException);
                    
                    %% On importe les donn�es utiles
                    graphique = soi.modele.graphique;
                    t_maximum= graphique.abscisses(end);
                    %% Si le r�pertoire existe d�j� comme nom de fichier, on
                    % l'�crase.
                    % Le fichier � supprimer peut ne pas exister, on
                    % supprime les avertissements � ce sujet.
                    warning('off','all');

                    delete(nom_du_fichier);
                    
                    %% On remet les avertissements
                    warning('on','all');
                    
                    %% On cr�e le dossier et on s'y met
                    mkdir(nom_du_fichier);
                    cd(nom_du_fichier);
                    
                    %% On enregistre les volumes dans le dossier cr��
                    barre_attente = waitbar(0,{'Le fichier � enregistrer fait plus de deux Go :', ...
                        'fractionnement en fichiers individuels pour chacun des pas de temps',...
                        'et enregistrement dans un dossier s�par�.'});
                    for t=1:t_maximum
                        volume_a_enregistrer = volumes_a_enregistrer(:,:,:,t);
                        save([nom_du_fichier,num2str(t),'.mat'],'volume_a_enregistrer',...
                            '-mat','-v6');
                        waitbar(t/t_maximum);
                    end
                    %% On revient dans le dossier parent et on supprime le fichier .mat
                    % probablement cr�� dans la partie try...
                    cd('..');
                    delete([nom_du_fichier,'.mat']);
                    
                    %% On revient dans le dossier principal et on ferme la barre d'attente
                    cd(dossier_principal);

                    close(barre_attente);
                else
                    % On affiche les erreurs qui n'auraient pas �t� g�r�es
                    rethrow(erreurs);
                end
            end
            % On retransforme l'erreur de taille de fichier .mat trop grand
            % en avertissement, comme par d�faut
            warning(etat_erreur_premodification);
        end
    end
    
end


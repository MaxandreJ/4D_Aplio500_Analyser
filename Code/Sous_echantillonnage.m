classdef Sous_echantillonnage < handle
    %SOUS_ECHANTILLONNAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vecteur_t_ech_normal
        vecteur_t_ssech
        sauvegarde
    end
    
    methods
        function sous_echantillonner(soi,handles)
            volumes = handles.volumes;
            
            nombre_de_pics = str2double(get(handles.valeur_nombre_de_pics,'String'));
            choix_forme_ROI = volumes.choix_forme_ROI;
            graphique_selon_axe4_choisi = get(handles.abscisses_axe4,'value');
            ordre_axes = volumes.ordre_axes;
            
            try
                axe_abscisse_pas_temps = ~graphique_selon_axe4_choisi || ordre_axes(4)~=4;
                if nombre_de_pics ~= 1
                    erreur_trop_de_pics.message = 'Le nombre de pics d�tect�s est strictement sup�rieur � 1.';
                    erreur_trop_de_pics.identifier = 'sous_echantillonnage_Callback:trop_de_pics';
                    error(erreur_trop_de_pics);
                elseif ~strcmp(choix_forme_ROI,'polygone')
                    erreur_polygone_pas_choisi.message = 'La r�gion d''int�r�t n''a pas �t� choisie avec un polygone.';
                    erreur_polygone_pas_choisi.identifier = 'sous_echantillonnage_Callback:polygone_pas_choisi';
                    error(erreur_polygone_pas_choisi);
                elseif axe_abscisse_pas_temps
                    erreur_axe_abscisse_pas_temps.message = 'L''axe des abscisses du graphique affich� n''est pas le Temps.';
                    erreur_axe_abscisse_pas_temps.identifier = 'sous_echantillonnage_Callback:axe_abscisse_pas_temps';
                    error(erreur_axe_abscisse_pas_temps);
                end
                 facteur_temps_I_max=str2double(get(handles.facteur_temps_I_max,'string'));
                 facteur_sous_echantillonnage=str2double(get(handles.facteur_sous_echantillonnage,'string'));
                 graphique = handles.graphique;
                 t_maximum=graphique.abscisses(end);
                 t_du_maximum_global = graphique.abscisses_intensites_maximales;
                 compteur_sous_echantillonnage = 0;
                 soi.vecteur_t_ech_normal = NaN(1,t_maximum);
                 soi.vecteur_t_ssech=NaN(1,t_maximum);
                 for t=1:t_maximum
                        condition_echantillonnage_normal = t<facteur_temps_I_max*t_du_maximum_global;
                        if condition_echantillonnage_normal
                            soi.vecteur_t_ech_normal(t)=t;
                        elseif mod(compteur_sous_echantillonnage,facteur_sous_echantillonnage)==0
                            soi.vecteur_t_ssech(t) = t;
                            compteur_sous_echantillonnage = compteur_sous_echantillonnage + 1;
                        else
                            compteur_sous_echantillonnage = compteur_sous_echantillonnage + 1;
                        end
                 end
                 soi.vecteur_t_ech_normal(isnan(soi.vecteur_t_ech_normal)) = [];
                 soi.vecteur_t_ssech(isnan(soi.vecteur_t_ssech)) = [];
             catch erreurs
                if (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:trop_de_pics'))
                    warndlg('Merci de choisir de d�tecter un seul pic � l''�tape pr�c�dente.');
                    causeException = MException(erreur_trop_de_pics.identifier,erreur_trop_de_pics.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                elseif (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:polygone_pas_choisi'))
                    warndlg('Merci de choisir une r�gion d''int�r�t de forme polygonale et de recommencer les �tapes jusqu''ici.');
                    causeException = MException(erreur_polygone_pas_choisi.identifier,erreur_polygone_pas_choisi.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                elseif (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:axe_abscisse_pas_temps'))
                    warndlg('Merci de choisir comme axe des abscisse le temps � l''�tape ''affichage du graphique''.');
                    causeException = MException(erreur_axe_abscisse_pas_temps.identifier,erreur_axe_abscisse_pas_temps.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                elseif (strcmp(erreurs.identifier, 'sous_echantillonnage_Callback:choix_annulation'))
                    causeException = MException(erreur_choix_annulation.identifier,erreur_choix_annulation.message);
                    erreurs = addCause(erreurs,causeException);
                end   
                rethrow(erreurs);
            end
        end
        
        function sauvegarder(soi,handles)
            [nom_du_fichier,chemin_sauvegarde] = uiputfile({'*.*'});
            choix_annulation = isequal(nom_du_fichier,0) || isequal(chemin_sauvegarde,0);
            if choix_annulation
                erreur_choix_annulation.message = 'L''utilisateur a annul� son action de sauvegarde.';
                erreur_choix_annulation.identifier = 'sous_echantillonnage_Callback:choix_annulation';
                error(erreur_choix_annulation);
            end
            dossier_principal=pwd;
            cd(chemin_sauvegarde);
            
            volumes_ech_normal=handles.volumes.donnees(:,:,:,soi.vecteur_t_ech_normal);
            volumes_ech_normal=squeeze(volumes_ech_normal);
            
            volumes_ssech=handles.volumes.donnees(:,:,:,soi.vecteur_t_ssech);
            volumes_ssech=squeeze(volumes_ssech);
            
            volumes_a_enregistrer = cat(4,volumes_ech_normal,volumes_ssech);
            save([nom_du_fichier,'.mat'],'volumes_a_enregistrer','-mat');
            cd(dossier_principal);
        end
    end
    
end


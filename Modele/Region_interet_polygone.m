classdef Region_interet_polygone < Region_interet
    % Classe concr�te contenant les propri�t�s et m�thodes particuli�res �
    % une r�gion d'int�r�t de forme polygonale et h�ritant des propri�t�s
    % et m�thodes de la classe abstraite Region_interet
    
    properties
        masque_binaire_4D % Masque contenant vrai pour les valeurs � l'int�rieur
                            % de la r�gion d'int�r�t, et faux pour les
                            % autres
        polygone
    end
    
    methods (Access = ?Modele)  %% Seul un mod�le (instance d'une classe parente) 
                                    % peut construire une instance de Region_interet_polygone
        function soi = Region_interet_polygone(modele)
            % Constructeur d'une instance de Region_interet_polygone, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    methods
        
       function tracer(soi)
           % Pour tracer une r�gion d'int�r�t visuellement
           
       % On utilise un bloc try...catch pour g�rer les erreurs
        try
            %% On importe la donn�e utile
            taille_axes = soi.modele.volumes.taille_axes_enregistree;
            
            %% On commence � tracer le polygone
            soi.polygone=impoly;
            
            %% Si jamais l'utilisateur change de vue en plein milieu de sa
            % s�ance de tra�age de polygone, on renvoie une erreur
            if isempty(soi.polygone)
                erreur_ROI_pas_choisi.message = 'La r�gion d''int�r�t n''a pas �t� d�limit�e avant le changement de vue.';
                erreur_ROI_pas_choisi.identifier = 'polygone_Callback:ROI_pas_choisi';
                error(erreur_ROI_pas_choisi);
            end
            
            %% On cr�e un masque bool�en (.==1 dans la zone d'int�r�t choisie,
            % .==0 en dehors) � partir de la r�gion d'int�r�t 
            masque_binaire_2D=soi.polygone.createMask();
            
            %% On convertit le masque qui a �t� dessin� sur l'image affich�e en
            % coordonn�es cart�siennes, en un masque adapt� � nos donn�es en coordonn�es
            % "indices de matrice" (voir sch�ma dans la documentation)
            masque_binaire_2D=masque_binaire_2D';
            
            %% On �largit le masque � toute la matrice 4D, en r�p�tant notre s�lection
            % sur les diff�rentes tranches et aux diff�rents temps
            % Etape qui prend beaucoup de temps (environ 3 secondes),
            % une optimisation est peut-�tre possible.
            soi.masque_binaire_4D = repmat(masque_binaire_2D,1,1,taille_axes(3),taille_axes(4));
        catch erreurs
            %% On g�re les erreurs lev�es
         if (strcmp(erreurs.identifier,'polygone_Callback:ROI_pas_choisi'))
            causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
            erreurs = addCause(erreurs,causeException);
            delete(soi.polygone);
         end
         % On affiche les erreurs qui n'auraient pas �t� g�r�es
         rethrow(erreurs);
        end

        end
                    
         function enregistrer(soi)
             % On enregistre le volume correspondant � la r�gion d'int�r�t 
             % trac�e en utilisant le masque binaire pr�c�demment d�fini
             
            %% On importe les donn�es n�cessaires
            volumes = soi.modele.volumes;
            donnees_4D=volumes.donnees;
            
            %% On s�lectionne les donn�es s�lectionn�es par la r�gion d'int�r�t
            % en utilisant en filtrage bool�en
            donnees_4D(soi.masque_binaire_4D==0) = NaN;
            
            %% On enregistre les donn�es qui nous int�ressent en les mettant
            % dans les propri�t�s de nos objets
            soi.donnees_4D = donnees_4D;
            soi.modele.donnees_region_interet = donnees_4D;
            soi.donnees_2D = donnees_4D(:,:,volumes.coordonnee_axe3_selectionnee,...
            volumes.coordonnee_axe4_selectionnee);
         end
         
    end
    
end


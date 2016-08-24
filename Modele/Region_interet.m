classdef (Abstract) Region_interet < handle
    % Classe abstraite contenant les propri�t�s et m�thodes communes aux
    % diff�rentes formes de r�gion d'int�r�t
    
    properties
        donnees_4D
        donnees_2D % les donn�es de la r�gion d'int�r�t de l'image sur laquelle
                   % elle a �t� s�lectionn�e
        entropie
        modele
    end
    
    methods (Abstract)
        %% M�thodes abstraites qui sont effectivement impl�ment�es dans les
        % classes concr�tes h�ritant de Region_interet
        tracer(soi)
        enregistrer(soi)
    end
    
    methods
        function selectionner_manuellement(soi,coordonnee_axe1_debut,...
        coordonnee_axe1_fin,coordonnee_axe2_debut,coordonnee_axe2_fin)
            % S�lectionner la r�gion d'int�r�t dans le cas o� l'utilisateur
            % a entr� les coordonn�es manuellement
    
            soi.coordonnee_axe1_debut=coordonnee_axe1_debut;
            soi.coordonnee_axe1_fin=coordonnee_axe1_fin;
            soi.coordonnee_axe2_debut=coordonnee_axe2_debut;
            soi.coordonnee_axe2_fin=coordonnee_axe2_fin;
            
            soi.largeur_axe1 = soi.coordonnee_axe1_fin - soi.coordonnee_axe1_debut;
            soi.hauteur_axe2 = soi.coordonnee_axe2_fin - soi.coordonnee_axe1_fin;
            
            % On appelle la m�thode abstraite
            soi.enregistrer;
        end
        
        function selectionner_visuellement(soi)
            % S�lectionner la r�gion d'int�r�t dans le cas o� l'utilisateur
            % a dessin� la r�gion d'int�r�t sur l'image
            
            soi.tracer;

            soi.enregistrer;

        end
        function calculer_entropie(soi)
            % On calcule l'entropie sur l'image de la r�gion d'int�r�t
            
            image_ROI=soi.donnees_2D;
            % On enl�ve les valeurs NaN de l'image par un filtre bool�en
            image_ROI=image_ROI(~isnan(image_ROI));
            % La fonction entropie de matlab ne fonctionne que sur des
            % entiers non-sign�s cod�s sur 8 bits (de 0 � 255)
            image_ROI_8bits=uint8(image_ROI);
            
            soi.entropie=entropy(image_ROI_8bits);
            % On met � jour la propri�t� du mod�le pour affichage
            soi.modele.entropie_region_interet = soi.entropie;
        end
        
    end

end


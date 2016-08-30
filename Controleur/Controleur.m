classdef Controleur < handle
    % Le controleur est le chef d'orchestre du programme. C'est cette
    % classe qui est charg�e d'appeler les m�thodes du mod�le (traitement
    % des donn�es) et les m�thodes de la vue (affichage). (Voir 'patron
    % de conception Mod�le Vue Contr�leur' sur internet).
    
    properties
        modele % le mod�le s'occupe du traitement des donn�es
        vue % la vue s'occupe de l'affichage
    end
    
    methods
        function soi = Controleur(modele)
            % Constructeur du contr�leur, qui prend le mod�le en entr�e et
            % qui instancie la vue
            soi.modele = modele;
            soi.vue = Vue(soi);
        end
        
        function charger_volumes_fichier_mat(soi)
            % charge un fichier au format .mat dans le programme
            
            % le mod�le instancie un �l�ment de Volumes_fichier_mat
            soi.modele.creer_volumes_fichier_mat;
            
            % On charge les volumes (la fonction de chargement a le m�me
            % nom mais est impl�ment�e diff�remment suivant 
            % l'instanciation � la ligne pr�c�dente, voir le concept de
            % 'polymorphisme' en programmation orient�e objet, sur
            % internet).
            soi.modele.volumes.charger;
        end
        
        function charger_volumes_dossier_mat(soi)
            % charge un dossier compos� de fichiers au format .mat 
            % dans le programme
            
            % le mod�le instancie un �l�ment de Volumes_dossier_mat
            soi.modele.creer_volumes_dossier_mat;
            
            % On charge les volumes (la fonction de chargement a le m�me
            % nom mais est impl�ment�e diff�remment suivant 
            % l'instanciation � la ligne pr�c�dente, voir le concept de
            % 'polymorphisme' en programmation orient�e objet, sur
            % internet).
            soi.modele.volumes.charger;
        end
        
        function charger_volumes_RawData_bin(soi)
            % charge un dossier, compos� de fichiers au format .bin encod�s
            % RawData, dans le programme
            
            % le mod�le instancie un �l�ment de Volumes_RawData_bin
            soi.modele.creer_volumes_RawData_bin;
            
            % On charge les volumes (la fonction de chargement a le m�me
            % nom mais est impl�ment�e diff�remment suivant 
            % l'instanciation � la ligne pr�c�dente, voir le concept de
            % 'polymorphisme' en programmation orient�e objet, sur
            % internet).
            soi.modele.volumes.charger;
        end
        
        function charger_volumes_VoxelData_bin(soi)
            % charge un dossier, compos� de fichiers au format .bin encod�s
            % VoxelData, dans le programme
            
            % le mod�le instancie un �l�ment de Volumes_VoxelData_bin
            soi.modele.creer_volumes_VoxelData_bin;
            
            % On charge les volumes (la fonction de chargement a le m�me
            % nom mais est impl�ment�e diff�remment suivant 
            % l'instanciation � la ligne pr�c�dente, voir le concept de
            % 'polymorphisme' en programmation orient�e objet, sur
            % internet).
            soi.modele.volumes.charger;
        end
        
        function mettre_a_jour_image_clavier(soi,eventdata)
            % met � jour l'image affich�e dans le programme si on appuie
            % sur une touche du clavier (soit une fl�che directionnelle
            % pour glisser entre les plans, soit un chiffre pour changer
            % d'orientation du plan)
            
            soi.modele.volumes.mettre_a_jour_image_clavier(eventdata);
        end
        
        function mettre_a_jour_image_bouton(soi,coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee)
            % met � jour l'image affich�e dans le programme si on entre les
            % coordonn�es sur l'axe 3 et 4 
            % dans la partie "afficher image" de l'interface graphique
            
            soi.modele.volumes.mettre_a_jour_image_bouton(coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee);
        end
        
        function selectionner_manuellement_region_interet(soi,coordonnee_axe1_debut,...
    coordonnee_axe1_fin,coordonnee_axe2_debut,coordonnee_axe2_fin)
            % s�lectionne une r�gion d'int�r�t rectangulaire apr�s avoir
            % entr� les coordonn�es dans l'interface graphique

            % on instancie une r�gion d'int�r�t rectangulaire
            soi.modele.creer_region_interet_rectangle;
            
            % on s�lectionne la r�gion d'int�r�t
            soi.modele.region_interet.selectionner_manuellement(coordonnee_axe1_debut,...
        coordonnee_axe1_fin,coordonnee_axe2_debut,coordonnee_axe2_fin);
  
        end
        
        function selectionner_visuellement_region_interet_rectangulaire(soi)
            % s�lectionne une r�gion d'int�r�t rectangulaire apr�s avoir
            % l'avoir trac� sur l'image (apr�s avoir fait clic droit 
            % sur l'image > s�lectionner une r�gion d'int�r�t > rectangle)
            
            % on instancie une r�gion d'int�r�t rectangulaire
            soi.modele.creer_region_interet_rectangle;
            
            % on indique � l'interface que l'on veut effectuer la s�lection
            % sur l'image
            soi.vue.choisir_axe_image;
            
            % On s�lectionne la r�gion d'int�r�t en la tra�ant sur l'image
            soi.modele.region_interet.selectionner_visuellement;
        end
        
        function selectionner_visuellement_region_interet_polygonale(soi)
            % s�lectionne une r�gion d'int�r�t polygonale apr�s avoir
            % l'avoir trac� sur l'image (apr�s avoir fait clic droit 
            % sur l'image > s�lectionner une r�gion d'int�r�t > polygone)
            
            % on instancie une r�gion d'int�r�t polygonale
            soi.modele.creer_region_interet_polygone;
            
            % on indique � l'interface que l'on veut effectuer la s�lection
            % sur l'image
            soi.vue.choisir_axe_image;
            
            % On s�lectionne la r�gion d'int�r�t en la tra�ant sur l'image
            soi.modele.region_interet.selectionner_visuellement;
        end
        
        function calculer_entropie_region_interet(soi)
            % calcule l'entropie globale de la r�gion d'int�r�t (sur la
            % matrice de l'image directement, et pas sur une matrice de cooccurrence)
            
            soi.modele.region_interet.calculer_entropie;
        end
        
        function definir_graphique(soi,axe_abscisses_choisi,axe_moyenne_choisi)
            % enregistre dans les param�tres du mod�le les propri�t�s du
            % graphique
            
            % on instancie le graphique
            soi.modele.creer_graphique(axe_abscisses_choisi,axe_moyenne_choisi);
            
            % on enregistre dans les param�tres du mod�le les propri�t�s du
            % graphique
            soi.modele.graphique.definir;
        end
        
        function detecter_pics(soi,taille_fenetre_lissage,nombre_de_pics)
            % d�tecte le nombre_de_pics souhait�s sur la courbe du
            % graphique liss� avec une taille de fen�tre taille_fenetre_lissage
            % (si taille_fenetre_lissage == 1 alors pas de lissage)
            
            % On recalcule le graphique pour �viter que les d�tection de
            % pics pr�c�dentes se superposent
            % Note : cette m�thode n'est pas propre et je devrais plut�t
            % avoir cr�� une fonction de remise � z�ro des param�tres
            % propres � la d�tection de pics (probl�me r�current dans mon
            % programme qui se retrouve pour d'autres objets)
            % mais je ne pense pas avoir le temps de le corriger
            soi.modele.graphique.definir;
            
            % On instancie l'objet pics qui fait partie des propri�t�s du
            % graphique
            soi.modele.graphique.creer_pics;
            
            % Pour l'affichage de la d�tection de pics on choisit l'axe
            % d'affichage du graphique 
            soi.vue.choisir_axe_affichage_graphique;
            
            % On enl�ve l'affichage des pics ou combinaison de pics 
            % pr�c�demment d�tect�s (on ne devrait n�anmoins pas faire comme �a,
            % et enlever les valeurs dans les param�tres du mod�le et pas dans la vue)
            soi.vue.mise_a_un_liste_de_pics;
            soi.vue.mise_a_un_liste_de_combinaisons_de_deux_pics;
            
            % On d�tecte les pics
            soi.modele.graphique.pics.detecter(taille_fenetre_lissage,nombre_de_pics);
        end
        
        function mettre_a_jour_largeur_a_mi_hauteur_pic_choisi(soi,pic_choisi)
            % Quand on change de pic choisi dans la liste d�roulante, on
            % change la valeur de la largeur � mi hauteur du pic choisi
            
            soi.modele.graphique.pics.mettre_a_jour_largeur_a_mi_hauteur_pic_choisi(pic_choisi);
        end
        
        function mettre_a_jour_distance_pic_a_pic_choisie(soi,numero_combinaison_de_deux_pics_choisie)
            % Quand on change de combinaisons de pics choisie 
            % dans la liste d�roulante, on
            % change la valeur de la distance pic � pic choisie
            
            soi.modele.graphique.pics.mettre_a_jour_distance_pic_a_pic_choisie(numero_combinaison_de_deux_pics_choisie);
        end
        
        function definir_et_sauvegarder_sous_echantillonnage(soi,facteur_temps_intensite_maximale,facteur_sous_echantillonnage)
            % On definit les param�tres du sous echantillonnage et on le
            % sauvegarde dans un fichier
            
            % On instancie un sous_echantillonnage
            soi.modele.creer_sous_echantillonnage;
            
            % On d�finit les param�tres du sous-�chantillonnage (quels temps
            % sauvegarder)
            soi.modele.sous_echantillonnage.definir(facteur_temps_intensite_maximale,facteur_sous_echantillonnage);
            
            % On sauvegarde les donn�es sous-echantillonn�es
            soi.modele.sous_echantillonnage.sauvegarder;
        end
        
        function previsualiser_sous_echantillonnage(soi,facteur_temps_intensite_maximale,facteur_sous_echantillonnage)
            % On calcule les param�tres du sous-echantillonnage sans pour
            % autant sauvegarder le fichier sous-echantillonn� : cela
            % permet  � l'utilisateur de rapidement voir comment le
            % sous-echantillonnage a �t� effectu�
            
            % On instancie le sous-echantillonnage
            soi.modele.creer_sous_echantillonnage;
            
            % On d�finit les param�tre du sous-echantillonnage
            soi.modele.sous_echantillonnage.definir(facteur_temps_intensite_maximale,facteur_sous_echantillonnage);
        end
        
        function exporter_graphique(soi)
            % On enregistre le graphique dans un format image � l'endroit
            % s�lectionn� par l'utilisateur
            
            soi.modele.graphique.exporter;
        end
        
        function exporter_image(soi)
            % On enregistre l'image ultrasonore affich�e 
            % dans un format image � l'endroit s�lectionn� par l'utilisateur
            
            soi.modele.exporter_image;
        end
        
        function exporter_interface(soi)
            % On enregistre toute l'interface du programme dans un format 
            % image dans fichier dont l'endroit est s�lectionn� par
            % l'utilisateur
            
            soi.modele.exporter_interface;
        end
        
        function afficher_aide(soi)
            % On affiche l'aide du programme
            
            soi.vue.aide;
        end
        
    end
end


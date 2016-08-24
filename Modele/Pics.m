classdef Pics < handle
    % Classe contenant les propri�t�s et m�thodes des pics (maximums locaux)
    % du graphique
    
    properties
        abscisses
        ordonnees
        largeurs_a_mi_hauteur
        nombre
        graphique
        liste
        combinaisons_indices_de_deux_pics % = [[1,2], [1,3], [2,3]] si soi.nombre == 3
        liste_combinaisons_de_deux_pics % = ['[1,2] & [3,4]'] si soi.abscisses == [1,3]
                                        % et soi.ordonnees == [2,4]
    end
    
    methods (Access = ?Graphique)  % Seul un graphique (instance d'une classe parente) 
                                    % peut construire une instance du Graphique
        function soi = Pics(graphique)
            % Constructeur d'une instance de Pics, il ne peut n'y en avoir
            % qu'une
           soi.graphique = graphique;
        end
     end
    
    methods
        
        function detecter(soi,taille_fenetre_lissage,nombre_de_pics)
            % D�tecte les pics (maximums locaux) du graphique
            % Prend en entr�e :
            % - la taille de la fen�tre utilis�e pour faire un lissage par
            % moyennes mobiles ;
            % - le nombre de pics que l'on souhaite d�tecter.
            
            % On utilise un bloc try...catch pour g�rer les erreurs
            try
                
                %% Si la taille de fen�tre choisie est paire, on renvoie
                % une erreur (elle doit �tre impaire car la fen�tre est
                % toujours centr�e sur un point)
                if mod(taille_fenetre_lissage,2) == 0
                    erreurImpaire.message = 'Fen�tre de taille paire.';
                    erreurImpaire.identifier = 'detection_pics_Callback:taille_fenetre_paire';
                    error(erreurImpaire);
                end
                
                %% Si le graphique est fait de plusieurs courbes, alors on
                % renvoie une erreur, car le programme n'est fait que pour
                % d�tecter les pics d'une courbe
                if ~soi.graphique.une_seule_courbe
                    erreurPlusieursCourbes.message = 'Plusieurs courbes affich�es.';
                    erreurPlusieursCourbes.identifier = 'detection_pics_Callback:plusieurs_courbes_affichees';
                    error(erreurPlusieursCourbes);
                end
                
                
                %% On importe et on convertit les donn�es issues du graphique
                ordonnees_graphique = double(soi.graphique.ordonnees);
                abscisses_graphique = double(soi.graphique.abscisses);
                
                %% Si la taille de la fen�tre de lissage est diff�rente de 1,
                % alors on effectue un lissage par moyennes mobiles
                if taille_fenetre_lissage~=1
                    filtre_lissage = (1/taille_fenetre_lissage)*ones(1,taille_fenetre_lissage);
                    coefficient_filtre = 1;
                    ordonnees_graphique = filter(filtre_lissage,coefficient_filtre,ordonnees_graphique);
                end
                
                %% On cherche les pics dans le graphique et leurs largeurs
                % � mi-hauteur. 
                % On appelle � chaque fois deux fois les
                % fonctions car pour obtenir l'affichage sur le graphique
                % il faut appeler la fonction sans arguments de retour,
                % mais pour obtenir la valeur des pics il est n�cessaire de
                % l'appeler avec des arguments de retour.
                hold on
                switch soi.graphique.axe_abscisses_choisi
                    case 1
                        [ordonnees_intensites_maximales,abscisses_intensites_maximales,...
                            soi.largeurs_a_mi_hauteur,~] = findpeaks(ordonnees_graphique,...
                            abscisses_graphique,'SortStr','descend','NPeaks',nombre_de_pics);
                        
                        findpeaks(ordonnees_graphique,abscisses_graphique,...
                            'Annotate','extents','SortStr','descend','NPeaks',nombre_de_pics);
                    case 2
                        [ordonnees_intensites_maximales,abscisses_intensites_maximales,...
                            soi.largeurs_a_mi_hauteur,~] = findpeaks(ordonnees_graphique,...
                            abscisses_graphique,'SortStr','descend','NPeaks',nombre_de_pics);
                        
                        findpeaks(ordonnees_graphique,abscisses_graphique,...
                            'Annotate','extents','SortStr','descend','NPeaks',nombre_de_pics);
                    case 3
                        [ordonnees_intensites_maximales,abscisses_intensites_maximales,...
                            soi.largeurs_a_mi_hauteur,~] = findpeaks(ordonnees_graphique,...
                            abscisses_graphique,'SortStr','descend','NPeaks',nombre_de_pics);
                        
                        findpeaks(ordonnees_graphique,abscisses_graphique,...
                            'Annotate','extents','SortStr','descend','NPeaks',nombre_de_pics);
                    case 4
                        [ordonnees_intensites_maximales,abscisses_intensites_maximales,...
                            soi.largeurs_a_mi_hauteur,~] = findpeaks(ordonnees_graphique,...
                            abscisses_graphique,'SortStr','descend','NPeaks',nombre_de_pics);
                        
                        findpeaks(ordonnees_graphique,abscisses_graphique,...
                            'Annotate','extents','SortStr','descend','NPeaks',nombre_de_pics);
                end
                % On enl�ve l'affichage qui prend une trop grande part du
                % graphique et qui est fausse en plus.
                legend('off');
                hold off
                
                %% Si l'utilisateur � demand� de trouver plus de pics qu'il
                % n'y en a sur le graphique, on renvoie une erreur
                nombre_de_pics_trouves = size(abscisses_intensites_maximales,1);
                
                if nombre_de_pics~=nombre_de_pics_trouves
                    erreur_nombre_de_pics_different.message = 'Il y a moins de pics dans le graphique que vous souhaitez en d�tecter.';
                    erreur_nombre_de_pics_different.identifier = 'detection_pics_Callback:nombre_de_pics_different';
                    error(erreur_nombre_de_pics_different);
                end
                
                %% On charge les propri�t�s des pics avec ce qu'on a trouv�
                soi.abscisses=abscisses_intensites_maximales;
                soi.ordonnees=ordonnees_intensites_maximales;
                soi.nombre = nombre_de_pics;
                
                %% On calcule la/les largeur(s) � mi-hauteur
                
                crochet_ouvrant = repmat('[', soi.nombre , 1);
                virgule = repmat(', ',soi.nombre,1);
                crochet_fermant = repmat(']',soi.nombre,1);
                soi.liste = [crochet_ouvrant num2str(soi.abscisses) virgule ...
                num2str(soi.ordonnees) crochet_fermant];
                
                pic_choisi_par_defaut = 1;
                
                % On met � jour le mod�le avec la valeur que l'on a
                % calcul�e, pour d�clencher l'affichage par la vue qui
                % l'observe
                soi.graphique.modele.largeur_a_mi_hauteur_pic_choisi = soi.largeurs_a_mi_hauteur(pic_choisi_par_defaut);
                
                %% On calcule la/les distance(s) pic � pic
                if soi.nombre>1
                    % On calcule les combinaisons C{_soi.nombre,^2}
                    soi.combinaisons_indices_de_deux_pics = combnk(1:soi.nombre,2);
                    
                    
                    [~,nb_colonnes]=size(soi.liste);
                    liste_de_pics_cellules=mat2cell(soi.liste,ones(1,soi.nombre),nb_colonnes);
                    soi.combinaisons_indices_de_deux_pics = combnk(1:soi.nombre,2);
                    [nb_combinaisons,~] = size(soi.combinaisons_indices_de_deux_pics);
                    
                    soi.liste_combinaisons_de_deux_pics=cell(nb_combinaisons,1);
                    
                    for ligne=1:nb_combinaisons
                        soi.liste_combinaisons_de_deux_pics{ligne} = [liste_de_pics_cellules{soi.combinaisons_indices_de_deux_pics(ligne,1),1} ...
                            ' & ' liste_de_pics_cellules{soi.combinaisons_indices_de_deux_pics(ligne,2),1}];
                    end
                    
                    numero_combinaison_de_deux_pics_choisie_par_defaut =  1;

                    combinaison_pics_choisie = soi.combinaisons_indices_de_deux_pics(numero_combinaison_de_deux_pics_choisie_par_defaut,:);

                    abscisse_plus_grand_des_deux_pics = soi.abscisses(combinaison_pics_choisie(2));
                    abscisse_plus_petit_des_deux_pics = soi.abscisses(combinaison_pics_choisie(1));
                    
                    % On met � jour le mod�le avec la valeur que l'on a
                    % calcul�e, pour d�clencher l'affichage par la vue qui
                    % l'observe
                    soi.graphique.modele.distance_pic_a_pic_choisie = abs(abscisse_plus_grand_des_deux_pics-...
                    abscisse_plus_petit_des_deux_pics);
                    
                end
                
            catch erreurs
                %% On g�re les erreurs lev�es
                if (strcmp(erreurs.identifier,'detection_pics_Callback:taille_fenetre_paire'))
                    warndlg('Merci d''entrer une taille de fen�tre de lissage impaire.');
                    causeException = MException(erreurImpaire.identifier,erreurImpaire.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                elseif (strcmp(erreurs.identifier,'detection_pics_Callback:plusieurs_courbes_affichees'))
                    warndlg('Merci de n''afficher qu''une seule courbe dans la partie ''affichage du graphique''.');
                    causeException = MException(erreurPlusieursCourbes.identifier,erreurPlusieursCourbes.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                elseif (strcmp(erreurs.identifier,'detection_pics_Callback:nombre_de_pics_different'))
                    warndlg('Merci de demander de d�tecter moins de pics : le graphique en contient moins que vous en demandez.');
                    causeException = MException(erreur_nombre_de_pics_different.identifier,erreur_nombre_de_pics_different.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                end
                % On affiche les erreurs qui n'auraient pas �t� g�r�es
                rethrow(erreurs);
            end
        end
        
        function mettre_a_jour_largeur_a_mi_hauteur_pic_choisi(soi,pic_choisi)
            % On calcule la largeur � mi-hauteur pour le pic_choisi, et on
            % met � jour le mod�le
            soi.graphique.modele.largeur_a_mi_hauteur_pic_choisi = soi.largeurs_a_mi_hauteur(pic_choisi);
        end
        
        function mettre_a_jour_distance_pic_a_pic_choisie(soi,numero_combinaison_de_deux_pics_choisie)
            % On calcule la distance pic � pic pour les deux pics choisis, et on
            % met � jour le mod�le
            combinaison_pics_choisie = soi.combinaisons_indices_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);

            abscisse_plus_grand_des_deux_pics = soi.abscisses(combinaison_pics_choisie(2));
            abscisse_plus_petit_des_deux_pics = soi.abscisses(combinaison_pics_choisie(1));

            soi.graphique.modele.distance_pic_a_pic_choisie = abs(abscisse_plus_grand_des_deux_pics-...
            abscisse_plus_petit_des_deux_pics);
        end
        
    end
    
end


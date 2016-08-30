function lancer_programme
% Merci de lancer ce script pour lancer le programme.

%% Ajout du r�pertoire Mod�le au chemin de Matlab
chemin = fullfile(pwd,'Modele');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du r�pertoire Vue au chemin de Matlab
chemin = fullfile(pwd,'Vue');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du r�pertoire Controleur au chemin de Matlab
chemin = fullfile(pwd,'Controleur');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du r�pertoire Interface Homme Machine au chemin de Matlab
chemin = fullfile(pwd,'Interface Homme Machine');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du r�pertoire altmany-export_fig au chemin de Matlab
chemin = fullfile(pwd,'altmany-export_fig');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du r�pertoire Tests au chemin de Matlab
chemin = fullfile(pwd,'Tests');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Lancement du programme
% On instancie le mod�le
modele = Modele;
% On instancie le contr�leur
controleur = Controleur(modele);
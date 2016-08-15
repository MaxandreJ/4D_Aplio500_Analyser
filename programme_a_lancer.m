function programme_a_lancer()
%Merci de lancer ce script pour lancer le programme.

%% Ajout du r�pertoire Mod�le au chemin de Matlab
code = fullfile(pwd,'Modele');
chemin_code = genpath(code);
addpath(chemin_code);

%% Ajout du r�pertoire Vue au chemin de Matlab
code = fullfile(pwd,'Vue');
chemin_code = genpath(code);
addpath(chemin_code);

%% Ajout du r�pertoire Controleur au chemin de Matlab
code = fullfile(pwd,'Controleur');
chemin_code = genpath(code);
addpath(chemin_code);

%% Ajout du r�pertoire Interface Homme Machine au chemin de Matlab
code = fullfile(pwd,'Interface Homme Machine');
chemin_code = genpath(code);
addpath(chemin_code);

%% Ajout du r�pertoire altmany-export_fig au chemin de Matlab
code = fullfile(pwd,'altmany-export_fig');
chemin_code = genpath(code);
addpath(chemin_code);

%% Lancement du programme
modele = Modele;
controleur = Controleur(modele);
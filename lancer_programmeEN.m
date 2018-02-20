function lancer_programme
% Merci de lancer ce script pour lancer le programme.

% Please launch this script in ordre to lauche the program

%% Ajout du r�pertoire Mod�le au chemin de Matlab

% Adds the repository "Mod�le" to the Matlab pathway
chemin = fullfile(pwd,'Modele');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du r�pertoire Vue au chemin de Matlab

% Adds the repository "Vue" to the Matlab pathway
chemin = fullfile(pwd,'Vue');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du r�pertoire Controleur au chemin de Matlab

% Adds the repository "Controleur" to the Matlab pathway
chemin = fullfile(pwd,'Controleur');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du r�pertoire Interface Homme Machine au chemin de Matlab

% Adds the repository "Interface Homme Machine" (Man Machine Interface) to the Matlab pathway
chemin = fullfile(pwd,'Interface Homme Machine');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du r�pertoire altmany-export_fig au chemin de Matlab

% Adds the repository "altmany-export_fig" to the Matlab pathway
chemin = fullfile(pwd,'altmany-export_fig');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du r�pertoire Tests au chemin de Matlab

% Adds the repository "Tests" to the Matlab pathway
chemin = fullfile(pwd,'Tests');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Lancement du programme

% Launching the program

% On instancie le mod�le

% Instantiates the model
modele = Modele;
% On instancie le contr�leur

% Instantiates the controler
controleur = Controleur(modele);
classdef Graphique < handle
    %GRAPHIQUE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        abscisses
        ordonnees
        axe_abscisses_choisi
        axe_moyenne_choisi
    end

    methods
        function soi = Graphique(abscisses,ordonnees,axe_abscisses_choisi,axe_moyenne_choisi)
         soi.abscisses=abscisses;
         soi.ordonnees=ordonnees;
         soi.axe_abscisses_choisi=axe_abscisses_choisi;
         soi.axe_moyenne_choisi=axe_moyenne_choisi;
        end
    end
    
end

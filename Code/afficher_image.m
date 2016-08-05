% --- Executes on button press in afficherImage.
function afficher_image(hObject, eventdata, handles)
%Affiche l'image dans handles.image 
%correspondant � la coordonn�e dans l'axe 3 et l'axe 4
%choisie dans les champs correspondants.
% hObject    handle to afficherImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%R�cup�re les coordonn�es de l'axe 3 et l'axe 4 choisis par l'utilisateur
%et les convertit en entier sign�s cod�s sur 16 bits
coordonnee_axe3 = int16(str2double(get(handles.valeur_axe3_image,'String')));
coordonnee_axe4 = int16(str2double(get(handles.valeur_axe4_image,'String')));

%On affiche l'image dans handles.image
axes(handles.image); %choix de l'endroit o� on affiche l'image
imshow4(handles.volumes,hObject,handles,coordonnee_axe3,coordonnee_axe4); %Appel de la fonction d'affichage d'image 4D
handles = guidata(handles.figure1);
%On ajoute la possibilit� de faire un clic droit sur l'image pour afficher
%un menu contextuel qui permet de s�lectionner une r�gion d'int�r�t
uicontextmenu = get(handles.image,'UIContextMenu'); %le menu contextuel est cr�� sur l'axe gr�ce � GUIDE...
set(handles.image.Children,'UIContextMenu',uicontextmenu); %mais doit �tre r�cup�r� puis reparam�tr� pour fonctionner sur l'image qui s'affiche sur l'axe.

%Une fois l'image s�lectionn�e, on peut permettre � l'utilisateur de
%choisir une r�gion d'int�r�t, ce qu'on lui indique visuellement en passant
%du gris au blanc les �l�ments graphiques correspondants. On utilise pour
%cela des mutateurs d'objets enregistr�s dans handles.
set(handles.valeur_axe1Debut_graphique,'enable','on','BackgroundColor','white');
set(handles.valeur_axe2Debut_graphique,'enable','on','BackgroundColor','white');
set(handles.valeur_axe1Fin_graphique,'enable','on','BackgroundColor','white');
set(handles.valeur_axe2Fin_graphique,'enable','on','BackgroundColor','white');

%On sauvegarde les modifications que l'on a fait dans handles dans la
%figure handles.figure1
guidata(handles.figure1,handles);
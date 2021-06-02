/*	Document : scripts\lights\mapGen.sqf
 *	Fonction : permet d'indiqué sur carte les générateur
 *	Auteur : Wolv (discord : Wolv#2393)
 *	Argument : 
		- _power		:	état souhaité 
 *	Appellé par : addAction
 *		- this addAction ["Cacher les générateur",{[Parrametre] execVM "scripts\lights\mapGen.sqf";},[],1.5,true,true,"","true",5];
 *	Apelle : 0/
 */
 
_genType = ["Land_spp_Transformer_F", "Land_dp_transformer_F"];		//liste des générateur
_petitPoteauType = ["powerpolewooden_f.p3d","powerpolewooden_small_f.p3d","powerpolewooden_l_off_f.p3d","powerpolewooden_l_f.p3d","lampshabby_off_f.p3d","lampshabby_f.p3d"];
//liste des petit Poteaux (le ".p3d" est essentiel car il s'agit de model 3D des objet, voir note en bas de page)
_moyenPoteauType = ["Land_HighVoltageColumn_F","Land_PowerCable_submarine_F","Land_PowerLine_01_pole_end_v1_F","Land_PowerLine_01_pole_end_v2_F","Land_PowerLine_01_pole_junction_F","Land_PowerLine_01_pole_lamp_F","Land_PowerLine_01_pole_lamp_off_F","Land_PowerLine_01_pole_small_F","Land_PowerLine_01_pole_tall_F","Land_PowerLine_01_pole_transformer_F"];
//liste des moyen Poteaux
_grandPoteauType = ["Land_HighVoltageTower_large_F","Land_HighVoltageTower_largeCorner_F"];	//liste des grand poteaux

//Radius Gen
private  _rGenP = 800; 	//raduis de désactivation des poteaux
private _rGenL = 500;	//raduis de désactivation des lamps

//Radius Petit poteau
private _rPetitP = 130; //raduis de désactivation des poteaux
private _rPetitL = 150; //raduis de désactivation des lamps

//Radius Moyen poteau
private _rMoyenP = 150; //raduis de désactivation des poteaux
private _rMoyenL = 160; //raduis de désactivation des lamps

//Radius Moyen poteau
private _rGrandP = 250;	//raduis de désactivation des poteaux
private _rGrandL = 250;	//raduis de désactivation des lamps

private _markerG = [0];
private _markerGP = [0];
private _posG = [0,0,0];
private _gen = nearestObjects [[15000, 15000, 0], _genType, 30000]; //recupère les générateur de la carte

private _state = 3; // ici on ne veux que l'affichage

//delay entre l'extinction (m/s)
private _speedL = 0; 	// des poteaus
private _speedP = 2000; 	// des lampes

private _power = param[0];

//groupe de poteaux deja changé d'etat
private _petitPoteauPool = [0]; //Petit
private _moyenPoteauPool = [0];	//moyen
private _grandPoteauPool = [0];	//grand

{
    _posG = position _x;	//recupère la position
	
	if (_power == 3) then {	//a 3 affiche les générateur et leur rayon d'action
		/*_markerG set [_forEachindex, createMarker [(format ["Gen Z %1", _forEachindex]), _posG]]; 
		(_markerG select _forEachindex) setMarkerShape "ELLIPSE";
		(_markerG select _forEachindex) setMarkerSize [_rGenP,_rGenP];
		(_markerG select _forEachindex) setMarkerBrush "SolidBorder";
		(_markerG select _forEachindex) setMarkerAlpha 0.2; 
		(_markerG select _forEachindex) setMarkerColor "ColorYellow";	// rayon d'action des générateur affiché sur carte*/
		
		_markerGP set [_forEachindex, createMarker [(format ["Gen P x %1, y %2, z %3", (_posG select 0), (_posG select 1), (_posG select 2)]), _posG]]; 
		(_markerGP select _forEachindex) setMarkerType "loc_Power";
		(_markerGP select _forEachindex) setMarkerColor "ColorYellow";
		
		private _petitPoteau = nearestObjects [_posG, [], _rGenP, true]; 	// recupère tout les obj
		private _moyenPoteau = nearestObjects [_posG, _moyenPoteauType, _rGenP, true];	// recupère tout les moyens poteau
		private _grandPoteau = nearestObjects [_posG, _grandPoteauType, _rGenP, true];	// recupère tout les grand poteaux
		
		
		{		//pour chaque petit poteau
			_objType = (getModelInfo _x) select 0; //récupère l'élément 0 des info de l'objet voir note en bas de page de generators.sqf
			_isPetitPoteaux = _petitPoteauType find _objType;		//verifie qu'il s'ajit d'un petit poteau
			
			//systemChat str _objType;			

			if(_isPetitPoteaux != -1) then {  	//si c'est un petit poteaux
				_posPoteau = (position _x); 	//recupère ca position et appel le script
				[_posPoteau, _petitPoteauPool, _forEachindex, _rPetitL, _rPetitP, _rGenP, _state, _speedL, _speedP] execVM "scripts\lights\petitPoteaux.sqf";
			}; 
			//systemChat str _forEachindex;
		} forEach _petitPoteau; 

		{		//pour chaque moyen poteau
			_posPoteau = (position _x); 	// recupère ca position et appel le script
			[_posPoteau, _moyenPoteauPool, _forEachindex, _rMoyenL, _rMoyenP, _rGenP,_state, _speedL, _speedP] execVM "scripts\lights\moyenPoteaux.sqf";
		} forEach _moyenPoteau;

		{		//pour chaque grand poteau
			_posPoteau = (position _x);	// recupère ca position et appel le script
			[_posPoteau, _grandPoteauPool, _forEachindex, _rGrandL, _rGrandP, _rGenP, _state, _speedL, _speedP] execVM "scripts\lights\grandPoteaux.sqf";
		} forEach _grandPoteau;
	}
	else {
		if (_power == 2) then {	//a 2 affiche les générateur et leur rayon d'action
			_markerG set [_forEachindex, createMarker [(format ["Gen z x %1, y %2, z %3", (_posG select 0), (_posG select 1), (_posG select 2)]), _posG]]; 
			(_markerG select _forEachindex) setMarkerShape "ELLIPSE";
			(_markerG select _forEachindex) setMarkerSize [_rGenL,_rGenL];
			(_markerG select _forEachindex) setMarkerBrush "SolidBorder";
			(_markerG select _forEachindex) setMarkerAlpha 0.2; 
			(_markerG select _forEachindex) setMarkerColor "ColorYellow";	// rayon d'action des générateur affiché sur carte
			
			_markerGP set [_forEachindex, createMarker [(format ["Gen P x %1, y %2, z %3", (_posG select 0), (_posG select 1), (_posG select 2)]), _posG]]; 
			(_markerGP select _forEachindex) setMarkerType "loc_Power";
			(_markerGP select _forEachindex) setMarkerColor "ColorYellow";
		
		}
		else {
			if (_power == 1) then {	//a 1 affiche que les points des générateur
				_markerGP set [_forEachindex, createMarker [(format ["Gen P x %1, y %2, z %3", (_posG select 0), (_posG select 1), (_posG select 2)]), _posG]]; 
				(_markerGP select _forEachindex) setMarkerType "loc_Power";
				(_markerGP select _forEachindex) setMarkerColor "ColorYellow";
			} 
			else {
				if (_power == 0) then {
					private _petitPoteau =  nearestObjects [[15000, 15000, 0], [], 30000, true]; // recupère tout les obj
					private _moyenPoteau =  nearestObjects [[15000, 15000, 0], _moyenPoteauType, 30000, true]; // recupère tout les moyens poteau
					private _grandPoteau = nearestObjects [[15000, 15000, 0], _grandPoteauType, 30000, true]; // les grand poteaux
					
					
					{
						_posG = position _x;
						deleteMarker (format ["Gen P x %1, y %2, z %3", (_posG select 0), (_posG select 1), (_posG select 2)]);
						deleteMarker (format ["Gen z x %1, y %2, z %3", (_posG select 0), (_posG select 1), (_posG select 2)]);
					}forEach _gen;
					
					{
						_posPoteau = position _x;
						deleteMarker (format ["Petit Poteaux P x %1, y %2, z %3", (_posPoteau select 0), (_posPoteau select 1), (_posPoteau select 2)]);
					}forEach _petitPoteau;
					
					{
						_posPoteau = position _x;
						deleteMarker (format ["Moyen Poteaux P x %1, y %2, z %3", (_posPoteau select 0), (_posPoteau select 1), (_posPoteau select 2)]);
					}forEach _moyenPoteau;
					
					{
						_posPoteau = position _x;
						deleteMarker (format ["Grand Poteaux P x %1, y %2, z %3", (_posPoteau select 0), (_posPoteau select 1), (_posPoteau select 2)]);
					}forEach _grandPoteau;
				};
			};
		};
	};
} forEach _gen;

//radio addAction ["Afficher les générateur",{[true] execVM "scripts\lights\mapGen.sqf";},[],1.5,true,true,"","true",5];// turn ON
//radio addAction ["Cacher les générateur",{[false] execVM "scripts\lights\mapGen.sqf";},[],1.5,true,true,"","true",5];// turn off


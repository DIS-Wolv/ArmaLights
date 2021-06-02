/*	Document : scripts\lights\generators.sqf
 *	Fonction : execute les action sur les générateur
 *	Auteur : Wolv (discord : Wolv#2393)
 *	Argument : 
		- "_target"		:	Ou est le Addaction (le générateur ciblé) (parrametre de base du addaction)
		- "_caller"		:	Qui effectue l'action (le player) (parrametre de base du addaction)
		- "_actionId"	:	L'id de l'action (int) (parrametre de base du addaction)
		- "_posPoteauG"	:	Position du générateur
		- "_state"		:	état souhaité 
 
 *	Appellé par : scripts\lights\init.sqf
 *	Apelle : scripts\lights\lamps.sqf, scripts\lights\petitPoteaux.sqf, scripts\lights\moyenPoteaux.sqf, scripts\lights\grandPoteaux.sqf
 */

params ["_target","_caller","_actionId","_posPoteauG","_state"]; 	//définition des parrametre
_genType = ["Land_spp_Transformer_F", "Land_dp_transformer_F"];		//liste des générateur
_petitPoteauType = ["powerpolewooden_f.p3d","powerpolewooden_small_f.p3d","powerpolewooden_l_off_f.p3d","powerpolewooden_l_f.p3d","lampshabby_off_f.p3d","lampshabby_f.p3d"];	//liste des petit Poteaux (le ".p3d" est essentiel car il s'agit de model 3D des objet, voir note en bas de page)
_moyenPoteauType = ["Land_HighVoltageColumn_F","Land_PowerCable_submarine_F"];	//liste des moyen Poteaux
_grandPoteauType = ["Land_HighVoltageTower_large_F","Land_HighVoltageTower_largeCorner_F"];	//liste des grand poteaux

//position poteau
private _posPoteau = 0;

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

//delay entre l'extinction (m/s)
private _speedL = 0; 	// des poteaus
private _speedP = 2000; 	// des lampes

//groupe de poteaux deja changé d'etat
private _petitPoteauPool = [0]; //Petit
private _moyenPoteauPool = [0];	//moyen
private _grandPoteauPool = [0];	//grand

[_posPoteauG, _state, _rGenL, _speedL] execVM "scripts\lights\lamps.sqf"; //change le statut des lampe a proximité du générateur 

private _petitPoteau =  nearestObjects [_posPoteauG, [], _rGenP, true]; // recupère tout les obj
private _moyenPoteau =  nearestObjects [_posPoteauG, _moyenPoteauType, _rGenP, true]; // recupère tout les moyens poteau
private _grandPoteau = nearestObjects [_posPoteauG, _grandPoteauType, _rGenP, true]; // les grand poteaux

{		//pour chaque petit poteau
	_objType = (getModelInfo _x) select 0; //récupère l'élément 0 des info de l'objet voir note en bas de page
	_isPetitPoteaux = _petitPoteauType find _objType;		//verifie qu'il s'ajit d'un petit poteau
	
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


/* NOTE : 
on ne peux pas distingué les petits poteaux comme les grands en les cherchant par objet, 
je recupère donc tout les objets et je vérifie que le noms des model des objets correspond au noms des petits poteaux.
*/
/* Note 2 :
les scripts de poteaux se réappele de facon récurente, mais sont limité par le nombre de poteaux sur la carte, 
se qui empeche les potentiel probleme.
*/







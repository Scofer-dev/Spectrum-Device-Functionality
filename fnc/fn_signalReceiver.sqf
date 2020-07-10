//======================================================================================================================================================
// Function: specdev_fnc_spectrumDestination
// Author: Scofer
// Version: 1.0
// Date: 06/07/20
// Description: Sets the spectrumDestination global variable, all spectrum sources will measure their distance from this destination.
//======================================================================================================================================================
private ["_module","_syncArray"];

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

_syncArray = synchronizedObjects _module;
spectrumDestination = _syncArray select 0;

deleteVehicle _module;
//========================================
// Function: specdev_fnc_spectrumSource
// Author: Scofer
// Version: 1.0
// Date: 08/07/20
// Description: Disable the defined signal
//========================================
private ["_module","_signalName","_signalStrengthPath","_signalTimeout"];

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

//===============Check if signal name is valid===============
_signalName = _module getVariable "specdev_spectrumDisable_name";

if (nameArray find _signalName == -1) exitWith
{
	["Invalid signal name detected: %1. Signal name to remove must be same as a signal name in Signal Source modules.",_signalName] call BIS_fnc_error;
};
//===========================================================

_signalTimeout = abs(_module getVariable "specdev_spectrumDisable_timeout");

_signalPath = [signalNameArray, _signalName] call BIS_fnc_findNestedElement;
_signalPath set [1,2];

sleep _signalTimeout;

[signalNameArray, _signalPath, 0] call BIS_fnc_setNestedElement;

/*
signalNameArray = [[SignalOne,StrengthOne,1],[SignalTwo,StrengthTwo,1]];
_signalPath = [signalNameArray, SignalOne] call BIS_fnc_findNestedElement;
_signalPath = [0,0];
(signalNameArray select (_signalPath select 0) set [2,0];
signalNameArray = [[SignalOne,StrengthOne,0],[SignalTwo,StrengthTwo,1]];
*/

deleteVehicle _module;
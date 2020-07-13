//======================================================================================================================================================
// Function: specdev_fnc_deviceSettings
// Author: Scofer
// Description: Configures the global #EM variables for the spectrum device
//======================================================================================================================================================
private ["_module","_minFreq","_maxFreq","_minStrength","_maxStrength","_minSelection","_maxSelection"];

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

_minFreq = abs(_module getVariable "specdev_deviceSettings_minFreq");
_maxFreq = abs(_module getVariable "specdev_deviceSettings_maxFreq");

_minStrength = abs(_module getVariable "specdev_deviceSettings_minStrength");
_maxStrength = abs(_module getVariable  "specdev_deviceSettings_maxStrength");

_minSelection = abs(_module getVariable "specdev_deviceSettings_minSelection");
_maxSelection = abs(_module getVariable "specdev_deviceSettings_maxSelection");


if (_minFreq > _maxFreq) exitWith
{
	["Minimum Frequency is larger than Maximum Frequency. %1 > %2. Minimum must be smaller than maximum.", _minFreq,_maxFreq] call BIS_fnc_error;
};
if (_minStrength > _maxStrength) exitWith
{
	["Minimum Strength is larger than Maximum Strength. %1 > %2. Minimum must be smaller than maximum", _minStrength,_maxStrength] call BIS_fnc_error;
};
if (_minSelection > _maxSelection) exitWith
{
	["Minimum Selection is larger than Maximum Selection. %1 > %2. Minimum must be smaller than maximum", _minSelection,_maxSelection] call BIS_fnc_error;
};
if ((_minSelection < _minFreq) || (_maxSelection > _maxFreq)) then
{
	["Selection range not within frequency range: Frequency Range: %1-%2. Selection Range: %3-%4",_minFreq,_maxFreq,_minSelection,_maxSelection] call BIS_fnc_error;
};

missionNamespace setVariable ["#EM_FMin", _minFreq, true];
missionNamespace setVariable ["#EM_FMax", _maxFreq, true];

missionNamespace setVariable ["#EM_SMin", _minStrength, true];
missionNamespace setVariable ["#EM_SMax", _maxStrength, true];

missionNamespace setVariable ["#EM_SelMin", _minSelection, true];
missionNamespace setVariable ["#EM_SelMax", _maxSelection, true];

missionNamespace setVariable ["#EM_Values", [0,0], true];

signalNameArray = [0];
signalNameArray deleteAt 0;
publicVariable "signalNameArray";
globalNameArray = ["0"];
globalNameArray deleteAt 0;
publicVariable "globalNameArray";

deleteVehicle _module;
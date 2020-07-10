//======================================================================================================================================================
// Function: specdev_fnc_spectrumSource
// Author: Scofer
// Version: 1.1
// Date: 08/07/20
// Description: Sets the source frequency, and continually calculates frequency strength based on distance between spectrumDestination and source object
//======================================================================================================================================================

//===============Define variables local to module===============
private ["_module","_objectSelect","_objectVar","_endAction","_range","_frequency","_delay","_sourceSeen","_minFreq","_maxFreq","_freqCheck","_arrayIndex","_strength","_arrayFrequency","_arrayStrength","_signalName","_signalActivation"];
private _object = [];
private _objectArray = [];
//==============================================================

if (isNil {spectrumDestination}) exitWith
{
	["No destination set. Spectrum Destination module must be synced with receiver unit"] call BIS_fnc_error;
};

//===============Assign module object to variable===============
_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};
//==============================================================

//===============Exit function if signal name is duplicated===============
_signalName = _module getVariable "specdev_spectrumSource_Name";

if (nameArray find _signalName != -1) exitWith
{
	["Duplicate signal name detected: %1",_signalName] call BIS_fnc_error;
};
//========================================================================

//===============Assign and select random source object, exit function if no source is set===============
_object = _module getVariable "specdev_spectrumSource_Source";
_objectArray = _object splitString ",";
_objectSelect = selectRandom _objectArray;

if (isNil {_objectSelect}) exitWith
{
	["Invalid signal source object detected: %1. Ensure a source object is set, and that the name is valid.",_objectArray] call BIS_fnc_error;
};

_objectVar = missionNamespace getVariable _objectSelect;
//=======================================================================================================

//===============Exit function if a source object variable name is invalid===============
if (isNil {_objectVar}) exitWith
{
	["Invalid variable name detected in array: %1",_objectArray] call BIS_fnc_error;
};
//=======================================================================================

//===============Get the rest of the required variables from module and other global variables===============
_range = abs(_module getVariable "specdev_spectrumSource_Range");
_frequency = abs(_module getVariable "specdev_spectrumSource_Frequency");
_delay = abs (_module getVariable "specdev_spectrumSource_Delay");

_minFreq = missionNamespace getVariable "#EM_FMin";
_maxFreq = missionNamespace getVariable "#EM_FMax";

_minStrength = missionNamespace getVariable "#EM_SMin";

_angleCoefficient = abs(_module getVariable "specdev_spectrumSource_angleCoefficient");

_freqCheck = missionNamespace getVariable "#EM_Values";
//===========================================================================================================

//===============Exit function if frequency is outside pre-defined frequency range===============
if (_frequency < _minFreq || _frequency > _maxFreq) exitWith
{
	["Invalid frequency detected: %1. Source frequency must be between configured minimum and maximum frequency in Device Settings module: %2 - %3",_frequency,_minFreq,_maxFreq] call BIS_fnc_error;
};
//===============================================================================================

//===============Add frequency to EM_Values and Signal Name array on first runthrough===============
_freqCheck append [_frequency,_minStrength];
_arrayFrequency = (count _freqCheck - 2); //Persistent identifier of the frequnecy added to #EM_Values
_arrayStrength = (count _freqCheck - 1); //Persistent identifier of frequency strength added to #EM_Values
missionNamespace setVariable ["#EM_Values",_freqCheck];


signalNameArray append [[_signalName,_arrayStrength,1]];
nameArray append [_signalName];

_signalPath = [signalNameArray, _signalName] call BIS_fnc_findNestedElement;
_signalPath set [1,2];
//==================================================================================================

/*
signalNameArray = [[SignalOne,StrengthOne,1],[SignalTwo,StrengthTwo,1]];
_signalPath = [signalNameArray, SignalOne] call BIS_fnc_findNestedElement;
_signalPath = [0,0];
(signalNameArray select (_signalPath select 0) set [2,0];
signalNameArray = [[SignalOne,StrengthOne,0],[SignalTwo,StrengthTwo,1]];
*/

//===============Add the disable action to the source object if set in module===============
_endAction = abs(_module getVariable "specdev_spectrumSource_EndAction");

if (_endAction == 1) then
{
	_actionDuration = _module getVariable "specdev_spectrumSource_ActionDuration";
	[
		_objectVar,														//_target
		"Disable",														//Action menu title
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",	//Idle Icon
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",	//Progress Icon
		"_this distance _target < 10",									//Show Condition
		"_caller distance _target < 10",								//Progress Condition
		{},																//Code when progress started
		{},																//Code during progress
		{_target setDamage 1},											//Code when progress completed
		{},																//Code when progress interrupted
		[],																//Arguments for script
		_actionDuration,												//Duration
		0,																//Priority
		true															//Remove action on completed
	] remoteExec ["BIS_fnc_holdActionAdd", 0, _objectVar];
};
//==========================================================================================

//===============Only run if the source object is alive===============
while {alive _objectVar && (([signalNameArray, _signalPath] call BIS_fnc_returnNestedElement) == 1)} do
{
	//===============If the source object is within 90 degrees infront of the receiver===============
	if ([getPosATL spectrumDestination, getDir spectrumDestination, 90, getPosATL _objectVar] call BIS_fnc_inAngleSector) then
	{
		_objectDistance = round (spectrumDestination distance _objectVar);
		_objectDistanceConversion = round (linearConversion [0,_range,_objectDistance,missionNamespace getVariable "#EM_SMax",missionNamespace getVariable "#EM_SMin",true]);
		_objectRelativeDirection = round (spectrumDestination getRelDir _objectVar);
		if (_objectRelativeDirection >= 180) then
		{
			_objectRelativeDirection = (360 - _objectRelativeDirection) * _angleCoefficient;
		}else{
			_objectRelativeDirection = _objectRelativeDirection * _angleCoefficient;
		};
		_strength = _objectDistanceConversion - _objectRelativeDirection;

		_freqCheck = missionNamespace getVariable "#EM_Values";

		_freqCheck set [_arrayStrength, _strength];
		missionNamespace setVariable ["#EM_Values",_freqCheck];
	}
	//===============================================================================================
	//===============If source object isn't within 90 degrees then set frequency strength to minimum===============
	else
	{
		_freqCheck = missionNamespace getVariable "#EM_Values";
		_freqCheck set [_arrayStrength, _minStrength];
		missionNamespace setVariable ["#EM_Values",_freqCheck];
	};
	//=============================================================================================================

	//===============Re-run the 'while' after _delay seconds===============
	sleep _delay;
	//=====================================================================
};
//====================================================================

//===============When object is killed permanently set frequency strength to the minimum===============
if (!alive _objectVar || (([signalNameArray, _signalPath] call BIS_fnc_returnNestedElement) == 0)) exitWith {
	_freqCheck = missionNamespace getVariable "#EM_Values";
	_freqCheck set [_arrayStrength, _minStrength];
	missionNamespace setVariable ["#EM_Values",_freqCheck];
	deleteVehicle _module;
};
//=====================================================================================================
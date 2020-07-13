//======================================================================================================================================================
// Function: specdev_fnc_spectrumSource
// Author: Scofer
// Description: Sets the source frequency, and continually calculates frequency strength based on distance between signalReceiver and source object
//======================================================================================================================================================

//===Assign Module object to variable===
private ["_module"];
_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};
//======================================

//===Check if signal name is unique, exit with error if not===
private ["_signalName"];
_signalName = _module getVariable "specdev_spectrumSource_Name";

if (globalNameArray find _signalName != -1) exitWith
{
	["Duplicate signal name detected: %1",_signalName] call BIS_fnc_error;
};
//============================================================

if (isNil {signalReceiver} && receiverMethod == 1) then
{
	waitUntil {!isNil {signalReceiver}};
};

//===Check if frequency is within frequency range, exit with error if not===
private ["_frequency","_minFreq","_maxFreq"];
_frequency = abs(_module getVariable "specdev_spectrumSource_Frequency");
_minFreq = missionNamespace getVariable "#EM_FMin";
_maxFreq = missionNamespace getVariable "#EM_FMax";

if (_frequency < _minFreq || _frequency > _maxFreq) exitWith
{
	["Invalid frequency detected: %1. Source frequency must be between configured minimum and maximum frequency in Device Settings: %2-%3",_frequency,_minFreq,_maxFreq] call BIS_fnc_error;
};
//==========================================================================


//===Check if all signal source names are valid, then select one at random===
private ["_objectsName","_objectVar","_objectError"];
private _objectsNameArray = [];

_objectsName = _module getVariable "specdev_spectrumSource_Source";
_objectsNameArray = _objectsName splitString ",";

if (count _objectsNameArray == 0) exitWith
{
	["No source object set for signal: %1. Source object(s) must be defined in 'Signal Source' module",_signalName] call BIS_fnc_error;
};

_objectError = 0;
{
	_objectVar = missionNamespace getVariable _x;
	if (isNil {_objectVar}) exitWith
	{
		_objectError = 1;
		["Source object name: %1, is invalid for signal: %2. All source object names must be accurately set as an object variable name.",_x,_signalName] call BIS_fnc_error;
	};
} forEach _objectsNameArray;

if (_objectError == 1) exitWith
{};

_objectSelect = selectRandom _objectsNameArray;

_objectVar = missionNamespace getVariable _objectSelect;
//===========================================================================


private ["_range","_delay","_angleCoefficient","_minStrength"];
_range = abs(_module getVariable "specdev_spectrumSource_Range");
_delay = abs (_module getVariable "specdev_spectrumSource_Delay");
_angleCoefficient = abs(_module getVariable "specdev_spectrumSource_angleCoefficient");

_minStrength = missionNamespace getVariable "#EM_SMin";


//===Add signal to global signal array===
private ["_freqCheck","_arrayFrequency","_arrayStrength"];
_freqCheck = missionNamespace getVariable "#EM_Values";
_freqCheck append [_frequency,_minStrength];
_arrayFrequency = (count _freqCheck - 2); //Persistent identifier of the frequnecy added to #EM_Values
_arrayStrength = (count _freqCheck - 1); //Persistent identifier of frequency strength added to #EM_Values
missionNamespace setVariable ["#EM_Values",_freqCheck, true];
//=======================================

signalNameArray append [[_signalName,_arrayStrength,1]];
publicVariable "signalNameArray";
globalNameArray append [_signalName];
publicVariable "globalNameArray";

//===Generate path to the added signal===
private _signalPath = [];
_signalPath = [signalNameArray, _signalName] call BIS_fnc_findNestedElement;
_signalPath set [1,2];
//=======================================


//===Add the disable action to the source object===
private ["_endAction"];
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
//=================================================


if (receiverMethod == 1) then
{
	private ["_objectDistance","_objectDistanceConversion","_objectRelativeDirection","_signalStrength"];
	//===Whilst source object is alive and disable signal hasn't been deactivated===
	while {alive _objectVar && (([signalNameArray, _signalPath] call BIS_fnc_returnNestedElement) == 1)} do
	{
		//===If the source object is within 90 degrees infront of the receiver===
		if ([getPosATL signalReceiver, getDir signalReceiver, 90, getPosATL _objectVar] call BIS_fnc_inAngleSector) then
		{
			_objectDistance = round (signalReceiver distance _objectVar);
			_objectDistanceConversion = round (linearConversion [0,_range,_objectDistance,missionNamespace getVariable "#EM_SMax",missionNamespace getVariable "#EM_SMin",true]);
			_objectRelativeDirection = round (signalReceiver getRelDir _objectVar);
			if (_objectRelativeDirection >= 180) then
			{
				_objectRelativeDirection = (360 - _objectRelativeDirection) * _angleCoefficient;
			}else{
				_objectRelativeDirection = _objectRelativeDirection * _angleCoefficient;
			};
			_signalStrength = _objectDistanceConversion - _objectRelativeDirection;

			_freqCheck = missionNamespace getVariable "#EM_Values";

			_freqCheck set [_arrayStrength, _signalStrength];
			missionNamespace setVariable ["#EM_Values",_freqCheck, true];
		}else{
			_freqCheck = missionNamespace getVariable "#EM_Values";
			_freqCheck set [_arrayStrength, _minStrength];
			missionNamespace setVariable ["#EM_Values",_freqCheck, true];
		};
		sleep _delay;
	};

	//===When source object is killed or disable signal has been deactivated===
	if (!alive _objectVar || (([signalNameArray, _signalPath] call BIS_fnc_returnNestedElement) == 0)) exitWith {
		_freqCheck = missionNamespace getVariable "#EM_Values";
		_freqCheck set [_arrayStrength, _minStrength];
		missionNamespace setVariable ["#EM_Values",_freqCheck, true];
		deleteVehicle _module;
	};
}else
{
	//===Check if receivers have been set, exit with error if not===
	private ["_signalReceivers","_receiverError","_receiverObject","_clientID"];
	private _receiversArray = [];

	_signalReceivers = _module getVariable "specdev_spectrumSource_signalReceiver";
	_receiversArray = _signalReceivers splitString ",";

	if (count _receiversArray == 0) exitWith
	{
		["No signal receivers set. Field in Signal Source module must be set when Units mode is used in Signal Receivers module. Error signal: %1",_signalName] call BIS_fnc_error;
	};

	_receiverError = 0;
	{
		_receiverObject = missionNamespace getVariable _x;
		if (isNil {_receiverObject}) exitWith
		{
			_receiverError = 1;
			["Receiver object name: %1, is invalid for signal: %2. All receiver object names must be accurately set as a unit variable name.",_x,_signalName] call BIS_fnc_error;
		};
	} forEach _receiversArray;

	if (_receiverError == 1) exitWith
	{};
	//==============================================================
	{
		_receiverObject = missionNamespace getVariable _x;
		_clientId = owner _receiverObject;
		_handle = [_objectVar,_signalPath,_receiverObject,_range,_angleCoefficient,_arrayStrength,_minStrength,_delay] remoteExec ["specdev_fnc_unitReceiver", _clientID];
		//params ["_objectVar","_signalPath","_receiverObject","_range","_angleCoefficient","_arrayStrength","_minStrength","_delay"];
	} forEach _receiversArray;
};
//======================================================================================================================================================
// Function: specdev_fnc_unitReceiver
// Author: Scofer
// Description: Function executed on clients who are set as signal receivers when the Signal Receiver module is set to Units
//======================================================================================================================================================




params ["_objectVar","_signalPath","_receiverObject","_range","_angleCoefficient","_arrayStrength","_minStrength","_delay"];

private ["_objectDistance","_objectDistanceConversion","_objectRelativeDirection","_signalStrength","_freqCheck"];
//===Whilst source object is alive and disable signal hasn't been activated===

while {alive _objectVar && (([signalNameArray, _signalPath] call BIS_fnc_returnNestedElement) == 1)} do
{
	//===If the source object is within 90 degrees infront of the receiver===
	if ([getPosATL _receiverObject, getDir _receiverObject, 90, getPosATL _objectVar] call BIS_fnc_inAngleSector) then
	{
		_objectDistance = round (_receiverObject distance _objectVar);
		_objectDistanceConversion = round (linearConversion [0,_range,_objectDistance,missionNamespace getVariable "#EM_SMax",missionNamespace getVariable "#EM_SMin",true]);
		_objectRelativeDirection = round (_receiverObject getRelDir _objectVar);
		if (_objectRelativeDirection >= 180) then
		{
			_objectRelativeDirection = (360 - _objectRelativeDirection) * _angleCoefficient;
		}else{
			_objectRelativeDirection = _objectRelativeDirection * _angleCoefficient;
		};
		_signalStrength = _objectDistanceConversion - _objectRelativeDirection;

		_freqCheck = missionNamespace getVariable "#EM_Values";

		_freqCheck set [_arrayStrength, _signalStrength];
		missionNamespace setVariable ["#EM_Values",_freqCheck];
	}else{
		_freqCheck = missionNamespace getVariable "#EM_Values";
		_freqCheck set [_arrayStrength, _minStrength];
		missionNamespace setVariable ["#EM_Values",_freqCheck];
	};
	sleep _delay;
};

//===When source object is killed or disable signal has been activated===
if (!alive _objectVar || (([signalNameArray, _signalPath] call BIS_fnc_returnNestedElement) == 0)) exitWith {
	_freqCheck = missionNamespace getVariable "#EM_Values";
	_freqCheck set [_arrayStrength, _minStrength];
	missionNamespace setVariable ["#EM_Values",_freqCheck];
};
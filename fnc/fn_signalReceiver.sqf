//======================================================================================================================================================
// Function: specdev_fnc_spectrumDestination
// Author: Scofer
// Description: Sets the spectrumDestination global variable, all spectrum sources will measure their distance from this destination.
//======================================================================================================================================================
private ["_module","_syncArray","_deviceUpdate"];

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

receiverMethod = _module getVariable "specdev_spectrumDestination_Method";

if (receiverMethod == 1) then
{
	_deviceUpdate = abs(_module getVariable "specdev_spectrumDestination_deviceUpdate");
	while {true} do
	{		
		{
			if ("hgun_esd_" in handgunWeapon _x) then
			{
				signalReceiver = _x;
				publicVariable "spectrumDestination";
			};
		} forEach allPlayers;
		sleep _deviceUpdate;
	};
};

deleteVehicle _module;
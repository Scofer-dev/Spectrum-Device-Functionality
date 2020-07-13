class specdev_Module_deviceSettings: Module_F
{
	scope = 2;
	displayName = "Device Settings";
	icon = "\A3\Data_F_Enoch\Logos\arma3_enoch_picture_ca.paa";
	category = "specdevSpectrum";
	function = "specdev_fnc_deviceSettings";
	functionPriority = 1;
	isGlobal = 0;
	isTriggerActivated = 0;
	isDisposable = 0;

	curatorInfoType = "RscDisplayAttributedeviceSettings";

	class Attributes: AttributesBase
	{
		class specdev_deviceSettings_minFreq: Edit
		{
			property = "specdev_deviceSettings_minFreq";
			displayName = "Minimum Device Frequency";
			tooltip = "Sets the minimum frequency on the Spectrum Device. Negative values will be automatically made positive.";
			typeName = "NUMBER";
			defaultValue = "100";
		};

		class specdev_deviceSettings_maxFreq: Edit
		{
			property = "specdev_deviceSettings_maxFreq";
			displayName = "Maximum Device Frequency";
			tooltip = "Sets the maximum frequency on the Spectrum Device. Negative values will be automatically made positive.";
			typeName = "NUMBER";
			defaultValue = "160";
		};

		class specdev_deviceSettings_minStrength: Edit
		{
			property = "specdev_deviceSettings_minStrength";
			displayName = "Minimum Frequency Strength";
			tooltip = "Sets the minimum signal strength on the Spectrum Device, all signal frequencies must be greater than this. Negative values will be automatically made positive.";
			typeName = "NUMBER";
			defaultValue = "0";
		};

		class specdev_deviceSettings_maxStrength: Edit
		{
			property = "specdev_deviceSettings_maxStrength";
			displayName = "Maximum Frequency Strength";
			tooltip = "Sets the maximum signal strength on the Spectrum Device, all signal frequencies must be less than this. Negative values will be automatically made positive.";
			typeName = "NUMBER";
			defaultValue = "100";
		};

		class specdev_deviceSettings_minSelection: Edit
		{
			property = "specdev_deviceSettings_minSelection";
			displayName = "Minimum Selection Range";
			tooltip = "Sets the minimum selection range on the Spectrum Device, must be between minimum and maximum frequency to display. Doesn't have any real functionality currently. Negative values will be automatically made positive.";
			typeName = "NUMBER";
			defaultValue = "100.5";
		};

		class specdev_deviceSettings_maxSelection: Edit
		{
			property = "specdev_deviceSettings_maxSelection";
			displayName = "Maximum Selection Range";
			tooltip = "Sets the maximum selection Range on the Spectrum Device, must be between minimum and maximum frequency to display. Doesn't have any real functionality currently. Negative values will be automatically made positive.";
			typeName = "NUMBER";
			defaultValue = "101.5";
		};
	};
};
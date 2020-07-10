class specdev_Module_spectrumDisable: Module_F
{
	scope = 2;
	displayName = "Disable Signal";
	category = "specdevSpectrum";
	function = "specdev_fnc_signalDisable";
	functionPriority = 4;
	isGlobal = 0;
	isTriggerActivated = 1;
	isDisposable = 1;

	curatorInfoType = "RscDisplayAttributespectrumDisable";

	class Attributes: AttributesBase
	{
		class specdev_spectrumDisable_name: Edit
		{
			property = "specdev_spectrumDisable_name";
			displayName = "Signal Name";
			tooltip = "The custom name of the signal to disable. Must be a name already defined in a Signal Source module.";
			typeName = "STRING";
		};

		class specdev_spectrumDisable_timeout: Edit
		{
			property = "specdev_spectrumDisable_timeout";
			displayName = "Signal Timeout";
			tooltip = "How long after the module is activated will the signal be disabled.";
			typeName = "NUMBER";
			defaultValue = "0";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description[] = {
			"Alternate way to stop signal from destroying source object.",
			"Enter name of signal that should be disabled.",
			"Enter time after module activation to disable signal.",
			"Module should be activated by trigger, otherwise will activate on mission start.";
		};
	};
};
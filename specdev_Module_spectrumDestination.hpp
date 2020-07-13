class specdev_Module_spectrumDestination: Module_F
{
    scope = 2;
    displayName = "Signal Receiver";
    icon = "\A3\Structures_F_Bootcamp\VR\Helpers\Data\UI\Map_VR_Sector_01_60deg_50_CA.paa";
    category = "specdevSpectrum";
    function = "specdev_fnc_signalReceiver";
    functionPriority = 2;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 0;

    curatorInfoType = "RscDisplayAttributespectrumDestination";

    class Attributes: AttributesBase
    {
        class specdev_spectrumDestination_Method: Combo
        {
            property = "specdev_spectrumDestination_Method";
            displayName = "Receiving Method";
            tooltip = "Sets how the module will decide the signal receiver. Units: Specific units that receive a signal are defined in the Signal Source module. Device: Player holding device will act as the signal receiver, should only have a single Spectrum Device available in the mission at a time.";
            typeName = "NUMBER";
            defaultValue = "0";
            class Values
            {
                class specdev_spectrumDestination_Method_oneUnit
                {
                    name = "Units";
                    value = 0;
                };
                class specdev_spectrumDestination_Method_oneDevice
                {
                    name = "Device";
                    value = 1;
                };
            };
        };
        class specdev_spectrumDestination_deviceUpdate: Edit
        {
            property = "specdev_spectrumDestination_deviceUpdate";
            displayName = "Signal Receiver Update";
            tooltip = "When using One Device mode, how often will the module check who is holding the device in seconds.";
            typeName = "NUMBER";
            defaultValue = "60";
        };

        class ModuleDescription: ModuleDescription{};
    };

    class ModuleDescription: ModuleDescription
    {
        description[] = {
            "Sets the method of receiving signals",
            "Units: Specific units that receive a signal are defined in the Signal Source module.",
            "Device: Player holding the Spectrum Device will receive the signals, should only have a single Spectrum Device available at a time in the mission",
            "When multiple devices are used in Device mode, any results are unintended.",
            "Module can be trigger activated.",
            "Don't use both types of Receiving Methods simultaneously!";
        };
    };
};
class specdev_Module_spectrumDestination: Module_F
{
    scope = 2;
    displayName = "Signal Receiver";
    category = "specdevSpectrum";
    function = "specdev_fnc_signalReceiver";
    functionPriority = 2;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 0;

    curatorInfoType = "RscDisplayAttributespectrumDestination";

    class Attributes: AttributesBase
    {
        class ModuleDescription: ModuleDescription{};
    };

    class ModuleDescription: ModuleDescription
    {
        description[] = {
            "This module sets which unit will be the receiver for signals.",
            "Sync to player that will receive signals.",
            "Must only have a SINGLE Destination module!",
            "Additional modules will overwrite the previous ones.",
            "Can sync to non-players if required, however anything that happens as a result of this is unintended.";
        };
        position = 0;
        direction = 0;
        optional = 0;
        duplicate = 0;
        sync[] = {"AnyPlayer"};
    };
};
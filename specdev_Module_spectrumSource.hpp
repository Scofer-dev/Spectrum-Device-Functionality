class specdev_Module_spectrumSource: Module_F
{
    scope = 2;
    displayName = "Signal Source";
    icon = "\a3\Modules_F_Curator\Data\iconRadio_ca.paa";
    category = "specdevSpectrum";
    function = "specdev_fnc_signalSource";
    functionPriority = 3;
    isGlobal = 0;
    isTriggerActivated = 1;
    isDisposable = 1;

    curatorInfoType = "RscDisplayAttributespectrumSource";

    class Attributes: AttributesBase
    {
        class specdev_spectrumSource_Name: Edit
        {
            property = "specdev_spectrumSource_Name";
            displayName = "Signal Name";
            tooltip = "A custom name to identify the signal. Can be used by Disable Signal module. Required!";
            typeName = "STING";
        };

        class specdev_spectrumSource_Source: Edit
        {
            property = "specdev_spectrumSource_Source";
            displayName = "Signal Source";
            tooltip = "Variable name of object(s) that will be the source of signal, can enter multiple variable names and one will be chosen at random. Variable names MUST be seperated by a comma with no spaces!";
            typeName = "STRING";
        };

        class specdev_spectrumSource_Range: Edit
        {
            property = "specdev_spectrumSource_Range";
            displayName = "Signal Range";
            tooltip = "The maximum range that the signal will be detectable by the Spectrum Device. The signal strength will increase as the receiver gets closer to the source object";
            typeName = "NUMBER";
            defaultValue = "1000";
        };

        class specdev_spectrumSource_Frequency: Edit
        {
            property = "specdev_spectrumSource_Frequency";
            displayName = "Signal Frequency";
            tooltip = "The frequency the signal will use, must be between the minimum and maximum device frequency.";
            typeName = "NUMBER";
            defaultValue = "120";
        };

        class specdev_spectrumSource_Delay: Edit
        {
            property = "specdev_spectrumSource_Delay";
            displayName = "Update Delay";
            tooltip = "How often the signal will update on the Spectrum Device. Value in seconds. Lower values will make the spectrum more accurate, but could lead to reduced performance with a larger number of spectrums. Values below 1 not recommended!";
            typeName = "NUMBER";
            defaultValue = "5";
        };

        class specdev_spectrumSource_angleCoefficient: Edit
        {
            property = "specdev_spectrumSource_angleCoefficient";
            displayName = "Angle Degradation Coefficient";
            tooltip = "How much the signal will degrade based on the angle offset between the source and receiver. Higher values mean the source will degrade more; lower values mean the source will degrade less. 0 will mean the source will not be degraded.";
            typeName = "NUMBER";
            defaultValue = "1";
        };

        class specdev_spectrumSource_signalReceiver: Edit
        {
            property = "specdev_spectrumSource_signalReceiver";
            displayName = "Signal Receiver";
            tooltip = "Specific which unit(s) will receive the signal, only used when 'Unit' method is used by Signal Receiver module";
            typeName = "STRING";
        };

        class specdev_spectrumSource_EndAction: CheckBoxNumber
        {
            property = "specdev_spectrumSource_EndAction";
            displayName = "Add Disable Action";
            tooltip = "Option to automatically add a hold action on the signal source object, this action will kill the object, stopping the signal.";
            typeName = "NUMBER";
            defaultValue = 0;
        };

        class specdev_spectrumSource_ActionDuration: Edit
        {
            property = "specdev_spectrumSource_ActionDuration";
            displayName = "Disable Action Duration";
            tooltip = "How long the hold option will need to be held to disable the source.";
            typeName = "NUMBER";
            defaultValue = 10;
        };

        class ModuleDescription: ModuleDescription{};
    };

    class ModuleDescription: ModuleDescription
    {
        description[] = {
			"Enter variable name(s) of Unit, Vehicle or Object.",
			"Can enter multiple names, source will be chosen at random. Names MUST be seperated by comma.",
			"i.e source_1,source_2,source_3",
			"Multiple signals can come from a single object.",
            "Signal Receiver field only used when 'Unit' method is used in Signal Receiver module.";
        };
    };
};
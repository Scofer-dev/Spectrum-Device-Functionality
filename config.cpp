class CfgPatches
{
    class specdev_spectrum
    {
        units[] = {"specdev_Module_deviceSettings","specdev_Module_spectrumDestination","specdev_Module_spectrumSource","specdev_Module_spectrumDisable"};
        requiredVersion = 1.00;
        requiredAddons[] = {"A3_Modules_F"};
        author = "Scofer";
        name = "Spectrum Device";
        version = "1.0";
    };
};

class CfgFactionClasses
{
    class specdevSpectrum
    {
        displayName = "Spectrum Device";
        priority = 1;
        side = 7;
    };
};

class CfgFunctions
{
    class specdev
    {
        class Source
        {
            file = "\spectrumDevice\fnc";
            class deviceSettings;
            class signalReceiver;
            class signalSource;
            class signalDisable;
            class unitReceiver;
        }
    };
};

class CfgVehicles
{   
    class Logic;
    class Module_F: Logic
    {
        class AttributesBase
        {
            class Default;
            class Edit; // Default edit box (i.e., text input field)
            class Combo; // Default combo box (i.e., drop-down menu)
            class Checkbox; // Default checkbox (returned value is Bool)
            class CheckboxNumber; // Default checkbox (returned value is Number)
            class ModuleDescription; // Module description
            class Units; // Selection of units on which the module is applied
        };
        class ModuleDescription
        {
            class Anything;
        };
    };
    #include "specdev_Module_deviceSettings.hpp"
    #include "specdev_Module_spectrumSource.hpp"
    #include "specdev_Module_spectrumDestination.hpp"
    #include "specdev_Module_spectrumDisable.hpp"
};

class CfgRemoteExec
{
    class Functions
    {
        mode = 2;
        jip = 1;

        class specdev_fnc_unitReceiver
        {
            allowedTargets = 0;
        };
    };
};
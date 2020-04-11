/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

class CfgPatches {
	class CAU_colorPicker {
        name="ColorPicker";
        author="ConnorAU";
        url="https://steamcommunity.com/id/_connor";

		requiredVersion=0.01;
		requiredAddons[]={"A3_3DEN","A3_Ui_F","CAU_UserInputMenus"};
		units[]={};
		weapons[]={};
	};
};

class CfgFunctions {
	class CAU_colorPicker {
		class script {
			class system {
				file="\cau\colorpicker\system.sqf";
			};
		};
	};
};

// Inherit Ctrls
class ctrlDefault;
class ctrlDefaultText;
class ctrlDefaultButton;
class ctrlButton;
class ctrlButtonPictureKeepAspect;
class ctrlMenu;
class ctrlMenuStrip;

// Add button to 3den toolbar
class Display3DEN {
	class controls {
		class MenuStrip: ctrlMenuStrip {
			class Items {
				class Tools {
					items[]+={"CAU_colorPicker"};
				};
				class CAU_colorPicker {
					text="$STR_CAU_ColorPicker_Title";
					action="_this call CAU_colorPicker_fnc_system";
					picture="\cau\colorpicker\icon.paa";
				};
			};
		};
	};
};

// Add button to debug menu
class RscControlsGroup;
class RscControlsGroupNoScrollbars;
class RscHTML;
class RscDebugConsole: RscControlsGroupNoScrollbars {
	class controls {
		class Link: RscHTML {
			x="(6 * (((safezoneW / safezoneH) min 1.2) / 40))";
		};
		class CAU_colorPicker: ctrlButtonPictureKeepAspect {
			idc=0; // idc 0 to exclude from repositioning in CBA extended debug
			deletable=0;
			text="\cau\colorpicker\icon.paa";
			tooltip="$STR_CAU_ColorPicker_Title";
			colorBackground[]={0,0,0,0};
			colorBackgroundActive[]={0,0,0,0};
			colorFocused[]={0,0,0,0};
			colorBackgroundDisabled[]={0,0,0,0};
			onButtonClick="_this call CAU_colorPicker_fnc_system";

			// get from title ctrl incase some mod moves it
			x="getNumber(configFile >> 'RscDebugConsole' >> 'controls' >> 'Title' >> 'w') - (1.1 * (((safezoneW / safezoneH) min 1.2) / 40))";
			y="getNumber(configFile >> 'RscDebugConsole' >> 'controls' >> 'Title' >> 'y')";
			w="1 * (((safezoneW / safezoneH) min 1.2) / 40)";
			h="1 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};
	};
};

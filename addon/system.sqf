/*──────────────────────────────────────────────────────┐
│   Author: ConnorAU                                    │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

[
    nil,localize "STR_CAU_ColorPicker_Title",
    {
        if _confirmed then {
			disableSerialization;
            uiNameSpace setVariable ["Display3DENCopy_data",[
                localize "STR_CAU_ColorPicker_Selected",
                [
                    "// RGBA1",_colorRGBA1,"",
                    "// RGBA256",_colorRGBA256,"",
                    "// HTML",_colorHTML
                ] joinString endl
            ]];

			// can't close one display and open another in the same frame
			[] spawn {
				private _display = switch true do {
					case (!isNull findDisplay 49):{findDisplay 49}; // Interrupt menu
					case (!isNull findDisplay 316000):{findDisplay 316000}; // 3den debug
					case (!isNull findDisplay 313):{findDisplay 313}; // 3den main
					default {displayNull};
				};
				if (isNull _display) then {
					createDialog "Display3DENCopy";
				} else {
					_display createDisplay "Display3DENCopy";
				};
			};
        };
    },"","",ctrlParent param[0,controlNull,[controlNull]]
] call (missionNameSpace getvariable ["CAU_UserInputMenus_fnc_colorPicker",{
	[
		format[
			"Color Picker now requires the <a href='%1'>UserInputMenus mod</a> to function correctly",
			"https://steamcommunity.com/sharedfiles/filedetails/?id=1673595418"
		],
		"Missing Dependency"
	] spawn ([BIS_fnc_guiMessage,BIS_fnc_3DENShowMessage] select is3DEN);
}]);

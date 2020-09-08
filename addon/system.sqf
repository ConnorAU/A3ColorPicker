/* ----------------------------------------------------------------------------
Project:
	https://github.com/ConnorAU/A3ColorPicker

Author:
	ConnorAU - https://github.com/ConnorAU

Function:
	CAU_colorPicker_fnc_system

Description:
	Opens the color picker menu with the detected default color value and the tasks to perform once a color is selected.

Parameters:
	None

Return:
	Nothing
---------------------------------------------------------------------------- */

#define VAL_VALID_HEX ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","#"]

private _defaultValue = [];

// Attempt to detect color value from clipboard
private _clipboard = toUpper copyFromClipboard;
if (count _clipboard > 0) then {
	private _clipboardSplit = _clipboard splitString "";

	private _isHex = (
		(
			(_clipboard find "#" == 0 && {count _clipboard in [7,9]}) ||
			{_clipboard find "#" == -1 && {count _clipboard in [6,8]}}
		) &&
		{_clipboardSplit findIf {!(_x in VAL_VALID_HEX)} == -1}
	);
	if _isHex then {
		_defaultValue = _clipboard;
	} else {
		private _isArray = _clipboard find "[" == 0 && {_clipboard find "]" == count _clipboard - 1};
		if _isArray then {
			private _clipboardValues = parseSimpleArray _clipboard;
			if (count _clipboardValues in [3,4] && {_clipboardValues isEqualTypeAll 0}) then {
				_defaultValue = _clipboardValues;
			};
		};
	};
};

[
    [_defaultValue],localize "STR_CAU_ColorPicker_Title",
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
				isNil {
					private _displays = [
						findDisplay 49, // Interrupt menu
						findDisplay 316000, // 3den debug
						findDisplay 313 // 3den main
					];
					private _display = _displays param [_displays findIf {!isNull _x},displayNull];

					if (isNull _display) then {
						createDialog "Display3DENCopy";
					} else {
						_display createDisplay "Display3DENCopy";
					};
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

nil

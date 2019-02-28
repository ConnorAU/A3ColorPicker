/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

#define THIS_FUNC CAU_colorPicker_fnc_system
#define DISPLAY_NAME CAU_displayColorPicker

#include "\a3\3den\ui\macros.inc"
#include "_defines.inc"

#define VAL_GRID_START_IDC 100
#define VAL_HEX_TABLE [\
	"00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F",\
	"10","11","12","13","14","15","16","17","18","19","1A","1B","1C","1D","1E","1F",\
	"20","21","22","23","24","25","26","27","28","29","2A","2B","2C","2D","2E","2F",\
	"30","31","32","33","34","35","36","37","38","39","3A","3B","3C","3D","3E","3F",\
	"40","41","42","43","44","45","46","47","48","49","4A","4B","4C","4D","4E","4F",\
	"50","51","52","53","54","55","56","57","58","59","5A","5B","5C","5D","5E","5F",\
	"60","61","62","63","64","65","66","67","68","69","6A","6B","6C","6D","6E","6F",\
	"70","71","72","73","74","75","76","77","78","79","7A","7B","7C","7D","7E","7F",\
	"80","81","82","83","84","85","86","87","88","89","8A","8B","8C","8D","8E","8F",\
	"90","91","92","93","94","95","96","97","98","99","9A","9B","9C","9D","9E","9F",\
	"A0","A1","A2","A3","A4","A5","A6","A7","A8","A9","AA","AB","AC","AD","AE","AF",\
	"B0","B1","B2","B3","B4","B5","B6","B7","B8","B9","BA","BB","BC","BD","BE","BF",\
	"C0","C1","C2","C3","C4","C5","C6","C7","C8","C9","CA","CB","CC","CD","CE","CF",\
	"D0","D1","D2","D3","D4","D5","D6","D7","D8","D9","DA","DB","DC","DD","DE","DF",\
	"E0","E1","E2","E3","E4","E5","E6","E7","E8","E9","EA","EB","EC","ED","EE","EF",\
	"F0","F1","F2","F3","F4","F5","F6","F7","F8","F9","FA","FB","FC","FD","FE","FF"\
]
#define VAL_VALID_NUMERIC ["0","1","2","3","4","5","6","7","8","9","."]
#define VAL_VALID_HEX ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]

#define GRID_COLOR(x,i) linearConversion[0,VAL_CELL_COUNT,x,i,1,true]

params[["_mode","",[""]],["_params",[]]];

switch _mode do {
	case "openDisplay":{
		_params params ["_ctrl"];
		(ctrlParent _ctrl) createDisplay QUOTE(DISPLAY_NAME);

	};
	case "onLoad":{
		USE_DISPLAY(_params#0);
		uiNamespace setVariable [QUOTE(DISPLAY_NAME),_display];

		USE_CTRL(_ctrlComboMode,IDC_COMBO_MODE);
		USE_CTRL(_ctrlEditR,IDC_EDIT_INPUT_R);
		USE_CTRL(_ctrlEditG,IDC_EDIT_INPUT_G);
		USE_CTRL(_ctrlEditB,IDC_EDIT_INPUT_B);
		USE_CTRL(_ctrlEditA,IDC_EDIT_INPUT_A);
		USE_CTRL(_ctrlSliderR,IDC_SLIDER_R);
		USE_CTRL(_ctrlSliderG,IDC_SLIDER_G);
		USE_CTRL(_ctrlSliderB,IDC_SLIDER_B);
		USE_CTRL(_ctrlSliderA,IDC_SLIDER_A);

		{
			_ctrlComboMode lbAdd _x;
		} forEach [
			localize "STR_CAU_ColorPicker_Mode_RGBA1",
			localize "STR_CAU_ColorPicker_Mode_RGBA255",
			localize "STR_CAU_ColorPicker_Mode_HEX"
		];
		_ctrlComboMode lbSetCurSel 0;
		_ctrlComboMode ctrlAddEventHandler ["LBSelChanged",{["modeLBSelChanged",_this] call THIS_FUNC}];

		{
			_x ctrlAddEventHandler ["KeyUp",{["editKeyUp",_this] call THIS_FUNC}];
		} foreach [_ctrlEditR,_ctrlEditG,_ctrlEditB,_ctrlEditA];

		private _startColor = (configFile >> "ctrlStaticTitle" >> "colorBackground") call BIS_fnc_colorConfigToRGBA;
		{
			_x params ["_ctrl","_pos"];
			_ctrl sliderSetRange [0,1];
			_ctrl sliderSetSpeed [1/256,0.1];
			_ctrl sliderSetPosition _pos;
			_ctrl ctrlAddEventHandler ["SliderPosChanged",{["sliderPosChanged",_this] call THIS_FUNC}];
		} foreach [
			[_ctrlSliderR,_startColor#0],
			[_ctrlSliderG,_startColor#1],
			[_ctrlSliderB,_startColor#2],
			[_ctrlSliderA,_startColor#3]
		];

		["createGrid",[_display]] call THIS_FUNC;
		["updateGridColor"] call THIS_FUNC;
		["updateOutput",_startColor] call THIS_FUNC;
		["updateEdit"] call THIS_FUNC;
	};

	case "createGrid":{
		_params params ["_display"];
		USE_CTRL(_ctrlGroup,IDC_GROUP_GRID);

		private _x = 0;
		private _y = 0;

		// there is simply no way I'm about to write all these into the config
		for "_i" from 0 to 1000 do {
			private _ctrl = _display ctrlCreate ["ctrlStructuredText",VAL_GRID_START_IDC + _i,_ctrlGroup];
			_ctrl ctrlSetPosition [
				_x*(PX_WA(VAL_CELL_SIZE)),
				_y*(PX_HA(VAL_CELL_SIZE)),
				PX_WA(VAL_CELL_SIZE),
				PX_HA(VAL_CELL_SIZE)
			];
			_ctrl ctrlAddEventHandler ["ButtonClick",{["gridClicked",_this] call THIS_FUNC}];
			_ctrl ctrlCommit 0;

			_y = _y + 1;
			if (_y == VAL_CELL_COUNT) then {
				_x = _x + 1;
				_y = 0;
			};
			if (_x > VAL_CELL_COUNT) exitWith {
				_ctrlGroup setVariable ["maxIDC",_i];
			};
		};
	};
	case "updateGridColor":{
		USE_DISPLAY(THIS_DISPLAY);
		USE_CTRL(_ctrlGroup,IDC_GROUP_GRID);
		USE_CTRL(_ctrlSliderR,IDC_SLIDER_R);
		USE_CTRL(_ctrlSliderG,IDC_SLIDER_G);
		USE_CTRL(_ctrlSliderB,IDC_SLIDER_B);
		USE_CTRL(_ctrlSliderA,IDC_SLIDER_A);

		private _maxIDC = _ctrlGroup getVariable ["maxIDC",0];
		private _ctrlSliderRPos = sliderPosition _ctrlSliderR;
		private _ctrlSliderGPos = sliderPosition _ctrlSliderG;
		private _ctrlSliderBPos = sliderPosition _ctrlSliderB;
		private _ctrlSliderAPos = sliderPosition _ctrlSliderA;

		private _x = 0;
		private _y = 0;

		for "_i" from 0 to _maxIDC do {
			USE_CTRL(_ctrl,VAL_GRID_START_IDC + _i);

			private _colorRGBA = [
				GRID_COLOR(_x,_ctrlSliderRPos) * (1-(_y/VAL_CELL_COUNT)),
				GRID_COLOR(_x,_ctrlSliderGPos) * (1-(_y/VAL_CELL_COUNT)),
				GRID_COLOR(_x,_ctrlSliderBPos) * (1-(_y/VAL_CELL_COUNT)),
				_ctrlSliderAPos
			];
			private _colorHTML = if (_ctrlSliderAPos < 1) then {
				_colorRGBA call BIS_fnc_colorRGBAtoHTML
			} else {
				_colorRGBA call BIS_fnc_colorRGBtoHTML
			};

			_ctrl ctrlSetBackgroundColor _colorRGBA;
			_ctrl ctrlSetTooltip _colorHTML;
			_ctrl ctrlSetTooltipColorShade _colorRGBA;
			_ctrl setVariable ["color",str _colorRGBA];
			_ctrl ctrlCommit 0;

			_y = _y + 1;
			if (_y == VAL_CELL_COUNT) then {
				_x = _x + 1;
				_y = 0;
			};
		};
	};

	case "updateOutput":{
		USE_DISPLAY(THIS_DISPLAY);
		USE_CTRL(_ctrlTitle,IDC_TITLE_TEXT);
		USE_CTRL(_ctrlOutputRGBA1,IDC_EDIT_OUTPUT_RGBA1);
		USE_CTRL(_ctrlOutputRGBA256,IDC_EDIT_OUTPUT_RGBA256);
		USE_CTRL(_ctrlOutputRRGGBB,IDC_EDIT_OUTPUT_RRGGBB);
		USE_CTRL(_ctrlOutputAARRGGBB,IDC_EDIT_OUTPUT_AARRGGBB);

		_ctrlTitle ctrlSetBackgroundColor _params;
		_ctrlOutputRGBA1 ctrlSetText str (["outputRGBA1",_params] call THIS_FUNC);
		_ctrlOutputRGBA256 ctrlSetText str (["RGBA1toRGBA256",_params] call THIS_FUNC);
		_ctrlOutputRRGGBB ctrlSetText (_params call BIS_fnc_colorRGBtoHTML);
		_ctrlOutputAARRGGBB ctrlSetText (_params call BIS_fnc_colorRGBAtoHTML);
	};
	case "updateEdit":{
		USE_DISPLAY(THIS_DISPLAY);
		USE_CTRL(_ctrlComboMode,IDC_COMBO_MODE);
		USE_CTRL(_ctrlEditR,IDC_EDIT_INPUT_R);
		USE_CTRL(_ctrlEditG,IDC_EDIT_INPUT_G);
		USE_CTRL(_ctrlEditB,IDC_EDIT_INPUT_B);
		USE_CTRL(_ctrlEditA,IDC_EDIT_INPUT_A);
		USE_CTRL(_ctrlSliderR,IDC_SLIDER_R);
		USE_CTRL(_ctrlSliderG,IDC_SLIDER_G);
		USE_CTRL(_ctrlSliderB,IDC_SLIDER_B);
		USE_CTRL(_ctrlSliderA,IDC_SLIDER_A);

		private _mode = lbCurSel _ctrlComboMode;
		private _color = [
			sliderPosition _ctrlSliderR,
			sliderPosition _ctrlSliderG,
			sliderPosition _ctrlSliderB,
			sliderPosition _ctrlSliderA
		];

		(switch _mode do {
			case 0:{["outputRGBA1",_color] call THIS_FUNC};
			case 1:{["RGBA1toRGBA256",_color] call THIS_FUNC};
			case 2:{
				private _hex = _color call BIS_fnc_colorRGBAtoHTML;
				[
					_hex select [3,2],
					_hex select [5,2],
					_hex select [7,2],
					_hex select [1,2]
				]
			};
			default {[1,1,1,1]};
		}) params ["_r","_g","_b","_a"];

		_ctrlEditR ctrlSetText format["%1",_r];
		_ctrlEditG ctrlSetText format["%1",_g];
		_ctrlEditB ctrlSetText format["%1",_b];
		_ctrlEditA ctrlSetText format["%1",_a];
	};
	case "updateSlider":{
		USE_DISPLAY(THIS_DISPLAY);
		USE_CTRL(_ctrlComboMode,IDC_COMBO_MODE);
		USE_CTRL(_ctrlEditR,IDC_EDIT_INPUT_R);
		USE_CTRL(_ctrlEditG,IDC_EDIT_INPUT_G);
		USE_CTRL(_ctrlEditB,IDC_EDIT_INPUT_B);
		USE_CTRL(_ctrlEditA,IDC_EDIT_INPUT_A);
		USE_CTRL(_ctrlSliderR,IDC_SLIDER_R);
		USE_CTRL(_ctrlSliderG,IDC_SLIDER_G);
		USE_CTRL(_ctrlSliderB,IDC_SLIDER_B);
		USE_CTRL(_ctrlSliderA,IDC_SLIDER_A);

		private _mode = lbCurSel _ctrlComboMode;
		private _color = [
			ctrlText _ctrlEditR,
			ctrlText _ctrlEditG,
			ctrlText _ctrlEditB,
			ctrlText _ctrlEditA
		];

		(switch _mode do {
			case 0:{["outputRGBA1",_color apply {parseNumber _x}] call THIS_FUNC};
			case 1:{["RGBA256toRGBA1",_color] call THIS_FUNC};
			case 2:{["htmlToRGBA1",[_color#3,_color#0,_color#1,_color#2]] call THIS_FUNC};
			default {[1,1,1,1]};
		}) params ["_r","_g","_b","_a"];

		_ctrlSliderR sliderSetPosition _r;
		_ctrlSliderG sliderSetPosition _g;
		_ctrlSliderB sliderSetPosition _b;
		_ctrlSliderA sliderSetPosition _a;
	};

	case "modeLBSelChanged":{
		["updateEdit"] call THIS_FUNC;
	};
	case "editKeyUp":{
		_params params ["_ctrl"];
		USE_DISPLAY(ctrlParent _ctrl);
		USE_CTRL(_ctrlComboMode,IDC_COMBO_MODE);

		private _mode = lbCurSel _ctrlComboMode;

		private _ctrlText = toUpper ctrlText _ctrl;
		private _validText = "";
		private _validChars = [VAL_VALID_NUMERIC,VAL_VALID_HEX] select (_mode == 2);
		{
			if (_x in _validChars) then {
				_validText = _validText + _x;
			};
		} forEach (_ctrlText splitString "");
		if (_ctrlText != _validText) then {
			if (_validText == "") then {
				_validText = ["0","00"] select (_mode == 2);
			};
			_ctrl ctrlSetText _validText;
		};
		["updateSlider"] call THIS_FUNC;
		["updateGridColor"] call THIS_FUNC;
	};
	case "sliderPosChanged":{
		["updateEdit"] call THIS_FUNC;
		["updateGridColor"] call THIS_FUNC;
	};
	case "gridClicked":{
		_params params ["_ctrl"];
		private _color = _ctrl getVariable ["color",[]];
		["updateOutput",parseSimpleArray _color] call THIS_FUNC;
	};

	case "outputRGBA1":{
		// round to nearest 3 decimal places
		_params apply {(round(_x*1000))/1000};
	};
	case "RGBA1toRGBA256":{
		_params apply {round(_x*255)};
	};
	case "RGBA256toRGBA1":{
		_params apply {(parseNumber _x)/255};
	};
	case "htmlToRGBA1":{
		private _out = [];
		{
			_out pushback linearConversion[0,255,VAL_HEX_TABLE find toUpper _x,0,1,true];
		} foreach _params;
		if (count _out == 4) then {
			// #AARRGGBB
			// move alpha to end of array
			_out pushBack (_out deleteAt 0);
		};
		_out
	};
};
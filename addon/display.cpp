/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

#define DIALOG_W 100
#define DIALOG_H 111

class CAU_displayColorPicker {
    idd=-1;
    onLoad="['onLoad',_this] call CAU_colorPicker_fnc_system";

    class controlsBackground {
        class tiles: ctrlStaticBackgroundDisableTiles {};
        class background: ctrlStaticBackground {
            x=CENTER_XA(DIALOG_W);
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M);
            w=PX_WA(DIALOG_W);
            h=PX_HA(DIALOG_H) - PX_HA(SIZE_M);
        };
        class title: ctrlStaticTitle {
            idc=IDC_TITLE_TEXT;
            text="$STR_CAU_ColorPicker_Title";
            x=CENTER_XA(DIALOG_W);
            y=CENTER_YA(DIALOG_H);
            w=PX_WA(DIALOG_W);
            h=PX_HA(SIZE_M);
        };
        class footer: ctrlStaticFooter {
            x=CENTER_XA(DIALOG_W);
            y=CENTER_YA(DIALOG_H) + PX_HA(DIALOG_H) - PX_HA((SIZE_M + 2));
            w=PX_WA(DIALOG_W);
            h=PX_HA((SIZE_M + 2));
        };
        class exit: ctrlButtonClose {
            idc=IDC_BUTTON_CLOSE;
            x=CENTER_XA(DIALOG_W) + PX_WA(DIALOG_W) - PX_WA((SIZE_M*5)) - PX_WA(1);
            y=CENTER_YA(DIALOG_H) + PX_HA(DIALOG_H) - PX_HA((SIZE_M + 1));
            w=PX_WA((SIZE_M*5));
            h=PX_HA(SIZE_M);
        };

    // background top-left panel
        class outputOverlay: ctrlStaticOverlay {
            x=CENTER_XA(DIALOG_W) + PX_WA(2);
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(2);
            w=PX_WA(DIALOG_W) - (PX_WA(VAL_CELL_SIZE))*(VAL_CELL_COUNT+1) - PX_WA(6);
            h=(PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT;
        };
        class outputFrame: ctrlStaticFrame {
            x=CENTER_XA(DIALOG_W) + PX_WA(2);
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(2);
            w=PX_WA(DIALOG_W) - (PX_WA(VAL_CELL_SIZE))*(VAL_CELL_COUNT+1) - PX_WA(6);
            h=(PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT;
        };

    // background bottom panel
        class editOverlay: ctrlStaticOverlay {
            x=CENTER_XA(DIALOG_W) + PX_WA(2);
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(4) + (PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT;
            w=PX_WA(DIALOG_W) - PX_WA(4);
            h=PX_HA(DIALOG_H) - PX_HA(SIZE_M) - PX_HA((SIZE_M + 2)) - (PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT - PX_HA(6);
        };
        class editFrame: ctrlStaticFrame {
            x=CENTER_XA(DIALOG_W) + PX_WA(2);
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(4) + (PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT;
            w=PX_WA(DIALOG_W) - PX_WA(4);
            h=PX_HA(DIALOG_H) - PX_HA(SIZE_M) - PX_HA((SIZE_M + 2)) - (PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT - PX_HA(6);
        };
    };
    class controls {

    // foreground top-left panel
        class outputTitleRGBA1: ctrlStatic {
            text="$STR_CAU_ColorPicker_Mode_RGBA1";
            x=CENTER_XA(DIALOG_W) + PX_WA(2);
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(3);
            w=PX_WA(DIALOG_W) - (PX_WA(VAL_CELL_SIZE))*(VAL_CELL_COUNT+1) - PX_WA(10);
            h=PX_HA(SIZE_M);
        };
        class outputEditRGBA1: ctrlEdit {
            idc=IDC_EDIT_OUTPUT_RGBA1;
            style=2;
            canModify=0;
            x=CENTER_XA(DIALOG_W) + PX_WA(4);
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(3) + PX_HA(SIZE_M);
            w=PX_WA(DIALOG_W) - (PX_WA(VAL_CELL_SIZE))*(VAL_CELL_COUNT+1) - PX_WA(10);
            h=PX_HA(SIZE_M);
        };

        class outputTitleRGBA256: outputTitleRGBA1 {
            text="$STR_CAU_ColorPicker_Mode_RGBA255";
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(4) + PX_HA((SIZE_M*2));
        };
        class outputEditRGBA256: outputEditRGBA1 {
            idc=IDC_EDIT_OUTPUT_RGBA256;
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(4) + PX_HA((SIZE_M*3));
        };

        class outputTitleRRGGBB: outputTitleRGBA1 {
            text="$STR_CAU_ColorPicker_Mode_RRGGBB";
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(5) + PX_HA((SIZE_M*4));
        };
        class outputEditRRGGBB: outputEditRGBA1 {
            idc=IDC_EDIT_OUTPUT_RRGGBB;
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(5) + PX_HA((SIZE_M*5));
        };

        class outputTitleAARRGGBB: outputTitleRGBA1 {
            text="$STR_CAU_ColorPicker_Mode_AARRGGBB";
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(6) + PX_HA((SIZE_M*6));
        };
        class outputEditAARRGGBB: outputEditRGBA1 {
            idc=IDC_EDIT_OUTPUT_AARRGGBB;
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(6) + PX_HA((SIZE_M*7));
        };

    // foreground top-right panel
        class gridGroup: ctrlControlsGroupNoScrollbars {
            idc=IDC_GROUP_GRID;
            x=CENTER_XA(DIALOG_W) + PX_WA(4) + (PX_WA(DIALOG_W) - (PX_WA(VAL_CELL_SIZE))*(VAL_CELL_COUNT+1) - PX_WA(6));
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(2);
            w=(PX_WA(VAL_CELL_SIZE))*(VAL_CELL_COUNT+1);
            h=(PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT;

            class controls {
                class gridBackground: ctrlStaticBackgroundDisableTiles {
                    x=0;
                    y=0;
                    w=(PX_WA(VAL_CELL_SIZE))*(VAL_CELL_COUNT+1);
                    h=(PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT;
	                tileW=((PX_WA(VAL_CELL_SIZE))*(VAL_CELL_COUNT+1))*2 / (32 * pixelW);
	                tileH=((PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT)*2 / (32 * pixelH);
                    colorText[]={1,1,1,0.1};
                };
            };
        };

    // foreground bottom panel
        class modeCombo: ctrlCombo {
            idc=IDC_COMBO_MODE;
            x=CENTER_XA(DIALOG_W) + PX_WA(4);
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(6) + (PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT;
            w=PX_WA(DIALOG_W) - PX_WA(8);
            h=PX_HA(SIZE_M);
        };

        class inputEditRed: ctrlEdit {
            idc=IDC_EDIT_INPUT_R;
            style=2;
            colorText[]={1,0,0,1};
            x=CENTER_XA(DIALOG_W) + PX_WA(4);
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(7.5) + (PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT + PX_HA(SIZE_M);
            w=((PX_WA(DIALOG_W) - PX_WA(8))/4) - PX_WA(1);
            h=PX_HA(SIZE_M);
        };
        class inputEditGreen: inputEditRed {
            idc=IDC_EDIT_INPUT_G;
            colorText[]={0,1,0,1};
            x=CENTER_XA(DIALOG_W) + PX_WA(4.25) + ((PX_WA(DIALOG_W) - PX_WA(8))/4);
        };
        class inputEditBlue: inputEditRed {
            idc=IDC_EDIT_INPUT_B;
            colorText[]={0.26,0.6,1,1};
            x=CENTER_XA(DIALOG_W) + PX_WA(4.5) + (((PX_WA(DIALOG_W) - PX_WA(8))/4)*2);
        };
        class inputEditAlpha: inputEditRed {
            idc=IDC_EDIT_INPUT_A;
            colorText[]={1,1,1,1};
            x=CENTER_XA(DIALOG_W) + PX_WA(4.75) + (((PX_WA(DIALOG_W) - PX_WA(8))/4)*3);
        };

        class sliderRed: ctrlXSliderH {
            idc=IDC_SLIDER_R;
            x=CENTER_XA(DIALOG_W) + PX_WA(4);
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(9) + (PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT + PX_HA((SIZE_M*2));
            w=PX_WA(DIALOG_W) - PX_WA(8);
            h=PX_HA(SIZE_M);
            color[]={1,0,0,1};
	        colorActive[]={1,0,0,1};
        };
        class sliderGreen: sliderRed {
            idc=IDC_SLIDER_G;
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(11) + (PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT + PX_HA((SIZE_M*3));
            color[]={0,1,0,1};
	        colorActive[]={0,1,0,1};
        };
        class sliderBlue: sliderRed {
            idc=IDC_SLIDER_B;
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(13) + (PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT + PX_HA((SIZE_M*4));
            color[]={0.26,0.6,1,1};
	        colorActive[]={0.26,0.6,1,1};
        };
        class sliderAlpha: sliderRed {
            idc=IDC_SLIDER_A;
            y=CENTER_YA(DIALOG_H) + PX_HA(SIZE_M) + PX_HA(15) + (PX_HA(VAL_CELL_SIZE))*VAL_CELL_COUNT + PX_HA((SIZE_M*5));
            color[]={1,1,1,1};
	        colorActive[]={1,1,1,1};
        };
    };
}; 
/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

// ~ Operations
#define QUOTE(a) #a

#ifdef THIS_FUNC
    #define DISPLAY(name) uiNameSpace getVariable [QUOTE(name),displayNull]
    #define USE_DISPLAY(display) private _display = display
    #define USE_CTRL(ctrl,idc) private ctrl = _display displayCtrl idc
#endif

#ifdef DISPLAY_NAME
    #define THIS_DISPLAY DISPLAY(DISPLAY_NAME)
#endif

#ifdef pixelScale
    // ~ UI Positioning
    #define PX_WA(n) n*GRID_W
    #define PX_HA(n) n*GRID_H
    #define CENTER_XA(n) (CENTER_X)-(0.5*(PX_WA(n)))
    #define CENTER_YA(n) (CENTER_Y)-(0.5*(PX_HA(n)))
#endif

// ~ Values used in both the display and script
#define VAL_CELL_SIZE 2
#define VAL_CELL_COUNT 25

// ~ Display IDCs
#define IDC_TITLE_TEXT 1
#define IDC_BUTTON_CLOSE 2
#define IDC_GROUP_GRID 3
#define IDC_EDIT_OUTPUT_RGBA1 4
#define IDC_EDIT_OUTPUT_RGBA256 5
#define IDC_EDIT_OUTPUT_RRGGBB 6
#define IDC_EDIT_OUTPUT_AARRGGBB 7
#define IDC_COMBO_MODE 8
#define IDC_EDIT_INPUT_R 9
#define IDC_EDIT_INPUT_G 10
#define IDC_EDIT_INPUT_B 11
#define IDC_EDIT_INPUT_A 12
#define IDC_SLIDER_R 13
#define IDC_SLIDER_G 14
#define IDC_SLIDER_B 15
#define IDC_SLIDER_A 16
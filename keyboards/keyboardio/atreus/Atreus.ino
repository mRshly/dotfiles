/* -*- mode: c++ -*-
 * Atreus -- Chrysalis-enabled Sketch for the Keyboardio Atreus
 * Copyright (C) 2018-2022  Keyboard.io, Inc
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef BUILD_INFORMATION
#define BUILD_INFORMATION "locally built on " __DATE__ " at " __TIME__
#endif

#include "Kaleidoscope.h"
#include "Kaleidoscope-EEPROM-Settings.h"
#include "Kaleidoscope-EEPROM-Keymap.h"
#include "Kaleidoscope-Escape-OneShot.h"
#include "Kaleidoscope-FirmwareVersion.h"
#include "Kaleidoscope-FocusSerial.h"
#include "Kaleidoscope-Macros.h"
#include "Kaleidoscope-MouseKeys.h"
#include "Kaleidoscope-OneShot.h"
#include "Kaleidoscope-Qukeys.h"
#include "Kaleidoscope-SpaceCadet.h"
#include "Kaleidoscope-DynamicMacros.h"
#include "Kaleidoscope-LayerNames.h"
#include <Kaleidoscope.h>
#include <Kaleidoscope-Macros.h>
#include <Kaleidoscope-MagicCombo.h>
#include <Kaleidoscope-Chord.h>
#include <Kaleidoscope-TapDance.h>

#define MO(n) ShiftToLayer(n)
#define TG(n) LockLayer(n)

#define Key_Exclamation LSHIFT(Key_1)
#define Key_At          LSHIFT(Key_2)
#define Key_Hash        LSHIFT(Key_3)
#define Key_Dollar      LSHIFT(Key_4)
#define Key_Percent     LSHIFT(Key_5)
#define Key_Caret       LSHIFT(Key_6)
#define Key_And         LSHIFT(Key_7)
#define Key_Star        LSHIFT(Key_8)
#define Key_Plus        LSHIFT(Key_Equals)
// My aliases
#define Key_LBrace      Key_LeftCurlyBracket
#define Key_RBrace      Key_RightCurlyBracket
#define Key_Tilde       LSHIFT(Key_Backslash)
#define Key_Underscore  LSHIFT(Key_Minus)

// Macros
enum {
  MACRO_BASE,
  MACRO_VERSION_INFO,
  MACRO_PREVIOUS_TAB,
  MACRO_NEXT_TAB,
  MACRO_WIN_PREVIOUS_WINDOW,
  MACRO_WIN_NEXT_WINDOW,
  MACRO_SELECT_TO_HOME,
  MACRO_SELECT_TO_END,
  MACRO_DELETE_WORD,
  MACRO_DUO_PAREN,
  MACRO_DUO_BRACE,
  MACRO_DUO_BRACKET
};

// Layers
enum {
  BASE,
  SYMBOL,
  FUN,
  LANG,
  NUMPAD
};

// MagicCombo
enum {
  ESC_WITH_LANG2
};

# define Key_Symbol     MO(SYMBOL)
# define Key_Fun        MO(FUN)
# define Key_Lang       MO(LANG)
# define Key_Numpad     MO(NUMPAD)

// Tap Dance
enum {
  CHANGE_JP_EN
};

// clang-format off
KEYMAPS(
  [BASE] = KEYMAP_STACKED
  (
       Key_Q      ,Key_W    ,Key_E        ,Key_R                ,Key_T
      ,SFT_T(A)   ,CTL_T(S) ,ALT_T(D)     ,GUI_T(F)             ,Key_G
      ,Key_Z      ,Key_X    ,Key_C        ,Key_V                ,Key_B          ,LT(LANG, Backtick)
      ,Key_Numpad ,Key_LAlt ,Key_LAlt     ,LT(FUN, Backspace)   ,Key_Enter      ,Key_Esc

                                ,Key_Y     ,Key_U             ,Key_I              ,Key_O      ,Key_P
                                ,Key_H     ,GUI_T(J)          ,ALT_T(K)           ,CTL_T(L)   ,SFT_T(Semicolon)
       ,Key_Minus               ,Key_N     ,Key_M             ,Key_Comma          ,Key_Period ,Key_Slash
       ,LT(SYMBOL, Tab)         ,Key_Space ,MO(FUN)           ,MO(FUN)            ,Key_Quote  ,Key_Numpad
  ),

  [SYMBOL] = KEYMAP_STACKED
  (
       Key_Exclamation ,Key_At           ,Key_Hash      ,Key_Dollar           ,Key_Percent
      ,Key_Caret       ,Key_And          ,Key_Star      ,Key_LeftParen        ,Key_RightParen
      ,Key_LBracket    ,Key_RBracket     ,Key_LBrace    ,Key_RBrace           ,Key_Plus           ,Key_Tilde
      ,XXX             ,XXX              ,XXX           ,XXX                  ,XXX                ,XXX

                   ,Key_Pipe        ,Key_Backslash     ,Key_Backtick          ,Key_Tilde ,XXX
                   ,Key_Underscore  ,Key_Minus         ,XXX     ,XXX    ,XXX
      ,Key_Delete  ,Key_Plus        ,Key_Equals        ,XXX     ,XXX    ,XXX
      ,XXX ,XXX ,XXX ,XXX ,XXX ,XXX
   ),

  [FUN] = KEYMAP_STACKED
  (
       Key_Insert            ,Key_Home                 ,Key_UpArrow   ,Key_End        ,Key_PageUp
      ,Key_Delete            ,Key_LeftArrow            ,Key_DownArrow ,Key_RightArrow ,Key_PageDown
      ,M(MACRO_PREVIOUS_TAB) ,M(MACRO_NEXT_TAB)        ,M(MACRO_SELECT_TO_HOME)       ,M(MACRO_SELECT_TO_END) ,___ ,___
      ,M(MACRO_WIN_PREVIOUS_WINDOW) ,M(MACRO_WIN_NEXT_WINDOW) ,___  ,___  ,___  ,___

                ,XXX          ,Key_F7              ,Key_F8          ,Key_F9         ,Key_F10
                ,XXX          ,Key_F4              ,Key_F5          ,Key_F6         ,Key_F11
      ,___      ,XXX          ,Key_F1              ,Key_F2          ,Key_F3         ,Key_F12
      ,XXX      ,XXX          ,___ ,___ ,Key_ScrollLock ,XXX
   ),

  [LANG] = KEYMAP_STACKED
  (
       XXX  ,XXX  ,XXX  ,XXX  ,XXX
      ,XXX  ,XXX  ,XXX  ,XXX  ,XXX
      ,XXX  ,XXX  ,XXX  ,XXX  ,XXX  ,XXX
      ,XXX  ,XXX  ,XXX  ,XXX  ,XXX  ,XXX

                ,XXX    ,XXX      ,XXX        ,XXX      ,XXX
                ,XXX    ,Key_Lang1  ,Key_Lang2    ,Key_F19  ,Key_F20
      ,XXX      ,XXX    ,XXX      ,XXX        ,XXX      ,XXX
      ,XXX      ,XXX    ,XXX      ,XXX        ,XXX      ,XXX
   ),
  [NUMPAD] = KEYMAP_STACKED
  (
       XXX  ,XXX  ,XXX        ,XXX        ,XXX
      ,XXX  ,XXX  ,XXX        ,XXX        ,XXX
      ,XXX  ,XXX  ,XXX        ,XXX        ,XXX          ,XXX
      ,XXX  ,XXX  ,Key_LAlt   ,Key_LCtrl  ,Key_LShift   ,Key_LGui

                    ,Key_Star     ,Key_7      ,Key_8    ,Key_9  ,Key_Plus
                    ,XXX          ,Key_4      ,Key_5    ,Key_6  ,Key_Minus
      ,XXX          ,XXX          ,Key_1      ,Key_2    ,Key_3  ,Key_Slash
      ,Key_Delete   ,Key_Enter    ,Key_0            ,XXX            ,Key_Period   ,XXX
   )
)
// clang-format on

void escapeWithLang2(uint8_t combo_index) {
    Macros.play(MACRO(T(Lang2), T(Escape)));
}

USE_MAGIC_COMBOS(
[ESC_WITH_LANG2] = {
  .action = escapeWithLang2,
  .keys = {R3C5}
});

void tapDanceAction(uint8_t tap_dance_index, KeyAddr key_addr, uint8_t tap_count,
                    kaleidoscope::plugin::TapDance::ActionType tap_dance_action) {
  switch (tap_dance_index) {
  case CHANGE_JP_EN:
    return tapDanceActionKeys(tap_count, tap_dance_action,
                              Key_Lang2, Key_Lang1);
    }
}

KALEIDOSCOPE_INIT_PLUGINS(
  // ----------------------------------------------------------------------
  // Chrysalis plugins

  // The EEPROMSettings & EEPROMKeymap plugins make it possible to have an
  // editable keymap in EEPROM.
  EEPROMSettings,
  EEPROMKeymap,

  // Focus allows bi-directional communication with the host, and is the
  // interface through which the keymap in EEPROM can be edited.
  Focus,

  // FocusSettingsCommand adds a few Focus commands, intended to aid in
  // changing some settings of the keyboard, such as the default layer (via the
  // `settings.defaultLayer` command)
  FocusSettingsCommand,

  // FocusEEPROMCommand adds a set of Focus commands, which are very helpful in
  // both debugging, and in backing up one's EEPROM contents.
  FocusEEPROMCommand,

  // The LayerNames plugin allows Chrysalis to display - and edit - custom layer
  // names, to be shown instead of the default indexes.
  LayerNames,

  // ----------------------------------------------------------------------
  // Keystroke-handling plugins

  // The Qukeys plugin enables the "Secondary action" functionality in
  // Chrysalis. Keys with secondary actions will have their primary action
  // performed when tapped, but the secondary action when held.
  Qukeys,

  // The macros plugin adds support for macros
  Macros,

  // Enables dynamic, Chrysalis-editable macros.
  DynamicMacros,

  // The MouseKeys plugin lets you add keys to your keymap which move the mouse.
  MouseKeys,
  MouseKeysConfig,

  // The MagicCombo plugin lets you use key combinations to trigger custom
  // actions - a bit like Macros, but triggered by pressing multiple keys at the
  // same time.
  MagicCombo,

  // Enables the GeminiPR Stenography protocol. Unused by default, but with the
  // plugin enabled, it becomes configurable - and then usable - via Chrysalis.
  // GeminiPR,

  TapDance,
  Chord
);

const macro_t *macroAction(uint8_t macro_id, KeyEvent &event) {
  if (keyToggledOn(event.state)) {
    switch (macro_id) {
    case MACRO_BASE:
      // This macro is currently unused, but is kept around for compatibility
      // reasons. We used to use it in place of `MoveToLayer(QWERTY)`, but no
      // longer do. We keep it so that if someone still has the old layout with
      // the macro in EEPROM, it will keep working after a firmware update.
      Layer.move(BASE);
      break;
    case MACRO_VERSION_INFO:
      Macros.type(PSTR("Keyboardio Atreus - Kaleidoscope "));
      Macros.type(PSTR(BUILD_INFORMATION));
      break;
    case MACRO_PREVIOUS_TAB:
      return MACRO(D(LeftControl), D(LeftShift), T(Tab), U(LeftControl), U(LeftShift));
      break;
    case MACRO_NEXT_TAB:
      return MACRO(D(LeftControl), T(Tab), U(LeftControl));
      break;
    case MACRO_WIN_PREVIOUS_WINDOW:
      return MACRO(D(LeftControl), D(LeftGui), T(LeftArrow), U(LeftControl), U(LeftGui));
      break;
    case MACRO_WIN_NEXT_WINDOW:
      return MACRO(D(LeftControl), D(LeftGui), T(RightArrow), U(LeftControl), U(LeftGui));
      break;
    case MACRO_SELECT_TO_HOME:
      return MACRO(D(LeftShift), T(Home), U(LeftShift));
      break;
    case MACRO_SELECT_TO_END:
      return MACRO(D(LeftShift), T(End), U(LeftShift));
      break;
    case MACRO_DELETE_WORD:
      return MACRO(D(LeftAlt), T(Backspace), U(LeftAlt));
      break;
    case MACRO_DUO_PAREN:
      // this seq doesn't work
      // SEQ(K(LeftParen), K(RightParen), K(LeftArrow));
      return MACRO(T(LeftParen), T(RightParen), T(LeftArrow));
      break;
    case MACRO_DUO_BRACE:
      return MACRO(T(LBrace), T(RBrace), T(LeftArrow));
      break;
    case MACRO_DUO_BRACKET:
      return MACRO(T(LBracket), T(RBracket), T(LeftArrow));
      break;
    default:
      break;
    }
  }
  return MACRO_NONE;
}

void setup() {

  Qukeys.setMinimumHoldTime(150);
  Qukeys.setOverlapThreshold(80);

  CHORDS (
    CHORD(Key_V, Key_B), Key_Lang2,
    CHORD(Key_N, Key_M), Key_Lang1,
    CHORD(Key_W, Key_T), M(MACRO_DELETE_WORD),
    CHORD(Key_Z, Key_X), M(MACRO_DUO_PAREN),
    CHORD(Key_X, Key_C), M(MACRO_DUO_BRACKET),
    CHORD(Key_C, Key_V), M(MACRO_DUO_BRACE),
  )

  Kaleidoscope.setup();
  EEPROMKeymap.setup(9);

  DynamicMacros.reserve_storage(48);

  LayerNames.reserve_storage(63);

  Layer.move(EEPROMSettings.default_layer());

  // To avoid any surprises, SpaceCadet is turned off by default. However, it
  // can be permanently enabled via Chrysalis, so we should only disable it if
  // no configuration exists.
  SpaceCadetConfig.disableSpaceCadetIfUnconfigured();
}

void loop() {
  Kaleidoscope.loop();
}

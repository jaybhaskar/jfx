// Copyright (c) 2020 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

package org.cef.javafx;

import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import org.cef.misc.EventFlags;

import java.util.Map;

public class CefKeyEvent {
    // event type
    public final static int KEY_PRESSED = 0;
    public final static int KEY_RELEASED = 1;
    public final static int KEY_TYPED = 2;

    // Windows virtual key code constants used by WebKit Java port
    public static final int VK_BACK = 0x08;
    public static final int VK_TAB = 0x09;
    public static final int VK_RETURN = 0x0D;
    public static final int VK_ESCAPE = 0x1B;
    public static final int VK_PRIOR = 0x21;
    public static final int VK_NEXT = 0x22;
    public static final int VK_END = 0x23;
    public static final int VK_HOME = 0x24;
    public static final int VK_LEFT = 0x25;
    public static final int VK_UP = 0x26;
    public static final int VK_RIGHT = 0x27;
    public static final int VK_DOWN = 0x28;
    public static final int VK_INSERT = 0x2D;
    public static final int VK_DELETE = 0x2E;
    public static final int VK_OEM_PERIOD = 0xBE;

    private final int eventType;
    private final char keyChar;
    private final int modifiers;
    private final int keyCode;

    private static final Map<String, Integer> eventTypes = Map.of(
            "KEY_PRESSED", KEY_PRESSED,
            "KEY_RELEASED", KEY_RELEASED,
            "KEY_TYPED", KEY_TYPED
    );

    public CefKeyEvent(KeyEvent e) {
        this.eventType = eventTypes.get(e.getEventType().getName());
        this.modifiers = getCefModifiers(e);
        if (e.getEventType() == KeyEvent.KEY_TYPED) {
            keyChar = e.getCharacter().charAt(0);
            keyCode = e.getCode().getCode();
        } else {
            Entry keyCodeEntry = lookup(e.getCode());
            keyChar = keyCodeEntry.getKeyIdentifier().charAt(0);
            keyCode = keyCodeEntry.getWindowsVirtualKeyCode();
        }
    }

    private int getCefModifiers(KeyEvent e) {
        int modifiers = 0;
        if (e.isShiftDown())
            modifiers |= EventFlags.EVENTFLAG_SHIFT_DOWN;
        if (e.isControlDown())
            modifiers |= EventFlags.EVENTFLAG_CONTROL_DOWN;
        if (e.isAltDown())
            modifiers |= EventFlags.EVENTFLAG_ALT_DOWN;
        if (e.isMetaDown())
            modifiers |= EventFlags.EVENTFLAG_COMMAND_DOWN;
        return modifiers;
    }

    public int getEventType() {
        return eventType;
    }

    public char getKeyChar() {
        return keyChar;
    }

    public int getModifiers() {
        return modifiers;
    }

    public int getKeyCode() {
        return keyCode;
    }

    public static final class Entry {
        private final int windowsVirtualKeyCode;
        private final String keyIdentifier;

        private Entry(int windowsVirtualKeyCode, String keyIdentifier) {
            this.windowsVirtualKeyCode = windowsVirtualKeyCode;
            this.keyIdentifier = keyIdentifier;
        }

        public int getWindowsVirtualKeyCode() {
            return windowsVirtualKeyCode;
        }

        public String getKeyIdentifier() {
            return keyIdentifier;
        }
    }

    private static final Map<KeyCode, Entry> MAP = Map.ofEntries(
            entry(KeyCode.ENTER, CefKeyEvent.VK_RETURN, "Enter"),
            entry(KeyCode.BACK_SPACE, CefKeyEvent.VK_BACK),
            entry(KeyCode.TAB, CefKeyEvent.VK_TAB),
            entry(KeyCode.CANCEL, 0x03),
            entry(KeyCode.CLEAR, 0x0C, "Clear"),
            entry(KeyCode.SHIFT, 0x10, "Shift"),
            entry(KeyCode.CONTROL, 0x11, "Control"),
            entry(KeyCode.ALT, 0x12, "Alt"),
            entry(KeyCode.PAUSE, 0x13, "Pause"),
            entry(KeyCode.CAPS, 0x14, "CapsLock"),
            entry(KeyCode.ESCAPE, CefKeyEvent.VK_ESCAPE),
            entry(KeyCode.SPACE, 0x20),
            entry(KeyCode.PAGE_UP, CefKeyEvent.VK_PRIOR, "PageUp"),
            entry(KeyCode.PAGE_DOWN, CefKeyEvent.VK_NEXT, "PageDown"),
            entry(KeyCode.END, CefKeyEvent.VK_END, "End"),
            entry(KeyCode.HOME, CefKeyEvent.VK_HOME, "Home"),
            entry(KeyCode.LEFT, CefKeyEvent.VK_LEFT, "Left"),
            entry(KeyCode.UP, CefKeyEvent.VK_UP, "Up"),
            entry(KeyCode.RIGHT, CefKeyEvent.VK_RIGHT, "Right"),
            entry(KeyCode.DOWN, CefKeyEvent.VK_DOWN, "Down"),
            entry(KeyCode.COMMA, 0xBC),
            entry(KeyCode.MINUS, 0xBD),
            entry(KeyCode.PERIOD, CefKeyEvent.VK_OEM_PERIOD),
            entry(KeyCode.SLASH, 0xBF),
            entry(KeyCode.DIGIT0, 0x30),
            entry(KeyCode.DIGIT1, 0x31),
            entry(KeyCode.DIGIT2, 0x32),
            entry(KeyCode.DIGIT3, 0x33),
            entry(KeyCode.DIGIT4, 0x34),
            entry(KeyCode.DIGIT5, 0x35),
            entry(KeyCode.DIGIT6, 0x36),
            entry(KeyCode.DIGIT7, 0x37),
            entry(KeyCode.DIGIT8, 0x38),
            entry(KeyCode.DIGIT9, 0x39),
            entry(KeyCode.SEMICOLON, 0xBA),
            entry(KeyCode.EQUALS, 0xBB),
            entry(KeyCode.A, 0x41),
            entry(KeyCode.B, 0x42),
            entry(KeyCode.C, 0x43),
            entry(KeyCode.D, 0x44),
            entry(KeyCode.E, 0x45),
            entry(KeyCode.F, 0x46),
            entry(KeyCode.G, 0x47),
            entry(KeyCode.H, 0x48),
            entry(KeyCode.I, 0x49),
            entry(KeyCode.J, 0x4A),
            entry(KeyCode.K, 0x4B),
            entry(KeyCode.L, 0x4C),
            entry(KeyCode.M, 0x4D),
            entry(KeyCode.N, 0x4E),
            entry(KeyCode.O, 0x4F),
            entry(KeyCode.P, 0x50),
            entry(KeyCode.Q, 0x51),
            entry(KeyCode.R, 0x52),
            entry(KeyCode.S, 0x53),
            entry(KeyCode.T, 0x54),
            entry(KeyCode.U, 0x55),
            entry(KeyCode.V, 0x56),
            entry(KeyCode.W, 0x57),
            entry(KeyCode.X, 0x58),
            entry(KeyCode.Y, 0x59),
            entry(KeyCode.Z, 0x5A),
            entry(KeyCode.OPEN_BRACKET, 0xDB),
            entry(KeyCode.BACK_SLASH, 0xDC),
            entry(KeyCode.CLOSE_BRACKET, 0xDD),
            entry(KeyCode.NUMPAD0, 0x60),
            entry(KeyCode.NUMPAD1, 0x61),
            entry(KeyCode.NUMPAD2, 0x62),
            entry(KeyCode.NUMPAD3, 0x63),
            entry(KeyCode.NUMPAD4, 0x64),
            entry(KeyCode.NUMPAD5, 0x65),
            entry(KeyCode.NUMPAD6, 0x66),
            entry(KeyCode.NUMPAD7, 0x67),
            entry(KeyCode.NUMPAD8, 0x68),
            entry(KeyCode.NUMPAD9, 0x69),
            entry(KeyCode.MULTIPLY, 0x6A),
            entry(KeyCode.ADD, 0x6B),
            entry(KeyCode.SEPARATOR, 0x6C),
            entry(KeyCode.SUBTRACT, 0x6D),
            entry(KeyCode.DECIMAL, 0x6E),
            entry(KeyCode.DIVIDE, 0x6F),
            entry(KeyCode.DELETE, CefKeyEvent.VK_DELETE, "U+007F"),
            entry(KeyCode.NUM_LOCK, 0x90),
            entry(KeyCode.SCROLL_LOCK, 0x91, "Scroll"),
            entry(KeyCode.F1, 0x70, "F1"),
            entry(KeyCode.F2, 0x71, "F2"),
            entry(KeyCode.F3, 0x72, "F3"),
            entry(KeyCode.F4, 0x73, "F4"),
            entry(KeyCode.F5, 0x74, "F5"),
            entry(KeyCode.F6, 0x75, "F6"),
            entry(KeyCode.F7, 0x76, "F7"),
            entry(KeyCode.F8, 0x77, "F8"),
            entry(KeyCode.F9, 0x78, "F9"),
            entry(KeyCode.F10, 0x79, "F10"),
            entry(KeyCode.F11, 0x7A, "F11"),
            entry(KeyCode.F12, 0x7B, "F12"),
            entry(KeyCode.F13, 0x7C, "F13"),
            entry(KeyCode.F14, 0x7D, "F14"),
            entry(KeyCode.F15, 0x7E, "F15"),
            entry(KeyCode.F16, 0x7F, "F16"),
            entry(KeyCode.F17, 0x80, "F17"),
            entry(KeyCode.F18, 0x81, "F18"),
            entry(KeyCode.F19, 0x82, "F19"),
            entry(KeyCode.F20, 0x83, "F20"),
            entry(KeyCode.F21, 0x84, "F21"),
            entry(KeyCode.F22, 0x85, "F22"),
            entry(KeyCode.F23, 0x86, "F23"),
            entry(KeyCode.F24, 0x87, "F24"),
            entry(KeyCode.PRINTSCREEN, 0x2C, "PrintScreen"),
            entry(KeyCode.INSERT, CefKeyEvent.VK_INSERT, "Insert"),
            entry(KeyCode.HELP, 0x2F, "Help"),
            entry(KeyCode.META, 0x00, "Meta"),
            entry(KeyCode.BACK_QUOTE, 0xC0),
            entry(KeyCode.QUOTE, 0xDE),
            entry(KeyCode.KP_UP, CefKeyEvent.VK_UP, "Up"),
            entry(KeyCode.KP_DOWN, CefKeyEvent.VK_DOWN, "Down"),
            entry(KeyCode.KP_LEFT, CefKeyEvent.VK_LEFT, "Left"),
            entry(KeyCode.KP_RIGHT, CefKeyEvent.VK_RIGHT, "Right"),
            entry(KeyCode.AMPERSAND, 0x37),
            entry(KeyCode.ASTERISK, 0x38),
            entry(KeyCode.QUOTEDBL, 0xDE),
            entry(KeyCode.LESS, 0xBC),
            entry(KeyCode.GREATER, CefKeyEvent.VK_OEM_PERIOD),
            entry(KeyCode.BRACELEFT, 0xDB),
            entry(KeyCode.BRACERIGHT, 0xDD),
            entry(KeyCode.AT, 0x32),
            entry(KeyCode.COLON, 0xBA),
            entry(KeyCode.CIRCUMFLEX, 0x36),
            entry(KeyCode.DOLLAR, 0x34),
            entry(KeyCode.EXCLAMATION_MARK, 0x31),
            entry(KeyCode.LEFT_PARENTHESIS, 0x39),
            entry(KeyCode.NUMBER_SIGN, 0x33),
            entry(KeyCode.PLUS, 0xBB),
            entry(KeyCode.RIGHT_PARENTHESIS, 0x30),
            entry(KeyCode.UNDERSCORE, 0xBD),
            entry(KeyCode.WINDOWS, 0x5B, "Win"),
            entry(KeyCode.CONTEXT_MENU, 0x5D),
            entry(KeyCode.FINAL, 0x18),
            entry(KeyCode.CONVERT, 0x1C),
            entry(KeyCode.NONCONVERT, 0x1D),
            entry(KeyCode.ACCEPT, 0x1E),
            entry(KeyCode.MODECHANGE, 0x1F),
            entry(KeyCode.KANA, 0x15),
            entry(KeyCode.KANJI, 0x19),
            entry(KeyCode.ALT_GRAPH, 0xA5),
            entry(KeyCode.PLAY, 0xFA),
            entry(KeyCode.TRACK_PREV, 0xB1),
            entry(KeyCode.TRACK_NEXT, 0xB0),
            entry(KeyCode.VOLUME_UP, 0xAF),
            entry(KeyCode.VOLUME_DOWN, 0xAE),
            entry(KeyCode.MUTE, 0xAD));

    private static Map.Entry<KeyCode, Entry> entry(KeyCode keyCode, int windowsVirtualKeyCode, String keyIdentifier) {
        return Map.entry(keyCode, new Entry(windowsVirtualKeyCode, keyIdentifier));
    }

    private static Map.Entry<KeyCode, Entry> entry(KeyCode keyCode, int windowsVirtualKeyCode) {
        return entry(keyCode, windowsVirtualKeyCode, null);
    }

    public static Entry lookup(KeyCode keyCode) {
        Entry entry = MAP.get(keyCode);
        if (entry == null || entry.getKeyIdentifier() == null) {
            int windowsVirtualKeyCode = entry != null
                    ? entry.getWindowsVirtualKeyCode() : 0;
            String keyIdentifier =
                    String.format("U+%04X", windowsVirtualKeyCode);
            entry = new Entry(windowsVirtualKeyCode, keyIdentifier);
        }
        return entry;
    }
}

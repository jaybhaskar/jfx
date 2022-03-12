// Copyright (c) 2020 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

package org.cef.javafx;

import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import org.cef.misc.EventFlags;

import java.util.Map;

public class CefMouseEvent {
    // event type
    public final static int MOUSE_DRAGGED = 0;
    public final static int MOUSE_ENTERED = 1;
    public final static int MOUSE_EXITED = 2;
    public final static int MOUSE_MOVED = 3;
    public final static int MOUSE_PRESSED = 4;
    public final static int MOUSE_RELEASED = 5;

    // button type
    public final static int NOBUTTON = 0;
    public final static int BUTTON1 = 1;
    public final static int BUTTON2 = 2;
    public final static int BUTTON3 = 3;

    private final int eventType;
    private final int x;
    private final int y;
    private final int modifiers;
    private final int clickCount;
    private final int button;

    private static final Map<String, Integer> eventTypes = Map.of(
            "MOUSE_DRAGGED", MOUSE_DRAGGED,
            "MOUSE_ENTERED", MOUSE_ENTERED,
            "MOUSE_EXITED", MOUSE_EXITED,
            "MOUSE_MOVED", MOUSE_MOVED,
            "MOUSE_PRESSED", MOUSE_PRESSED,
            "MOUSE_RELEASED", MOUSE_RELEASED
    );

    private static final Map<MouseButton, Integer> buttonTypes = Map.of(
            MouseButton.NONE, NOBUTTON,
            MouseButton.PRIMARY, BUTTON1,
            MouseButton.MIDDLE, BUTTON2,
            MouseButton.SECONDARY, BUTTON3
    );

    public CefMouseEvent(MouseEvent e) {
        this.eventType = eventTypes.get(e.getEventType().getName());
        this.x = (int) Math.round(e.getX());
        this.y = (int) Math.round(e.getY());
        this.modifiers = getCefModifiers(e);
        this.clickCount = e.getClickCount();
        this.button = buttonTypes.get(e.getButton());
    }

    private int getCefModifiers(MouseEvent e) {
        int modifiers = 0;
        if (e.isShiftDown())
            modifiers |= EventFlags.EVENTFLAG_SHIFT_DOWN;
        if (e.isControlDown())
            modifiers |= EventFlags.EVENTFLAG_CONTROL_DOWN;
        if (e.isAltDown())
            modifiers |= EventFlags.EVENTFLAG_ALT_DOWN;
        if (e.isPrimaryButtonDown())
            modifiers |= EventFlags.EVENTFLAG_LEFT_MOUSE_BUTTON;
        if (e.isMiddleButtonDown())
            modifiers |= EventFlags.EVENTFLAG_MIDDLE_MOUSE_BUTTON;
        if (e.isSecondaryButtonDown())
            modifiers |= EventFlags.EVENTFLAG_RIGHT_MOUSE_BUTTON;
        if (e.isMetaDown())
            modifiers |= EventFlags.EVENTFLAG_COMMAND_DOWN;
        return modifiers;
    }

    public int getEventType() {
        return eventType;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public int getModifiers() {
        return modifiers;
    }

    public int getClickCount() {
        return clickCount;
    }

    public int getButton() {
        return button;
    }
}

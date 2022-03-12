// Copyright (c) 2020 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

package org.cef.javafx;

import javafx.scene.input.ScrollEvent;
import org.cef.misc.EventFlags;

public class CefMouseWheelEvent {
    private final int x;
    private final int y;
    private final int modifiers;
    private final int deltaX;
    private final int deltaY;

    public CefMouseWheelEvent(ScrollEvent e) {
        this.x = (int) Math.round(e.getX());
        this.y = (int) Math.round(e.getY());
        this.modifiers = getCefModifiers(e);
        this.deltaX = (int) Math.round(e.getDeltaX());
        this.deltaY = (int) Math.round(e.getDeltaY());
    }

    private int getCefModifiers(ScrollEvent e) {
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

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public int getModifiers() {
        return modifiers;
    }

    public int getDeltaX() {
        return deltaX;
    }

    public int getDeltaY() {
        return deltaY;
    }
}

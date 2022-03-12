// Copyright (c) 2013 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

package org.cef;

import javafx.scene.Node;
import org.cef.browser.CefBrowser;
import org.cef.handler.CefAppHandlerAdapter;

/**
 * Exposes static methods for managing the global JFX-CEF context.
 */
public class CefAppFX {
    private static CefAppFX self;
    private static CefClient client;
    private final CefBrowser browser;
    private final Node node;

    static void initialize(boolean useOSR) {
        if (!CefApp.startup(null)) {
            System.out.println("Startup initialization failed!");
            return;
        }

        CefApp.addAppHandler(new CefAppHandlerAdapter(null) {
            @Override
            public void stateHasChanged(CefApp.CefAppState state) {
                if (state == CefApp.CefAppState.TERMINATED)
                    System.exit(0);
            }
        });

        CefSettings settings = new CefSettings();
        settings.windowless_rendering_enabled = useOSR;
        CefApp cefApp = CefApp.getInstance(settings);
        client = cefApp.createClient();
    }

    public static CefAppFX createInstance(String startUrl, boolean useOSR, boolean isTransparent) {
        if (self == null)
            initialize(useOSR);
        self = new CefAppFX(startUrl, useOSR, isTransparent);
        return self;
    }

    public static CefAppFX getInstance() {
        if (self == null)
            throw new RuntimeException();
        return self;
    }

    private CefAppFX(String startUrl, boolean useOSR, boolean isTransparent) {
        browser = client.createBrowser(startUrl, useOSR, isTransparent);
        browser.setCloseAllowed();
        node = browser.getFXUIComponent();
    }

    public CefBrowser getBrowser() {
        return browser;
    }

    public CefClient getClient() {
        return client;
    }

    public Node getNode() {
        return node;
    }

    public void dispose() {
        System.exit(0);
        CefApp.getInstance().dispose();
    }
}

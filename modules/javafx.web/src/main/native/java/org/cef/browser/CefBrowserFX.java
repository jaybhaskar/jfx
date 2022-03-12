// Copyright (c) 2020 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

package org.cef.browser;

import javafx.application.Platform;
import javafx.geometry.Rectangle2D;
import javafx.scene.Node;
import javafx.scene.image.ImageView;
import javafx.scene.image.PixelBuffer;
import javafx.scene.image.PixelFormat;
import javafx.scene.image.WritableImage;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.ScrollEvent;
import javafx.scene.layout.BorderPane;
import org.cef.CefClient;
import org.cef.callback.CefDragData;
import org.cef.handler.CefRenderHandler;
import org.cef.handler.CefScreenInfo;

import java.awt.Component;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.nio.ByteBuffer;
import java.util.concurrent.CompletableFuture;

/**
 * This class represents an off-screen rendered FX browser.
 * The visibility of this class is "package". To create a new
 * CefBrowser instance, please use CefBrowserFactory.
 */
public class CefBrowserFX extends CefBrowser_N implements CefRenderHandler {
    private BorderPane node;
    private PixelBuffer<ByteBuffer> pixelBuffer;
    private ImageView iv;
    private boolean justCreated;
    private Rectangle browser_rect = new Rectangle(0, 0, 1, 1);
    private Point screenPoint = new Point(0, 0);
    private double scaleFactor = 1.0;
    private int depth = 32;
    private int depth_per_component = 8;
    private boolean isTransparent;

    CefBrowserFX(CefClient client, String url, boolean transparent, CefRequestContext context) {
        this(client, url, transparent, context, null, null);
    }

    private CefBrowserFX(CefClient client, String url, boolean transparent,
                         CefRequestContext context, CefBrowserFX parent, Point inspectAt) {
        super(client, url, context, parent, inspectAt);
        isTransparent = transparent;
        iv = new ImageView();
        createSharedImage(1, 1);
    }

    @Override
    public void createImmediately() {
        justCreated = true;
        createBrowserIfRequired(false);
    }

    @Override
    public Component getUIComponent() {
        throw new UnsupportedOperationException("Unsupported for FX rendering");
    }

    @Override
    public Node getFXUIComponent() {
        node = new BorderPane();
        node.boundsInParentProperty().addListener((observable, oldValue, newValue) -> {
            createSharedImage((int) newValue.getWidth(), (int) newValue.getHeight());
            browser_rect.setBounds(0, 0, (int) newValue.getWidth(), (int) newValue.getHeight());
            wasResized((int) newValue.getWidth(), (int) newValue.getHeight());
        });
        node.addEventHandler(MouseEvent.MOUSE_MOVED, e -> sendMouseEventFX(e));
        node.addEventHandler(MouseEvent.MOUSE_DRAGGED, e -> sendMouseEventFX(e));
        node.addEventHandler(MouseEvent.MOUSE_ENTERED, e -> sendMouseEventFX(e));
        node.addEventHandler(MouseEvent.MOUSE_EXITED, e -> sendMouseEventFX(e));
        node.addEventHandler(MouseEvent.MOUSE_PRESSED, e -> {
            sendMouseEventFX(e);
            node.requestFocus();
        });
        node.addEventHandler(MouseEvent.MOUSE_RELEASED, e -> sendMouseEventFX(e));
        node.addEventHandler(KeyEvent.ANY, e -> sendKeyEventFX(e));
        node.addEventHandler(ScrollEvent.SCROLL, e -> sendMouseWheelEventFX(e));
        node.focusedProperty().addListener((observable, oldValue, newValue) -> setFocus(node.isFocused()));
        node.setFocusTraversable(true);

        Platform.runLater(() -> createBrowserIfRequired(true));
        node.setCenter(iv);
        return node;
    }

    @Override
    public CefRenderHandler getRenderHandler() {
        return this;
    }

    @Override
    protected CefBrowser_N createDevToolsBrowser(CefClient client, String url,
                                                 CefRequestContext context,
                                                 CefBrowser_N parent, Point inspectAt) {
        return new CefBrowserFX(
                client, url, isTransparent, context, this, inspectAt);
    }

    private void createSharedImage(int width, int height) {
        ByteBuffer byteBuffer = ByteBuffer.allocate(width * height * 4);
        pixelBuffer = new PixelBuffer<>(width, height, byteBuffer,
                PixelFormat.getByteBgraPreInstance());
        WritableImage img = new WritableImage(pixelBuffer);
        iv.setImage(img);
    }

    @Override
    public Rectangle getViewRect(CefBrowser browser) {
        return browser_rect;
    }

    @Override
    public Point getScreenPoint(CefBrowser browser, Point viewPoint) {
        Point screenPoint_ = new Point(screenPoint);
        screenPoint_.translate(viewPoint.x, viewPoint.y);
        return screenPoint_;
    }

    @Override
    public void onPopupShow(CefBrowser browser, boolean show) {
        throw new UnsupportedOperationException("Popup not supported yet");
    }

    @Override
    public void onPopupSize(CefBrowser browser, Rectangle size) {
        throw new UnsupportedOperationException("Popup not supported yet");
    }

    @Override
    public void onPaint(CefBrowser browser, boolean popup, Rectangle[] dirtyRects,
                        ByteBuffer buffer, int width, int height) {
        pixelBuffer.getBuffer().asIntBuffer().put(buffer.asIntBuffer());
        Platform.runLater(() -> {
            for (Rectangle rect : dirtyRects)
                pixelBuffer.updateBuffer(b -> new Rectangle2D(rect.x, rect.y, rect.width, rect.height));
        });
    }

    @Override
    public void onCursorChange(CefBrowser browser, int cursor) {
//        throw new UnsupportedOperationException("Cursor change not supported yet");
    }

    @Override
    public boolean startDragging(CefBrowser browser, CefDragData dragData, int mask, int x, int y) {
        throw new UnsupportedOperationException("Dragging not supported yet");
    }

    @Override
    public void updateDragCursor(CefBrowser browser, int operation) {
        throw new UnsupportedOperationException("Dragging not supported yet");
    }

    private void createBrowserIfRequired(boolean hasParent) {
        long window_handle = 0;

        if (getNativeRef("CefBrowser") == 0) {
            if (getParentBrowser() != null) {
                createDevTools(getParentBrowser(), getClient(), window_handle, true, isTransparent,
                        null, getInspectAt());
            } else {
                createBrowser(getClient(), window_handle, getUrl(), true, isTransparent, null,
                        getRequestContext());
            }
        } else if (hasParent && justCreated) {
            notifyAfterParentChanged();
            setFocus(true);
            justCreated = false;
        }
    }

    private void notifyAfterParentChanged() {
        getClient().onAfterParentChanged(this);
    }

    @Override
    public boolean getScreenInfo(CefBrowser browser, CefScreenInfo screenInfo) {
        screenInfo.Set(scaleFactor, depth, depth_per_component, false,
                browser_rect.getBounds(), browser_rect.getBounds());
        return true;
    }

    @Override
    public CompletableFuture<BufferedImage> createScreenshot(boolean nativeResolution) {
        throw new UnsupportedOperationException("Screenshot not supported yet");
    }
}

// Copyright (c) 2020 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

package tests.jfx;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import org.cef.CefAppFX;
import org.cef.CefClient;
import org.cef.browser.CefBrowser;
import org.cef.browser.CefFrame;
import org.cef.handler.CefDisplayHandlerAdapter;
import org.cef.handler.CefLoadHandlerAdapter;

import java.util.List;

/**
 * This is a simple example application using JFX-CEF.
 */
public class MainFrame extends Application {
    private static final String DEFAULT_URL = "https://www.google.com";
    private static final boolean useOSR = true;
    private static final boolean isTransparent = false;
    private static final double NAVI_BAR_MIN_DIMENSION = 32.0;
    private static final double PADDING_VALUE = 2.0;
    private static final String buttonStyle = "-fx-font-weight: bold; -fx-font-size: 16px;";

    // Unicode characters for buttons
    private static final String goButtonUnicodeSymbol = "\u21B5";
    private static final String stopButtonUnicodeSymbol = "\u2715";
    private static final String backButtonUnicodeSymbol = "\u003C";
    private static final String forwardButtonUnicodeSymbol = "\u003E";
    private static final String reloadButtonUnicodeSymbol = "\u27F3";

    @Override
    public void start(Stage primaryStage) {
        List<String> args = getParameters().getRaw();
        final String initialUrl = args.size() > 0 ? args.get(0) : DEFAULT_URL;

        CefAppFX cefApp = CefAppFX.createInstance(initialUrl, useOSR, isTransparent);
        CefClient client = cefApp.getClient();
        CefBrowser browser = cefApp.getBrowser();
        Node browserUI = cefApp.getNode();

        final TextField urlBox = new TextField();
        urlBox.setMinHeight(NAVI_BAR_MIN_DIMENSION);
        urlBox.setText(initialUrl);
        HBox.setHgrow(urlBox, Priority.ALWAYS);
        urlBox.setOnAction(e -> browser.loadURL(urlBox.getText()));

        final Label bottomTitle = new Label();
        bottomTitle.textProperty().bind(urlBox.textProperty());

        final Button goStopButton = new Button(goButtonUnicodeSymbol);
        goStopButton.setStyle(buttonStyle);
        goStopButton.setOnAction(e -> browser.loadURL(urlBox.getText()));

        final Button backButton = new Button(backButtonUnicodeSymbol);
        backButton.setStyle(buttonStyle);
        backButton.setDisable(true);
        backButton.setOnAction(e -> browser.goBack());

        final Button forwardButton = new Button(forwardButtonUnicodeSymbol);
        forwardButton.setStyle(buttonStyle);
        forwardButton.setDisable(true);
        forwardButton.setOnAction(e -> browser.goForward());

        final Button reloadButton = new Button(reloadButtonUnicodeSymbol);
        reloadButton.setStyle(buttonStyle);
        reloadButton.setOnAction(e -> browser.reload());

        final HBox naviBar = new HBox();
        naviBar.getChildren().addAll(backButton, forwardButton, urlBox,
                reloadButton, goStopButton);
        naviBar.setPadding(new Insets(PADDING_VALUE)); // Small padding in the navigation Bar

        final VBox root = new VBox();
        root.getChildren().addAll(naviBar, browserUI, bottomTitle);
        VBox.setVgrow(browserUI, Priority.ALWAYS);

        client.addDisplayHandler(new CefDisplayHandlerAdapter() {
            @Override
            public void onAddressChange(CefBrowser browser, CefFrame frame, String url) {
                Platform.runLater(() -> urlBox.setText(url));
            }
        });

        client.addLoadHandler(new CefLoadHandlerAdapter() {
            @Override
            public void onLoadingStateChange(CefBrowser browser, boolean isLoading, boolean canGoBack, boolean canGoForward) {
                Platform.runLater(() -> {
                    if (isLoading) {
                        goStopButton.setText(stopButtonUnicodeSymbol);
                        goStopButton.setOnAction(e -> browser.stopLoad());
                    } else {
                        goStopButton.setText(goButtonUnicodeSymbol);
                        goStopButton.setOnAction(e -> browser.loadURL(urlBox.getText()));
                    }
                    bottomTitle.setVisible(isLoading);
                    backButton.setDisable(!canGoBack);
                    forwardButton.setDisable(!canGoForward);
                });
            }
        });

        Scene scene = new Scene(root, 800, 600);
        primaryStage.setTitle("JFX-CEF Example");
        primaryStage.setScene(scene);
        primaryStage.show();
    }

    @Override
    public void stop() throws Exception {
        CefAppFX.getInstance().dispose();
        super.stop();
    }

    public static void main(String[] args) {
        Application.launch(args);
    }
}

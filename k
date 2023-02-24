diff --git a/modules/javafx.web/src/main/native/Source/WebCore/PlatformJava.cmake b/modules/javafx.web/src/main/native/Source/WebCore/PlatformJava.cmake
index 096a3114c3..23efcd5441 100644
--- a/modules/javafx.web/src/main/native/Source/WebCore/PlatformJava.cmake
+++ b/modules/javafx.web/src/main/native/Source/WebCore/PlatformJava.cmake
@@ -57,27 +57,14 @@ endif ()
 #FIXME: Workaround
 list(APPEND WebCoreTestSupport_LIBRARIES ${SQLite3_LIBRARIES})
 
-if (ENABLE_MODERN_MEDIA_CONTROLS)
 list(APPEND WebCore_USER_AGENT_STYLE_SHEETS
-    ${WEBCORE_DIR}/css/themeAdwaita.css
-    ${WebCore_DERIVED_SOURCES_DIR}/ModernMediaControls.css
-)
-else()
-list(APPEND WebCore_USER_AGENT_STYLE_SHEETS
-    ${WEBCORE_DIR}/css/themeAdwaita.css
     ${WEBCORE_DIR}/Modules/mediacontrols/mediaControlsAdwaita.css
+    ${WEBCORE_DIR}/css/themeAdwaita.css
 )
-endif()
 
-if (ENABLE_MODERN_MEDIA_CONTROLS)
-set(WebCore_USER_AGENT_SCRIPTS
-    ${WebCore_DERIVED_SOURCES_DIR}/ModernMediaControls.js
-)
-else()
 set(WebCore_USER_AGENT_SCRIPTS
     ${WEBCORE_DIR}/Modules/mediacontrols/mediaControlsAdwaita.js
 )
-endif()
 
 add_definitions(-DMAX_DOM_TREE_DEPTH=2000)
 
diff --git a/modules/javafx.web/src/main/native/Source/WebCore/css/CSSValueKeywords.in b/modules/javafx.web/src/main/native/Source/WebCore/css/CSSValueKeywords.in
index 350e9b3a12..caa8df8b67 100644
--- a/modules/javafx.web/src/main/native/Source/WebCore/css/CSSValueKeywords.in
+++ b/modules/javafx.web/src/main/native/Source/WebCore/css/CSSValueKeywords.in
@@ -843,6 +843,32 @@ square-button
 button
 default-button
 listbox
+// if platform JAVA
+media-controls-background
+media-controls-dark-bar-background
+media-controls-fullscreen-background
+media-controls-light-bar-background
+media-current-time-display
+media-enter-fullscreen-button
+media-exit-fullscreen-button
+media-fullscreen-volume-slider
+media-fullscreen-volume-slider-thumb
+media-mute-button
+media-overlay-play-button
+media-play-button
+media-return-to-realtime-button
+media-rewind-button
+media-seek-back-button
+media-seek-forward-button
+media-slider
+media-sliderthumb
+media-time-remaining-display
+media-toggle-closed-captions-button
+media-volume-slider
+media-volume-slider-container
+media-volume-slider-mute-button
+media-volume-sliderthumb
+// endif platform JAVA
 menulist
 menulist-button
 meter
diff --git a/modules/javafx.web/src/main/native/Source/WebCore/css/mediaControls.css b/modules/javafx.web/src/main/native/Source/WebCore/css/mediaControls.css
index 8e71f7b290..32b364cd05 100644
--- a/modules/javafx.web/src/main/native/Source/WebCore/css/mediaControls.css
+++ b/modules/javafx.web/src/main/native/Source/WebCore/css/mediaControls.css
@@ -41,7 +41,7 @@ audio {
     flex-direction: column;
 }
 
-:is(audio, video)::-webkit-media-controls-panel {
+audio::-webkit-media-controls-panel, video::-webkit-media-controls-panel {
     display: flex;
     direction: ltr;
     flex-direction: row;
@@ -59,15 +59,18 @@ audio {
 video:-webkit-full-page-media {
     margin: auto;
     position: absolute;
-    inset: 0;
+    top: 0;
+    right: 0;
+    bottom: 0;
+    left: 0;
 }
 
 video:-webkit-full-page-media::-webkit-media-controls-panel {
     bottom: 0px;
 }
 
-:is(audio, video)::-webkit-media-controls-mute-button,
-:is(audio, video)::-webkit-media-controls-play-button {
+audio::-webkit-media-controls-mute-button, video::-webkit-media-controls-mute-button {
+    -webkit-appearance: media-mute-button;
     display: flex;
     width: 16px;
     height: 16px;
@@ -76,11 +79,22 @@ video:-webkit-full-page-media::-webkit-media-controls-panel {
     color: inherit;
 }
 
-:is(audio, video)::-webkit-media-controls-overlay-play-button {
+audio::-webkit-media-controls-overlay-play-button, video::-webkit-media-controls-overlay-play-button {
     display: none;
 }
 
-:is(audio, video)::-webkit-media-controls-timeline-container {
+audio::-webkit-media-controls-play-button, video::-webkit-media-controls-play-button {
+    -webkit-appearance: media-play-button;
+    display: flex;
+    width: 16px;
+    height: 16px;
+    background-color: initial;
+    border: initial;
+    color: inherit;
+}
+
+audio::-webkit-media-controls-timeline-container, video::-webkit-media-controls-timeline-container {
+    -webkit-appearance: media-controls-background;
     display: flex;
     flex-direction: row;
     align-items: center;
@@ -91,12 +105,16 @@ video:-webkit-full-page-media::-webkit-media-controls-panel {
     min-width: 0;
 }
 
-:is(audio, video)::-webkit-media-controls-current-time-display,
-:is(audio, video)::-webkit-media-controls-time-remaining-display {
+audio::-webkit-media-controls-current-time-display, video::-webkit-media-controls-current-time-display {
     display: none;
 }
 
-:is(audio, video)::-webkit-media-controls-timeline {
+audio::-webkit-media-controls-time-remaining-display, video::-webkit-media-controls-time-remaining-display {
+    display: none;
+}
+
+audio::-webkit-media-controls-timeline, video::-webkit-media-controls-timeline {
+    -webkit-appearance: media-slider;
     display: flex;
     flex: 1 1;
     height: 16px;
@@ -108,17 +126,35 @@ video:-webkit-full-page-media::-webkit-media-controls-panel {
     min-width: 0;
 }
 
-:is(audio, video)::-webkit-media-controls-volume-slider {
+audio::-webkit-media-controls-volume-slider, video::-webkit-media-controls-volume-slider {
     background-color: initial !important;
     border: initial !important;
     color: inherit !important;
     margin: initial !important;
 }
 
-:is(audio, video)::-webkit-media-controls-seek-back-button,
-:is(audio, video)::-webkit-media-controls-seek-forward-button,
-:is(audio, video)::-webkit-media-controls-fullscreen-button,
-:is(audio, video)::-webkit-media-controls-toggle-closed-captions-button {
+audio::-webkit-media-controls-seek-back-button, video::-webkit-media-controls-seek-back-button {
+    -webkit-appearance: media-seek-back-button;
+    display: flex;
+    width: 16px;
+    height: 16px;
+    background-color: initial;
+    border: initial;
+    color: inherit;
+}
+
+audio::-webkit-media-controls-seek-forward-button, video::-webkit-media-controls-seek-forward-button {
+    -webkit-appearance: media-seek-forward-button;
+    display: flex;
+    width: 16px;
+    height: 16px;
+    background-color: initial;
+    border: initial;
+    color: inherit;
+}
+
+audio::-webkit-media-controls-fullscreen-button, video::-webkit-media-controls-fullscreen-button {
+    -webkit-appearance: media-enter-fullscreen-button;
     display: flex;
     width: 16px;
     height: 16px;
@@ -127,29 +163,58 @@ video:-webkit-full-page-media::-webkit-media-controls-panel {
     color: inherit;
 }
 
-:is(audio, video)::-webkit-media-controls-rewind-button,
-:is(audio, video)::-webkit-media-controls-return-to-realtime-button {
+audio::-webkit-media-controls-rewind-button, video::-webkit-media-controls-rewind-button {
     display: none;
     background-color: initial;
     border: initial;
     color: inherit;
 }
 
-:is(audio, video)::-webkit-media-controls-closed-captions-container,
-:is(audio, video)::-webkit-media-controls-closed-captions-track-list,
-:is(audio, video)::-webkit-media-controls-fullscreen-volume-slider,
-:is(audio, video)::-webkit-media-controls-fullscreen-volume-min-button,
-:is(audio, video)::-webkit-media-controls-fullscreen-volume-max-button {
+audio::-webkit-media-controls-return-to-realtime-button, video::-webkit-media-controls-return-to-realtime-button {
     display: none;
+    background-color: initial;
+    border: initial;
+    color: inherit;
+}
+
+audio::-webkit-media-controls-toggle-closed-captions-button, video::-webkit-media-controls-toggle-closed-captions-button {
+    -webkit-appearance: media-toggle-closed-captions-button;
+    display: flex;
+    width: 16px;
+    height: 16px;
+    background-color: initial;
+    border: initial;
+    color: inherit;
 }
 
-:is(audio, video)::-webkit-media-controls-volume-slider-mute-button {
+audio::-webkit-media-controls-closed-captions-container, video::-webkit-media-controls-closed-captions-container {
+    display: none;
+}
+
+audio::-webkit-media-controls-closed-captions-track-list, video::-webkit-media-controls-closed-captions-track-list {
+    display: none;
+}
+
+audio::-webkit-media-controls-volume-slider-mute-button, video::-webkit-media-controls-volume-slider-mute-button {
+    -webkit-appearance: media-volume-slider-mute-button !important;
     display: none !important;
     background-color: initial !important;
     border: initial !important;
     color: inherit !important;
 }
 
+audio::-webkit-media-controls-fullscreen-volume-slider, video::-webkit-media-controls-fullscreen-volume-slider {
+    display: none;
+}
+
+audio::-webkit-media-controls-fullscreen-volume-min-button, video::-webkit-media-controls-fullscreen-volume-min-button {
+    display: none;
+}
+
+audio::-webkit-media-controls-fullscreen-volume-max-button, video::-webkit-media-controls-fullscreen-volume-max-button {
+    display: none;
+}
+
 video::-webkit-media-text-track-container {
     position: relative;
     width: 100%;
diff --git a/modules/javafx.web/src/main/native/Source/WebCore/platform/ThemeTypes.h b/modules/javafx.web/src/main/native/Source/WebCore/platform/ThemeTypes.h
index 5ee6467691..e804602cbc 100644
--- a/modules/javafx.web/src/main/native/Source/WebCore/platform/ThemeTypes.h
+++ b/modules/javafx.web/src/main/native/Source/WebCore/platform/ThemeTypes.h
@@ -48,6 +48,27 @@ enum ControlPart {
     ProgressBarPart,
     SliderHorizontalPart,
     SliderVerticalPart,
+    MediaSliderThumbPart,
+    MediaEnterFullscreenButtonPart,
+    MediaPlayButtonPart,
+    MediaVolumeSliderThumbPart,
+    MediaExitFullscreenButtonPart,
+    MediaOverlayPlayButtonPart,
+    MediaMuteButtonPart,
+    MediaSeekBackButtonPart,
+    MediaSeekForwardButtonPart,
+    MediaRewindButtonPart,
+    MediaReturnToRealtimeButtonPart,
+    MediaToggleClosedCaptionsButtonPart,
+    MediaSliderPart,
+    MediaVolumeSliderMuteButtonPart,
+    MediaVolumeSliderContainerPart,
+    MediaVolumeSliderPart,
+    MediaFullScreenVolumeSliderPart,
+    MediaFullScreenVolumeSliderThumbPart,
+    MediaTimeRemainingPart,
+    MediaCurrentTimePart,
+    MediaControlsBackgroundPart,
     SearchFieldPart,
 #if ENABLE(APPLE_PAY)
     ApplePayButtonPart,
diff --git a/modules/javafx.web/src/main/native/Source/WebCore/platform/java/RenderThemeJava.cpp b/modules/javafx.web/src/main/native/Source/WebCore/platform/java/RenderThemeJava.cpp
index a298cf1fea..9ee9de235d 100644
--- a/modules/javafx.web/src/main/native/Source/WebCore/platform/java/RenderThemeJava.cpp
+++ b/modules/javafx.web/src/main/native/Source/WebCore/platform/java/RenderThemeJava.cpp
@@ -395,6 +395,25 @@ void RenderThemeJava::adjustSliderThumbSize(RenderStyle& style, const Element*)
         style.setWidth(Length(sliderThumbHeight, LengthType::Fixed));
         style.setHeight(Length(sliderThumbWidth, LengthType::Fixed));
     }
+#if ENABLE(VIDEO)
+    else if (part == MediaSliderThumbPart) {
+        static int timeWidth = 0;
+        static int timeHeight;
+        if (timeWidth == 0) {
+            getSliderThumbSize(JNI_EXPAND_MEDIA(SLIDER_TYPE_TIME), &timeWidth, &timeHeight);
+        }
+        style.setWidth(Length(timeWidth, LengthType::Fixed));
+        style.setHeight(Length(timeHeight, LengthType::Fixed));
+    } else if (part == MediaVolumeSliderThumbPart) {
+        static int volumeWidth = 0;
+        static int volumeHeight;
+        if (volumeWidth == 0) {
+            getSliderThumbSize(JNI_EXPAND_MEDIA(SLIDER_TYPE_VOLUME), &volumeWidth, &volumeHeight);
+        }
+        style.setWidth(Length(volumeWidth, LengthType::Fixed));
+        style.setHeight(Length(volumeHeight, LengthType::Fixed));
+    }
+#endif
 }
 
 bool RenderThemeJava::paintSliderThumb(const RenderObject&, const PaintInfo&, const IntRect&)
@@ -484,22 +503,28 @@ Color RenderThemeJava::platformInactiveSelectionForegroundColor(OptionSet<StyleC
 #if ENABLE(VIDEO)
 Vector<String, 2> RenderThemeJava::mediaControlsScripts()
 {
-#if ENABLE(MODERN_MEDIA_CONTROLS)
-    return { String(ModernMediaControlsJavaScript, sizeof(ModernMediaControlsJavaScript)) };
-#else
     return { String(mediaControlsAdwaitaJavaScript, sizeof(mediaControlsAdwaitaJavaScript)) };
-#endif
 }
 
 String RenderThemeJava::extraMediaControlsStyleSheet()
 {
-#if ENABLE(MODERN_MEDIA_CONTROLS)
-    return String(ModernMediaControlsUserAgentStyleSheet, sizeof(ModernMediaControlsUserAgentStyleSheet));
-#else
     return String(mediaControlsAdwaitaUserAgentStyleSheet, sizeof(mediaControlsAdwaitaUserAgentStyleSheet));
-#endif
 }
 
+String RenderThemeJava::formatMediaControlsCurrentTime(float, float) const
+{
+    return ""_s;
+}
+
+String RenderThemeJava::formatMediaControlsRemainingTime(float currentTime, float duration) const
+{
+    return formatMediaControlsTime(currentTime) + "/" + formatMediaControlsTime(duration);
+}
+
+/*
+bool RenderThemeJava::paintMediaFullscreenButton(const RenderObject& o, const PaintInfo& paintInfo, const IntRect &r);
+*/
+
 static RefPtr<HTMLMediaElement> parentMediaElement(const Node* node)
 {
     if (!node)
@@ -511,6 +536,125 @@ static RefPtr<HTMLMediaElement> parentMediaElement(const Node* node)
         return nullptr;
     return downcast<HTMLMediaElement>(mediaNode.get());
 }
+
+bool RenderThemeJava::paintMediaPlayButton(const RenderObject& renderObject, const PaintInfo& paintInfo, const IntRect& r)
+{
+    auto mediaElement = parentMediaElement(renderObject.node());
+    if (mediaElement == nullptr)
+        return false;
+
+    // readyState can be NETWORK_EMPTY if preload is NONE
+    jint type = mediaElement->readyState() == HTMLMediaElementEnums::ReadyState::HAVE_NOTHING
+                    ? JNI_EXPAND_MEDIA(DISABLED_PLAY_BUTTON)
+                    : mediaElement->paused()
+                        ? JNI_EXPAND_MEDIA(PLAY_BUTTON)
+                        : JNI_EXPAND_MEDIA(PAUSE_BUTTON);
+    return paintMediaControl(type, renderObject, paintInfo, r);
+}
+
+bool RenderThemeJava::paintMediaMuteButton(const RenderObject& renderObject, const PaintInfo& paintInfo, const IntRect& r)
+{
+    auto mediaElement = parentMediaElement(renderObject.node());
+    if (mediaElement == nullptr)
+        return false;
+
+    jint type = !mediaElement->hasAudio()
+                    ? JNI_EXPAND_MEDIA(DISABLED_MUTE_BUTTON)
+                    : mediaElement->muted()
+                        ? JNI_EXPAND_MEDIA(UNMUTE_BUTTON)
+                        : JNI_EXPAND_MEDIA(MUTE_BUTTON);
+    return paintMediaControl(type, renderObject, paintInfo, r);
+}
+
+/*
+bool RenderThemeJava::paintMediaSeekBackButton(const RenderObject& o, const PaintInfo& paintInfo, const IntRect &r);
+bool RenderThemeJava::paintMediaSeekForwardButton(const RenderObject& o, const PaintInfo& paintInfo, const IntRect &r);
+*/
+
+bool RenderThemeJava::paintMediaSliderTrack(const RenderObject& renderObject, const PaintInfo& paintInfo, const IntRect& r)
+{
+    auto mediaElement = parentMediaElement(renderObject.node());
+    if (mediaElement == nullptr)
+        return false;
+
+    Ref<TimeRanges> timeRanges = mediaElement->buffered();
+
+    paintInfo.context().platformContext()->rq().freeSpace(4
+        + 4                 // number of timeRange pairs
+        + timeRanges->length() * 4 *2   // timeRange pairs
+        + 4 + 4             // duration and currentTime
+        + 4 + 4 + 4 + 4     // x, y, w, h
+        )
+    << (jint)com_sun_webkit_graphics_GraphicsDecoder_RENDERMEDIA_TIMETRACK
+    << (jint)timeRanges->length();
+
+    //utatodo: need [double] support
+    for (unsigned i = 0; i < timeRanges->length(); i++) {
+        paintInfo.context().platformContext()->rq()
+        << (jfloat)timeRanges->start(i).releaseReturnValue() << (jfloat)timeRanges->end(i).releaseReturnValue();
+    }
+
+    paintInfo.context().platformContext()->rq()
+    << (jfloat)mediaElement->duration()
+    << (jfloat)mediaElement->currentTime()
+    << (jint)r.x() <<  (jint)r.y() << (jint)r.width() << (jint)r.height();
+    return true;
+}
+
+bool RenderThemeJava::paintMediaSliderThumb(const RenderObject& renderObject, const PaintInfo& paintInfo, const IntRect& r)
+{
+    return paintMediaControl(JNI_EXPAND_MEDIA(TIME_SLIDER_THUMB), renderObject, paintInfo, r);
+}
+
+bool RenderThemeJava::paintMediaVolumeSliderContainer(const RenderObject& renderObject, const PaintInfo& paintInfo, const IntRect& r)
+{
+    return paintMediaControl(JNI_EXPAND_MEDIA(VOLUME_CONTAINER), renderObject, paintInfo, r);
+}
+
+bool RenderThemeJava::paintMediaVolumeSliderTrack(const RenderObject& renderObject, const PaintInfo& paintInfo, const IntRect& r)
+{
+    auto mediaElement = parentMediaElement(renderObject.node());
+    if (mediaElement == nullptr)
+        return false;
+
+    paintInfo.context().platformContext()->rq().freeSpace(28)
+    << (jint)com_sun_webkit_graphics_GraphicsDecoder_RENDERMEDIA_VOLUMETRACK
+    << (jfloat)mediaElement->volume()
+    << (jint)(mediaElement->hasAudio() && !mediaElement->muted() ? 0 : 1)   // muted
+    << (jint)r.x() <<  (jint)r.y() << (jint)r.width() << (jint)r.height();
+    return true;
+
+}
+
+bool RenderThemeJava::paintMediaVolumeSliderThumb(const RenderObject& renderObject, const PaintInfo& paintInfo, const IntRect& rect)
+{
+    return paintMediaControl(JNI_EXPAND_MEDIA(VOLUME_THUMB), renderObject, paintInfo, rect);
+}
+
+/*
+bool RenderThemeJava::paintMediaRewindButton(const RenderObject& o, const PaintInfo& paintInfo, const IntRect &r);
+bool RenderThemeJava::paintMediaReturnToRealtimeButton(const RenderObject& o, const PaintInfo& paintInfo, const IntRect &r);
+bool RenderThemeJava::paintMediaToggleClosedCaptionsButton(const RenderObject& o, const PaintInfo& paintInfo, const IntRect &r);
+*/
+
+bool RenderThemeJava::paintMediaControlsBackground(const RenderObject&, const PaintInfo&, const IntRect&)
+{
+//    return paintMediaControl(JNI_EXPAND_MEDIA(BACKGROUND), o, paintInfo, r);
+    return true;
+}
+
+bool RenderThemeJava::paintMediaCurrentTime(const RenderObject&, const PaintInfo&, const IntRect&)
+{
+//    return paintMediaControl(JNI_EXPAND_MEDIA(CURRENT_TIME), o, paintInfo, r);
+    return true;
+}
+
+bool RenderThemeJava::paintMediaTimeRemaining(const RenderObject&, const PaintInfo&, const IntRect&)
+{
+//    return paintMediaControl(JNI_EXPAND_MEDIA(REMAINING_TIME), o, paintInfo, r);
+    return true;
+}
+
 bool RenderThemeJava::paintMediaControl(jint type, const RenderObject&, const PaintInfo& paintInfo, const IntRect& r)
 {
     paintInfo.context().platformContext()->rq().freeSpace(24)
diff --git a/modules/javafx.web/src/main/native/Source/WebCore/platform/java/RenderThemeJava.h b/modules/javafx.web/src/main/native/Source/WebCore/platform/java/RenderThemeJava.h
index d5c893940a..1c77dcf0d0 100644
--- a/modules/javafx.web/src/main/native/Source/WebCore/platform/java/RenderThemeJava.h
+++ b/modules/javafx.web/src/main/native/Source/WebCore/platform/java/RenderThemeJava.h
@@ -82,6 +82,20 @@ protected:
     virtual Vector<String, 2> mediaControlsScripts() override;
     String extraMediaControlsStyleSheet() override;
 
+    String formatMediaControlsCurrentTime(float currentTime, float duration) const override;
+    String formatMediaControlsRemainingTime(float currentTime, float duration) const override;
+
+    bool paintMediaPlayButton(const RenderObject&, const PaintInfo&, const IntRect&) override;
+    bool paintMediaMuteButton(const RenderObject&, const PaintInfo&, const IntRect&) override;
+    bool paintMediaSliderTrack(const RenderObject&, const PaintInfo&, const IntRect&) override;
+    bool paintMediaSliderThumb(const RenderObject&, const PaintInfo&, const IntRect&) override;
+    bool paintMediaVolumeSliderContainer(const RenderObject&, const PaintInfo&, const IntRect&) override;
+    bool paintMediaVolumeSliderTrack(const RenderObject&, const PaintInfo&, const IntRect&) override;
+    bool paintMediaVolumeSliderThumb(const RenderObject&, const PaintInfo&, const IntRect&) override;
+    bool paintMediaControlsBackground(const RenderObject&, const PaintInfo&, const IntRect&) override;
+    bool paintMediaCurrentTime(const RenderObject&, const PaintInfo&, const IntRect&) override;
+    bool paintMediaTimeRemaining(const RenderObject&, const PaintInfo&, const IntRect&) override;
+
 #endif
 
     Seconds animationRepeatIntervalForProgressBar(const RenderProgress&) const override;
diff --git a/modules/javafx.web/src/main/native/Source/WebCore/rendering/RenderTheme.cpp b/modules/javafx.web/src/main/native/Source/WebCore/rendering/RenderTheme.cpp
index 8ba778ace2..eeb07d4e35 100644
--- a/modules/javafx.web/src/main/native/Source/WebCore/rendering/RenderTheme.cpp
+++ b/modules/javafx.web/src/main/native/Source/WebCore/rendering/RenderTheme.cpp
@@ -295,6 +295,17 @@ void RenderTheme::adjustStyle(RenderStyle& style, const Element* element, const
         return adjustMenuListStyle(style, element);
     case MenulistButtonPart:
         return adjustMenuListButtonStyle(style, element);
+    case MediaPlayButtonPart:
+    case MediaCurrentTimePart:
+    case MediaTimeRemainingPart:
+    case MediaEnterFullscreenButtonPart:
+    case MediaExitFullscreenButtonPart:
+    case MediaMuteButtonPart:
+    case MediaVolumeSliderContainerPart:
+        return adjustMediaControlStyle(style, element);
+    case MediaSliderPart:
+    case MediaVolumeSliderPart:
+    case MediaFullScreenVolumeSliderPart:
     case SliderHorizontalPart:
     case SliderVerticalPart:
         return adjustSliderTrackStyle(style, element);
@@ -524,6 +535,47 @@ bool RenderTheme::paint(const RenderBox& box, ControlStates& controlStates, cons
     case SliderThumbHorizontalPart:
     case SliderThumbVerticalPart:
         return paintSliderThumb(box, paintInfo, integralSnappedRect);
+    case MediaEnterFullscreenButtonPart:
+    case MediaExitFullscreenButtonPart:
+        return paintMediaFullscreenButton(box, paintInfo, integralSnappedRect);
+    case MediaPlayButtonPart:
+        return paintMediaPlayButton(box, paintInfo, integralSnappedRect);
+    case MediaOverlayPlayButtonPart:
+        return paintMediaOverlayPlayButton(box, paintInfo, integralSnappedRect);
+    case MediaMuteButtonPart:
+        return paintMediaMuteButton(box, paintInfo, integralSnappedRect);
+    case MediaSeekBackButtonPart:
+        return paintMediaSeekBackButton(box, paintInfo, integralSnappedRect);
+    case MediaSeekForwardButtonPart:
+        return paintMediaSeekForwardButton(box, paintInfo, integralSnappedRect);
+    case MediaRewindButtonPart:
+        return paintMediaRewindButton(box, paintInfo, integralSnappedRect);
+    case MediaReturnToRealtimeButtonPart:
+        return paintMediaReturnToRealtimeButton(box, paintInfo, integralSnappedRect);
+    case MediaToggleClosedCaptionsButtonPart:
+        return paintMediaToggleClosedCaptionsButton(box, paintInfo, integralSnappedRect);
+    case MediaSliderPart:
+        return paintMediaSliderTrack(box, paintInfo, integralSnappedRect);
+    case MediaSliderThumbPart:
+        return paintMediaSliderThumb(box, paintInfo, integralSnappedRect);
+    case MediaVolumeSliderMuteButtonPart:
+        return paintMediaMuteButton(box, paintInfo, integralSnappedRect);
+    case MediaVolumeSliderContainerPart:
+        return paintMediaVolumeSliderContainer(box, paintInfo, integralSnappedRect);
+    case MediaVolumeSliderPart:
+        return paintMediaVolumeSliderTrack(box, paintInfo, integralSnappedRect);
+    case MediaVolumeSliderThumbPart:
+        return paintMediaVolumeSliderThumb(box, paintInfo, integralSnappedRect);
+    case MediaFullScreenVolumeSliderPart:
+        return paintMediaFullScreenVolumeSliderTrack(box, paintInfo, integralSnappedRect);
+    case MediaFullScreenVolumeSliderThumbPart:
+        return paintMediaFullScreenVolumeSliderThumb(box, paintInfo, integralSnappedRect);
+    case MediaTimeRemainingPart:
+        return paintMediaTimeRemaining(box, paintInfo, integralSnappedRect);
+    case MediaCurrentTimePart:
+        return paintMediaCurrentTime(box, paintInfo, integralSnappedRect);
+    case MediaControlsBackgroundPart:
+        return paintMediaControlsBackground(box, paintInfo, integralSnappedRect);
     case MenulistButtonPart:
     case TextFieldPart:
     case TextAreaPart:
@@ -686,6 +738,43 @@ void RenderTheme::paintDecorations(const RenderBox& box, const PaintInfo& paintI
     }
 }
 
+#if ENABLE(VIDEO)
+
+String RenderTheme::formatMediaControlsTime(float time) const
+{
+    if (!std::isfinite(time))
+        time = 0;
+    // FIXME: Seems like it would be better to use std::lround here.
+    int seconds = static_cast<int>(std::abs(time));
+    int hours = seconds / (60 * 60);
+    int minutes = (seconds / 60) % 60;
+    seconds %= 60;
+    if (hours)
+        return makeString((time < 0 ? "-" : ""), hours, ':', pad('0', 2, minutes), ':', pad('0', 2, seconds));
+    return makeString((time < 0 ? "-" : ""), pad('0', 2, minutes), ':', pad('0', 2, seconds));
+}
+
+String RenderTheme::formatMediaControlsCurrentTime(float currentTime, float /*duration*/) const
+{
+    return formatMediaControlsTime(currentTime);
+}
+
+String RenderTheme::formatMediaControlsRemainingTime(float currentTime, float duration) const
+{
+    return formatMediaControlsTime(currentTime - duration);
+}
+
+LayoutPoint RenderTheme::volumeSliderOffsetFromMuteButton(const RenderBox& muteButtonBox, const LayoutSize& size) const
+{
+    LayoutUnit y = -size.height();
+    FloatPoint absPoint = muteButtonBox.localToAbsolute(FloatPoint(muteButtonBox.offsetLeft(), y), { IsFixed, UseTransforms });
+    if (absPoint.y() < 0)
+        y = muteButtonBox.height();
+    return LayoutPoint(0_lu, y);
+}
+
+#endif
+
 Color RenderTheme::activeSelectionBackgroundColor(OptionSet<StyleColorOptions> options) const
 {
     auto& cache = colorCache(options);
@@ -1275,6 +1364,10 @@ void RenderTheme::adjustMenuListButtonStyle(RenderStyle&, const Element*) const
 {
 }
 
+void RenderTheme::adjustMediaControlStyle(RenderStyle&, const Element*) const
+{
+}
+
 void RenderTheme::adjustSliderTrackStyle(RenderStyle&, const Element*) const
 {
 }
diff --git a/modules/javafx.web/src/main/native/Source/WebCore/rendering/RenderTheme.h b/modules/javafx.web/src/main/native/Source/WebCore/rendering/RenderTheme.h
index 53914e9bd5..d7d1e1a224 100644
--- a/modules/javafx.web/src/main/native/Source/WebCore/rendering/RenderTheme.h
+++ b/modules/javafx.web/src/main/native/Source/WebCore/rendering/RenderTheme.h
@@ -202,6 +202,23 @@ public:
     virtual Seconds animationDurationForProgressBar(const RenderProgress&) const;
     virtual IntRect progressBarRectForBounds(const RenderObject&, const IntRect&) const;
 
+#if ENABLE(VIDEO)
+    // Media controls
+    virtual bool supportsClosedCaptioning() const { return false; }
+    virtual bool hasOwnDisabledStateHandlingFor(ControlPart) const { return false; }
+    virtual bool usesMediaControlStatusDisplay() { return false; }
+    virtual bool usesMediaControlVolumeSlider() const { return true; }
+    virtual bool usesVerticalVolumeSlider() const { return true; }
+    virtual double mediaControlsFadeInDuration() { return 0.1; }
+    virtual Seconds mediaControlsFadeOutDuration() { return 300_ms; }
+    virtual String formatMediaControlsTime(float time) const;
+    virtual String formatMediaControlsCurrentTime(float currentTime, float duration) const;
+    virtual String formatMediaControlsRemainingTime(float currentTime, float duration) const;
+
+    // Returns the media volume slider container's offset from the mute button.
+    virtual LayoutPoint volumeSliderOffsetFromMuteButton(const RenderBox&, const LayoutSize&) const;
+#endif
+
     virtual IntSize meterSizeForBounds(const RenderMeter&, const IntRect&) const;
     virtual bool supportsMeter(ControlPart, const HTMLMeterElement&) const;
 
@@ -368,6 +385,27 @@ protected:
     virtual void adjustSearchFieldResultsButtonStyle(RenderStyle&, const Element*) const;
     virtual bool paintSearchFieldResultsButton(const RenderBox&, const PaintInfo&, const IntRect&) { return true; }
 
+    virtual void adjustMediaControlStyle(RenderStyle&, const Element*) const;
+    virtual bool paintMediaFullscreenButton(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaPlayButton(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaOverlayPlayButton(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaMuteButton(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaSeekBackButton(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaSeekForwardButton(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaSliderTrack(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaSliderThumb(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaVolumeSliderContainer(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaVolumeSliderTrack(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaVolumeSliderThumb(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaRewindButton(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaReturnToRealtimeButton(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaToggleClosedCaptionsButton(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaControlsBackground(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaCurrentTime(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaTimeRemaining(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaFullScreenVolumeSliderTrack(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+    virtual bool paintMediaFullScreenVolumeSliderThumb(const RenderObject&, const PaintInfo&, const IntRect&) { return true; }
+
 public:
     void updateControlStatesForRenderer(const RenderBox&, ControlStates&) const;
     OptionSet<ControlStates::States> extractControlStatesForRenderer(const RenderObject&) const;

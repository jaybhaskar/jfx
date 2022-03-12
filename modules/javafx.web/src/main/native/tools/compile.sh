#!/bin/bash
# Copyright (c) 2013 The Chromium Embedded Framework Authors. All rights
# reserved. Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file.

if [ -z "$1" ]; then
  echo "ERROR: Please specify a target platform: linux32 or linux64 or macosx64"
else
  DIR="$( cd "$( dirname "$0" )" && cd .. && pwd )"
  OUT_PATH="${DIR}/out/$1"
  JAVA_PATH="${DIR}/java"
  CLS_PATH="${DIR}/third_party/jogamp/jar/*:${DIR}/third_party/junit/*:${JAVA_PATH}:/home/alexa/myproject/openjdk/jfx/build/sdk/lib/*"

  if [ ! -d "$OUT_PATH" ]; then
    mkdir -p "$OUT_PATH"
  fi


if [ -z "$PATH_TO_FX" ]
then
    echo "*********************************************************************"
    echo "*                                                                   *"
    echo "*              Set PATH_TO_FX location                              *"
    echo "*              jfx/build/sdk/lib                                    *"
    echo "*                                                                   *"
    echo "*********************************************************************"
else
    echo "*********************************************************************"
    echo "*                                                                   *"
    echo "       Good to go , PATH_TO_FX is defined"
    echo "*                                                                   *"
    echo "*                                                                   *"
    echo "*********************************************************************"
fi


  javac -Xdiags:verbose --module-path="$PATH_TO_FX" --add-modules="javafx.graphics,javafx.controls" -cp "$CLS_PATH" -d "$OUT_PATH" "${JAVA_PATH}"/tests/detailed/*.java "${JAVA_PATH}"/tests/junittests/*.java "${JAVA_PATH}"/tests/simple/*.java  "${JAVA_PATH}"/tests/jfx/*.java "${JAVA_PATH}"/org/cef/*.java "${JAVA_PATH}"/org/cef/browser/*.java "${JAVA_PATH}"/org/cef/callback/*.java "${JAVA_PATH}"/org/cef/handler/*.java "${JAVA_PATH}"/org/cef/misc/*.java "${JAVA_PATH}"/org/cef/network/*.java

fi


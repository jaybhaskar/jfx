#!/bin/bash
# Copyright (c) 2013 The Chromium Embedded Framework Authors. All rights
# reserved. Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file.

if [ -z "$1" ]; then
  echo "ERROR: Please specify a target platform: linux32 or linux64 or macosx64"
else
  if [ -z "$2" ]; then
    echo "ERROR: Please specify a build type: Debug or Release"
  elif [ -z "$3" ]; then
    echo "ERROR: Please specify a run type: detailed or simple"
  else
    DIR="$( cd "$( dirname "$0" )" && cd .. && pwd )"
    OUT_PATH="${DIR}/out/$1"

    LIB_PATH="${DIR}/jcef_build/native/$2"
    if [ ! -d "$LIB_PATH" ]; then
      echo "ERROR: Native build output path does not exist"
      exit 1
    fi

    RUN_TYPE="$3"
    CLS_PATH="${DIR}/third_party/jogamp/jar/*:$OUT_PATH"

    # Necessary for jcef_helper to find libcef.so.
    if [ -n "$LD_LIBRARY_PATH" ]; then
      LD_LIBRARY_PATH="$LIB_PATH:${LD_LIBRARY_PATH}"
    else
      LD_LIBRARY_PATH="$LIB_PATH"
    fi
    export LD_LIBRARY_PATH

    # Remove the first three params ($1, $2 and $3) and pass the rest to java.
    shift
    shift
    shift
    echo "***********DIR********";
    echo $DIR
    echo "**********************";
    echo "***********OUT********";
    echo $OUT_PATH
    echo "**********************";
    echo "***********LD_LIBRARY_PATH********";
    echo $LD_LIBRARY_PATH
    echo "**********************";
    echo "***********CLASS_PATH********";
    echo $CLS_PATH
    echo "**********************";
    if [[ "$1" == "macosx64" ]]
       then
          LD_PRELOAD=libcef.dylib java --module-path=$PATH_TO_FX --add-modules="javafx.base,javafx.controls,javafx.fxml,javafx.graphics" -cp "$CLS_PATH" -Djava.library.path="$LIB_PATH" tests.$RUN_TYPE.MainFrame "$@"
       else
          LD_PRELOAD=libcef.so java --module-path=$PATH_TO_FX --add-modules="javafx.base,javafx.controls,javafx.fxml,javafx.graphics" -cp "$CLS_PATH" -Djava.library.path="$LIB_PATH" tests.$RUN_TYPE.MainFrame "$@"
    fi
  fi
fi

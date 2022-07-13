#!/bin/sh

for file in Anilibria-ios-app/Generated/*
do
    if [ -f $file ]
    then
        chmod a=rw "$file"
    fi
done

if test -d "/opt/homebrew/bin/"; then
  PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

if which swiftgen >/dev/null; then
  swiftgen config run --config SwiftGen/swiftgen.yml
else
    echo "warning: SwiftGen not installed, download it from https://github.com/SwiftGen/SwiftGen"
fi

for file in Anilibria-ios-app/Generated/*
do
    chmod a=r "$file"
done

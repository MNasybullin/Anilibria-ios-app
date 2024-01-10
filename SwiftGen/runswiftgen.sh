#!/bin/sh

if test !Anilibria-ios-app/Generated; then
mkdir Anilibria-ios-app/Generated
fi

for file in Anilibria-ios-app/Generated/*
do
    if [ -f $file ]
    then
        chmod a=rw "$file"
    fi
done

if [[ -f "${PODS_ROOT}/SwiftGen/bin/swiftgen" ]]; then
  "${PODS_ROOT}/SwiftGen/bin/swiftgen" config run --config SwiftGen/swiftgen.yml
else
  echo "warning: SwiftGen is not installed. Run 'pod install --repo-update' to install it."
fi

for file in Anilibria-ios-app/Generated/*
do
    chmod a=r "$file"
done

echo 'Synchronzing test files...'
mkdir .generated
rsync --archive \
      --recursive \
      --out-format='%n%L' \
      test/suite .generated/ && echo 'Done!\n'

echo 'Compiling Assets...'
node_modules/.bin/gulp js && node_modules/.bin/gulp css && echo 'Done!\n'

echo 'Creating lib/assets folder...'
mkdir -pv lib/assets && echo 'Done!\n'

echo 'Copying assets into the lib folder...'
mkdir -p lib/assets
rsync --archive \
      --recursive \
      --out-format='%n%L' \
      .generated/{javascripts,stylesheets} lib/assets/ && echo 'Done!\n'

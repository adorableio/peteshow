echo 'Compiling Assets...'
node_modules/.bin/gulp js && \
node_modules/.bin/gulp css && \
node_modules/.bin/gulp vendor && \
echo 'Done!\n'

echo 'Creating lib/assets folder...'
mkdir -pv lib/assets && echo 'Done!\n'

echo 'Copying assets into the lib folder...'
mkdir -p lib
rsync --archive \
      --recursive \
      --out-format='%n%L' \
      .generated/{javascripts,stylesheets} lib/assets/ && echo 'Done!\n'

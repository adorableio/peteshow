echo 'Compiling Assets...'
node_modules/.bin/gulp js && node_modules/.bin/gulp css && echo 'Done!\n'

echo 'Creating lib/assets folder...'
mkdir -pv lib/assets && echo 'Done!\n'

echo 'Copying assets into the lib folder...'
rsync -avz .generated/{javascripts,stylesheets} lib/assets/ && echo 'Done!\n'

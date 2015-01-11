echo 'Compiling Assets...'
node_modules/.bin/gulp js && node_modules/.bin/gulp css && echo 'Done!\n'

echo 'Creating lib folder...'
mkdir -pv lib/assets/javascripts lib/assets/stylesheets && echo 'Done!\n'

echo 'Copying assets into the lib folder...'
mv -fv .generated/* lib/assets/ && echo 'Done!\n'

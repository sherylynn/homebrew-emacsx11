#version="28.0.91"
version="30.0.50"
version_num=${version%.*}
url="https://github.com/emacs-mirror/emacs/archive/refs/tags/emacs-"${version}".tar.gz"
fileName=emacs

FormulaName=emacsx11@${version_num}
curl -o ${fileName}.tar.gz -L ${url}
sha256=$(openssl dgst -sha256 ${fileName}.tar.gz)
echo ${sha256}
sha256_string=${sha256##*= }
echo ${sha256_string}
rm ${fileName}.tar.gz
cp ./Formula/emacsx11@00.rb ./Formula/${FormulaName}.rb
vi ./Formula/${FormulaName}.rb -c '/Emacsx11AT' -c 'normal ddOclass Emacsx11AT' -c "normal a${version_num} < Formula " -c 'wq!'
vi ./Formula/${FormulaName}.rb -c '/branch' -c 'normal ddOurl "https://github.com/emacs-mirror/emacs.git", :branch => "emacs-"' -c "normal i${version_num}" -c 'wq!'
vi ./Formula/${FormulaName}.rb -c '/version' -c 'normal ddOversion ""' -c "normal i${version}" -c 'wq!'
vi ./Formula/${FormulaName}.rb -c '/sha256' -c 'normal ddOsha256 ""' -c "normal i${sha256_string}" -c 'wq!'
#brew tap sherylynn/emacsx11
#brew uninstall emacsx11
#brew install --build-bottle emacsx11
#brew bottle emacsx11

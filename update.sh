#version="28.0.91"
version="27.2"
url="https://github.com/emacs-mirror/emacs/archive/refs/tags/emacs-"${version}".tar.gz"
fileName=emacs
FormulaName=emacsx11@27
curl -o ${fileName}.tar.gz -L ${url}
sha256=$(openssl dgst -sha256 ${fileName}.tar.gz)
echo ${sha256}
sha256_string=${sha256##*= }
echo ${sha256_string}
rm ${fileName}.tar.gz
vi ./Formula/${FormulaName}.rb -c '/version' -c 'normal ddOversion ""' -c "normal i${version}" -c 'wq!'
vi ./Formula/${FormulaName}.rb -c '/sha256' -c 'normal ddOsha256 ""' -c "normal i${sha256_string}" -c 'wq!'

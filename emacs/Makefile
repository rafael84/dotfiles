emacs:
	brew tap d12frosted/emacs-plus
	brew install emacs-plus@28
	ln -Fs /usr/local/Cellar/emacs-plus@28/28.0.50/Emacs.app /Applications/Emacs.app

spacemacs: emacs
	ln -Fs $(abspath .spacemacs) ~/.spacemacs
	npm install -g eslint babel-eslint eslint-plugin-react prettier typescript typescript-language-server import-js

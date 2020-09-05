forall () { 
	find -maxdepth 1 -type d -exec bash -c "cd {}; echo;echo ---------------------------------------------{}---------------------------------------------;echo;$*" \; ; 
}

gitall () { 
	find -maxdepth 2 -type d -name .git -exec dirname {} \; | xargs -I {} bash -c "cd {}; echo;echo ---------------------------------------------{}---------------------------------------------;echo;git $*";
}

cdd () { cd $* && ls; }



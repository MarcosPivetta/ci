#!/bin/bash

set +x

email="m.pivetta@centauro.com.br"
name="Pivetta"

git config --global user.email $email
git config --global user.name $name
git config --global push.default simple

if [[ $(git config user.email) == $email || $(git config user.name) == $name ]]; 
	then
		echo "======================================================================="
		echo "Usuário e senha global do git estão corretos:"
		echo "email : $(git config user.email)"
		echo "usuário : $(git config user.name)"
	else
		echo "======================================================================="
		echo "E-mail e usuário global do GIT estão incorretos:"
		echo "email : $(git config --global user.email $email)"
		echo "usuário : $(git config --global user.name $name)"
fi
		echo "======================================================================="

#Faz checkout da "master" e atualização "master" local
git checkout master
git fetch -p
git pull

#Cria variável local "branches" com todas as branches remotas (exceto a "master")
braches=$(git branch -r | egrep -v 'master' | cut -c 10-)

for branch in $braches; 
	do
		echo "======================================================================="
		echo "Branch: " $branch
		git checkout $branch
   		git merge master
		if [[ $? == 1 ]]; then
			echo "Encontrado conflito na $branch. Necessário resolver manualmente."  
			$(git merge --abort)
		else
			echo "Merge realizado com sucesso;"
			$(git push)
		fi
	done
		echo "======================================================================="

#Faz checkout da "master" 
git checkout master

#Deleta as branches locais (exceto a "master")
git branch | egrep -v 'master' | xargs git branch -D

set -x
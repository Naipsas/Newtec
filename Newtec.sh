#!/bin/bash
# Alvaro Martin Rodriguez
# k8s demo - Newtec

# FUNCTIONS
function menu {

  echo "#####################"
  echo "####             ####"
  echo "# 1.- Install k8s   #"
  echo "# 2.- Run minikube  #"
  echo "# 3.- Launch ex01   #"
  echo "# 4.- Remove ex01   #"
  echo "# 5.- ShowData ex01 #"
  echo "# 6.- Stop minikube #"
  echo "# 7.- Exit          #"
  echo "####             ####"
  echo "#####################"

  echo ""
  echo -n "Select an option: "
  read Option

  case $Option in
    1 )
      InstallMinikube
      ;;
    2 )
      RunMinikube
      ;;
    3 )
      LaunchEx "01"
      ;;
    4 )
      RemoveEx "01"
      ;;
    5 )
      ShowData "01"
      ;;
    6 )
      StopMinikube
      ;;
    7 )
      clear
      exit
      ;;
    * )
      # Non valid option
      menu
      ;;

  esac

}

function backtoMenu()
{

  echo ""
	echo -n "Do you want to return to the menu? (Y/N) : "
  read Option

  if [ "$Option" = "Y" ] || [ "$Option" = "y" ]; then
    menu
  else
    exit
  fi

}

function InstallMinikube()
{

  clear
  echo "Getting ready to install minikube..."

  echo -e "\n\tDonwloading VirtualboxRepo..."
  wget -qO $VirtualboxRepo "${VBRepoURL}"
  if [ -r $VirtualboxRepo ]; then
    echo -e "\tInstalling VirtualBoxRepo..."
    sudo mv $VirtualboxRepo $TargetRepo > /dev/null
    if [ "$?" -eq "0" ]; then
      echo -e "\tOK"
      echo -e "\n\tInstalling VirtualBox..."
      sudo yum install $VirtualBoxsudo yum -y > /dev/null
      if [ "$?" -eq "0" ]; then
        echo -e "\tVirtualBox installed!"
      else
        echo -e "\tSomething went wrong..."
      fi
    else
      echo -e "\tCouldn't be done!"
    fi
  else
    echo -e "\tCouldn't download!"
  fi

  echo -e "\n\tInstalling dependencies..."
  # Let's assume kernel source not installed and dkms not used
  sudo yum groupinstall "Development Tools" -y > /dev/null
  if [ "$?" -eq "0" ]; then
    echo -e "\tDevelopment tools installed"
  fi
  sudo yum install kernel-devel -y > /dev/null
  if [ "$?" -eq "0" ]; then
    echo -e "\tKernel source - development installed"
  fi

  echo -e "\n\tDonwloading Minikube..."
  wget -qO $Minikube "${MinikubeURL}"
  if [ -r $Minikube ]; then
    echo -e "\tInstalling Minikube..."
    chmod +x $Minikube  > /dev/null
    chown $user:$group $Minikube
    sudo mv $Minikube $MinikubeTarget  > /dev/null
    if [ "$?" -eq "0" ]; then
      echo -e "\tOK"
    else
      echo -e "\tCouldn't be done!"
    fi
  else
    echo -e "\tCouldn't download!"
  fi

  echo -e "\n\tDowloading kubectl..."
  wget -qO $Kubectl "${KubectlURL}"
  if [ -r $Kubectl ]; then
    echo -e "\tInstalling Kubectl..."
    chmod +x $Kubectl  > /dev/null
    chown $user:$group $Kubectl
    sudo mv $Kubectl $KubectlTarget  > /dev/null
    if [ "$?" -eq "0" ]; then
      echo -e "\tOK"
    else
      echo -e "\tCouldn't be done!"
    fi
  else
    echo -e "\tCouldn't download!"
  fi

  backtoMenu

}

function RunMinikube()
{

  clear
  echo "Starting Minikube..."
  /usr/local/bin/minikube start

  backtoMenu

}

function LaunchEx()
{

  clear
  echo "Starting Example $1..."

  prefix="ex"
  suffix="run"
  file="$prefix$1$suffix"
  file+=".sh"

  path="Example_"
  path+=$1
  cd $path > /dev/null
  source "$file"
  cd .. > /dev/null

  backtoMenu

}

function RemoveEx()
{

  clear
  echo "Removing Example $1..."

  prefix="ex"
  suffix="rem"
  file="$prefix$1$suffix"
  file+=".sh"

  path="Example_"
  path+=$1
  cd $path > /dev/null
  source "$file"
  cd .. > /dev/null

  backtoMenu

}

function ShowData()
{

  clear
  echo "Key data:"

  echo -en "\tCluster external IP: "
  kubeip=$(minikube ip)
  echo $kubeip

  echo -e "\tService that exposes the blog: "
  kubectl get svc -n "example-$1" | grep "NodePort"

  echo -e "\tIf we access to the blog: \n\t"
  wget -qO web 192.168.99.100:30000; head web | grep "Newtec"
  rm web > /dev/null

  backtoMenu

}

function StopMinikube()
{

  clear
  echo "Stopping minikube..."

  minikube stop > /dev/null

  if [ "$?" -eq "0" ]; then
    echo "OK"
  else
    echo "Something went wrong!"
  fi

  backtoMenu

}

source ./Newtec_vars
menu

#!/usr/bin/env bash

sudo su ckan
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

die_on_bad_cd()
{
  local folder=$1
  echo "Unable to cd to $folder"
  exit 1
}

install_extension()
{
  local github_url=$1
  local checkout_foldername=$2
  local commit_hash=$3

  local checkout_folder_abs_path="$CKAN_EXTENSIONS_PATH/$checkout_foldername"

  if [ -d "$checkout_folder_abs_path" ]
  then
    rm -rf "$checkout_folder_abs_path"
  fi

  git clone "$github_url" "$checkout_folder_abs_path"

  if [[ "$commit_hash" != "" ]]; then
    cd $checkout_folder_abs_path
    git checkout "$commit_hash"
  fi
  
  cd "$checkout_folder_abs_path" &&
  python setup.py develop

  if [ -f "$checkout_folder_abs_path/dev-requirements.txt" ]
  then
    pip install -r dev-requirements.txt
  fi

  if [ -f "$checkout_folder_abs_path/requirements.txt" ]
  then
    pip install -r requirements.txt
  fi
}

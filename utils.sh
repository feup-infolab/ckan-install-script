#!/usr/bin/env bash

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

  local checkout_folder_abs_path="$CKAN_EXTENSIONS_PATH/$checkout_foldername"

  if [ -d "$checkout_folder_abs_path" ]
  then
    rm -rf "$checkout_folder_abs_path"
  fi

  git clone "$github_url" "$checkout_folder_abs_path"
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

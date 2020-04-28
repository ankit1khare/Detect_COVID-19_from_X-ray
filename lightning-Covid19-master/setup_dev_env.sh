#!/bin/bash -ex
script_link="$( readlink "$BASH_SOURCE" )" || script_link="$BASH_SOURCE"
apparent_sdk_dir="${script_link%/*}"
if [ "$apparent_sdk_dir" == "$script_link" ]; then
  apparent_sdk_dir=.
fi
sdk_dir="$( command cd -P "$apparent_sdk_dir" > /dev/null && pwd -P )"

# create root directory to install miniconda
dev_env_dir=$sdk_dir/.dev_env
mkdir -p $dev_env_dir

# define miniconda paths
conda_bin_dir=$dev_env_dir/bin
conda_bin=$conda_bin_dir/conda

# download and install miniconda
if [ ! -e $dev_env_dir/miniconda.sh ]; then
    curl -o $dev_env_dir/miniconda.sh \
	 -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x $dev_env_dir/miniconda.sh
fi
if [ ! -e $conda_bin ]; then
    $dev_env_dir/miniconda.sh -b -u -p $dev_env_dir
fi

# create an environment with the specific python version
$conda_bin update -n base -c defaults conda
$conda_bin env create -f environment.yml
$conda_bin clean -ya

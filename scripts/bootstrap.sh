#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Enter repository root
cd "$( dirname "${BASH_SOURCE[0]}" )"/..

# Load symlink script
source scripts/symlink.sh

# Clone mbed-os
if [ -d "dependencies/mbed-os" ]
then
    echo "Using existing mbed-os"
else
    # git clone https://github.com/ARMmbed/mbed-os.git
    # Use feature branch until merged to master
    git clone --depth 1 https://github.com/paul-szczepanek-arm/mbed-os.git -b unittest dependencies/mbed-os
fi

# Add symlinks
symlink dependencies/mbed-os       tests/UNITTESTS/mbed-os

symlink dependencies/mbed-os       tests/TESTS/LinkLoss/device/mbed-os
symlink services/LinkLoss          tests/TESTS/LinkLoss/device/LinkLoss

symlink dependencies/mbed-os       tests/TESTS/DeviceInformation/device/mbed-os
symlink services/DeviceInformation tests/TESTS/DeviceInformation/device/DeviceInformation

# Create mbed-os.lib for CMake builds
echo "https://github.com/ARMmbed/mbed-os" > tests/TESTS/LinkLoss/device/mbed-os.lib
echo "https://github.com/ARMmbed/mbed-os" > tests/TESTS/DeviceInformation/device/mbed-os.lib

# Create virtual environment
if [ -d "tests/TESTS/venv" ]
then
  echo "Using existing virtual environment"
else
  mkdir tests/TESTS/venv
  # On Windows, the Python 3 executable is called 'python'
  if windows; then
    python  -m virtualenv tests/TESTS/venv
  else
    python3 -m virtualenv tests/TESTS/venv
  fi
fi

# Activate virtual environment
source scripts/activate.sh

# Install mbed-os requirements
pip install -r dependencies/mbed-os/requirements.txt

# Install testing requirements
pip install -r tests/TESTS/requirements.txt

# Install cli and tools
pip install --upgrade mbed-cli mbed-tools

echo "Services repository bootstrap complete"

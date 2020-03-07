# History

## 1.4.1 (Sept 9, 2019)

* updated molecule `2.20.02`->`2.22`
* changed support for ansible from patch versions to minors

## 1.4.0 (Jul 24, 2019)

* updated molecule `2.20.0`->`2.20.2`
* updated vagrant `2.2.3`->`2.2.2`
* updated ansible `2.8+`

## 1.3.0 (May 17, 2019)

Important Note:

`Since now images are tagged via ansible and molecule version: ansible-ansible_version-molecule-molecule_version. Old format that is tagging via only ansible - ansible-ansible_version is maintained but may become deprecated in future releases`

Other changes:

* Removed hooks
* Added local builds with Makefile in place of hooks
* Added changelog
* Updated defaults in Dockerfile

## 1.2.0 (Apr 4, 2019)

* Updated molecule to new version 2.20
* Changes in image - update of setuptools - forced by new molecule
* Added new versions

## 1.1.0 (Feb 28, 2019)

* Fixed issue where envs should be args
* Added ansible.cfg for docker image
* Changed name of the image

## 1.0.0 (Feb 21, 2019)

* initial release

<!-- ### Backwards Incompatibilities / Notes -->

<!-- ### Important Changes -->

<!-- ### Others -->

<!-- ### Bug Fixes -->

<!-- ### Known Issues -->
# Building Selinux on Fedora:

## Pre-Requisites

1. Creation of Bugzilla account if you dont have one.

2. Creation of a Fedora Account

3. Creation of Pagure account

4. Join the important Mailing Lists

5. Introduce yourself

***Refer [link](https://docs.fedoraproject.org/en-US/package-maintainers/JoiningthePackageMaintainers/) for detailed description about the pre-requisites.***

Quick steps to build packages:
1. kinit from the machine from which you have added ssh pub keys to fedora account
 `# kinit <username>@FEDORAPROJECT.ORG`
 Use the password and username of the fedora account itself

2. fedpkg clone glusterfs-selinux
 
3. fedpkg switch-branch <required fedora branch>
 
4.  you could update the .spec file, e.g. update Release to current release and add a %changelog.

5. Then git add *.spec from [upstream gluster selinux repo](https://github.com/gluster/glusterfs-selinux)

6. fedpkg commit -p -c -s
    
7. fedpkg build --target <branch name>

8. Upload tar.gz file to  https://src.fedoraproject.org/rpms/glusterfs-selinux
  `#fedpkg upload glusterfs-selinux-2.0.1.tar.gz`
    
   followed by:
  `#git add` 
  `#fedpkg push`
    
9. Make sure that package you built is marked stable at https://bodhi.fedoraproject.org/updates/
by searching for: glusterfs-selinux in Search tab.

# Steps involved in upstream release of glusterfs

Additional steps are required for major verison releases.
If you are looking for minor version release, skip through below steps and start with the heading Minor Version.

## Major version
1. Create a tracker issue with deadlines and proposed RFEs or fixes (Refer [Example](https://github.com/gluster/glusterfs/issues/3023)) 

2. Pitch in about the same in gluster community meeting, discuss about the deadlines, and roadmap, incorporate if any changes are required in the roadmap.

3. Update [community packages page](https://docs.gluster.org/en/latest/Install-Guide/Community-Packages/) with release details, after the discussion with the packaging team (Kaleb - kkeithle@redhat.com, Neils - ndevos@redhat.com, Shwetha - sacharya@redhat.com, Sheetal - spamecha@redhat.com ).

4. Create release 10 label for github issues.

5. Request [redant tests](https://github.com/gluster/redant) are provisoned for new release branch by creating an issue in redant repo.

6. Create branch for the new release
   Choose a commit from where you want to branch, ideally we would take the    commit which has less failures or no failures,
   OR latest of develop branch
  
7. Follow steps in this [link](https://hackmd.io/mv7iVDypTxiXPrtN0yVVLg?view)

8. Update about the branch creation in community meeting. 
   Restrict branch merge to release owners (BZ request to infra)

 9. Creation of release notes and remaining steps are same as in steps and information listed under the heading  **Minor version**. 
Please refer from step 4 under the heading  **Minor version** until the end of this doc.



## Minor version
1. Open a tracking github issue to track the release work.
Example : https://github.com/gluster/glusterfs/issues/3099

2. Merge the patches listed by the below query :
Query : is:pr is:open label:"release 10"


3. check if previous release is having any patches which are absent in current release

    example:
    git diff release-8..release-7 > /tmp/original.branch-diff.txt

4. Create release notes containing issues that are resolved in the current release.

   Steps to create release notes :
   In the github cli cloned repository do the next steps.

   a. clone the glusterfs repo using git cli
      ```# gh repo clone git@github.com:gluster/glusterfs.git```


      Find Out how many issues have been reported
      (note 2000 should be replaced with a bigger number when we have
      issues more than 2000 )


   b. Fire the Script command to capture the output (note that script command       will capture everything that is typed in after firing script and 
      will store it in  file called typescript.

      ```#script```

   c. Fire the below command :

      ```# gh issue list -s "all" -L 2000```


   d. Press control+d to logout of the script mode


   e. Copy the output collected in the logfile to /tmp/

      ```# cp typescript /tmp/```


   f. In a separate terminal fire the below command to get the commit ids
      of the start and end commits of this release:

     ```# git log  --decorate --oneline --graph```

      Commit10 zzzzzz
      Commit9  yyyyyy
      Commit8 (tag v9.0)  xxxxx

      So I will pick commit8 and commit10 as the commits to be
      used in the next command. 


   g. Fire the below script and you will get the bug list:
     ```$  ~/new-release_notes.sh xxxxx zzzzzz ~/gitcli-cloned-repo/glusterfs /tmp/typescript```

   h. Open https://hackmd.io/ website and create a release notes by 
      using the above output. shorten/modify descriptions if incase 
      necessary inorder to convey better convey their purpose better


5. Release notes is to be merged in doc/release-notes on https://github.com/gluster/glusterfs of respective release branch.
Example: https://github.com/gluster/glusterfs/tree/release-10/doc/release-notes

6. Creating a tarball
Goto a jenkins job and fire it. Result will be a link.
https://build.gluster.org/job/release-new/
https://build.gluster.org/job/release-new/143/parameters/

7. Raising a request to create builds :
Sending an email to packaging@gluster.org
And pinging on the releasing-and-packing channel on gchat
(Kaleb - kkeithle@redhat.com, Neils - ndevos@redhat.com, Shwetha - sacharya@redhat.com, Sheetal - spamecha@redhat.com ) 


## Other essential changes to be made after packages are built and before the announcing the release:

> Debian:
1. Verify all the required packages are built for specific version and OS using [community guidelines](https://docs.gluster.org/en/latest/Install-Guide/Community-Packages/) and uploaded at https://download.gluster.org/pub/gluster/glusterfs

2. Make sure latest of all the versions. (Refer [Example](https://download.gluster.org/pub/gluster/glusterfs/LATEST/)), and latest of current version (Refer [Example](https://download.gluster.org/pub/gluster/glusterfs/10/LATEST/)) is updated.


> Suse:
1. Verify if all the required builds are successful at https://build.opensuse.org/project/subprojects/home:glusterfs with respect to the community guidelines


> Centos:
1. Download the packages once the packages are tagged for testing
Verify that the packages getting downloaded and working as expected.
Report any inconsistencies to Niels.

> Ubunutu:
1. Verify if all the required builds are successfully built at the [Launchpad](https://launchpad.net/~gluster/+archive/ubuntu)


> Glusterdocs:
1. Make sure that the release notes and required indexes are updated at glusterdocs

2. Incase of major releases:
   Update upgrade guide as well.

> gluster org:

1. incase of Major release update https://www.gluster.org/install/
 
## The final step:
Send out Announcement mail to glusterusers and glusterdevel mailing list

(Refer [Example](https://www.spinics.net/lists/gluster-users/msg39866.html))


# Procedure to build glusterfs suse packages

1. Trigger [github actions](https://github.com/Shwetha-Acharya/suse-build-automation) to automatically trigger suse builds.

2. Verify the trigger is successful, and packages are successfully listed at [build.opensuse.org](https://build.opensuse.org/project/subprojects/home:glusterfs)

3. Update the changelogs in  locally clonned [suse glusterfs repo](https://github.com/gluster/glusterfs-suse) and merge them:
```

#git push origin local_branch:remote_branch
eg: git push origin buster-glusterfs-4.1.10:buster-glusterfs-4.1

```

Refer [Example](https://github.com/gluster/glusterfs-suse/commit/adecbd3d2d5683da444a0a1e2cad46adbf36c8e2).


4. if incase build is not successfull, debug the issue at build logs of [build.opensuse.org](https://build.opensuse.org/project/subprojects/home:glusterfs) and modify the codebase. Retry manually by making changes at [build.opensuse.org](https://build.opensuse.org/project/subprojects/home:glusterfs) UI.

5. Push the changes to [suse glusterfs repo](https://github.com/gluster/glusterfs-suse) once the build is successfull.
Refer [Example](https://github.com/gluster/glusterfs-suse/commit/759f1211710df04fdcb5099acedd6d0abe7e6fb4)

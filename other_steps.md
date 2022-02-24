# Other steps:

1. get your user created at download.rht.gluster.org by filing a BZ at gluster infra.

2. scp the tar.gz file produced by the build to download.rht.gluster.org:/var/www/scratch (this method is followed as there’s not enough space in /tmp)

3. ssh to the download.rht.gluster.org

4. cd to /var/www/html/pub/gluster/glusterfs

   create the series, version, os and other required folders referring to existing [pattern](https://download.gluster.org/pub/gluster/glusterfs/)

6. cd to amd64/apt or arm64/apt of required version:
   Example:cd /var/www/html/pub/gluster/glusterfs/qa-releases/7.0rc0/Debian/stretch/amd64/apt

7. untar the packages
   example: sudo tar xpf /var/www/scratch/stretch…tar.gz

8. Update the overall latest verison, and latest version with respect to indivisual series.

9. don’t forget to delete the tar.gz files inside /var/www/scratch/ afterwards

   NOTE: These steps would be automated if this [PR](https://github.com/gluster/build-jobs/pull/44) is integrated to jenkins

10. update Readme files in download.rht.gluster.org as and when required and make sure symlinks are pointing to correct data for each release.

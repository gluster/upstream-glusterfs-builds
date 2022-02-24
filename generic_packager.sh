
#!/bin/bash

######################################################################################
This is genric packger script. It can be used to build gluster packages for ubuntu and
debian operating systems

Execution:
#bash generic_packager.sh <OS> <Flavor> <Series> <Version> <Release> 
#OS (e.g. Ubuntu/Debian)
#Series (e.g. 4.1)
#Version (e.g. 4.1.0)
#Release (e.g. 1)
#Flavor(e.g. Ubuntu - xenial/bionic/disco/eoan/focal, Debian - buster/stretch/bullseye)
#Type (qa/regular)

#Example: 'bash generic_packager.sh.sh debian stretch 6 4.1.0 1'
######################################################################################

os=$1
flavor=$2
series=$3
version=$4
release=$5

#Keys required in debian builds
declare -a debuild_keys
debuild_keys=("8B7C364430B66F0B084C0B0C55339A4C6A7BD8D4",
              "55F839E173AC06F364120D46FA86EEACB306CEE1",
              "32F8E2FDBE1460F94A62407E468C889BEEDF12A8",
              "F9C958A3AEE0D2184FAD1CBD43607F0DC2F8238C")

declare -a pbuild_keys
pbuild_keys=("7F6E5563", "EFCE7625", "4061252D", "BF11C87C")

# Check for OS(Ubuntu or Debian)
if [ "$os" == "ubuntu" ]; then
        mirror="http://ubuntu.osuosl.org/ubuntu/"
        debuild_key=4F5B5CA5
elif [ "$os" == "debian" ]; then
        mirror="http://ftp.us.debian.org/debian/"
        case ${series} in
          "3.12")
            debuild_key=${debuild_keys[0]}
            pbuild_key=${pbuild_keys[0]}
            ;;
          "4.0")
            debuild_key=${debuild_keys[1]}
            pbuild_key=${pbuild_keys[1]}
            ;;
          "4.1")
            if [ "$flavor" == "stretch" ]; then
                 debuild_key=${pbuild_keys[2]}
            else
                 debuild_key=${debuild_keys[2]}
            fi
            pbuild_key=${pbuild_keys[2]}
            ;;
          "5" | "6" | "7" | "8" | "9" | "10")
            if [ "$flavor" == "stretch" ]; then
                 debuild_key=${pbuild_keys[3]}
            else
                 debuild_key=${debuild_keys[3]}
            fi
            pbuild_key=${pbuild_keys[3]}
        esac
else
        echo "Exiting: OS should be debian or ubuntu. Please provide the right one"
        exit
fi

mkdir ${os}-${flavor}-Glusterfs-${version}

cd ${os}-${flavor}-Glusterfs-${version}

mkdir build packages

echo "Building glusterfs-${version}-${release} for ${flavor}"

cd build

TGZS=(`ls ~/glusterfs-${version}-?-*/build/glusterfs-${version}.tar.gz`)
echo ${TGZS[0]}

if [ -z ${TGZS[0]} ]; then
        echo "wget https://download.gluster.org/pub/gluster/glusterfs/${series}/${version}/glusterfs-${version}.tar.gz"
        wget https://download.gluster.org/pub/gluster/glusterfs/${series}/${version}/glusterfs-${version}.tar.gz
        For qa release
        #echo "wget https://download.gluster.org/pub/gluster/glusterfs/qa-releases/${version}/glusterfs-${version}.tar.gz"
        #wget https://download.gluster.org/pub/gluster/glusterfs/qa-releases/${version}/glusterfs-${version}.tar.gz
else
        echo "found ${TGZS[0]}, using it..."
        cp ${TGZS[0]} .
fi

echo "Creating link file.."
ln -s glusterfs-${version}.tar.gz glusterfs_${version}.orig.tar.gz

echo "Untaring.."
tar xpf glusterfs-${version}.tar.gz

# Changelogs needed for building are maintained in a separate repo.
# the repo has to be clone and updated properly so we can copy the changelogs so far.

echo "Cloning the glusterfs-debian repo"
git clone http://github.com/gluster/glusterfs-debian.git

cd glusterfs-debian/

git checkout -b ${flavor}-${series}-local origin/${flavor}-glusterfs-${series}

if [ "$os" == "ubuntu" ]; then
       sed -i "1i glusterfs (${version}-${os}1~${flavor}1) ${flavor}; urgency=medium\n\n * GlusterFS ${version} GA\n\n -- GlusterFS GlusterFS deb packages <deb.packages@gluster.org>  `date +"%a, %d %b %Y %T %z"`\n" debian/changelog
elif [ "$os" == "debian" ]; then
       sed -i "1i glusterfs (${version}-1) ${flavor}; urgency=low\n\n  [ Gluster Packager ]\n  * GlusterFS ${version} GA\n\n -- Gluster Packager <glusterpackager@download.gluster.org>  `date +"%a, %d %b %Y %T %z"`\n" debian/changelog
fi

git commit -a -m "Glusterfs ${version} G.A (${flavor})"
git show

echo "Pushing Changelog changes.."
git push origin ${flavor}-${series}-local:${flavor}-glusterfs-${series}

echo "Copying Changelog to source"
cp -a debian ../glusterfs-${version}/

echo "Building source package.."
cd ../glusterfs-${version}
debuild -S -sa -k${debuild_key}

echo "Uploading the packages.."
if [ "$os" == "ubuntu" ]; then
        dput ppa:gluster/glusterfs-${series} ../glusterfs_${version}-${os}1~${flavor}1_source.changes

    echo "Done"
    exit
fi

# we are using the same builder machine to build so we are running the "pbuilder
# create" everytime to create the chroot according to the os and flavor we want to build.
echo "creating chroot for ${os} ${flavor}"
sudo pbuilder create --distribution ${flavor} --mirror ${mirror} --debootstrapopts --keyring=/usr/share/keyrings/${os}-archive-keyring.gpg

echo "Building glusterfs-${version} for ${os} ${flavor} using the chroot and .dsc we created"

# have to use the .dsc file inside the ${os}${flavor} folder
sudo pbuilder build ~/${os}-${flavor}-Glusterfs-${version}/build/glusterfs_${version}-${release}.dsc | tee build.log

#move the packages to packages directory.
sudo mv /var/cache/pbuilder/result/glusterfs*${version}-${release}*.deb ~/${os}-${flavor}-Glusterfs-${version}/packages/
if [ "$flavor" != "stretch" ]; then
     sudo mv /var/cache/pbuilder/result/libg*${version}-${release}*.deb ~/${os}-${flavor}-Glusterfs-${version}/packages/
fi
/usr/share/debdelta/dpkg-sig -v -k ${pbuild_key} --sign builder ~/${os}-${flavor}-Glusterfs-${version}/packages/glusterfs-*${version}-${release}*.deb

cd /var/www/repos/apt/debian/

rm -rf pool/* dists/* db/*

cp ~/conf.distributions/${series} conf/distributions

echo "Uploading the packages.."
for i in ~/${os}-${flavor}-Glusterfs-${version}/packages/glusterfs-*${version}-${release}*; do reprepro includedeb $flavor $i; done
if [ "$flavor" != "stretch" ]; then
     for i in ~/${os}-${flavor}-Glusterfs-${version}/packages/libg*${version}-${release}*.deb; do reprepro includedeb ${flavor} $i; done
fi
reprepro includedsc ${flavor} ~/${os}-${flavor}-Glusterfs-${version}/build/glusterfs_${version}-${release}.dsc

tar czf ~/${os}-${flavor}-Glusterfs-${version}/${flavor}-apt-amd64-${version}.tgz pool/ dists/

echo "Done."

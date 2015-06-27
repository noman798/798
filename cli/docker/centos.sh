yum update -y
yum install tmux docker nginx mercurial -y

cd /home
mkdir -p docker

hg clone https://bitbucket.org/798r/798_docker_home 798
cd 798
/bin/rm .hg -rf

cd 798
hg clone https://bitbucket.org/798r/798 798


---
pageTitle: Tools
---

<md-icon class="fa fa-clock-o fa-lg" aria-hidden="true"></md-icon> Time to complete 15ms


# <a name="set_tools">Installing tools </a>


## MacOS

- **envsubst**

```
brew install gettext
brew link --force gettext
```

Verify the installation

`envsubst --help`

<i class="fa fa-spinner fa-pulse fa-fw"></i>
The output will be similar to this,
```
Usage: envsubst [OPTION] [SHELL-FORMAT]

Substitutes the values of environment variables.

Operation mode:
  -v, --variables             output the variables occurring in SHELL-FORMAT

Informative output:
  -h, --help                  display this help and exit
  -V, --version               output version information and exit
```

- **kubectl**
```
brew install kubernetes-cli
```

Verify the installation

`kubectl version`

- **git**
```
brew install git
```

Verify the installation

`git --version`


## Ubuntu/Debian

- **kubectl**
```
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

Verify the installation

`kubectl version`

- **git**
```
sudo apt-get install git-core
```

Verify the installation

`git --version`


## CentOS

- **kubectl**
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl
```

Verify the installation

`kubectl version`

- **git**
```
sudo yum install git
```

Verify the installation

`git --version`


## Windows

- **kubectl**

Run the installation commands in _Powershell_ (making sure to specify a DownloadLocation)
```
Install-Script -Name install-kubectl -Scope CurrentUser -Force
install-kubectl.ps1 [-DownloadLocation <path>]
```

Verify the installation

`kubectl version`

- **git**
```
choco install git
```

Verify the installation

`git --version`






export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-syntax-highlighting kubectl)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh



# export NVM_DIR="$HOME/.nvm"
#   [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"  # This loads nvm
#   [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


######## Kube Aliases ########
alias k="kubectl"
alias kgp="kubectl get pods"
alias kl="kubectl logs"
alias klf="kubectl logs -f"
alias knames="kubectl get pods --no-headers -o custom-columns=":metadata.name""
alias knamesf="kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep"


####### Git Aliases #######
alias gcs="git commit -S -m"
alias gch="git checkout"
alias gchb="git checkout -b"
alias gitgraph="git log --all --decorate --oneline --graph"
alias lz="lazygit"

###### Utils ######
alias search="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs nvim"
alias ts="tmux new -A -s"

###### MISC ######
alias byebye="sudo shutdown -h now"
alias v="nvim"




export PATH=$PATH:~/go/bin/ # add Go path binaries
export PATH=$PATH:~/.cargo/bin # add cargo binaries
export PATH=$PATH:/usr/local/bin # add homebrew binaries

export EDITOR=nvim

source ~/.nvm/nvm.sh

source "/opt/homebrew/opt/spaceship/spaceship.zsh"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export JAVA_HOME="/opt/homebrew/Cellar/openjdk/21.0.1"
export PATH=$JAVA_HOME/bin:$PATH
export HOMEBREW_NO_AUTO_UPDATE=1

export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

export TERM=tmux-256color



##### General Functions ######
gover () { 
    t="/tmp/go-cover.$$.tmp"
    go test ./... -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}

# PR function that checks out a PR branch git pull the origin and then checks out the branch
#  Usage: pr <source_branch> <destination_branch> [rebase]
pr() {
  if [ $# -lt 2 ]; then
    echo "Usage: pr <source_branch> <destination_branch> [rebase]"
    return 1
  fi

  local source_branch="$1"
  local destination_branch="$2"
  local use_rebase="${3:-}"

  git fetch origin || {
    echo "Failed to fetch from origin"
    return 1
  }

  git checkout "$destination_branch" || {
    echo "Failed to checkout branch: $destination_branch"
    return 1
  }

  git pull || {
    echo "Failed to pull latest changes for: $destination_branch"
    return 1
  }

  if [ "$use_rebase" = "rebase" ]; then
    git pull --rebase origin "$source_branch" || {
      echo "Rebase failed from: $source_branch"
      return 1
    }
  else
    git pull origin "$source_branch" --no-rebase || {
      echo "Merge failed from: $source_branch"
      return 1
    }
  fi

  git push || {
    echo "Push failed"
    return 1
  }

  git checkout "$source_branch" || {
    echo "Failed to switch back to: $source_branch"
    return 1
  }
}


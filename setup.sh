tmutil localsnapshot
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

## switch off Gatekeeper
sudo spctl --master-disable .

echo /usr/local/bin/bash | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash

for f in  /Applications/*; do xattr -d com.apple.quarantine  "$f"; done

dockutil --remove all
dockutil --add "~/Desktop"
dockutil --add "~/Downloads"

cat > ~/.docker/daemon.json <<EOF
{
  "debug": true,
  "insecure-registries": [
    "registry.k8z.eu",
    "docker.for.mac.localhost:5000",
    "registry.ing.k8z.eu",
    "localhost:5000"
  ],
  "experimental": true,
  "features": {
    "buildkit": true
  }
}
EOF

hosts() {
  echo 127.0.0.1 lo loc |sudo tee -a /etc/hosts
}

tmux-plugins(){
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  # minimal tmux conf
  cat >  ~/.tmux.conf <<EOF
set-window-option -g mode-keys vi

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'

run -b '~/.tmux/plugins/tpm/tpm'
EOF

}

powerline() {
    # powerline font
    curl -Lo /Library/Fonts/Ubuntu-Mono-Powerline-Bold.ttf  https://github.com/Lokaltog/powerline-fonts/raw/master/UbuntuMono/Ubuntu%20Mono%20derivative%20Powerline%20Bold.ttf
    open /Library/Fonts/Ubuntu-Mono-Powerline-Bold.ttf
    echo "source '$(find ~/.virtualenv/ -name powerline.conf)'" >> ~/.tmux.conf
     
    curl -Lo ~/Downloads/tomorrow.terminal "https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/OS%20X%20Terminal/Tomorrow%20Night.terminal"
    open ~/Downloads/tomorrow.terminal
     
    cat<<EOF
########################
go to Terminal/Preferences/Settings/Text/Font/Change
and select the Ubuntu Mono font
########################
EOF

}

short_passwd(){
    pwpolicy getaccountpolicies > ~/Desktop/file.plist
    sed -i.bak '1 d; s/{4,}/{2,}/' ~/Desktop/file.plist 
    pwpolicy setaccountpolicies ~/Desktop/file.plist
}
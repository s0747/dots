# dots

# Kickstart
```
sudo apt install -y \
git \
build-essential \
locate \
cmake \
stow \
rustup \
neovim  \
tmux \
fzf
```

```
echo 'source /usr/share/doc/fzf/examples/key-bindings.bash' >> ~/.bashrc
echo 'source /usr/share/doc/fzf/examples/completion.bash' >> ~/.bashrc
echo 'export TERM=xterm-256color' >> ~/.bashrc
source  ~/.bashrc
```

- NVIM
```
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build
cpack -G DEB
sudo dpkg -i nvim-linux64.deb


sudo update-alternatives --install /usr/bin/vi vi "$(command -v nvim)" 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim "$(command -v nvim)" 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor "$(command -v nvim)" 60
sudo update-alternatives --config editor
```

- RUST
```
rustup default stable
cargo install cargo-binstall
cargo binstall watchexec-cli
```

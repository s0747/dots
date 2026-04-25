# dots

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
cargo install --locked watchexec-cli
or
cargo install cargo-binstall
cargo binstall watchexec-cli
```

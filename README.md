# My Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## 📁 Structure

```
~/dotfiles/
├── bash/          # Bash configuration
├── nvim/          # Neovim configuration
└── ...            # Other application configs
```

Each folder is a "package" that contains config files in the same structure they should have in the home directory.

## Requirements

### Git
```bash
sudo apt install git
```

### Stow
```bash
sudo apt install stow
```


## Installation 

1. **Clone this repository:**
   ```bash
   cd ~
   git clone 
   ```

2. **Stow the packages you want:**
   ```bash
   cd ~/dotfiles
   stow bash
   stow nvim
   # or stow everything at once:
   stow */
   ```

## Usage

**Install a package (create symlinks):**
```bash
stow <package-name>
```

**Remove a package (delete symlinks):**
```bash
stow -D <package-name>
```

**Update a package (refresh symlinks):**
```bash
stow -R <package-name>
```

**Preview changes without applying:**
```bash
stow -n <package-name>
```

## Making Changes

1. Edit the config files normally (the symlinks make changes automatic)
2. Commit and push your changes:
   ```bash
   cd ~/dotfiles
   git add .
   git commit -m "Update configuration"
   git push
   ```

3. Pull changes on other machines:
   ```bash
   cd ~/dotfiles
   git pull
   ```

## Adding New Configs

1. Create a new package folder:
   ```bash
   mkdir ~/dotfiles/newapp
   ```

2. Move your config files into it (maintaining directory structure):
   ```bash
   mv ~/.config/newapp ~/dotfiles/newapp/.config/
   ```

3. Stow it:
   ```bash
   cd ~/dotfiles
   stow newapp
   ```

## ⚠️ Notes

- Always run `stow` from the `~/dotfiles` directory
- Package folders should mirror the structure relative to `~`
- Don't commit sensitive data (use `.gitignore` for secrets)

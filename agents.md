# CRUSH.md for Nix Configurations

This file outlines conventions and commands for agents operating in this NixOS configuration repository.

## Build/Lint/Test Commands

- **Build entire NixOS system:** `nilla os build <host-name>`
- **Build entire home-manager system:** `nilla home build <host-name>`
- **Build a specific package (e.g., `crush`):** `nilla build crush`

## Code Style Guidelines

- **Nix Formatting:** Adhere to `alejandra` for all Nix files.
- **File Structure:**
    - `modules/home/`: Home-manager configurations.
    - `modules/nixos/`: NixOS system configurations.
    - `hosts/`: Host-specific configurations (e.g., `cl01`, `links`).
    - `packages/`: Custom Nix packages.
- **Imports:** Use relative paths for imports within the repository, and `nixpkgs` for standard packages.
- **Naming Conventions:**
    - Use `kebab-case` for file names and directory names.
    - Use `camelCase` for Nix attributes where appropriate (e.g., `extraConfig`).
- **Error Handling:** Nix expressions primarily rely on static analysis and build failures for error indication. Ensure configurations are syntactically correct and referentially sound.
- **Documentation:** Add comments (`#`) for complex Nix expressions or when defining system-specific details.

## Agent-Specific Rules

- Always prioritize non-disruptive changes.
- Before suggesting changes to Nix expressions, ensure you understand the potential impact on system configurations.

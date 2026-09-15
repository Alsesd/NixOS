# NixOS Configuration Documentation

## Overview

This document describes the NixOS configuration located at `~/.config/nixos/`. The setup is organized around a **flake-based** approach with modular feature modules.

### Key Components

- **`flake.nix`** – Main flake defining inputs, outputs, and feature composition.
- **`nixos/modules/parts.nix`** – Base module defining supported operating systems and per-system configurations.
- **`nixos/modules/user.nix`** – User account, home-manager integration, and application packages.
- **`nixos/modules/features/`** – Feature modules organized by category:
  - **GUI** – Themes (niri, noctalia, stylix), display settings, session managers (greetd, niri, noctalia).
  - **Hardware** – GPU (chaotic-chachyos, cpu, nvidia), storage, and peripherals.
  - **Services** – System tweaks, Tailscale, wallpaper management.
  - **Shells** – Zsh, Starship, Fastfetch, Python environments.
  - **Soft** – Alternative shells (kitty, steam, zed) and utilities.

---

## Directory Structure

```
.nixos/
├── flake.nix                    # Main flake definition
├── modules/
│   ├── parts.nix                # Base system configuration
│   ├── user.nix                 # User & home-manager setup
│   └── features/
│       ├── GUI/                  # Themes & display
│       │   ├── greeted.nix
│       │   ├── niri.nix
│       │   ├── noctalia.nix
│       │   └── stylix.nix
│       ├── hardware/             # GPU, CPU, storage
│       │   ├── chaotic-chachyos.nix
│       │   ├── cpu.nix
│       │   └── nvidia.nix
│       ├── services/             # System tweaks, Tailscale, wallpaper
│       │   ├── system-tweaks.nix
│       │   ├── tailscale.nix
│       │   └── wallpaper.nix
│       ├── shells/               # Shell environments
│       │   ├── zsh.nix
│       │   ├── starship.nix
│       │   ├── fastfetch.nix
│       │   └── python.nix
│       └── soft/                # Alternatives (kitty, steam, zed)
│           ├── kitty.nix
│           ├── steam.nix
│           └── zed.nix
```

---

## Flake (`flake.nix`)

### Inputs

| Input | Description |
|-------|-------------|
| `nixpkgs` | Core Nix package repository (unstable branch). |
| `flake-parts` | Provides `mkFlake` helper for building composite flakes. |
| `home-manager` | Home-manager for system administration. |
| `stylix` | Stylized desktop environment. |
| `niri` | NIRI framework for themes and desktops. |
| `chaotic` | Nyx kernel for Chaotic Cychros. |
| `wrapper-modules` | Nix wrappers for additional features. |
| `zen-browser` | Zen Browser desktop. |
| `freesmlauncher` | Freesm Launcher for multi-app management. |

### Outputs

The flake produces a single output:

```
myNixos = { inputs.nixpkgs.follows = "nixpkgs"; }
```

---

## Module Breakdown

### 1. `parts.nix`

Defines the list of supported systems and per-system configurations:

```nix
{ systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ]; }
```

Per-system configuration (`perSystem`) enables `allowUnfree = true` and optionally configures CUDA support.

### 2. `user.nix`

Creates a dedicated user (`${vars.username}`), integrates **Home Manager**, and installs a curated set of packages:

- **Shell**: Zsh with autocomplete, completion, and aliases.
- **Desktop**: Home-managed packages (discord, qbittorrent, vlc, slack, etc.).
- **Programs**: yazi, zsh-nix-shell, nixd, htop, etc.
- **System Settings**: Timezone (`Europe/Kiev`), wallpaper path, systemd user toggles.

### 3. Feature Modules

#### GUI (Themes & Displays)
- **greetd.nix** – Greeter session with welcome message.
- **niri.nix** – NIRI-based theme (dark mode, color schemes).
- **noctalia.nix** – Night-light-themed UI with extensive widget layout.
- **stylix.nix** – Stylus framework with custom fonts (JetBrains Mono, Inter, Noto Serif).

#### Hardware (GPU & CPU)
- **chaotic-chachyos.nix** – Chaquos kernel, NVIDIA driver stack, GPU acceleration.
- **cpu.nix** – Intel microcode updates, undervolt settings.
- **nvidia.nix** – NVIDIA container toolkit, DRM modes, Vulkan setup.

#### Services
- **system-tweaks.nix** – Early OOM killer, `fstrim`, direnv for Zsh integration.
- **tailscale.nix** – Tailscale VPN integration.
- **wallpaper.nix** – Automatic wallpaper switching via `swaybg`.

#### Shells
- **zsh.nix** – Zsh with Oh My Zsh, aliases for system commands, shell integrations.
- **starship.nix** – Advanced terminal prompt with colored palette (base16).
- **fastfetch.nix** – Hardware monitoring CLI with ASCII art.
- **python.nix** – Python 3.12 environment with CUDA support and ML RNN example.

#### Soft (Alternatives)
- **kitty.nix** – Lightweight tiling shell.
- **steam.nix** – Steam client integration.
- **zed.nix** – Zed terminal emulator.

---

## Refactoring Suggestions

### 1. Consolidate Parameters

The current configuration duplicates `vars` (username, wallpaper) across multiple modules. A cleaner approach is to centralize all shared variables in a single `vars.nix` and import them wherever needed.

**Current pattern:**
```nix
# user.nix
variables = { vars = { username = "alsesd"; wallpaper = "/home/alsesd/Pictures/NixWallBin.png"; }; }
```

**Suggested consolidation:**
```nix
# nixos/modules/vars.nix
variables = {
  username = "alsesd"
  wallpaper = "/home/alsesd/Pictures/NixWallBin.png"
}
```
Then import this `vars` object into `user.nix`, `parts.nix`, and all feature modules via `imports = [ self.nixosModules.vars ]`.

### 2. Merge Feature Definitions

Currently, each feature module repeats theme definitions (palette, colors, widgets). Consider moving these into a shared library:

- Create `nixos/modules/shared/colors.nix` for palette constants.
- Extract widget layouts from `noctalia.nix` into `nixos/modules/shared/ui/layouts.nix`.
- Use `flake-parts` to compose modules declaratively rather than manually importing dozens of sub-modules.

### 3. Separate Host Configuration

The `hosts/my-machine/configuration.nix` imports many sub-modules. Consider splitting into:
- `hosts/my-machine/core.nix` – Common system settings.
- `hosts/my-machine/graphics.nix` – GPU and display configuration.
- `hosts/my-machine/general.nix` – Timezone, locale, and basic policies.

### 4. Parameter Standardization

All modules should declare their public API using `export` so consumers can query them safely:
```nix
# In a module
flake.nixosModules.myFeature = { ... }: {
  exports = { myFeature = ...; };
}
```

---

## Quick Customization Guide

| Goal | Command |
|------|----------|
| Update Nixpkgs | `nix flake update` |
| Apply changes | `sudo nixos-rebuild boot --flake ~/.config/nixos/myNixos` |
| View config | `cat ~/.config/nixos/modules/features/` |
| List modules | `nix list -f flake.nix` |

---

## License & Credits

- **Base**: NixOS (community-driven).
- **Features**: stylix, niri, chaotic, zen-browser, freesmlauncher.
- **Tools**: Zsh, Starship, Fastfetch, Python, CUDA toolkit.

---

*Document generated from `~/.config/nixos/`*

---

# Документация по конфигурации NixOS (RU)

## Обзор

Этот документ описывает конфигурацию NixOS в `~/.config/nixos/`. Она построена на **flake**-подходе с модульными компонентами.

### Основные компоненты

- **`flake.nix`** — основной flake с входами и выходами.
- **`nixos/modules/parts.nix`** — базовый модуль с поддерживаемыми системами.
- **`nixos/modules/user.nix`** — пользователь, home-manager, пакеты.
- **`nixos/modules/features/`** — модули функций:
  - **GUI** — темы, дисплей, сессии (greetd, niri, noctalia, stylix).
  - **Hardware** — GPU, CPU, NVIDIA.
  - **Services** — системные настройки, Tailscale, обои.
  - **Shells** — Zsh, Starship, Fastfetch, Python.
  - **Soft** — альтернативы (kitty, steam, zed).

---

## Структура каталогов

```
.nixos/
├── flake.nix                    # Основное определение flake
├── modules/
│   ├── parts.nix                # Базовая системная конфигурация
│   ├── user.nix                 # Пользователь и home-manager
│   └── features/
│       ├── GUI/                  # Темы и дисплей
│       │   ├── greeted.nix
│       │   ├── niri.nix
│       │   ├── noctalia.nix
│       │   └── stylix.nix
│       ├── hardware/             # GPU, CPU, хранилище
│       │   ├── chaotic-chachyos.nix
│       │   ├── cpu.nix
│       │   └── nvidia.nix
│       ├── services/             # Системные настройки, Tailscale, обои
│       │   ├── system-tweaks.nix
│       │   ├── tailscale.nix
│       │   └── wallpaper.nix
│       ├── shells/               # Окружения оболочки
│       │   ├── zsh.nix
│       │   ├── starship.nix
│       │   ├── fastfetch.nix
│       │   └── python.nix
│       └── soft/                # Альтернативы (kitty, steam, zed)
│           ├── kitty.nix
│           ├── steam.nix
│           └── zed.nix
```

---

## Flake (`flake.nix`)

### Входы

| Вход | Описание |
|------|----------|
| `nixpkgs` | Основное хранилище пакетов Nix (нестабильная ветка). |
| `flake-parts` | Предоставляет `mkFlake` для составления составных flake. |
| `home-manager` | Home-manager для администрирования системы. |
| `stylix` | Стилизованная рабочая среда. |
| `niri` | Фреймворк NIRI для тем и рабочих столов. |
| `chaotic` | Ядро Nyx для Chaotic Cychros. |
| `wrapper-modules` | Nix-обёртки для дополнительных функций. |
| `zen-browser` | Рабочий стол Zen Browser. |
| `freesmlauncher` | Freesm Launcher для управления множеством приложений. |

### Выходы

Flake производит один выход:

```
myNixos = { inputs.nixpkgs.follows = "nixpkgs"; }
```

---

## Разбор модулей

### 1. `parts.nix`

Определяет список поддерживаемых систем и конфигурацию на систему:

```nix
{ systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ]; }
```

Конфигурация на систему (`perSystem`) включает `allowUnfree = true` и опционально настраивает поддержку CUDA.

### 2. `user.nix`

Создаёт отдельного пользователя (`${vars.username}`), интегрирует **Home Manager** и устанавливает curated набор пакетов:

- **Оболочка**: Zsh с автодополнением, завершением и алиасами.
- **Рабочий стол**: Пакеты home-manager (discord, qbittorrent, vlc, slack и др.).
- **Программы**: yazi, zsh-nix-shell, nixd, htop и др.
- **Системные настройки**: Часовой пояс (`Europe/Kiev`), путь к обоям, переключатели systemd пользователя.

### 3. Модули функций

#### GUI (Темы и дисплеи)
- **greetd.nix** — Сессия greeter с приветственным сообщением.
- **niri.nix** — Тема на основе NIRI (тёмный режим, цветовые схемы).
- **noctalia.nix** — UI с ночным освещением и обширной компоновкой виджетов.
- **stylix.nix** — Фреймворк Stylus с пользовательскими шрифтами (JetBrains Mono, Inter, Noto Serif).

#### Аппаратное обеспечение (GPU и CPU)
- **chaotic-chachyos.nix** — Ядро Chaquos, стек драйверов NVIDIA, ускорение GPU.
- **cpu.nix** — Обновления микрокода Intel, настройки undervolt.
- **nvidia.nix** — NVIDIA container toolkit, режимы DRM, настройка Vulkan.

#### Службы
- **system-tweaks.nix** — Ранний OOM killer, `fstrim`, direnv для интеграции с Zsh.
- **tailscale.nix** — Интеграция Tailscale VPN.
- **wallpaper.nix** — Автоматическое переключение обоев через `swaybg`.

#### Оболочки
- **zsh.nix** — Zsh с Oh My Zsh, алиасами для системных команд, интеграциями оболочки.
- **starship.nix** — Расширенный терминальный промпт с цветовой палитрой (base16).
- **fastfetch.nix** — CLI мониторинга оборудования с ASCII-арт.
- **python.nix** — Окружение Python 3.12 с поддержкой CUDA и примером ML RNN.

#### Soft (Альтернативы)
- **kitty.nix** — Лёгкая плиточная оболочка.
- **steam.nix** — Интеграция клиента Steam.
- **zed.nix** — Терминальный эмулятор Zed.

---

## Предложения по рефакторингу

### 1. Объединить параметры

Текущая конфигурация дублирует `vars` (имя пользователя, обои) в нескольких модулях. Лучший подход — централизовать все общие переменные в одном `vars.nix` и импортировать их везде, где нужно.

**Текущий шаблон:**
```nix
# user.nix
variables = { vars = { username = "alsesd"; wallpaper = "/home/alsesd/Pictures/NixWallBin.png"; }; }
```

**Предлагаемая консолидация:**
```nix
# nixos/modules/vars.nix
variables = {
  username = "alsesd"
  wallpaper = "/home/alsesd/Pictures/NixWallBin.png"
}
```
Затем импортировать этот объект `vars` в `user.nix`, `parts.nix` и все модули функций через `imports = [ self.nixosModules.vars ]`.

### 2. Объединить определения функций

В настоящее время каждый модуль функции повторяет определения тем (палитра, цвета, виджеты). Рассмотрите возможность вынесения этих элементов в общую библиотеку:

- Создайте `nixos/modules/shared/colors.nix` для констант палитры.
- Извлеките компоновку виджетов из `noctalia.nix` в `nixos/modules/shared/ui/layouts.nix`.
- Используйте `flake-parts` для декларативного составления модулей вместо ручного импорта десятков подмодулей.

### 3. Разделить конфигурацию хоста

`hosts/my-machine/configuration.nix` импортирует множество подмодулей. Рассмотрите разделение на:
- `hosts/my-machine/core.nix` — Общие системные настройки.
- `hosts/my-machine/graphics.nix` — Конфигурация GPU и дисплея.
- `hosts/my-machine/general.nix` — Часовой пояс, локаль и базовые политики.

### 4. Стандартизация параметров

Все модули должны объявлять свой публичный API с помощью `export`, чтобы потребители могли безопасно их запрашивать:
```nix
# В модуле
flake.nixosModules.myFeature = { ... }: {
  exports = { myFeature = ...; };
}
```

---

## Быстрое руководство по настройке

| Цель | Команда |
|------|----------|
| Обновить Nixpkgs | `nix flake update` |
| Применить изменения | `sudo nixos-rebuild boot --flake ~/.config/nixos/myNixos` |
| Посмотреть конфигурацию | `cat ~/.config/nixos/modules/features/` |
| Список модулей | `nix list -f flake.nix` |

---

## Лицензия и благодарности

- **База**: NixOS (сообщество-ориентированный).
- **Функции**: stylix, niri, chaotic, zen-browser, freesmlauncher.
- **Инструменты**: Zsh, Starship, Fastfetch, Python, CUDA toolkit.

---

*Документация сгенерирована из `~/.config/nixos/`*

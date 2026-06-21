# Agent Workflow Guide

This document defines the mandatory workflow for all AI agents working on the `esphome-display` repository. Following these rules ensures consistency, prevents conflicts, and maintains high code quality. All GitHub interactions **MUST** be performed using the GitHub CLI (`gh`) rather than the web browser where possible.

## 1. Branch Naming & Usage

Always use a new feature branch for your task. Do not work directly on the `main` branch. If a branch for your task has not already been created, create one before making any changes.

All branches must be named according to [Conventional Commits](https://www.conventionalcommits.org/):
- `feat/`: New features
- `fix/`: Bug fixes
- `docs/`: Documentation changes
- `style/`: Formatting, missing semicolons, etc.; no code changes
- `refactor/`: Refactoring production code
- `test/`: Adding missing tests, refactoring tests; no production code changes
- `chore/`: Updating build tasks, package manager configs, etc.; no production code changes

Example: `feat/add-boot-sound` or `fix/ports-alignment`.

## 2. Pull Request Management

Once changes are complete, push the branch and create a pull request.

- **Detailed Description**: You **MUST** write a detailed title and description for the PR providing a clear explanation of:
  - **Purpose**: Why are these changes being made?
  - **Implementation**: How were the changes implemented? Highlight any significant design or implementation details.
- **Auto-Merge**: It is recommended to enable auto-merge when creating a pull request:
  ```bash
  gh pr create --fill
  gh pr merge --auto --merge
  ```

## 3. GitHub CLI Authentication

To facilitate automated GitHub interactions, agents must use a Personal Access Token (PAT) stored in the `.gh-token` file in the repository root.

- **Authentication**: Before running any `gh` commands, ensure you are authenticated by passing the token from `.gh-token`:
  ```bash
  gh auth login --with-token < .gh-token
  ```
- **Security**: The `.gh-token` file is included in `.gitignore` to prevent accidental commits. Never share or commit this file.

## 4. ESPHome Commands via Docker

All ESPHome compilation, validation, and configuration checks **MUST** be run using the official ESPHome Docker container, rather than using a local pip installation.

- **Config Validation**:
  To validate the ESPHome YAML configuration file, run:
  ```bash
  docker run --rm -v "$(pwd):/config" -w /config esphome/esphome config esphome/openscad-display.yaml
  ```

- **Compilation**:
  To compile the ESPHome binary, run:
  ```bash
  docker run --rm -v "$(pwd):/config" -w /config esphome/esphome compile esphome/openscad-display.yaml
  ```


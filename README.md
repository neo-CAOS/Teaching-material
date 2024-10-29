# Computer Architectures and Operating Systems

This repository contains all the materials and exercises for the **Computer Architectures and Operating Systems** course. The repository utilizes a script to keep all submodules up to date and provides a structured way to work on personal modifications within a separate branch.

## ⚠️ Important Notice

> **Note:** The current implementation is not fully up to date. Modifications will follow to address all outstanding issues.
> **Note:** The pulling and data collection from all submodules works, but managing the personal branch for developing personal modifications is still not functioning.

## Table of Contents
- [Overview](#overview)
- [Structure](#structure)
- [Usage](#usage)
  - [Cloning the Repository](#cloning-the-repository)
  - [Running the Update Script](#running-the-update-script)
  - [Creating a Personal Branch](#creating-a-personal-branch)
- [Current Repositories](#current-repositories)
- [Contributing](#contributing)
- [License](#license)

## Overview

This repository serves as a collection point for all the labs and exercises related to the course. It is designed to automatically clone or pull updates from the official teaching repositories and to provide a clear workflow for adding personal modifications to the exercises.

By using a script to manage submodules, the repository ensures that all dependencies and repositories are always up-to-date. The repository also supports working on a separate branch called `personal` to track personal modifications without affecting the main repository.

## Structure

- `Laboratories/`: Contains all laboratory repositories.
- `Exercises/`: Contains all exercise repositories.
- `urls.txt`: A file containing all repository URLs and their custom names.
- `manage_submodules.sh`: A script used to automatically clone and update all submodules (laboratories and exercises).
  
## Usage

### Cloning the Repository

To clone the repository along with all the submodules:

```bash
git clone --recurse-submodules https://github.com/eliainnocenti/Computer-Architectures-and-Operating-Systems.git
cd Computer-Architectures-and-Operating-Systems
```

### Running the Update Script

The script `manage_submodules.sh` automates the process of updating all the submodules (labs and exercises). It reads repository URLs from the `urls.txt` file, clones them (if not already cloned), or pulls updates from the remote repositories.

To run the script:

```bash
./manage_submodules.sh
```

The script will:

1. Clone any missing repositories into the `Laboratories/` and `Exercises/` directories.
2. Pull updates for existing repositories.

### Creating a Personal Branch

To work on the exercises and make your own modifications without affecting the main repository, follow these steps to create a new `personal` branch:

1. Switch to the `main` branch (if you're not already on it):

    ```bash
    git checkout main
    ```
    
2. Create and switch to a new branch called `personal`:

    ```bash
    git checkout -b personal
    ```
    
3. Make your changes and commit them:

    ```bash
    git add .
    git commit -m "My modifications to the exercises"
    ```

4. Push your personal `branch` to GitHub:

    ```bash
    git push -u origin personal
    ```
    
Once the branch is pushed, you will be able to switch between the `main` and `personal` branches in GitHub and view your modifications by selecting the corresponding branch.

## Current Repositories

Below is the current list of repositories managed by the script:

| Type      | Repository URL                                                                                      | Custom Name             |
|-----------|-----------------------------------------------------------------------------------------------------|-------------------------|
| CAOS      | [CAOS Repository](https://baltig.polito.it/teaching-material/CAOS.git)                            | CAOS Repository         |
| Lab       | [Lab1 - Setup](https://baltig.polito.it/teaching-material/labs-caos-and-os/lab-1-setup.git)      | Lab1 - Setup            |
| Lab       | [Lab2 - baremetal](https://baltig.polito.it/teaching-material/labs-caos-and-os/lab2-baremetal.git) | Lab2 - baremetal        |
| Lab       | [Lab3 - FreeRTOS](https://baltig.polito.it/teaching-material/labs-caos-and-os/lab3-freertos.git)  | Lab3 - FreeRTOS        |
| Exercise  | [ARM Bare Metal](https://baltig.polito.it/teaching-material/exercises-caos-and-os/arm-bare-metal.git) | ARM Bare Metal          |
| Exercise  | [CrossCompilation](https://baltig.polito.it/teaching-material/exercises-caos-and-os/crosscompilation.git) | CrossCompilation        |
| Exercise  | [FreeRTOS_HelloWorld](https://baltig.polito.it/teaching-material/exercises-caos-and-os/freertos_helloworld.git) | FreeRTOS_HelloWorld    |
| Exercise  | [MyFirstOS](https://baltig.polito.it/teaching-material/exercises-caos-and-os/myfirstos.git)      | MyFirstOS               |
| Exercise  | [Process Scheduling](https://baltig.polito.it/teaching-material/exercises-caos-and-os/process-scheduling.git) | Process Scheduling       |

## Contributing

Feel free to fork the repository and make pull requests to improve the workflow or fix any issues. Contributions are always welcome!

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

### How to Use

- Copy the above content into a file named `README.md` and place it in the root directory of your repository.
- This provides a comprehensive overview of how to manage the repositories and how the script works, including a section for personal modifications.

Let me know if you'd like any changes!

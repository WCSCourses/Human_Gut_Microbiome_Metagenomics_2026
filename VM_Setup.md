## Part A: Steps to Create a Virtual Machine

1. **Open VirtualBox** and navigate to: 
   - `Machine > New`
   
   ![VirtualBox Manager](https://github.com/WCSCourses/WCS_Internal_Guides/blob/main/Guide_Images_Folder/4_a.png)

2. **Enter Virtual Machine Details:**
   - **Name:** `CourseNameAbbreviatedYear` (Example: `CGA2025`)
   - **Folder:** Select previously created folder.
   - **ISO Image:** Select the downloaded Ubuntu ISO file.
   - The Type and Version fields will auto-fill.
   - Click **Next**.

   ![VirtualBox VM Name & OS](https://github.com/WCSCourses/WCS_Internal_Guides/blob/main/Guide_Images_Folder/4_b.png)

3. **Guest OS Setup:**
   - **Username & Password:** `manager`
   - **Host Machine Name:** Same as VM (e.g., `CGA2025`).
   - **Enable Guest Additions** and ensure correct file path.
   - Click **Next**.

   ![VirtualBox Unattended Install](https://github.com/WCSCourses/WCS_Internal_Guides/blob/main/Guide_Images_Folder/4_c.png)

4. **Hardware Settings:**
   - **Base Memory:** Allocate ~⅔ of available memory (Example: `11048 MB` out of `16384 MB`).
   - **Processors:** Allocate at least `4 CPUs` (Adjust if necessary).
   - Click **Next**.

   ![VirtualBox Hardware](https://github.com/WCSCourses/WCS_Internal_Guides/blob/main/Guide_Images_Folder/4_d.png)

5. **Storage Configuration:**
   - Allocate at least **150 GB**.
   - Ensure at least **200 GB** free storage space.
   - Click **Next**, review the summary, then click **Finish**.
   
   **Note:** Storage cannot be changed after VM creation.
   
   ![VirtualBox Disk](https://github.com/WCSCourses/WCS_Internal_Guides/blob/main/Guide_Images_Folder/4_e.png)
   ![VirtualBox Summary](https://github.com/WCSCourses/WCS_Internal_Guides/blob/main/Guide_Images_Folder/4_f.png)

6. **Ubuntu Installation Begins:**
   - A terminal window will open automatically.
   - Avoid selecting proprietary software (no license).
   - When prompted for user details, enter `manager` for name, username, and password.
   - Installation can take up to an hour.
   
   ![Ubuntu Proprietary Software](https://github.com/WCSCourses/WCS_Internal_Guides/blob/main/Guide_Images_Folder/4_g.png)
   ![Ubuntu User Creation](https://github.com/WCSCourses/WCS_Internal_Guides/blob/main/Guide_Images_Folder/4_h.png)

---

## Part B: Mounting Guest Additions

Add Required Packages 

   ```bash
      sudo apt update
      sudo apt install build-essential dkms linux-headers-$(manager -r)
   ```

1. **Insert Guest Additions CD:**
   - In VirtualBox menu: `Devices → Insert Guest Additions CD Image`.
   - If greyed out, it is already inserted.
  
Alternatively, we can install the package virtualbox-guest-additions-iso in the host Ubuntu.
   ```bash
      sudo apt install virtualbox-guest-additions-iso
   ```

2. **Check if Mounted:**
   ```bash
     ls /mnt
     ls /media/$USER/
   ```
   - Look for a folder like `VBox_GAs_7.0.12`.

3. **Locate ISO File:**
   ```bash
      ls /usr/share/virtualbox | grep VBoxGuestAdditions
   ```

4. **Verify Installation:**
   ```bash
     lsmod | grep vbox
   ```
   - If `vboxguest` appears, it is installed.

5. **Check Installed Version:**
   ```bash
     modinfo vboxguest | grep version
     VBoxClient --version
   ```

6. **Manually Install if Needed:**
   ```bash
     sudo mount /dev/cdrom /mnt
     cd /mnt
     sudo sh VBoxLinuxAdditions.run
   ```

Additional troubleshooting? Refer: [Ask ubuntu - How do I install guest additions?](https://askubuntu.com/questions/22743/how-do-i-install-guest-additions-in-a-virtualbox-vm)

---

## Part C: Setting up Conda & pip

Run the following command to ensure your system is up to date:

   ```bash
   sudo apt-get update && sudo apt-get install -y git wget && sudo apt-get clean
   ```

**Install pip:**
   ```bash
   sudo apt install python3-pip
   ```

**Install Miniforge:**
1. **About Miniforge**: Miniforge is a minimal Conda installer that defaults to conda-forge instead of defaults 
   ```bash
   sudo apt update && sudo apt install -y wget
   wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
   bash Miniforge3-Linux-x86_64.sh
   ```
   - Accept the license and set the installation path.

2. **Initialize Conda:**
   ```bash
   source ~/miniforge3/bin/activate
   conda --version
   ```

**Additional Sub-step - Manually add Conda to your shell**
Run the following command to initialize Conda for your shell:

   ```bash
   eval "$(/home/manager/miniforge3/bin/conda shell.bash hook)"
   ```

Or, if you're using zsh, replace bash with zsh:

   ```bash
   eval "$(/home/manager/miniforge3/bin/conda shell.zsh hook)"
   ```

**Now, try:**
   ```bash
   conda --version
   ```

**If this works, proceed to initialise Conda for Future Sessions**
   ```bash
   conda init
   ```

This modifies your shell configuration file (e.g., ~/.bashrc or ~/.zshrc), so Conda activates automatically when you open a new terminal.

3. **Configure Conda Channels:**
Miniforge defaults to conda-forge, but we also need bioconda for bioinformatics tools.
Check Current Channels

   ```bash
   conda config --show channels
    ```

Remove Any Paid Channels (If They Exist)

   ```bash
   conda config --remove channels defaults
   conda config --remove channels anaconda
   conda config --remove channels r
   conda config --remove channels pro
   ```

Add Required Channels

   ```bash
   conda config --add channels conda-forge
   conda config --add channels bioconda
   conda config --set channel_priority strict
   ```

Now, verify the channels:

   ```bash 
      conda config --show channels
   ```

It should display:

channels:
  - conda-forge
  - bioconda
Edit .condarc (Alternative)

**Additional sub-step, if you prefer, manually edit ~/.condarc:**

   ```bash
   nano ~/.condarc
   ```

Add the following:

   ```bash
   channels:
  - conda-forge
  - bioconda
  - nodefaults
   denylist_channels: [defaults, anaconda, r, main, pro] #!final
   ```

Save and exit (CTRL+X, then Y, then ENTER).
More steps and documentation for changing channels on conda can be found here: [migration from miniconda to anaconda](https://ssg-confluence.internal.sanger.ac.uk/display/FARM/Conda#Conda-InstallMiniforgeConda-NBpleasedocheckwithyourTiComrepresentativebeforeproceeding.Theremaybeamoreeffectivelocallymanagedservicealreadyavailableforyouruse.) (Connect to VPN to view the webpage, if not on campus)


5. **Create a Bioinformatics Environment:**
   ```bash
   conda create -n bioinfo_env -y
   conda activate bioinfo_env
   ```

6. **Install Bioinformatics Tools:**
   ```bash
   conda install -c bioconda -c conda-forge software-name
   ```

---

4. **Setting up MetaWrap:**

Github Repository: [metaWRAP](https://github.com/bxlab/metaWRAP)

0. Install mamba:

    ```bash
   conda install -y mamba
    ```

   Mamba will effectively replace conda and do exactly the same thing, but much faster.
   
2. Download or clone this repository:
    ```bash
    git clone https://github.com/bxlab/metaWRAP.git
     ```
3. Add metaWRAP bin to PATH:
**Option 1**

```bash
echo 'export PATH=$HOME/metaWRAP/bin:$PATH' >> ~/.bashrc
```

Reload shell configuration:

```bash
source ~/.bashrc
```

Check it worked:

```bash
which metawrap
metawrap -h
```

If correct, it should return:

```bash
/home/manager/metaWRAP/bin/metawrap
```

**Option 2, Modify ~/.bash_profile instead**

If your system uses ~/.bash_profile instead of .bashrc:

```bash
echo 'export PATH=$HOME/metaWRAP/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
```

You only need one of these files, not both.

Confirm PATH contains it
```bash
echo $PATH
```

You should see **/home/manager/metaWRAP/bin** listed at the beginning.

4. Make a new conda environment to install and manage all dependencies:

This creates a new env and never touches Anaconda commercial channels:

```bash
mamba create -y -n metawrap_tools --override-channels \
  -c conda-forge -c bioconda -c nodefaults \
  python=3.11
conda activate metawrap_tools
```

Install the tools MetaWRAP modules call.

```bash
mamba install -y --override-channels \
  -c conda-forge -c bioconda -c nodefaults \
  metabat2 maxbin2 megahit spades \
  bowtie2 bwa samtools \
  checkm-genome quast prokka \
  kraken krona fastqc trim-galore \
  pandas matplotlib seaborn biopython
```

**Verify MetaWRAP can see the tools**

```bash
which metawrap
which metabat2
which maxbin2
which megahit
which spades.py
which checkm
which bowtie2
which samtools
which prokka
```

**To see all package versions installed in the env:**

```bash
conda list
```

Optional: export PATH=$HOME/miniforge3/envs/metawrap_tools/bin:$PATH



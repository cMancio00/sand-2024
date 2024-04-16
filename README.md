# Analysis of visual cortical neurons of mice

| Authors             | email                                   | 
|---------------------|-----------------------------------------|
| Cristian Bargiacchi | <a href="mailto:cristian.bargiacchi@edu.unifi.it">cristian.bargiacchi@edu.unifi.it</a> | 
| Christian Mancini   | <a href="mailto:christian.mancini1@edu.unifi.it">christian.mancini1@edu.unifi.it</a> |  

## Project description

This is the final project of [Statistical Analysis of Network Data](https://www.unifi.it/p-ins2-2022-624136-0.html) at 
University of Florence.

The aim of the project is to analyse some network data with the techniques seen during the course.

We choose da dataset including the network of visual cortex of mice [[2]](#references).

Data represents cell-to-cell mapping of axonal tracts between neurons, created from cellular data like electron microscopy.

Graphs are provided by default in [graphML](http://graphml.graphdrawing.org/) format. This is the only format that supports iterable attributes.

> [!TIP]
> An IDE like Pycharm will detect the [requirements](requirements.txt) and install a virtual environment for you in the project folder,
> we encourage you to use this mechanism to run the Notebook. Otherwise you can follow these steps to manually install the 
> [requirements](#manually-install-the-requirement).

# Manually install the requirement

In the project folder run the following commands:

```bash
python3 -m venv .venv
```
> [!NOTE]
> The name of the virtual environment will be the same as the name of hidden folder, 
>in this case `.venv`.

The virtual environment can be activated with:

```bash
source .venv/bin/activate
```
The requirements can be installed with:

```bash
pip install --upgrade pip & pip install -r requirements.txt
```

We just now need to make the virtual environment a Jupyter kernel.

```bash
python -Xfrozen_modules=off -m ipykernel install --user --name=sand-2024
```
Now you can choose `sand-2024` as a Kernel.

We can see the installed kernels with:

```bash
jupyter kernelspec list
```
The output should be something like this:

```
Available kernels:
  python3      /home/mancio/PycharmProjects/sand-2024/.venv/share/jupyter/kernels/python3
  sand-2024    /home/mancio/.local/share/jupyter/kernels/sand-2024
```
> [!NOTE]  
> You can remove a kernel with the following command:

```bash
jupyter kernelspec uninstall sand-2024 -y
```

# References
[1] [Neurodata repository](https://neurodata.io/project/connectomes/).

[2] [Mouse_visual.cortex_2](https://s3.amazonaws.com/connectome-graphs/mouse/mouse_visual.cortex_2.graphml)

[3] [Network anatomy and in vivo physiology of visual cortical neurons](https://www.nature.com/articles/nature09802).
Deploy branch

Seed with these files:

* **kustomization.yaml** - Tells kustomize-controller which YAMLs to deploy in this branch.
* **.gitignore** - Do not allow output/ directory to be added.
* **output/.keep** - To ensure the output/ directory is not missing when ci/rake.sh runs.
* **ci/rake.sh** - This goes on the release branch. It sweeps production.yaml into this directory.


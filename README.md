## GHA Sass Build
[heading__title]:
  #gha-sass-build
  "&#x2B06; Top of ReadMe File"


GitHub Action JavaScript wrapper runs Sass build with provided Inputs


## [![Byte size of gha-sass][badge__master__gha_sass_build__source_code]][gha_sass_build__master__source_code] [![Open Issues][badge__issues__gha_sass_build]][issues__gha_sass_build] [![Open Pull Requests][badge__pull_requests__gha_sass_build]][pull_requests__gha_sass_build] [![Latest commits][badge__commits__gha_sass_build__master]][commits__gha_sass_build__master]


---


#### Table of Contents


- [:arrow_up: Top of ReadMe File][heading__title]

- [:building_construction: Requirements][heading__requirements]

- [:zap: Quick Start][heading__quick_start]

- [&#x1F5D2; Notes][notes]

- [:card_index: Attribution][heading__attribution]

- [:balance_scale: License][heading__license]


---



## Requirements
[heading__requirements]:
  #requirements
  "&#x1F3D7; What is needed prior to making use of this repository"


Access to GitHub Actions if using on GitHub, or manually assigning environment variables prior to running `npm test`.


______


## Quick Start
[heading__quick_start]:
  #quick-start
  "&#9889; Perhaps as easy as one, 2.0,..."


Reference the code of this repository within your own `workflow`...


```YAML
on:
  push:
    branches:
      - src-pages


jobs:
  build_css:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout source Git branch
        uses: actions/checkout@v2
        with:
            ref: src-pages
            fetch-depth: 10
            submodules: true

      - name: Make destination directory for compiled CSS
        run: mkdir -vp /tmp/repo-name/assets/css

      - name: Compile CSS from SCSS files
        uses: gha-utilities/sass-build@v0.4.6
        with:
          source: _scss/main.scss
          destination: /tmp/repo-name/assets/css/main.css

      - name: Checkout destination Git branch
        uses: actions/checkout@v2
        with:
            ref: pr-pages
            fetch-depth: 1

      - name: Move compiled CSS to path within pr-pages branch
        run: mv /tmp/repo-name/assets/css assets/

      - name: Add and Commit changes to pr-pages branch
        run: |
          git config --local user.email 'action@github.com'
          git config --local user.name 'GitHub Action'
          git add assets/css/*
          git commit -m 'Updates compiled CSS files'

      - name: Push changes
        uses: ad-m/github-push-action@master
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          branch: pr-pages

      - name: Initialize Pull Request
        uses: gha-utilities/init-pull-request@v0.0.4
        with:
          pull_request_token: ${{ secrets.GITHUB_TOKEN }}
          head: pr-pages
          base: gh-pages
          title: 'Updates site files from latest Actions build'
          body: >
            Perhaps a multi-line description
            about latest features and such.
```


______


## Notes
[notes]:
  #notes
  "&#x1F5D2; Additional notes and links that may be worth clicking in the future"


To compile multiple files, define `source` and `destination` similarly to how you would assign `run` multiple commands. Make sure each file in `source` and `destination` are lined up.


```YAML
    - name: Compile main.css from main.scss
      uses: gha-utilities/sass-build@v0.4.6
      with:
        source: |
          _scss/main.scss
          _scss/global.scss
          _scss/articles/post.scss
        destination: |
          /tmp/repo-name/assets/css/main.css
          /tmp/repo-name/assets/css/global.css
          /tmp/repo-name/assets/css/articles/post.css
```


---


To pass compiled CSS to another workflow utilize the Upload and Download Actions from GitHub...


**`.github/workflows/build_css.yml`**


```YAML
on:
  push:
    branches:
      - src-pages


jobs:
  build_css:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout source Git branch
        uses: actions/checkout@v2
        with:
            ref: src-pages
            fetch-depth: 10
            submodules: true

      - name: Make destination directory for compiled CSS
        run: mkdir -vp /tmp/assets/css

      - name: Compile CSS from SCSS files
        uses: gha-utilities/sass-build@v0.4.6
        with:
          source: _scss/main.scss
          destination: /tmp/assets/css/main.css

      - name: Upload Complied CSS
        uses: actions/upload-artifact@v1.0.0
        with:
          name: Compiled-CSS
          path: /tmp/assets/css
```


**`.github/workflows/open_pull_request.yml`**


```YAML
on:
  push:
    branches:
      - src-pages


jobs:
  open_pull_request:
    needs: [build_css]
    runs-on: ubuntu-latest

    steps:
      - name: Checkout destination Git branch
        uses: actions/checkout@v2
        with:
            ref: gh-pages
            fetch-depth: 1
            submodules: true

      - name: Download Compiled CSS
        uses: actions/download-artifact@v1.0.0
        with:
          name: Compiled-CSS
          path: assets/css

      - name: Add and Commit changes to pr-pages branch
        run: |
          git config --local user.email 'action@github.com'
          git config --local user.name 'GitHub Action'
          git add assets/css/*
          git commit -m 'Updates compiled CSS files'

      - name: Push changes
        uses: ad-m/github-push-action@master
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          branch: pr-pages

      - name: Initialize Pull Request
        uses: gha-utilities/init-pull-request@v0.0.4
        with:
          pull_request_token: ${{ secrets.GITHUB_TOKEN }}
          head: pr-pages
          base: gh-pages
          title: 'Updates site files from latest Actions build'
          body: >
            Perhaps a multi-line description
            about latest features and such.
```


---


This repository is influenced by tests preformed by `sass-utilities/gha-sass` which uses Docker powered GitHub Actions to achieve similar results. What differs are that this repository will start faster and enables configuring the build process further, see the [`action.yml`](action.yml) for currently available configurations.


______


## Attribution
[heading__attribution]:
  #attribution
  "&#x1F4C7; Resources and individuals that where helpful in building this project so far."


**Individuals**


- [@wendigo Fork](https://github.com/wendigo/sass-build), so far fixed bugs and added sane defaults


**Resources**


- [GitHub -- Actions Create Pull Request](https://github.com/marketplace/actions/create-pull-request)

- [GitHub -- Creating a JavaScript Action](https://help.github.com/en/articles/creating-a-javascript-action#commit-and-push-your-action-to-github), specifically the `commit-and-push-your-action-to-github` section that states dependencies need to be checked into Git tracking.

- [GitHub -- Node Sass `outfile`](https://github.com/sass/node-sass#outfile)

- [GitHub -- Workflow syntax for GitHub actions](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

- [Sass Language -- JS API Documentation](https://sass-lang.com/documentation/js-api)

- [StackOverflow -- GitHub Actions share Workspace Artifacts between jobs](https://stackoverflow.com/questions/57498605)

- [StackOverflow -- Node.js check if path is file or directory](https://stackoverflow.com/questions/15630770)

- [StackOverflow -- nodejs get file name from absolute path?](https://stackoverflow.com/questions/19811541)


______


## License
[heading__license]:
  #license
  "&#x2696; Legal bits of Open Source software"


Legal bits of Open Source software. Note the following license does **not** necessarily apply to any dependencies of this repository, see licensing and documentation for those within there respective sub-directories under `node_modules/`.


```
Sass Build GitHub Actions documentation
Copyright (C) 2019  S0AndS0

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation; version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```



[badge__commits__gha_sass_build__master]:
  https://img.shields.io/github/last-commit/gha-utilities/sass-build/master.svg

[commits__gha_sass_build__master]:
  https://github.com/gha-utilities/sass-build/commits/master
  "&#x1F4DD; History of changes on this branch"


[gha_sass_build__community]:
  https://github.com/gha-utilities/sass-build/community
  "&#x1F331; Dedicated to functioning code"


[badge__issues__gha_sass_build]:
  https://img.shields.io/github/issues/gha-utilities/sass-build.svg

[issues__gha_sass_build]:
  https://github.com/gha-utilities/sass-build/issues
  "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."


[badge__pull_requests__gha_sass_build]:
  https://img.shields.io/github/issues-pr/gha-utilities/sass-build.svg

[pull_requests__gha_sass_build]:
  https://github.com/gha-utilities/sass-build/pulls
  "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"


[badge__master__gha_sass_build__source_code]:
  https://img.shields.io/github/repo-size/gha-utilities/sass-build

[gha_sass_build__master__source_code]:
  https://github.com/gha-utilities/sass-build
  "&#x2328; Project source code!"

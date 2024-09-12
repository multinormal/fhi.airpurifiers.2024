# Air purifiers in classrooms for infection control: a pilot study

## Introduction

This repository contains code and data for part 2 of the pilot study on air purifiers in classrooms 
for infection control (see [https://zenodo.org/doi/10.5281/zenodo.12818264](https://zenodo.org/doi/10.5281/zenodo.12818264)).

## Software requirements and setup

The analysis is implemented using Stata 18.

To run the analysis you will need to [clone this repository to your local system](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository).

The code generates a report in Word format in the `products` directory. Git is used for version control. The generated report will contain a git hash that identifies the specific version of the analysis code that was used to generate the report. To do this, the code shells out to the `git` program. It is assumed that `git` is installed on your system and is on whatever search path your installation of Stata uses to find external programs. A Mac or UNIX environment is assumed; shelling out to `git` may not work on Windows (this has not been tested). If you cannot install or use `git` on your system, you will need to edit the files `all.do` and `reports/report.do` to remove or comment out all uses of `git` and the `git_revision` global macro.

## Running the analysis

Once the software requirements above are satisfied, you can run the analysis by setting Stata's current working directory to the directory into which you cloned the repository, and then running `do all`. The analysis will `clear all`, so be sure to save any unsaved Stata work before running the analysis. A report containing the results will be written to `products/report.docx`.

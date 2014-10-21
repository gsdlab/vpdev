vpdev: Virtual Platform Development Tool
========================================

v0.3.7

Virtual Platform
----------------

Virtual platform is an approach to the concurrent development of multiple product variants (a *product family* or a *product line*).
Using virtual platform, one can achieve some benefits of clone-and-own and traditional product-line engineering (PLE) approaches at the same time while avoiding the drawbacks of these approaches.
A virtual platform plays a role similar to the integrated platform in PLE with a difference that the features and the associated reusable assets are distributed among the cloned projects instead of being integrated into a platform.
Feature-oriented development can be seen as a special case of a virtual platform with only one project.

For more information, see:

* The [abstract and slides](http://gsd.uwaterloo.ca/PLEWorkshop2013#Antkiewicz) of a talk,
* The recording of the talk [Morning Session 2](http://gsd.uwaterloo.ca/PLEWorkshop2013#MorningSession2),
* The paper in the ICSE'2014 New Ideas and Emergning Research (NIER) track [Flexible Product Line Engineering with a Virtual Platform](http://gsd.uwaterloo.ca/node/560).

### Motivation

A real-world example of a virtual platform, which motivates the development of `vpdev`, is *Clafer Web Tools*: 
[ClaferMooVisualizer](https://github.com/gsdlab/ClaferMooVisualizer) (the "visualizer"), 
[ClaferConfigurator](https://github.com/gsdlab/ClaferConfigurator) (the "configurator"), and 
[ClaferIDE](https://github.com/gsdlab/ClaferIDE) (the "IDE").

The first tool we developed was the visualizer. 
Later, we forked (cloned) the visualizer to create the configurator, which reused some features of the visualizer and added new ones.
Consequently, we forked the visualizer again to create the IDE and propagated a few features from the configurator. 
During the development, we propagated new features, feature extensions, and bug fixes among these three projects.
Finally, we extracted the common features into an integrated platform [ClaferToolsUICommonPlatform](https://github.com/gsdlab/ClaferToolsUICommonPlatform), while leaving the unique features in the individual projects.
The feature models of the three tools are available on the [wiki page](http://t3-necsis.cs.uwaterloo.ca:8091/ClaferToolsPLE/Intro).
Having a tool such as `vpdev` would have helped us doing feature-oriented development of the three projects and, consequently, managing the consistency and benefiting from the virtual platform strategy.

### Dogfooding

We intend to develop this project by "eating our own dog food", that is, using the tool in the development of the tool.
By satisfying our own needs during the development and by ensuring applicability to the Clafer Web Tools virtual platform, we hope the tool will also be useful for others, in general. 

Virtual Platform Development Tool
---------------------------------

The tool `vpdev` is intended to assist with the typical activities performed during feature-oriented development and when applying the virtual platform strategy. 
`vpdev` is a background process (a web server) that should be run locally on a development machine, one instance per the virtual platform. 
The participating projects must be listed as members of the platform.

The virtual platform depends on a notion of a *feature* and various kinds of *meta-data* about the *project*, the features, and the *assets* of the project.
When the project is developed in a distributed manner (i.e., by using a distributed version control system, such as [Git](http://git-scm.com/) or [Darcs](http://darcs.net/)) the features and the meta-data are intended to be merged and integrated the same way as all other assets of the system since, in feature-oriented development, they are integral parts of the system.

### Project setup

You can begin using `vpdev` on any project and at any time during the project lifecycle. 
You can declare the features in a feature model, directly in the code, or in both, simulataneously.

`vpdev` assumes a single feature model per project contained in the `.vp-project` file in the root folder of the project (see [project feature model](project-feature-model) below).
`vpdev` assumes a feature annotation system used for embedding feature annotations directly inside the code (see [feature annotation system](#feature-annotation-system) below).
`vpdev` either creates a feature model from the feature annotations embedded in the code or it simply synchronizes an existing feature model and the feature annotations. 

### Platform setup

`vpdev` assumes a single project to be designated as the `virtual platform` by adding a file `.virtual-platform` and listing the projects in it. 
`vpdev` assumes the folders for each project to be siblings of the virtual platform project (all folders are assumed to have the same parent folder).

For example, consider a virtual platform called `ClaferWebTools` which contains four projects: 
`ClaferVisualizer`, `ClaferConfigurator`, `ClaferIDE`, and `ClaferToolsUICommonPlatform`.
The folder structure should be as follows:

```
<a parent folder>
    ClaferWebTools
        .virtual-platform
    ClaferVisualizer
        .vp-project
    ClaferConfigurator
        .vp-project
    ClaferIDE
        .vp-project    
    ClaferToolsUICommonPlatform
        .vp-project    
```

The file `.virtual-platform` should simply list the four projects, each in a new line:

```
ClaferVisualizer
ClaferConfigurator
ClaferIDE
ClaferToolsUICommonPlatform
```

In the special case when the virtual platform consists of a single project, it should contain both files. 
For example, the project `vpdev` itself has the following folder structure:

```
vpdev
    .virtual-platform
    .vp-project
```

The file `.virtual-platform` simply lists the project `vpdev` as the only project:

```
vpdev
```

### Development with `vpdev`

To use `vpdev` (either for the first time or ongoing), change the folder to the virtual platform project and execute the `vpdev` command. 
It will 

* start the server, 
* read the `.virtual-platform` file to retrieve the folder names of the projects
* for each project
    * read (compile) the `.vp-project` file (or create a new one if missing),
    * process the entire code base to locate all feature annotations,
    * read (or create if missing) the various meta-data files.

After that, you can access the `virtual platform dashboard` by opening `http://localhost:8642` in your browser (see [Virtual Platform Dashboard](https://github.com/gsdlab/vpdev/blob/develop/README.md#virtual-platform-dashboard) below).

### Project feature model

The project feature model should be expressed using a modeling language [Clafer](http://clafer.org) and it should contain a single top-level concrete clafer to represent the entire project and to contain all project features. 
By default (when automatically creating the feature model for the first time), the project clafer name is created from the root folder name of the project.
The model can contain any number of abstract clafers. 

For example, a project in the folder `ClaferMooVisualizer` could have the following `.vp-project` feature model

```
ClaferMooVisualizer     // the single top-level concrete clafer for the project
    `Server             // composing the Server feature model
    `Client
    processManagement   // subfeatures of the project
        polling
        timeout

abstract Server         // an abstract clafer to modularize the feature model
    backends
        ClaferMoo
            timeout
        ChocoSoo

abstract Client
    views
        Input
        BubbleFrontGraph
        FeatureAndQualityMatrix
        VariantComparer
```

### Feature annotation system

The feature annotation system is a set of conventions for annotating folders, files, and contents of files with the features they implement.

The feature annotations refer to the features using their `least-partially-qualified names` (`lpq name` for short), which usually are just the feature names if they are unique in the project. 
If a name is not unique, then it must be qualified partially just enough to make the reference unique. 

For example, the feature `ClaferMoo` has a unique name in the model and can be referred to simply using its name.
On the other hand, the feature name `timeout` occurs twice in the model and must be qualified to uniquely identify a feature either as `ClaferMoo::timeout` or `processManagement::timeout`. 
Fully-qualified names could also be used (e.g., `::ClaferMooVisualizer::processManagement::timeout`); however, they are much longer and more brittle as compared to the least-partially-qualified names when the feature model evolves.

#### Annotation Conventions

In general, to refer to multiple features, list `lpq names` of the features separated with any whitespace character except a new line.

* We do not annotate folders, since it's a particular case of files. Annotations can be done outside a folder by specifying folder name, or inside the folder by referring to it as `.` (dot).

* To annotate files or folders without modifying their contents, add a file called `.vp-files` and list each file or folder name by a mask in a new line followed by a list of features in another line. In general, use standard syntax allowed by the linux/unix `ls` or windows `dir` commands.

For example, a file `/.vp-files` in a project root folder (`ClaferMooVisualizer`) could contain the following (excluding the comments):

```
Server/Backends/*.*                     // mask of the files with any extension
backends                                // feature name
```

Also, it's possible to have a file `/.vp-files` in the `Server` subfolder. We specify two features here:

```
.                                       // current folder (i.e., Server)
Server Backends help                    // the list of features using `lpqName`s
./server.js, ./config.json              // name or mask or list of a concrete file(s)
processManagement::timeout              // features of server.js
```

If we have `/.vp-files` in the `Backends` subfolder with the following contents:

```
ChocoMoo/*.*         // all files within ClaferMoo folder
ClaferMoo            // feature name
ChocoSoo/*.*         
ChocoSoo
```

then, the new mapping will complement already existing mapping inherited from the root folder. Thus, all the files in the `ClaferMoo` folder will implement the `Backends` feature as well.

* To annotate a fragment of a file or the entire contents of a file, use the appropriate comment syntax of the used programming language to mark the beginning and end of the fragment.
Inside the comment, to mark the beginning of the fragment, surround the list of features with `|>` and `|>` delimiters. 
The `>` can be understood as "what's after implements the features".
Inside the comment, to mark the end of the fragment, surround the list of features with `<|` and `<|` delimiters.
The `<` can be understood as "what's before' implements the features".
The new line character can be used instead of the closing delimiter.

The proposed syntax of the delimiters is based on [Comparison of programming languages (syntax)](http://en.wikipedia.org/wiki/Comparison_of_programming_languages_(syntax)) so that it can be used across all major programming languages. However, the exact syntax of the delimiters should, in general, be configurable.

For example, the `Server/server.js` file could contain a following fragment implementing a feature `processManagement::timeout`:

```
        //    |> processManagement::timeout |>
        core.timeoutProcessClearInactivity(process);
        core.timeoutProcessSetInactivity(process);
        //    <| processManagement::timeout <|
```                

The delimiter `|> processManagement::timeout |>` marks the beginning of the fragment and `<| processManagement::timeout <|` marks the end. 
The closing delimiter can be omitted indicating that the feature implementation continues until the end of file.

* To annotate a single line of a file, use the appropriate in-line comment syntax of the used programming language to mark the line.
Inside the comment, surround the list of features with `|>` and `<|` delimiters.

For example, the `Server/server.js` file could contain a following line implementing a feature `processManagement::timeout`:

```
    core.timeoutProcessSetPing(process);   //    |> processManagement::timeout <|
``` 

##### Expressing logical `AND` or `OR`

There are two ways of annotating a fragment with multiple features which express two different intentions: `AND` or `OR`. 
The distinction only make sense when the features are optional and we are concerned with the removal of fragments when the features are not present in a configuration.

To express that a given fragment is relevant to every listed feature and at least one of the features must be present for the fragment to be relevant (logical `OR`), list the features in a single annotation:

```
    //    |> process timeout |>
    core.timeoutProcessClearInactivity(process);
    core.timeoutProcessSetInactivity(process);
    //    <| process timeout <|
```

To express that a given fragment is relevant to all listed features and all of the features must be present for the fragment to be relevant (logical `AND`), use multiple nested annotations each containing a single feature:

```
    //    |> process |>
    //    |> timeout |>    
    core.timeoutProcessClearInactivity(process);
    core.timeoutProcessSetInactivity(process);
    //    <| timeout <|
    //    <| process <|
```

##### Overlapping annotations

It is also possible that the annotations are not properly nested. For example:

```
1.    //    |> process |>
2.    core.process.init();
3.    //    |> timeout |>    
4.    core.timeoutProcessClearInactivity(process);
5.    //    <| process <|
6.    core.timeoutProcessSetInactivity(process);
7.    //    <| timeout <|
```

The first statement on line 2 belongs to `process` only, the second statement on line 4 to both `process` and `timeout`, and the third one on line 6 to `timeout` only.

#### Choosing between a file or fragment annotation for a file

As a recommended practice, only the binary files or textual files that cannot be modified should be annotated using the `.vp-files` annotation. 
In all other cases, a fragment annotation encompassing the contents of the file is recommended because it naturally co-evolves with the file contents and does not require any maintenance costs.

#### Alternative Annotation Conventions

These conventions are used in the ClaferWebTools Simulation Case Study. 
For example, see the fully annotated project [ClaferMooVisualizeer](https://github.com/redmagic4/ClaferMooVisualizer).

* To annotate a folder with a feature, add a file called `.vp-folder` and list the features it implements.

For example, consider the following folder/file tree:

```
ClaferMooVisualizer
    Server
        .vp-folder            // containing "Server processManagement"
        Backend
        Client
            .vp-folder        // containing "Client processManagement"
```

* To annotate entire files without modifying their contents (e.g., binary files), add a file called `.vp-files` and list each file name in a new line followed by a list of features in another line.

For example, a file `Server/.vp-files` could contain the following (excluding the comments):

```
server.js                               // name of the file
Server processManagement::timeout       // features of server.js
config.json                             // name of the file
processManagement::timeout              // features of config.json
```

* To annotate a fragment of a file, use the appropriate comment syntax of the used programming language to mark the beginning and end of the fragment.
Inside the comment, to mark the beginning of the fragment, surround the list of features between `&begin [` and `]` delimiters.
Inside the comment, to mark the end of the fragment, surround the list of features between `&end [` and `]` delimiters.

For example, the `Server/server.js` file could contain a following fragment implementing a feature `processManagement::timeout`:

```
        //&begin [ processManagement::timeout ]
        core.timeoutProcessClearInactivity(process);
        core.timeoutProcessSetInactivity(process);
        //&end [ processManagement::timeout ]
```                

* To annotate a single line of a file, use the appropriate in-line comment syntax of the used programming language to mark the line.
Inside the comment, surround the list of features with `&line [` and `]` delimiters.

For example, the `Server/server.js` file could contain a following line implementing a feature `processManagement::timeout`:

```
    core.timeoutProcessSetPing(process);   //&line [ processManagement::timeout ]
``` 

### Virtual Platform Dashboard

The dashboard is used to view information about your whole product line as well as information related to your project's relationship with other projects within the virtual platform. 

For example, the dashboard for the `ClaferWebTools` virtual platform would display

* the list of projects,
* the list of features which occur in at least two projects together with their status: `consistent`, `inconsistent`,
* timeline showing the evolution of all projects and the instances of feature propagations over time (that the feature `matrix` was propagated from the project `ClaferMooVisualizer` to the project `ClaferConfigurator`),
* unannotated clones discovered automatically, which could be candidates for features,
* ...

For example, the dashboard for the project `ClaferIDE` would display

* the features of that project together with their traceability information,
* provenance information of the project (IDE is a fork of the visualizer) and of the features (features of the IDE were cloned from the visualizer),
* the status of the cloned features (whether there are some modifications done to the original features in the visualizer that might need to be propagated into the IDE),
* ...

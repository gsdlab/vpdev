vpdev: Virtual Platform Development Tool
========================================

Virtual Platform
----------------

Virtual platform is a way of achieving some benefits of clone-and-own and product-line engineering (PLE) approaches at the same time while avoiding the drawbacks of these approaches.
A virtual platform plays a similar role to the integrated platform in PLE with a difference that the features and the associated reusable assets are distributed among the cloned projects instead of being integrated into a platform.
The virtual platform with only one project is simply *feature-oriented development*.

For more information:

* See the abstract and slides at [Michal Antkiewicz - Flexible Product Line Engineering with a Virtual Platform](http://gsd.uwaterloo.ca/PLEWorkshop2013#Antkiewicz)
* The recording of the talk is also available [Morning Session 2](http://gsd.uwaterloo.ca/PLEWorkshop2013#MorningSession2).
* The talk is based on the paper in the ICSE'2014 New Ideas and Emergning Research (NIER) track [Flexible Product Line Engineering with a Virtual Platform](http://gsd.uwaterloo.ca/node/560).

An real-world example of a virtual platform, which motivates the development of `vpdev`, are the three Clafer Web Tools: 
[ClaferMooVisualizer](https://github.com/gsdlab/ClaferMooVisualizer) (the "visualizer"), 
[ClaferConfigurator](https://github.com/gsdlab/ClaferConfigurator) (the "configurator", and 
[ClaferIDE](https://github.com/gsdlab/ClaferIDE) (the "IDE").
The first tool we developed was ClaferMooVisualizer. 
Later, we forked (cloned) the project to create the ClaferConfigurator, which reused some features of the visualizer and added new ones.
Consequently, we forked the visualizer again to create the ClaferIDE and propagated a few features from the configurator. 
We propagated new features, feature extensions, and bug fixes among the three projects.
Finally, we extracted the common features into an integrated platform [ClaferToolsUICommonPlatform](https://github.com/gsdlab/ClaferToolsUICommonPlatform), while leaving the unique features in the individual projects.

Virtual Platform Development Tool
---------------------------------

The tool `vpdev` is intended to assist with the typical activities performed during the development with a virtual platform. 
`vpdev` is a background process (a web server) that you run locally on a development machine, one instance per project.

The virtual platform depends on a notion of a *feature* and different kinds of *meta-data* about the features and the project *assets*.
When the project is developed in a distributed manner (i.e., by using a distributed version control system, such as Git or Darcs) the features and the meta-data are intended to be merged and integrated the same way as all other assets of the system since, in feature-oriented development, they are integral parts of the system.

### Project setup

You can begin using `vpdev` on any project and at any time during the project lifecycle. 
You can declare the features in a feature model, directly in the code, or in both, simulataneously.

`vpdev` assumes a [single feature model per project](#Project feature model) contained in the `project.cfr` file in the root folder of the project.
`vpdev` assumes a [feature annotation system](#Feature annotation system) used for embedding feature annotations directly inside the code.
`vpdev` either creates a feature model from the feature annotations embedded in the code or it simply synchronizes an existing feature model and the feature annotations. 

### Development with `vpdev`

To use `vpdev` (either for the first time or ongoing), change the folder to the root of your project and execute the `vpdev` command. 
It will read (compile) the `project.cfr` file (or create a new one if missing) and process the entire code base to locate all feature annotations. 
It will also read (or create if missing) the various meta-data files.
After that, you can access the `virtual platform dashboard` by opening `http://localhost:8642` in your browser.

### Project feature model

The project feature model should be expressed using Clafer and it should contain a single top-level concrete clafer to represent the entire project and to contain all project features. 
By default (when automatically creating the feature model for the first time), the project clafer name is created from the root folder name of the project.
The model can contain any number of abstract clafers. 

For example, a project in the folder `ClaferMooVisualizer` could have the following `project.cfr` feature model

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

The feature annotations refer to the features using their `least partially qualified names` (`lpq name` for short), which usually are just the feature names if they are unique in the project. 
If a name is not unique, then it must be qualified partially to make the reference unique. 

For example, the feature `ClaferMoo` has a unique name in the model and can be referred to simply using its name.
On the other hand, the feature name `timeout` occurs twice in the model and must be qualified to uniquely identify a feature either as `ClaferMoo::timeout` or `processManagement::timeout`. 
Fully-qualified names could also be used (e.g., `::ClaferMooVisualizer::processManagement::timeout`); however, they are much more brittle as compared to the least partially qualified names when the feature model evolves.

#### Annotation conventions

* To annotate a folder with a feature, add a file called `.vpfolder` and list lpq names of the features separated with any whitespace character except a new line.

For example, consider the following folder/file tree:

```
ClaferMooVisualizer
    Server
        .vpfolder            // containing "Server processManagement"
        Backend
        Client
            .vpfolder        // containing "Client processManagement"
```

* To annotate entire files without modifying their contents (e.g., binary files), add a file called `..vpfiles` and list each file name in a new line, followed by a list of lpq names of the features separated with any whitespace character except a new line.

For example, a file `Server/.vpfiles` could contain the following (excluding the comments):

```
server.js                               // name of the file
Server processManagement::timeout       // features of server.js
config.json                             // name of the file
processManagement::timeout              // features of config.json
```

* To annotate a fragment of a file, use the appropriate comment syntax of the used programming language to mark the beginning and end of the fragment.
Inside the comment surround the list lpq names of the features separated with any whitespace character except a new line with `<|` and `|>` delimiters.

The syntax of the delimiters is based on [Comparison of programming languages (syntax)](http://en.wikipedia.org/wiki/Comparison_of_programming_languages_(syntax)) so that it can be used across all major programming languages.

For example, the `Server/server.js` file could contain a following fragment implementing a feature `processManagement::timeout`:

```
                // <| processManagement::timeout |>
                core.timeoutProcessClearInactivity(process);
                core.timeoutProcessSetInactivity(process);
                // <| processManagement::timeout |>
```                

The first occurence of the delimiter `<| processManagement::timeout |>` marks the beginning of the fragment. 
The second, marks the end and can be ommitted indicating that the feature implementation continues until the end of file.

### Virtual Platform Dashboard

The dashboard is used to view information about your feature-oriented system as well as information related to your projects relationship with other projects forming the virtual platform. 

For example, the dashboard for the ClaferIDE project would display

* the features of that project together with their traceability information,
* provenance information of the project (IDE is a fork of the visualizer) and of the features (features of the IDE were cloned from the visualizer),
* the status of the cloned features (whether there are some modifications done to the original features in the visualizer that might need to be propagated into the IDE),
* and others.
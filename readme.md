# Data Quality assessment model

## Introduction
There are two ways to measure data quality - subjective and objective. Objective measures should be independent of data and usage, thanks to that this option is way more generic.
Proposed solution merges both ideas, so part of it can be used without knowing anything about the data, the other part requires EDA and overall data knowledge.

The diagram denotes overall pipeline how to use this solution:
![Data Quality](Diagrams/data_quality_model.jpg)

Metadata and sample are created programatically based on the data. There might be a need for permission elevation to automatically run whole project.

## Used dimensions and metrics
The metadata plays an important role in the quality assessment, it works as a link between data and DQ model. This is the part of objective DQ, it can be used for measuring other database qualities as well. Based on the metadata there is a calculation for overall schema quality assessment, taking into account:
- Empty tables
- "Metadata as data"
- Wide tables
- Lacking relations
- [Indexes] <- optional
Every feature gets calculated with formula, using weights:
1. Empty Tables:

<img src="https://latex.codecogs.com/svg.latex?F_{ET}=\frac{\sum_{1}^{N}ET}{n},&space;where:&space;ET=\begin{cases}&space;&&space;\text{&space;1,&space;if&space;table&space;is&space;empty}&space;\\&space;&&space;\text{&space;0&space;otherwise&space;}&space;\end{cases}" title="F_{ET}=\frac{\sum_{1}^{N}ET}{n}, where: ET=\begin{cases} & \text{ 1, if table is empty} \\ & \text{ 0 otherwise } \end{cases}" />
2. Metadata as data means that table consists of just a bunch of foreign keys

<img src="https://latex.codecogs.com/svg.latex?F_{MT}=\frac{\sum_{1}^{n}MT}{n},&space;where:&space;MT=\begin{cases}&space;&&space;\text{&space;1,&space;if&space;table&space;can&space;be&space;qualified&space;as&space;metadata}&space;\\&space;&&space;\text{&space;0&space;otherwise&space;}&space;\end{cases}" title="F_{MT}=\frac{\sum_{1}^{n}MT}{n}, where: MT=\begin{cases} & \text{ 1, if table can be qualified as metadata} \\ & \text{ 0 otherwise } \end{cases}" />

3. Lacking relations - these are attributes present in various entities not marked as foreign keys and marked as a primary key in a 'source' entity. 

<img src="https://latex.codecogs.com/gif.latex?F_{LFK}=\frac{\sum_{1}^{n}LFK}{n},&space;where:&space;LFK&space;=&space;\text{&space;number&space;of&space;abandoned&space;foreign&space;keys&space;(number&space;of&space;tables&space;referencing&space;this&space;PK)&space;}" title="F_{LFK}=\frac{\sum_{1}^{n}LFK}{n}, where: LFK = \text{ number of abandoned foreign keys (number of tables referencing this PK) }" />

### Dimensions:
1. Completeness - To verify the quality of inserted data it is recommended to check values, which could indicate empty values i.e. NULL, 'N/A', 'None' etc. Using helper functions there is a special lookup table created and used for fuzzy matching for completeness. 
<img src="https://latex.codecogs.com/gif.latex?Completness&space;=&space;1&space;-&space;(W_{1}&space;*{Completness_{A}}&space;&plus;&space;W_{1}&space;*{Completness_{T}}&space;&plus;&space;W_{1}&space;*{Completness_{D}})" title="Completness = 1 - (W_{1} *{Completness_{A}} + W_{1} *{Completness_{T}} + W_{1} *{Completness_{D}})" />
, where:
CompletnessA stands for Completness of attributes and is denoted by:
<img src="https://latex.codecogs.com/svg.latex?{Completeness_{A}}&space;=&space;\frac{\sum_{1}^{n}\frac{\sum_{1}^{a}\frac{\sum_{1}^{t}KA_{tan}}{t}}{a}}{n}" title="{Completeness_{A}} = \frac{\sum_{1}^{n}\frac{\sum_{1}^{a}\frac{\sum_{1}^{t}KA_{tan}}{t}}{a}}{n}" />, where: 
<img src="https://latex.codecogs.com/svg.latex?KA_{tan}=\begin{cases}&space;&&space;\text{&space;1,&space;if&space;tuple&space;t&space;has&space;value&space;set&space;for&space;attribute&space;a&space;in&space;relation&space;n}&space;\\&space;&&space;\text{&space;0&space;otherwise&space;}&space;\end{cases}" title="KA_{tan}=\begin{cases} & \text{ 1, if tuple t has value set for attribute a in relation n} \\ & \text{ 0 otherwise } \end{cases}" />
and **n** denotes number of relations, **a** denotes number of attributes, **t** denotes number of tuples. 
CompletenessT stands for completeness of tuples
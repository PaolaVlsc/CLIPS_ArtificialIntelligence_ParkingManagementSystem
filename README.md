# CLIPS_ArtificialIntelligence_ParkingManagementSystem
A rule-based parking system using CLIPS. It enables car entry, exit, and platform movement within a multi-floor parking lot via an interactive command-line menu. University Project for Artificial Intelligence

# Parking Management System

## Overview

This repository contains the source code for a simple parking management system implemented in the CLIPS expert system language. The system simulates the operation of a parking lot, allowing cars to enter, exit, and park on available platforms. The code includes facts, rules, and templates to manage the parking process, and it serves as a practical example of using CLIPS for rule-based applications.

## Table of Contents 
- [System Features](#system-features)
  - [Initialization](#initialization)
  - [Add Cars](#add-cars)
  - [Parking Strategy](#parking-strategy)
  - [Exit Cars](#exit-cars)
  - [Dynamic Platform Movement](#dynamic-platform-movement)
  - [Interactive Menu](#interactive-menu)
- [Code Structure](#code-structure)
- [Running the System](#running-the-system)
- [Contribution and Modification](#contribution-and-modification)
- [Extras](#extras)

- 
## System Features

### Initialization
The system starts with an empty parking lot on three different floors. It initializes the number of available parking spaces and platforms. The user can specify the number of spaces available in the parking lot.

### Add Cars
Users can add cars to the parking lot. The system prompts the user to input the number of cars waiting to park and then collects the license plate numbers for each car.

### Parking Strategy
The system uses a rule-based strategy to determine where to park each car. It selects an available platform to park the car based on the defined rules.

### Exit Cars
Users can indicate which cars are ready to leave the parking lot. The system then initiates the exit process for those cars.

### Dynamic Platform Movement
The platforms in the parking lot can be moved left, right, up, and down to optimize parking availability. The system manages these platform movements based on a set of rules.

### Interactive Menu
Users interact with the system through a simple command-line menu. They can choose to add cars, exit cars, or terminate the program.

## Code Structure

The code is organized into several sections:

- **Templates**: The `deftemplate` section defines the templates used in the system. There are templates for parking spaces, platforms, and cars.

- **Initial Facts**: The `deffacts` section initializes the initial facts for the parking lot. It specifies the layout of parking spaces, platforms, and their relationships.

- **Rules**: The `defrule` section contains the core rules that govern the operation of the parking management system. It covers car entry, exit, platform movement, and menu selection.

- **README**: This README file provides an overview of the code and its functionality.

## Running the System

To run the parking management system, you will need to have CLIPS installed on your computer. Here are the steps to execute the code:

1. **Install CLIPS**: Download and install the CLIPS expert system from the official website (https://www.clipsrules.net/).

2. **Save the Code**: Save the provided code in a text file with the ".clp" extension.

3. **Run CLIPS**: Open a terminal or command prompt and navigate to the directory where the ".clp" file is located.

4. **Load Code**: Start CLIPS by running the command: `clips`. Load the code into CLIPS by typing `(load "your_file.clp")`, replacing `"your_file.clp"` with the name of the file containing the code.

5. **Initiate the System**: To initiate the parking management system, enter the command `(reset)` followed by `(run)`.

6. **User Interaction**: Follow the prompts and menu options to add cars, exit cars, and interact with the system.

7. **Termination**: Terminate the program by selecting the appropriate option from the menu.

## Contribution and Modification

This code is intended as a simple example of a parking management system using CLIPS. You can use it as a starting point for more complex systems or modify it to fit your specific needs. If you have any improvements, suggestions, or bug fixes, please feel free to contribute to this repository by creating a pull request.
 
This project was created by:
- Velasco Paola
- Micha Evagelia 

## Extras
* Report paper in greek: [Report paper](https://github.com/PaolaVlsc/CLIPS_ArtificialIntelligence_ParkingManagementSystem/blob/main/Final_Parking_Clips_cs161020_cs171102%5B1%5D.pdf)

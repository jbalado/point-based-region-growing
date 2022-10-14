# Multi Feature-Rich Synthetic Colour (MFRSC) for point clouds

Created by Jesús Balado Frías, Elena González, Juan L. Rodríguez-Somoza and Pedro Arias

## Introduction

Although point features have shown their usefulness in classification with Machine Learning, point cloud visualization enhancement methods focus mainly on lighting. The visualization of point features helps to improve the perception of the 3D environment. This work proposes Multi Feature-Rich Synthetic Colour (MFRSC) as an alternative non-photorealistic colour approach of natural-coloured point clouds. The method is based on the selection of nine features (reflectance, return number, inclination, depth, height, point density, linearity, planarity, and scattering) associated with five human perception descriptors (edges, texture, shape, size, depth, orientation). The features are reduced to fit the RGB display channels. 

![](https://i.imgur.com/T3o1mXo.jpeg)

## Work

The designed method is described in the article ****Multi Feature-Rich Synthetic Colour to improve human visual perception of point clouds****.

Before applying the code, reading the paper is highly recommended.

It is available in Open Access at this [link](Pendiente).


## Application
The code consists of two fundamental functions: erosion followed by dilation. The first fuction (erosion) require two input point clouds: 
* Point cloud input: composed of an NxA matrix, where N is the number of points and A the number of attributes, XYZ being the first three.
* Point cloud strutcturing element: composed of an Nx3 matrix, where N is the number of points. It is the auxiliary point cloud that acts as a structuring element.

The output is a segmented point cloud.


## Citation
Pendiente

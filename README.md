# Netflix Movies and TV Shows Data Analysis using SQL
![Netflix Logo](https://github.com/maneeshmm/Netflix_SQL_Project/blob/main/download.png)


## Overview
This project involves a detailed analysis of Netflix's movies and TV shows dataset using SQL. The goal of the project is to derive actionable insights and answer various business-related questions based on the dataset. The analysis covers different aspects of Netflix's content, including content types, ratings, release years, countries, genres, directors, and actors.

## Objectives
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific keywords such as "kill" and "violence".
## Dataset
The data used in this project is sourced from the Netflix movies and TV shows dataset available on Kaggle. The dataset contains detailed information about various shows and movies available on Netflix, such as:

Show ID

Title

Type (Movie/TV Show)

Country

Release Year

Duration

Genres

Director

Cast

Description

Date Added

SQL Queries

## SQL Queries
Below are the main queries used to analyze the dataset:

## 1. Count the Number of Movies vs TV Shows.
'''sql
CREATE DATABASE Netflix
USE Netflix
SELECT * FROM netflix_project

SELECT COUNT (*) AS total_content FROM netflix_project

SELECT DISTINCT type FROM netflix_project
SELECT type, COUNT (*) AS total_content FROM netflix_project GROUP BY type 
'''sql



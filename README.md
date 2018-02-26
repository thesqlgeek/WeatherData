	National Weather Service Data Collector
	Script Collects and Processes Weather.gov Weather Station Data

	Copyright (C) 2017  Jason McKittrick - jasonmck@outlook.com

    This program/scripts is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

-------------------------------------------------------------------------------------------------

To Setup the National Weather Service Data Collector

This Solution picks up the current observations at the weather stations that update hourly.

Prereqs:
SQL Server any Edition(can be SQL Express) and Version needs to be at least 2008R2, I used SQL 2016
Windows Powershell

1 - Edit WeatherDB_US.sql  File - Change the Filepath to your own files paths in the Database Creation Script

    ( NAME = N'WeatherDB_US', FILENAME = N'D:\SQL Data\WeatherDB_US.mdf' , SIZE = 794624KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
    LOG ON
    ( NAME = N'WeatherDB_US_log', FILENAME = N'D:\SQL Logs\WeatherDB_US_log.ldf' , SIZE = 6365184KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )

2 - Once edited save and run the WeatherDB_US Database Creation Script

3 - Open and Run the WeatherFeedStationsData.sql  This will load in all of the station locations into the weather feed tables

4 - Edit the Weather Data Collector V1.0.ps1 PowerShell script.  You can use notepad. Update the SQL Server\Instance Name and the Processing folder. The Processing
    folder is only used to hold the file pulled while it is processed.  

    $dataSource = "SQLServer\SQLInstance"
    $rootfiledir = "D:\Directory Path For Processing\"

5 - Save the file Weather Data Collector V1.0.ps1

6 - Execute the Weather Data Collector V1.0.ps1 file.  You can setup a task to run and collect hourly.  The data is only updated once and hour on the hour.  I pickup mine
    at :15 after the hour 24x7.  Use Task Scheduler on your Desktop/Server to schedule the Task. It is included in all versions of Windows Desktop and PC.  You need to leave the PC/Server
    on in order to run this if you have it scheduled. 

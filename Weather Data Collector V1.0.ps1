<#
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
#>


#Parameter Variables
$dataSource = "SQLServer\SQLInstance"
$rootfiledir = "D:\Directory Path For Processing\"

#Define Variable Set
$database = "WeatherDB_US"
$proc_start_time = Get-Date
$connectionString = "Server=$dataSource;Database=$database;Integrated Security=True;"
$weatherfilepath = $rootfiledir + (("Weather Files " + ([String](get-date) -replace "/", "-") -replace ":", "") + "\")
$elapsed = [System.Diagnostics.Stopwatch]::StartNew()

#Verify and Create Directory and Paths for Log Files and Download Files Holding

if ((Test-Path $weatherfilepath) -eq 0) { New-Item -ItemType Directory -Force -Path $weatherfilepath }
#if ((Test-Path $stockdldlogfilepath) -eq 0) { New-Item -ItemType Directory -Force -Path $stockdldlogfilepath }

#Create Connection for SQL to Retrive Symbols for working set and retrieve the working set

$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString

$connection.Open()

$query = "Select WeatherFeedID, ObservationStationCode from WeatherFeed where IsWeatherFeedActive = 1 order by WeatherFeedID asc"

$command = $connection.CreateCommand()
$command.CommandText = $query

$result = $command.ExecuteReader()

$table = new-object "System.Data.DataTable"
$table.Load($result)

$table | ForEach-Object {
	$CurrentWeatherProcTime = Get-Date

	$CurrentObservationStationCode = $_.ObservationStationCode
	
	$CurrentWeatherFeedID = $_.WeatherFeedID
	
	$CurrentWeatherFilePath = $weatherfilepath + $CurrentWeatherFeedID + ".xml"
	
	#$CurrentWeatherFeedURL = "http://w1.weather.gov/xml/current_obs/KWWR.xml"
	$CurrentWeatherFeedURL = "http://w1.weather.gov/xml/current_obs/" + $CurrentObservationStationCode + ".xml"
	
	Invoke-WebRequest -Uri $CurrentWeatherFeedURL -OutFile $CurrentWeatherFilePath -ErrorAction SilentlyContinue
	
	#[xml]$Weather = Get-Content C:\WeatherData\KADH.xml
	
	[xml]$Weather = Get-Content $CurrentWeatherFilePath
	$SQLWeatherInsertStatement = "Insert into WeatherHistorical(WeatherFeedID,Observation_Time,CurrentObservation,Temp_F,Temp_C,Relative_Humidity,Wind_Dir,Wind_Degrees,Wind_MPH,Dewpoint_F,Dewpoint_C,Wind_KNOTS,Pressure_IN,Visibility_MI)
    Values('" +
	$CurrentWeatherFeedID + "','" + (($Weather.current_observation.observation_time.Substring(16, 21)) -replace ",", "") + "','" +
	$Weather.current_observation.weather + "','" + $Weather.current_observation.temp_f + "','" +
	$Weather.current_observation.temp_c + "','" + $Weather.current_observation.relative_humidity + "','" +
	$Weather.current_observation.wind_dir + "','" + $Weather.current_observation.wind_degrees + "','" +
	$Weather.current_observation.wind_mph + "','" + $Weather.current_observation.dewpoint_f + "','" +
	$Weather.current_observation.dewpoint_c + "','" + $Weather.current_observation.wind_kt + "','" +
	$Weather.current_observation.pressure_in + "','" + $Weather.current_observation.visibility_mi + "')"
	#$SQLWeatherInsertStatement
	
	$command.CommandText = $SQLWeatherInsertStatement
	
	$command.ExecuteNonQuery()
	
	
	
}


#CleanUp 

$connection.Close()
Remove-Item -Recurse -Force $weatherfilepath


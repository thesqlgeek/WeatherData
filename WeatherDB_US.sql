/*
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
*/

USE [master]
GO

CREATE DATABASE [WeatherDB_US]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WeatherDB_US', FILENAME = N'D:\SQL Data\WeatherDB_US.mdf' , SIZE = 794624KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WeatherDB_US_log', FILENAME = N'D:\SQL Logs\WeatherDB_US_log.ldf' , SIZE = 6365184KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [WeatherDB_US] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WeatherDB_US].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WeatherDB_US] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WeatherDB_US] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WeatherDB_US] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WeatherDB_US] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WeatherDB_US] SET ARITHABORT OFF 
GO
ALTER DATABASE [WeatherDB_US] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WeatherDB_US] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WeatherDB_US] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WeatherDB_US] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WeatherDB_US] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WeatherDB_US] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WeatherDB_US] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WeatherDB_US] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WeatherDB_US] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WeatherDB_US] SET  DISABLE_BROKER 
GO
ALTER DATABASE [WeatherDB_US] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WeatherDB_US] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WeatherDB_US] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WeatherDB_US] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WeatherDB_US] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WeatherDB_US] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WeatherDB_US] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WeatherDB_US] SET RECOVERY FULL 
GO
ALTER DATABASE [WeatherDB_US] SET  MULTI_USER 
GO
ALTER DATABASE [WeatherDB_US] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WeatherDB_US] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WeatherDB_US] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WeatherDB_US] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WeatherDB_US] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'WeatherDB_US', N'ON'
GO
ALTER DATABASE [WeatherDB_US] SET QUERY_STORE = OFF
GO
USE [WeatherDB_US]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO

/****** Object:  Table [dbo].[WeatherHistorical]    Script Date: 2/25/2018 9:59:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeatherHistorical](
	[WeatherHistoricalID] [int] NOT NULL,
	[WeatherFeedID] [smallint] NOT NULL,
	[Observation_Time] [smalldatetime] NOT NULL,
	[CurrentObservation] [varchar](75) NOT NULL,
	[Temp_F] [decimal](6, 2) NOT NULL,
	[Temp_C] [decimal](6, 2) NOT NULL,
	[Relative_Humidity] [decimal](6, 2) NOT NULL,
	[Wind_Dir] [varchar](20) NOT NULL,
	[Wind_Degrees] [smallint] NOT NULL,
	[Wind_MPH] [decimal](6, 2) NOT NULL,
	[Wind_KNOTS] [decimal](6, 2) NOT NULL,
	[Pressure_IN] [decimal](6, 2) NOT NULL,
	[Dewpoint_F] [decimal](6, 2) NOT NULL,
	[Dewpoint_C] [decimal](6, 2) NOT NULL,
	[Visibility_MI] [decimal](6, 2) NOT NULL,
	[DateCreated] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_WeatherHistorical] PRIMARY KEY CLUSTERED 
(
	[WeatherHistoricalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[WeatherPrecipiation]    Script Date: 2/25/2018 9:59:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[WeatherPrecipiation]

as

Select WeatherHistoricalID,1 as Precipitation 
from [dbo].[WeatherHistorical]
Where CurrentObservation in ( 'Drizzle',
                              'Drizzle and Breezy',
                              'Drizzle and Windy',
                              'Drizzle Fog/Mist',
                              'Heavy Drizzle',
                              'Heavy Drizzle and Breezy',
                              'Heavy Rain',
                              'Heavy Rain  Thunderstorm in Vicinity',
                              'Heavy Rain  Thunderstorm in Vicinity and Breezy',
                              'Heavy Rain and Breezy',
                              'Heavy Rain and Windy',
                              'Heavy Rain Fog',
                              'Heavy Rain Fog  Thunderstorm in Vicinity',
                              'Heavy Rain Fog and Breezy',
                              'Heavy Rain Fog and Windy',
                              'Heavy Rain Fog/Mist',
                              'Heavy Rain Fog/Mist  Thunderstorm in Vicinity',
                              'Heavy Rain Fog/Mist and Breezy',
                              'Heavy Rain Fog/Mist and Windy',
                              'Heavy Showers Rain',
                              'Heavy Showers Rain and Breezy',
                              'Heavy Showers Rain Fog/Mist',
                              'Light Drizzle',
                              'Light Drizzle  Thunderstorm in Vicinity',
                              'Light Drizzle and Breezy',
                              'Light Drizzle and Windy',
                              'Light Drizzle Fog/Mist',
                              'Light Rain',
                              'Light Rain  Fog in Vicinity',
                              'Light Rain  Showers in Vicinity',
                              'Light Rain  Thunderstorm in Vicinity',
                              'Light Rain and Breezy',
                              'Light Rain and Windy',
                              'Light Rain Fog',
                              'Light Rain Fog and Breezy',
                              'Light Rain Fog and Windy',
                              'Light Rain Fog/Mist',
                              'Light Rain Fog/Mist  Thunderstorm in Vicinity',
                              'Light Rain Fog/Mist and Breezy',
                              'Light Rain Fog/Mist and Windy',
                              'Light Rain Fog/Mist Shallow Fog',
                              'Light Rain Fog/Mist Smoke',
                              'Light Rain Haze',
                              'Light Rain Patches Fog',
                              'Light Rain Smoke',
                              'Light Showers Rain',
                              'Light Showers Rain  Thunderstorm in Vicinity',
                              'Light Showers Rain and Breezy',
                              'Light Showers Rain and Windy',
                              'Light Showers Rain Fog',
                              'Light Showers Rain Fog/Mist',
                              'Light Showers Rain Fog/Mist and Breezy',
                              'Light Showers Rain Patches Fog',
                              'Light Snow',
                              'Light Snow and Windy',
                              'Light Snow Fog/Mist',
                              'Rain',
                              'Rain  Thunderstorm in Vicinity',
                              'Rain and Breezy',
                              'Rain and Windy',
                              'Rain Fog',
                              'Rain Fog/Mist',
                              'Rain Fog/Mist  Thunderstorm in Vicinity',
                              'Rain Fog/Mist and Breezy',
                              'Rain Fog/Mist and Windy',
                              'Rain Fog/Mist Squalls',
                              'Rain Patches Fog',
                              'Showers in Vicinity',
                              'Showers in Vicinity and Breezy',
                              'Showers in Vicinity Rain',
                              'Showers Rain',
                              'Showers Rain  Thunderstorm in Vicinity',
                              'Showers Rain  Thunderstorm in Vicinity and Breezy',
                              'Snow',
                              'Squalls and Windy',
                              'Thunderstorm',
                              'Thunderstorm  Showers in Vicinity',
                              'Thunderstorm and Breezy',
                              'Thunderstorm and Windy',
                              'Thunderstorm Blowing Dust',
                              'Thunderstorm Drizzle',
                              'Thunderstorm Drizzle in Vicinity',
                              'Thunderstorm Fog/Mist',
                              'Thunderstorm Fog/Mist and Breezy',
                              'Thunderstorm Fog/Mist in Vicinity',
                              'Thunderstorm Haze',
                              'Thunderstorm Haze and Breezy',
                              'Thunderstorm Haze in Vicinity',
                              'Thunderstorm Heavy Rain',
                              'Thunderstorm Heavy Rain and Breezy',
                              'Thunderstorm Heavy Rain and Windy',
                              'Thunderstorm Heavy Rain Fog',
                              'Thunderstorm Heavy Rain Fog and Breezy',
                              'Thunderstorm Heavy Rain Fog and Windy',
                              'Thunderstorm Heavy Rain Fog/Mist',
                              'Thunderstorm Heavy Rain Fog/Mist and Breezy',
                              'Thunderstorm Heavy Rain Fog/Mist and Windy',
                              'Thunderstorm Heavy Rain in Vicinity',
                              'Thunderstorm Heavy Rain in Vicinity and Breezy',
                              'Thunderstorm Heavy Rain in Vicinity Fog/Mist',
                              'Thunderstorm Heavy Rain Squalls',
                              'Thunderstorm Heavy Snow',
                              'Thunderstorm in Vicinity',
                              'Thunderstorm in Vicinity  Showers in Vicinity',
                              'Thunderstorm in Vicinity and Breezy',
                              'Thunderstorm in Vicinity and Windy',
                              'Thunderstorm in Vicinity Drizzle',
                              'Thunderstorm in Vicinity Drizzle and Breezy',
                              'Thunderstorm in Vicinity Fog',
                              'Thunderstorm in Vicinity Fog and Breezy',
                              'Thunderstorm in Vicinity Fog/Mist',
                              'Thunderstorm in Vicinity Fog/Mist and Breezy',
                              'Thunderstorm in Vicinity Haze',
                              'Thunderstorm in Vicinity Haze and Windy',
                              'Thunderstorm in Vicinity Heavy Rain',
                              'Thunderstorm in Vicinity Heavy Rain and Breezy',
                              'Thunderstorm in Vicinity Heavy Rain Fog',
                              'Thunderstorm in Vicinity Heavy Rain Fog and Breezy',
                              'Thunderstorm in Vicinity Heavy Rain Fog/Mist',
                              'Thunderstorm in Vicinity Heavy Rain Fog/Mist and Breezy',
                              'Thunderstorm in Vicinity Heavy Rain Fog/Mist and Windy',
                              'Thunderstorm in Vicinity Light Rain',
                              'Thunderstorm in Vicinity Light Rain and Breezy',
                              'Thunderstorm in Vicinity Light Rain and Windy',
                              'Thunderstorm in Vicinity Light Rain Fog/Mist',
                              'Thunderstorm in Vicinity Light Rain Fog/Mist and Breezy',
                              'Thunderstorm in Vicinity Light Showers Rain',
                              'Thunderstorm in Vicinity Rain',
                              'Thunderstorm in Vicinity Rain and Breezy',
                              'Thunderstorm in Vicinity Rain and Windy',
                              'Thunderstorm in Vicinity Rain Fog/Mist',
                              'Thunderstorm in Vicinity Rain Fog/Mist and Breezy',
                              'Thunderstorm in Vicinity Smoke',
                              'Thunderstorm in Vicinity Squalls and Breezy',
                              'Thunderstorm in Vicinity Squalls and Windy',
                              'Thunderstorm Light Drizzle',
                              'Thunderstorm Light Drizzle and Breezy',
                              'Thunderstorm Light Drizzle in Vicinity',
                              'Thunderstorm Light Drizzle in Vicinity and Breezy',
                              'Thunderstorm Light Rain',
                              'Thunderstorm Light Rain and Breezy',
                              'Thunderstorm Light Rain and Windy',
                              'Thunderstorm Light Rain Fog/Mist',
                              'Thunderstorm Light Rain Fog/Mist and Breezy',
                              'Thunderstorm Light Rain in Vicinity',
                              'Thunderstorm Light Rain in Vicinity and Breezy',
                              'Thunderstorm Light Rain in Vicinity and Windy',
                              'Thunderstorm Light Rain in Vicinity Fog/Mist',
                              'Thunderstorm Light Snow',
                              'Thunderstorm Light Snow in Vicinity',
                              'Thunderstorm Rain',
                              'Thunderstorm Rain and Breezy',
                              'Thunderstorm Rain and Windy',
                              'Thunderstorm Rain Fog',
                              'Thunderstorm Rain Fog/Mist',
                              'Thunderstorm Rain Fog/Mist and Breezy',
                              'Thunderstorm Rain Fog/Mist and Windy',
                              'Thunderstorm Rain in Vicinity',
                              'Thunderstorm Rain in Vicinity and Breezy',
                              'Thunderstorm Rain in Vicinity and Windy',
                              'Thunderstorm Rain in Vicinity Fog/Mist',
                              'Thunderstorm Showers Rain',
                              'Thunderstorm Snow',
                              'Thunderstorm Unknown Precip',
                              'Thunderstorm Unknown Precip in Vicinity and Breezy'
                             )
Union

Select WeatherHistoricalID,0 as Precipitation 
from [dbo].[WeatherHistorical]
Where CurrentObservation not in ( 'Drizzle',
                              'Drizzle and Breezy',
                              'Drizzle and Windy',
                              'Drizzle Fog/Mist',
                              'Heavy Drizzle',
                              'Heavy Drizzle and Breezy',
                              'Heavy Rain',
                              'Heavy Rain  Thunderstorm in Vicinity',
                              'Heavy Rain  Thunderstorm in Vicinity and Breezy',
                              'Heavy Rain and Breezy',
                              'Heavy Rain and Windy',
                              'Heavy Rain Fog',
                              'Heavy Rain Fog  Thunderstorm in Vicinity',
                              'Heavy Rain Fog and Breezy',
                              'Heavy Rain Fog and Windy',
                              'Heavy Rain Fog/Mist',
                              'Heavy Rain Fog/Mist  Thunderstorm in Vicinity',
                              'Heavy Rain Fog/Mist and Breezy',
                              'Heavy Rain Fog/Mist and Windy',
                              'Heavy Showers Rain',
                              'Heavy Showers Rain and Breezy',
                              'Heavy Showers Rain Fog/Mist',
                              'Light Drizzle',
                              'Light Drizzle  Thunderstorm in Vicinity',
                              'Light Drizzle and Breezy',
                              'Light Drizzle and Windy',
                              'Light Drizzle Fog/Mist',
                              'Light Rain',
                              'Light Rain  Fog in Vicinity',
                              'Light Rain  Showers in Vicinity',
                              'Light Rain  Thunderstorm in Vicinity',
                              'Light Rain and Breezy',
                              'Light Rain and Windy',
                              'Light Rain Fog',
                              'Light Rain Fog and Breezy',
                              'Light Rain Fog and Windy',
                              'Light Rain Fog/Mist',
                              'Light Rain Fog/Mist  Thunderstorm in Vicinity',
                              'Light Rain Fog/Mist and Breezy',
                              'Light Rain Fog/Mist and Windy',
                              'Light Rain Fog/Mist Shallow Fog',
                              'Light Rain Fog/Mist Smoke',
                              'Light Rain Haze',
                              'Light Rain Patches Fog',
                              'Light Rain Smoke',
                              'Light Showers Rain',
                              'Light Showers Rain  Thunderstorm in Vicinity',
                              'Light Showers Rain and Breezy',
                              'Light Showers Rain and Windy',
                              'Light Showers Rain Fog',
                              'Light Showers Rain Fog/Mist',
                              'Light Showers Rain Fog/Mist and Breezy',
                              'Light Showers Rain Patches Fog',
                              'Light Snow',
                              'Light Snow and Windy',
                              'Light Snow Fog/Mist',
                              'Rain',
                              'Rain  Thunderstorm in Vicinity',
                              'Rain and Breezy',
                              'Rain and Windy',
                              'Rain Fog',
                              'Rain Fog/Mist',
                              'Rain Fog/Mist  Thunderstorm in Vicinity',
                              'Rain Fog/Mist and Breezy',
                              'Rain Fog/Mist and Windy',
                              'Rain Fog/Mist Squalls',
                              'Rain Patches Fog',
                              'Showers in Vicinity',
                              'Showers in Vicinity and Breezy',
                              'Showers in Vicinity Rain',
                              'Showers Rain',
                              'Showers Rain  Thunderstorm in Vicinity',
                              'Showers Rain  Thunderstorm in Vicinity and Breezy',
                              'Snow',
                              'Squalls and Windy',
                              'Thunderstorm',
                              'Thunderstorm  Showers in Vicinity',
                              'Thunderstorm and Breezy',
                              'Thunderstorm and Windy',
                              'Thunderstorm Blowing Dust',
                              'Thunderstorm Drizzle',
                              'Thunderstorm Drizzle in Vicinity',
                              'Thunderstorm Fog/Mist',
                              'Thunderstorm Fog/Mist and Breezy',
                              'Thunderstorm Fog/Mist in Vicinity',
                              'Thunderstorm Haze',
                              'Thunderstorm Haze and Breezy',
                              'Thunderstorm Haze in Vicinity',
                              'Thunderstorm Heavy Rain',
                              'Thunderstorm Heavy Rain and Breezy',
                              'Thunderstorm Heavy Rain and Windy',
                              'Thunderstorm Heavy Rain Fog',
                              'Thunderstorm Heavy Rain Fog and Breezy',
                              'Thunderstorm Heavy Rain Fog and Windy',
                              'Thunderstorm Heavy Rain Fog/Mist',
                              'Thunderstorm Heavy Rain Fog/Mist and Breezy',
                              'Thunderstorm Heavy Rain Fog/Mist and Windy',
                              'Thunderstorm Heavy Rain in Vicinity',
                              'Thunderstorm Heavy Rain in Vicinity and Breezy',
                              'Thunderstorm Heavy Rain in Vicinity Fog/Mist',
                              'Thunderstorm Heavy Rain Squalls',
                              'Thunderstorm Heavy Snow',
                              'Thunderstorm in Vicinity',
                              'Thunderstorm in Vicinity  Showers in Vicinity',
                              'Thunderstorm in Vicinity and Breezy',
                              'Thunderstorm in Vicinity and Windy',
                              'Thunderstorm in Vicinity Drizzle',
                              'Thunderstorm in Vicinity Drizzle and Breezy',
                              'Thunderstorm in Vicinity Fog',
                              'Thunderstorm in Vicinity Fog and Breezy',
                              'Thunderstorm in Vicinity Fog/Mist',
                              'Thunderstorm in Vicinity Fog/Mist and Breezy',
                              'Thunderstorm in Vicinity Haze',
                              'Thunderstorm in Vicinity Haze and Windy',
                              'Thunderstorm in Vicinity Heavy Rain',
                              'Thunderstorm in Vicinity Heavy Rain and Breezy',
                              'Thunderstorm in Vicinity Heavy Rain Fog',
                              'Thunderstorm in Vicinity Heavy Rain Fog and Breezy',
                              'Thunderstorm in Vicinity Heavy Rain Fog/Mist',
                              'Thunderstorm in Vicinity Heavy Rain Fog/Mist and Breezy',
                              'Thunderstorm in Vicinity Heavy Rain Fog/Mist and Windy',
                              'Thunderstorm in Vicinity Light Rain',
                              'Thunderstorm in Vicinity Light Rain and Breezy',
                              'Thunderstorm in Vicinity Light Rain and Windy',
                              'Thunderstorm in Vicinity Light Rain Fog/Mist',
                              'Thunderstorm in Vicinity Light Rain Fog/Mist and Breezy',
                              'Thunderstorm in Vicinity Light Showers Rain',
                              'Thunderstorm in Vicinity Rain',
                              'Thunderstorm in Vicinity Rain and Breezy',
                              'Thunderstorm in Vicinity Rain and Windy',
                              'Thunderstorm in Vicinity Rain Fog/Mist',
                              'Thunderstorm in Vicinity Rain Fog/Mist and Breezy',
                              'Thunderstorm in Vicinity Smoke',
                              'Thunderstorm in Vicinity Squalls and Breezy',
                              'Thunderstorm in Vicinity Squalls and Windy',
                              'Thunderstorm Light Drizzle',
                              'Thunderstorm Light Drizzle and Breezy',
                              'Thunderstorm Light Drizzle in Vicinity',
                              'Thunderstorm Light Drizzle in Vicinity and Breezy',
                              'Thunderstorm Light Rain',
                              'Thunderstorm Light Rain and Breezy',
                              'Thunderstorm Light Rain and Windy',
                              'Thunderstorm Light Rain Fog/Mist',
                              'Thunderstorm Light Rain Fog/Mist and Breezy',
                              'Thunderstorm Light Rain in Vicinity',
                              'Thunderstorm Light Rain in Vicinity and Breezy',
                              'Thunderstorm Light Rain in Vicinity and Windy',
                              'Thunderstorm Light Rain in Vicinity Fog/Mist',
                              'Thunderstorm Light Snow',
                              'Thunderstorm Light Snow in Vicinity',
                              'Thunderstorm Rain',
                              'Thunderstorm Rain and Breezy',
                              'Thunderstorm Rain and Windy',
                              'Thunderstorm Rain Fog',
                              'Thunderstorm Rain Fog/Mist',
                              'Thunderstorm Rain Fog/Mist and Breezy',
                              'Thunderstorm Rain Fog/Mist and Windy',
                              'Thunderstorm Rain in Vicinity',
                              'Thunderstorm Rain in Vicinity and Breezy',
                              'Thunderstorm Rain in Vicinity and Windy',
                              'Thunderstorm Rain in Vicinity Fog/Mist',
                              'Thunderstorm Showers Rain',
                              'Thunderstorm Snow',
                              'Thunderstorm Unknown Precip',
                              'Thunderstorm Unknown Precip in Vicinity and Breezy'
                             )

GO
/****** Object:  Table [dbo].[WeatherFeed]    Script Date: 2/25/2018 9:59:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeatherFeed](
	[WeatherFeedID] [int] IDENTITY(1,1) NOT NULL,
	[ObservationLocation] [varchar](85) NOT NULL,
	[ObservationStationCode] [char](4) NOT NULL,
	[ObservationURL] [varchar](75) NOT NULL,
	[ObservationState] [char](2) NOT NULL,
	[LocationLat] [decimal](11, 7) NULL,
	[LocationLong] [decimal](11, 7) NULL,
	[DateAdded] [datetime] NOT NULL,
	[DateModified] [datetime] NOT NULL,
	[IsWeatherFeedActive] [bit] NOT NULL,
 CONSTRAINT [PK_WeatherFeedTable] PRIMARY KEY CLUSTERED 
(
	[WeatherFeedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [NonClusteredIndex-20170821-202511]    Script Date: 2/25/2018 9:59:02 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20170821-202511] ON [dbo].[WeatherHistorical]
(
	[WeatherFeedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WeatherFeed] ADD  CONSTRAINT [DF_WeatherFeedTable_DateAdded]  DEFAULT (getdate()) FOR [DateAdded]
GO
ALTER TABLE [dbo].[WeatherFeed] ADD  CONSTRAINT [DF_WeatherFeedTable_DateModified]  DEFAULT (getdate()) FOR [DateModified]
GO
ALTER TABLE [dbo].[WeatherFeed] ADD  CONSTRAINT [DF_WeatherFeedTable_IsActive]  DEFAULT ((1)) FOR [IsWeatherFeedActive]
GO
ALTER TABLE [dbo].[WeatherHistorical] ADD  CONSTRAINT [DF_WeatherHistorical_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
USE [master]
GO
ALTER DATABASE [WeatherDB_US] SET  READ_WRITE 
GO

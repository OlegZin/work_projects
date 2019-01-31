USE [master]
GO
/****** Object:  Database [PDM]    Script Date: 31.01.2019 16:45:52 ******/
CREATE DATABASE [PDM]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PDM', FILENAME = N'D:\base_test\PDM.mdf' , SIZE = 68608KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'PDM_log', FILENAME = N'D:\base_test\PDM_log.ldf' , SIZE = 915968KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [PDM] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PDM].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PDM] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PDM] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PDM] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PDM] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PDM] SET ARITHABORT OFF 
GO
ALTER DATABASE [PDM] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PDM] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PDM] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PDM] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PDM] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PDM] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PDM] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PDM] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PDM] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PDM] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PDM] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PDM] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PDM] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PDM] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PDM] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PDM] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PDM] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PDM] SET RECOVERY FULL 
GO
ALTER DATABASE [PDM] SET  MULTI_USER 
GO
ALTER DATABASE [PDM] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PDM] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PDM] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PDM] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [PDM] SET DELAYED_DURABILITY = DISABLED 
GO
USE [PDM]
GO
/****** Object:  Table [dbo].[document_complex]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_complex](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[created] [datetime] NULL,
	[uid] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[document_extra]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[document_extra](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[object_id] [int] NOT NULL,
	[is_agree] [int] NOT NULL,
	[is_complex] [int] NOT NULL,
	[is_actual] [int] NOT NULL,
	[is_support] [int] NOT NULL,
	[filename] [varchar](100) NULL,
	[type] [int] NULL,
	[fullname] [varchar](200) NULL,
	[hash] [varchar](50) NULL,
	[version] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[document_extra_old]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[document_extra_old](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[object_id] [int] NOT NULL,
	[version] [int] NOT NULL,
	[is_in_work] [bit] NOT NULL,
	[work_uid] [int] NULL,
	[is_agree] [bit] NOT NULL,
	[is_complex] [bit] NOT NULL,
	[is_actual] [bit] NOT NULL,
	[is_support] [bit] NOT NULL,
	[name] [varchar](100) NULL,
	[type] [int] NULL,
	[fullname] [varchar](200) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[document_inwork]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_inwork](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[uid] [int] NOT NULL,
	[created] [datetime] NOT NULL,
	[minor_version] [float] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[document_object]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_object](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[created] [datetime] NULL,
	[uid] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[document_object_history]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[document_object_history](
	[fid] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NOT NULL,
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[created] [datetime] NULL,
	[uid] [int] NULL,
	[deleted] [datetime] NULL,
	[huid] [int] NULL,
	[comment] [varchar](max) NULL,
	[operation_id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[document_type]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[document_type](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) NOT NULL,
	[ext] [varchar](5) NULL,
	[program] [varchar](50) NULL,
	[icon] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[document_version]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[document_version](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[created] [datetime] NULL,
	[uid] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[employees]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[employees](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fio] [varchar](200) NULL,
	[name] [varchar](100) NULL,
	[subdiv_id] [int] NULL,
	[subdiv_group_id] [int] NULL,
	[id_1c] [char](11) NULL,
	[is_del] [bit] NOT NULL,
	[phones_inner] [int] NULL,
	[phones_outer] [bigint] NULL,
	[post_id] [int] NULL,
	[location_id] [int] NULL,
	[user_id] [int] NULL,
	[ord] [int] NOT NULL,
	[is_visible] [bit] NOT NULL,
	[is_decret] [bit] NOT NULL,
	[color] [int] NULL,
	[email] [varchar](100) NULL,
	[host] [varchar](50) NULL,
	[mobile_ph] [bigint] NULL,
	[directum_id] [int] NULL,
	[is_vacation] [bit] NULL,
	[vacation_dateAt] [datetime] NULL,
	[phones1] [varchar](11) NULL,
	[IAmHere] [bit] NULL,
	[company_id] [int] NOT NULL,
	[have_photo] [bit] NULL,
	[tabnum] [int] NULL,
	[pars_id] [uniqueidentifier] NULL,
	[is_working] [bit] NOT NULL,
	[codeRef_1C_upp] [varchar](79) NULL,
	[sklad_id] [int] NULL,
 CONSTRAINT [PK_employees] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[navigation]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[navigation](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[uid] [int] NOT NULL,
	[created] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[navigation_cross]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[navigation_cross](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[link_id] [int] NOT NULL,
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[base_link_id] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[navigation_cross_history]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[navigation_cross_history](
	[fid] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NOT NULL,
	[link_id] [int] NOT NULL,
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[base_link_id] [int] NULL,
	[deleted] [datetime] NULL,
	[huid] [int] NULL,
	[comment] [varchar](max) NULL,
	[operation_id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[navigation_history]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[navigation_history](
	[fid] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NULL,
	[parent] [int] NULL,
	[child] [int] NULL,
	[uid] [int] NULL,
	[created] [datetime] NULL,
	[deleted] [datetime] NULL,
	[huid] [int] NULL,
	[comment] [varchar](max) NULL,
	[operation_id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[object]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[object](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[kind] [int] NOT NULL,
	[mass] [float] NULL,
	[name] [varchar](1000) NULL,
	[mark] [varchar](100) NULL,
	[created] [datetime] NULL,
	[uid] [int] NULL,
	[icon] [varchar](50) NULL,
	[comment] [varchar](max) NULL,
	[has_docs] [int] NULL,
 CONSTRAINT [PK_object] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[object_classificator]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[object_classificator](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[descript] [nvarchar](max) NULL,
	[kind] [int] NULL,
	[extratable] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[object_history]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[object_history](
	[fid] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NOT NULL,
	[kind] [int] NOT NULL,
	[mass] [float] NULL,
	[name] [varchar](1000) NULL,
	[mark] [varchar](100) NULL,
	[created] [datetime] NULL,
	[uid] [int] NULL,
	[icon] [varchar](50) NULL,
	[deleted] [datetime] NULL,
	[huid] [int] NULL,
	[hcomment] [varchar](max) NULL,
	[operation_id] [int] NULL,
	[comment] [varchar](max) NULL,
	[has_docs] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[operation]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[operation](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pdm_MailCondition]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pdm_MailCondition](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[condition] [nvarchar](max) NULL,
	[id_mailList] [int] NOT NULL,
	[deleted] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[pdm_MailList]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pdm_MailList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[naim] [nvarchar](256) NULL,
	[subject] [nvarchar](50) NULL,
	[body] [nvarchar](max) NULL,
	[deleted] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[pdm_Programs]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pdm_Programs](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[detail] [nvarchar](500) NULL,
	[icon] [nvarchar](50) NULL,
	[deleted] [bit] NOT NULL,
	[condition] [nvarchar](500) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[pdm_ProgVersions]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pdm_ProgVersions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[detail] [nvarchar](200) NULL,
	[icon] [nvarchar](50) NULL,
	[filename] [nvarchar](max) NULL,
	[deleted] [bit] NOT NULL,
	[ProgId] [int] NULL,
	[condition] [nvarchar](max) NULL,
	[status] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[pdm_Settings]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pdm_Settings](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[progName] [nvarchar](100) NULL,
	[section] [nvarchar](100) NULL,
	[propName] [nvarchar](100) NULL,
	[value] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[section_kind]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[section_kind](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[object_id] [int] NOT NULL,
	[kind] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[structure]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[structure](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[created] [datetime] NULL,
	[uid] [int] NULL,
	[count] [float] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[structure_cross]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[structure_cross](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[link_id] [int] NOT NULL,
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[base_link_id] [int] NULL,
 CONSTRAINT [PK_link_cross] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[structure_history]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[structure_history](
	[fid] [int] IDENTITY(1,1) NOT NULL,
	[id] [int] NULL,
	[parent] [int] NULL,
	[child] [int] NULL,
	[created] [datetime] NULL,
	[uid] [int] NULL,
	[count] [float] NULL,
	[deleted] [datetime] NULL,
	[huid] [int] NULL,
	[comment] [varchar](max) NULL,
	[operation_id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[test]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id2] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[vDocInWork]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vDocInWork]
AS
SELECT        dbo.document_inwork.parent, FORMAT(dbo.document_inwork.created, 'd', 'de-de') AS created, dbo.document_extra.is_agree, dbo.document_extra.is_complex, dbo.document_extra.is_actual, dbo.document_extra.is_support, 
                         dbo.document_extra.filename, dbo.document_extra.type, dbo.document_extra.fullname, dbo.document_extra.hash, employees_1.fio AS work_fio, object_2.uid, dbo.document_extra.object_id, dbo.document_inwork.id AS link_id, 
                         ISNULL(dbo.document_extra.version - 1, 0) + ISNULL(dbo.document_inwork.minor_version, 0) AS full_version, dbo.document_inwork.minor_version, dbo.employees.fio AS autor_fio, dbo.object.name AS object_name, 
                         object_3.name AS doc_name, dbo.document_extra.version, dbo.document_inwork.child, document_object_1.id AS document_object_link_id
FROM            dbo.object AS object_1 INNER JOIN
                         dbo.document_inwork ON object_1.id = dbo.document_inwork.parent INNER JOIN
                         dbo.employees ON object_1.uid = dbo.employees.id INNER JOIN
                         dbo.document_object ON object_1.id = dbo.document_object.child INNER JOIN
                         dbo.object ON dbo.document_object.parent = dbo.object.id INNER JOIN
                         dbo.object AS object_3 ON dbo.document_inwork.child = object_3.id INNER JOIN
                         dbo.document_object AS document_object_1 ON dbo.document_inwork.child = document_object_1.child LEFT OUTER JOIN
                         dbo.object AS object_2 INNER JOIN
                         dbo.document_extra ON object_2.id = dbo.document_extra.object_id ON dbo.document_inwork.child = dbo.document_extra.object_id LEFT OUTER JOIN
                         dbo.employees AS employees_1 ON dbo.document_inwork.uid = employees_1.id

GO
/****** Object:  View [dbo].[vDocument1]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vDocument1]
AS
SELECT        do.id AS link_id, do.parent, do.child, e1.fio AS autor_fio, dt.ext, o1.name AS object_name, FORMAT(o2.created, 'd', 'de-de') AS created, o2.comment, CASE WHEN (ISNULL(dbo.document_inwork.minor_version, 0) = 0) 
                         THEN de.version ELSE (de.version - 1) + ISNULL(dbo.document_inwork.minor_version, 0) END AS full_version, de.is_agree, de.is_complex, de.is_actual, de.is_support, de.type, de.fullname, de.hash, de.filename, 
                         o2.name AS doc_name, dbo.employees.fio AS work_fio, dbo.document_inwork.created AS edited, dbo.document_inwork.minor_version, de.version
FROM            dbo.document_object AS do LEFT OUTER JOIN
                         dbo.document_inwork ON do.child = dbo.document_inwork.child LEFT OUTER JOIN
                         dbo.object AS o1 ON do.parent = o1.id LEFT OUTER JOIN
                         dbo.object AS o2 ON do.child = o2.id LEFT OUTER JOIN
                         dbo.document_extra AS de ON do.child = de.object_id LEFT OUTER JOIN
                         dbo.employees AS e1 ON do.uid = e1.id LEFT OUTER JOIN
                         dbo.document_type AS dt ON dt.id = de.type LEFT OUTER JOIN
                         dbo.employees ON dbo.document_inwork.uid = dbo.employees.id

GO
/****** Object:  View [dbo].[vGroup]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vGroup]
AS
SELECT        dbo.object.kind, dbo.object.mass, dbo.object.name, dbo.object.mark, dbo.object.icon, dbo.object.created AS oCreated, dbo.object.uid AS oUid, dbo.navigation.parent, dbo.navigation.child, dbo.navigation.id AS lId, 
                         dbo.navigation.uid AS luid, dbo.object.id AS oId, dbo.navigation.created AS lCreated, dbo.object.comment, dbo.object.has_docs, NULL AS count
FROM            dbo.navigation INNER JOIN
                         dbo.object ON dbo.navigation.child = dbo.object.id

GO
/****** Object:  View [dbo].[vObject]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vObject]
AS
SELECT        dbo.object.name, dbo.object.kind, dbo.object.mass, dbo.object.mark, dbo.object.icon, dbo.structure.id AS lId, dbo.object.uid AS oUid, dbo.structure.uid AS lUid, dbo.object.created AS oCreated, dbo.structure.created AS lCreated, 
                         dbo.structure.count, dbo.object.has_docs, dbo.object.comment, dbo.structure.parent, dbo.structure.child, dbo.structure.id, dbo.structure.created, dbo.structure.uid
FROM            dbo.object INNER JOIN
                         dbo.structure ON dbo.object.id = dbo.structure.child

GO
ALTER TABLE [dbo].[document_extra] ADD  CONSTRAINT [DF_extra_document_is_agree1]  DEFAULT ((0)) FOR [is_agree]
GO
ALTER TABLE [dbo].[document_extra] ADD  CONSTRAINT [DF_extra_document_is_complex1]  DEFAULT ((0)) FOR [is_complex]
GO
ALTER TABLE [dbo].[document_extra] ADD  CONSTRAINT [DF_extra_document_is_actual1]  DEFAULT ((0)) FOR [is_actual]
GO
ALTER TABLE [dbo].[document_extra] ADD  CONSTRAINT [DF_extra_document_is_support1]  DEFAULT ((0)) FOR [is_support]
GO
ALTER TABLE [dbo].[document_extra_old] ADD  CONSTRAINT [DF_document_extra_version]  DEFAULT ((1)) FOR [version]
GO
ALTER TABLE [dbo].[document_extra_old] ADD  CONSTRAINT [DF_extra_document_in_work]  DEFAULT ((0)) FOR [is_in_work]
GO
ALTER TABLE [dbo].[document_extra_old] ADD  CONSTRAINT [DF_extra_document_is_agree]  DEFAULT ((0)) FOR [is_agree]
GO
ALTER TABLE [dbo].[document_extra_old] ADD  CONSTRAINT [DF_extra_document_is_complex]  DEFAULT ((0)) FOR [is_complex]
GO
ALTER TABLE [dbo].[document_extra_old] ADD  CONSTRAINT [DF_extra_document_is_actual]  DEFAULT ((0)) FOR [is_actual]
GO
ALTER TABLE [dbo].[document_extra_old] ADD  CONSTRAINT [DF_extra_document_is_support]  DEFAULT ((0)) FOR [is_support]
GO
ALTER TABLE [dbo].[document_inwork] ADD  CONSTRAINT [DF_document_inwork_minor_version]  DEFAULT ((0)) FOR [minor_version]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_employees_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_employees_ord]  DEFAULT ((65535)) FOR [ord]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_employees_is_visible]  DEFAULT ((1)) FOR [is_visible]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_employees_is_decret]  DEFAULT ((0)) FOR [is_decret]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_employees_color]  DEFAULT ((8388608)) FOR [color]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_employees_company_id]  DEFAULT ((0)) FOR [company_id]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF_employees_is_working]  DEFAULT ((1)) FOR [is_working]
GO
ALTER TABLE [dbo].[object] ADD  CONSTRAINT [DF_object_has_docs]  DEFAULT ((0)) FOR [has_docs]
GO
ALTER TABLE [dbo].[pdm_MailCondition] ADD  CONSTRAINT [DF_pdm_MailCondition_deleted]  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[pdm_MailList] ADD  CONSTRAINT [DF_pdm_MailList_deleted]  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[pdm_Programs] ADD  CONSTRAINT [DF_pdm_Programs_deleted]  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[pdm_ProgVersions] ADD  CONSTRAINT [DF_pdm_ProgVersions_deleted]  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[pdm_ProgVersions] ADD  CONSTRAINT [DF_pdm_ProgVersions_status]  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[structure] ADD  CONSTRAINT [DF_link_count]  DEFAULT ((1)) FOR [count]
GO
/****** Object:  StoredProcedure [dbo].[pdm_CREATE_CROSS_LINKS]    Script Date: 31.01.2019 16:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Зиновьев О.Н.
-- Create date: 29.11.2018
-- Description:	
--     Создает набор вспомогательных ссылок (маршрутов) в таблице [@tableName]_cross, отвечающей за быструю нваигацию по дереву связей таблицы [@tableName].
--     По сути, это набор всех предков по дереву [@tableName] для указанной связки. Выбираются как id связки, так и текущие значения Parent и Child
--     этих связок. Данные избыточные, но позволяют не привязываться к другим таблицам и делают этот механизм независимым.

--     Процедура заточена под рекурсивный вызов.

-- Алгоритм работы:
--     - для текущей связки ( [@tableName].id ) берутся все записи, где [@tableName].child = [@tableName].parent текущей связи
--     - текущие данные заносятся в маршрут (таблица [@tableName]_cross)
--     - получаем список родителей и для каждого рекурсивно вызываем эту же процедуру, чтобы обработать все ответвления связей

-- После отработки всех рекурсий, получим список всех предков базовой связки вплоть до корневого элемента
-- =============================================
CREATE PROCEDURE [dbo].[pdm_CREATE_CROSS_LINKS] 
    @tableName sysname,        -- имя исходной таблицы в которой искать данные
	@link_id int,              -- id текущей обрабатываемой записи-связи из таблицы связей
	@base_link_id int = 0      -- при рекурсивном запуске - id исходной записи-связи из таблицы связей, для которой строится набор
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @sql nvarchar(max)

	
	-- первая итерация
	IF @base_link_id = 0
	BEGIN 
	     SET @base_link_id = @link_id
		 -- чистим маршрут для базовой связки, если есть какой-то мусор
		 -- (отменено, поскольку требуется перед удалением скинуть имеющиеся в архив, что данная процедура не сможет сделать
		 --  и данная задача возложена на программу )
--		 SET @sql = 'DELETE FROM ' + @tableName + '_cross WHERE base_link_id = '+CAST(@link_id as varchar) 
--		 EXEC(@sql)
      
	END


	SET @sql = 
	+ N' DECLARE @parent int '
	+ N' DECLARE @child int '
	-- получаем данные текущей связки
	+ N' SELECT @parent = parent, @child = child FROM '+@tableName+' WHERE id = ' + CAST(@link_id as varchar)
	-- добавляем ее в маршрут
--	+ N' IF NOT EXISTS (SELECT * FROM '+@tableName+'_cross WHERE link_id = '+CAST(@link_id as varchar)+' AND base_link_id = '+CAST(@base_link_id as varchar)+' AND parent = @parent AND child = @child ) '
	+ N' INSERT INTO '+@tableName+'_cross (link_id, base_link_id, parent, child) VALUES ('+CAST(@link_id as varchar)+', '+CAST(@base_link_id as varchar)+', @parent, @child) '
    -- получаем всех родителей текущей связки
	+ N' DECLARE @p int '
	+ N' DECLARE c'+CAST(@link_id as varchar)+' CURSOR '
	+ N' FOR SELECT id FROM '+@tableName+' WHERE child = @parent '
	+ N' OPEN c'+CAST(@link_id as varchar)+' '
	+ N' FETCH NEXT FROM c'+CAST(@link_id as varchar)+' INTO @p; '
	+ N' WHILE @@FETCH_STATUS = 0 ' 
	+ N' BEGIN ' 
         -- рекурсивно обрабатываем каждого предка
	+ N'     EXEC pdm_CREATE_CROSS_LINKS '+@tableName+', @p, '+CAST(@base_link_id as varchar)
	+ N'     FETCH NEXT FROM c'+CAST(@link_id as varchar)+' INTO @p '
	+ N' END '
	+ N' CLOSE c'+CAST(@link_id as varchar)+'; ' 
	+ N' DEALLOCATE c'+CAST(@link_id as varchar)+'; ' 

	exec sp_executesql @sql
    
END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Хранит дополнительные поля для объектов-документов (kind = 12)
содержит набор признаков для функционала работы с документами.
фактическое хранение файла документа в базе [FilesDB].[PDMFiles], где значение поля [name] совпадает со значением [name] в объекте-документа [object].[name].
дерево версий содержится в таблице [doc_version]
дерево структуры сложного документа хранится в таблице [doc_complex]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ссылка на основной объект документа в таблице object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra', @level2type=N'COLUMN',@level2name=N'object_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'признак того, что данная версия прошла все согласования и является принятой. может быть несколько принятых версий за всю историю существтвания докумена.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra', @level2type=N'COLUMN',@level2name=N'is_agree'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'признак того, что это документ содержащий в себе другие файлы.
например, чертеж, содержащий привязанные картинки и другие источники.
при выгрузке для просмотра/редактирования, документ будет выгружен вместе со всеми вложенными в него файлами (они хранятся как отдельные записи в таблице object c признаком is_support = 1). структура связей хранится в таблице doc_complex)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra', @level2type=N'COLUMN',@level2name=N'is_complex'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Отмечает единственную актуальную в текущий момент версию. признак может быть установлен только для утвержденного документа с is_agree = 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra', @level2type=N'COLUMN',@level2name=N'is_actual'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'признак вспомогательного файла. т.е. он является составной частью другого документа. признак облегчает фильтрацию и выборку, чтобы не шерстить таблицу doc_complex для поиска основных файлов объекта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra', @level2type=N'COLUMN',@level2name=N'is_support'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя файла для отображения в интерфейсе программы' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra', @level2type=N'COLUMN',@level2name=N'filename'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип документа из справочника document_type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra', @level2type=N'COLUMN',@level2name=N'type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя документа, являющееся ссылкой на поле [FilesDB].[PDMFiles].[name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra', @level2type=N'COLUMN',@level2name=N'fullname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'хэш файла для отслеживания наличия изменений при создании новой версии из текущей' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra', @level2type=N'COLUMN',@level2name=N'hash'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Хранит дополнительные поля для объектов-документов (kind = 12)
содержит набор признаков для функционала работы с документами.
фактическое хранение файла документа в базе [FilesDB].[PDMFiles], где значение поля [name] совпадает со значением [name] в объекте-документа [object].[name].
дерево версий содержится в таблице [doc_version]
дерево структуры сложного документа хранится в таблице [doc_complex]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ссылка на основной объект документа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'object_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'версия документа. в базе хранятся все версии, пока не будут принудительно удалены. версии образуют дерево, струкутра которого хранится в таблице doc_versions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'version'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'признак, что данную версию документа один из пользователей взял в работу.
при этом копия файла выгружена на его локальный компьютер, а доступ к редактированию другими пользователями блокируется,
пока пользователь не загрузит отредактированный файл в базу как новую версию, либо блок не будет снят принудительно (например, когда документ нужен, а его забрал пользователь, находящийся в отпуске)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'is_in_work'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id пользователя, взявшего данный документ в работу' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'work_uid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'признак того, что данная версия прошла все согласования и является принятой. может быть несколько принятых версий за всю историю существтвания докумена.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'is_agree'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'признак того, что это документ содержащий в себе другие файлы.
например, чертеж, содержащий привязанные картинки и другие источники.
при выгрузке для просмотра/редактирования, документ будет выгружен вместе со всеми вложенными в него файлами (они хранятся как отдельные записи в таблице object c признаком is_support = 1). структура связей хранится в таблице doc_complex)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'is_complex'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Отмечает единственную актуальную в текущий момент версию. признак может быть установлен только для утвержденного документа с is_agree = 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'is_actual'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'признак вспомогательного файла. т.е. он является составной частью другого документа. признак облегчает фильтрацию и выборку, чтобы не шерстить таблицу doc_complex для поиска основных файлов объекта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'is_support'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя документа, являющееся ссылкой на поле [FilesDB].[PDMFiles].[name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип документа из справочника document_type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_extra_old', @level2type=N'COLUMN',@level2name=N'type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица привязок рабочих версий документов к их исходным версиям.
При взятии документа в работу, создается новая версия (копия) и привязывается к исходной, как рабочая версия с установкой минорной версии в 1.
при сохранении рабочей версии не создаются новые файлы в хранилище, а перезаписывается имеющийся, пока он не получит статус новой версии ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_inwork', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id документа исходной версии' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_inwork', @level2type=N'COLUMN',@level2name=N'parent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id документа рабочей версии' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_inwork', @level2type=N'COLUMN',@level2name=N'child'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id пользователя, взявшего документ в работу' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_inwork', @level2type=N'COLUMN',@level2name=N'uid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'дата взятия версии в работу' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_inwork', @level2type=N'COLUMN',@level2name=N'created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица дерева связей версий документов. Какая была создана из какой.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'document_version', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'подразделение' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'subdiv_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'код 1с' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'id_1c'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'уволен/удален' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'is_del'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Внутрение номера телефона' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'phones_inner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Внешние номера телефона' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'phones_outer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Должность' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'post_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Расположение, местонахождение кабинета, рабочего места' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'location_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'цвет в отчете' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'color'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 - в отпуске' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'is_vacation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата отпуска по' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'vacation_dateAt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Компания: 0 - НМ; 1 - СНМ; 2 - СНА;' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'company_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'табельный номер' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'tabnum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'на работе' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'is_working'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ссылка на пользователя БД 1С УПП, справочник ПОЛЬЗОВАТЕЛИ. 
Используется для простановки ответственного при загрузке документов из БД НФТ в БД 1С УПП.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'codeRef_1C_upp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Склад закрепленный за подразделением. Например, используется при загрузке документов перемещений из НФТ в 1С. В таблице employees есть ссылка на склад, это нужно, когда в одном подразделении более одного склада за разными ответственными.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employees', @level2type=N'COLUMN',@level2name=N'sklad_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Родительский элемент дерева (id этой же таблицы)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'navigation', @level2type=N'COLUMN',@level2name=N'parent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Элемент дерева (id таблицы navigation)
дополнительный элемент для механизма непрямыз ссылок.
для записи с прямой ссылкой child на parent содержит id записи (fact = 1).
для записи с непрямой ссылкой (на одного из родителей высокого уровня, fact = 0), содержит id записи с прямой ссылкой.

Данный подход позволяет за один проход таблицы запросом получить как записи всех родителей, вплоть до корневого, так и всех непосредственных потомков. что резко ускоряет работу с деревом (должно, по крайней мере)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'navigation', @level2type=N'COLUMN',@level2name=N'child'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Если установлено - id пользователя создавшего связку. По-умолчанию видима только ему. Но могут существтвать дополнительные связки в настройках доступа с другими пользователями, группами' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'navigation', @level2type=N'COLUMN',@level2name=N'uid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ссылка на запись таблицы Operation, содержащей развернутое описание операции. Для оптимизации объема хранимых данных.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'navigation_history', @level2type=N'COLUMN',@level2name=N'operation_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'комментарий к объекту в свободной форме' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'object', @level2type=N'COLUMN',@level2name=N'comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип объект, используется в таблице Object для разделения объектов по типам' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'object_classificator', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя таблицы в базе, хранящая дополнителные данные для объекта данного типа (в дополнение к данным таблицы object)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'object_classificator', @level2type=N'COLUMN',@level2name=N'extratable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица с условиями выборки получателей рассылок таблицы pdm_MailList' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_MailCondition', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'условие для раздела WHERE запроса из таблицы employeer. каждое условие для рассылки добавляется к запросу через OR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_MailCondition', @level2type=N'COLUMN',@level2name=N'condition'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ссылка на рассылку из pdm_MailList' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_MailCondition', @level2type=N'COLUMN',@level2name=N'id_mailList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица email-рассылок' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_MailList', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наименование рассылки, одновременно - идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_MailList', @level2type=N'COLUMN',@level2name=N'naim'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'указывается в теме письма' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_MailList', @level2type=N'COLUMN',@level2name=N'subject'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'текст письма. можно с HTML разметкой. формат поля поддерживает unicode в тексте' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_MailList', @level2type=N'COLUMN',@level2name=N'body'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'краткое описание, видимое в списке програм под наименованием' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_ProgVersions', @level2type=N'COLUMN',@level2name=N'detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'имя иконки для отображения в списке версий. ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_ProgVersions', @level2type=N'COLUMN',@level2name=N'icon'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'путь и имя исполняемого файла с расширением' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_ProgVersions', @level2type=N'COLUMN',@level2name=N'filename'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'признак удаления. 0 - не удален, 1 - удален и исключается из рабочих выборок' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_ProgVersions', @level2type=N'COLUMN',@level2name=N'deleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'версией какой программы является (таблица pdm_Programs)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_ProgVersions', @level2type=N'COLUMN',@level2name=N'ProgId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'при STATUS = 0, содержит строку-условие для WHERE выборки по таблице EMPLOYEES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_ProgVersions', @level2type=N'COLUMN',@level2name=N'condition'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип версии: 0 - персональная, 1- общедоступная рабочая, 2 - общедоступная тестовая' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pdm_ProgVersions', @level2type=N'COLUMN',@level2name=N'status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'объект типа "раздел"' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'section_kind', @level2type=N'COLUMN',@level2name=N'object_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Отображение/добавление какого типа поддерживает (id из object_classificator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'section_kind', @level2type=N'COLUMN',@level2name=N'kind'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'родительский объект связки (id )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'structure', @level2type=N'COLUMN',@level2name=N'parent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ривязываемый объект' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'structure', @level2type=N'COLUMN',@level2name=N'child'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'время создания этой версии связки (с момента последнего изменения)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'structure', @level2type=N'COLUMN',@level2name=N'created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'пользователь, создавший эту версию связки' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'structure', @level2type=N'COLUMN',@level2name=N'uid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'количество привязанных объектов в текущих единицах изменения' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'structure', @level2type=N'COLUMN',@level2name=N'count'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[55] 4[19] 2[18] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "object_1"
            Begin Extent = 
               Top = 1
               Left = 495
               Bottom = 181
               Right = 669
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "document_inwork"
            Begin Extent = 
               Top = 0
               Left = 727
               Bottom = 228
               Right = 901
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "employees"
            Begin Extent = 
               Top = 151
               Left = 27
               Bottom = 281
               Right = 204
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "document_object"
            Begin Extent = 
               Top = 11
               Left = 269
               Bottom = 141
               Right = 443
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "object"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "object_3"
            Begin Extent = 
               Top = 291
               Left = 511
               Bottom = 421
               Right = 685
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "object_2"
            Begin Extent = 
               Top = 15
               Left = 1168
               Bottom = 275
               Right = 1342
            End
            ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vDocInWork'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "document_extra"
            Begin Extent = 
               Top = 0
               Left = 951
               Bottom = 298
               Right = 1125
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "employees_1"
            Begin Extent = 
               Top = 236
               Left = 295
               Bottom = 408
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "document_object_1"
            Begin Extent = 
               Top = 332
               Left = 950
               Bottom = 462
               Right = 1124
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2850
         Alias = 1590
         Table = 1740
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vDocInWork'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vDocInWork'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[52] 4[29] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "do"
            Begin Extent = 
               Top = 189
               Left = 391
               Bottom = 343
               Right = 565
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "document_inwork"
            Begin Extent = 
               Top = 337
               Left = 906
               Bottom = 509
               Right = 1080
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "o1"
            Begin Extent = 
               Top = 27
               Left = 65
               Bottom = 195
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "o2"
            Begin Extent = 
               Top = 218
               Left = 71
               Bottom = 471
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "de"
            Begin Extent = 
               Top = 0
               Left = 623
               Bottom = 294
               Right = 797
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e1"
            Begin Extent = 
               Top = 405
               Left = 599
               Bottom = 576
               Right = 776
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dt"
            Begin Extent = 
               Top = 141
               Left = 913
               Bottom = 300
               Right = 1087
            End
            DisplayFlags = 280
            Top' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vDocument1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'Column = 0
         End
         Begin Table = "employees"
            Begin Extent = 
               Top = 542
               Left = 1113
               Bottom = 672
               Right = 1290
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1980
         Table = 2025
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vDocument1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vDocument1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "navigation"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 215
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "object"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 220
               Right = 428
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vGroup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vGroup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[32] 4[41] 2[9] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "object"
            Begin Extent = 
               Top = 17
               Left = 324
               Bottom = 217
               Right = 506
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "structure"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 208
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 5220
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vObject'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vObject'
GO
USE [master]
GO
ALTER DATABASE [PDM] SET  READ_WRITE 
GO

drop table IBERPLAS.CP_TCargaOrdenProduccion
CREATE TABLE IBERPLAS.CP_TCargaOrdenProduccion(
      ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ORDEN_PRODUCCION	VARCHAR(10)	NOT NULL,
      ARTICULO			VARCHAR(25)	NOT NULL,
      REFERENCIA		VARCHAR(50)	NULL,
      CANTIDAD_ARTICULO	DECIMAL(28,8)	NOT NULL,
      CANTIDAD_PRODUCCI	DECIMAL(28,8)	 NULL,
      FECHA_REQUERIDA	DATETIME	NOT NULL,
      FECHA_CREACION	DATETIME	NOT NULL,
      PISO_ID	        int	 NULL,

)


CREATE TABLE IBERPLAS.fullcalendareventos(
      ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      fechainicio datetime	NOT NULL,
      fechafin datetime	null,
      todoeldia	bit	NULL,
      color	varchar(100) NULL,
      titulo	varchar(100)NULL,
      turno	varchar(25)	NULL,
      equipo	varchar(25)NULL,
     
)




USE [ibertplastic]
GO

/****** Object:  Table [IBERPLAS].[CP_EQUIPOARTICULO]    Script Date: 01/01/2018 15:26:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[IBERPLAS].[CP_EQUIPOARTICULO]') AND type in (N'U'))
DROP TABLE [IBERPLAS].[CP_EQUIPOARTICULO]
GO

USE [ibertplastic]
GO

/****** Object:  Table [IBERPLAS].[CP_EQUIPOARTICULO]    Script Date: 01/01/2018 15:26:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [IBERPLAS].[CP_EQUIPOARTICULO](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EQUIPO] [varchar](10) NOT NULL,
	[DESC_EQUIPO] [varchar](200) NOT NULL,
	[ARTICULO] [varchar](25) NOT NULL,
	[NUM_CAVIDADES] [decimal](28, 2) NOT NULL,
	[PIEZASXHORAS] [decimal](28, 2) NOT NULL,
	[CICLO_SEG_MAQUINA] [decimal](28, 2) NOT NULL,
	[HORA_HOLGURASXDIA] [decimal](28, 2) NOT NULL,
	[NUM_OPERADORES] [decimal](28, 2) NOT NULL,
	[COLOR][varchar] (50) NULL,
	[OPERACION][varchar] (50) NULL,
	[TIEMPOMOLDE][decimal] (28,2) NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
GO
select * from IBERPLAS.TURNO




insert into IBERPLAS.CP_TCargaOrdenProduccion(ORDEN_PRODUCCION,ARTICULO,REFERENCIA,CANTIDAD_ARTICULO,FECHA_REQUERIDA,FECHA_CREACION,CANTIDAD_PRODUCCI)
SELECT ORDEN_PRODUCCION, ARTICULO,REFERENCIA, CANTIDAD_ARTICULO, FECHA_REQUERIDA, FECHA_CREACION,0.00 
FROM IBERPLAS.ORDEN_PRODUCCION
WHERE 
ESTADO in ('F','L') 
and ORDEN_PRODUCCION not in (select ORDEN_PRODUCCION from IBERPLAS.CP_TCargaOrdenProduccion)

update IBERPLAS.ORDEN_PRODUCCION SET ESTADO='F' 
WHERE 
ORDEN_PRODUCCION in ('0000030833','0000030949','0000030806','0000030999','0000031005','0000031003','0000030996','0000030926','0000031004','0000030998','0000030876','0000030997')

DELETE IBERPLAS.CP_TCargaOrdenProduccion


DROP TABLE [IBERPLAS].[CP_ENCABEZADOPLANIFICACION];
CREATE TABLE [IBERPLAS].[CP_ENCABEZADOPLANIFICACION](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[planificacion_id] [varchar](10)  null,
	[ordenproduccion] [varchar] (50)not null,
	[pedido] [varchar] (50) not null,
	[estado] [varchar] (2) not null,
	[articulo] [varchar] (100) not null,
	[horaini] integer null,
	[horafin] integer  null,
	[thoraini] [time]  null,
	[thorafin] [time]  null,
	[fhoraini][datetime] null,
	[fhorafin][datetime] null,
	[horas] integer  NULL,
	[cantidad] [decimal] (28,2)  NULL,
	[turno] [varchar](10) NULL,
	[fecha] [date]  NULL,
	[operacion][varchar](50)  NULL,
	[centrocosto] [varchar] (50)  NULL,
	[secuencia] [varchar] (2)  NULL,
	FICHA_TECNICA integer NULL,
	[USUARIOCREACION] [varchar](50)  NULL,
	[FECHACREACION] [datetime]  NULL,
	[USUARIOUPDATE] [varchar](50)  NULL,
	[FECHAUPDATE] [datetime]  NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
DROP TABLE [IBERPLAS].[CP_DETALLEPLANIFICACION];
CREATE TABLE [IBERPLAS].[CP_DETALLEPLANIFICACION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[calendario_id] [varchar](10) not null,
	[planificacion_id] [varchar](10)  null,
	[ordenproduccion] [varchar] (50)not null,
	[orden_prod] [varchar](50) not null,
	[hora] [time] NOT NULL,
	[horan] [decimal] (28,2)  NULL,
	[orden] [varchar](2) NOT NULL,
	[turno] [varchar](10) NOT NULL,
	[fecha] [date] NOT NULL,
	[operacion][varchar](50) NOT NULL,
	[centrocosto] [varchar] (50) NOT NULL,
	[secuencia] [varchar] (2) NOT NULL,
	[cantidadxhora] [decimal] (28,2) NOT NULL,
	FICHA_TECNICA integer null,
	[USUARIOCREACION] [varchar](50)  NULL,
	[FECHACREACION] [datetime]  NULL,
	[USUARIOUPDATE] [varchar](50)  NULL,
	[FECHAUPDATE] [datetime]  NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

alter table IBERPLAS.CP_DETALLEPLANIFICACION add  fechaCalendario DATETIME null;


USE [ibertplastic]
GO

/****** Object:  Table [IBERPLAS].[CP_CLAVES]    Script Date: 02/07/2018 02:57:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[IBERPLAS].[CP_CLAVES]') AND type in (N'U'))
DROP TABLE [IBERPLAS].[CP_CLAVES]
GO

USE [ibertplastic]
GO

/****** Object:  Table [IBERPLAS].[CP_CLAVES]    Script Date: 02/07/2018 02:57:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [IBERPLAS].[CP_CLAVES](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CLAVE] [int] NOT NULL,
	[DESCRIPCION] [varchar](50) NOT NULL,
	[ACTIVA] [varchar](1) NULL,
	[USUARIOCREACION] [varchar](50) NOT NULL,
	[FECHACREACION] [datetime] NOT NULL,
	[USUARIOUPDATE] [varchar](50) NULL,
	[FECHAUPDATE] [datetime] NULL,
	[OPERACION] [varchar](25) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



SET ANSI_PADDING OFF
GO


USE [ibertplastic]
GO

/****** Object:  Table [IBERPLAS].[CP_CALENDARIO_PLANIFICADOR]    Script Date: 01/09/2018 15:58:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[IBERPLAS].[CP_CALENDARIO_PLANIFICADOR]') AND type in (N'U'))
DROP TABLE [IBERPLAS].[CP_CALENDARIO_PLANIFICADOR]
GO

USE [ibertplastic]
GO

/****** Object:  Table [IBERPLAS].[CP_CALENDARIO_PLANIFICADOR]    Script Date: 01/09/2018 15:58:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [IBERPLAS].[CP_CALENDARIO_PLANIFICADOR](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CORE] [varchar](10) NOT NULL,
	[TURNO] [varchar](4) NOT NULL,
	[FECHA] [datetime] NOT NULL,
	[HORA_INICIO] [datetime] NOT NULL,
	[HORA_FIN] [datetime] NOT NULL,
	[ESTADO] [varchar](50) NULL,
	[DIA] [varchar](25) NULL,
	[TIPO] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

drop TABLE [IBERPLAS].[CP_REGISTROHORAS]
CREATE TABLE [IBERPLAS].[CP_REGISTROHORAS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TURNO] [varchar](10) NOT NULL,
	[FECHA] [date] NOT NULL,
	[OPERACION] [varchar](100) NOT NULL,
	[OPERA] [varchar](10) NOT NULL,
	[ORDENPRODUCCION] [varchar](25) NOT NULL,
	[HORAINICIO] [varchar](10) NOT NULL,
	[HORAFIN] [varchar](10) NOT NULL,
	[TIEMPO] [varchar](10) NOT NULL,
	[CLAVE] [varchar](25) NOT NULL,
	[CARGADO_ERP] BIT default 0 NOT NULL,
	[COMENTARIOS] [varchar](75)  NULL,
	[USUARIOCREACION] [varchar](50)  NULL,
	[FECHACREACION] [datetime]  NULL,
	[USUARIOUPDATE] [varchar](50)  NULL,
	[FECHAUPDATE] [datetime]  NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

drop TABLE [IBERPLAS].[CP_REGISTROEMPLEADOS]
CREATE TABLE [IBERPLAS].[CP_REGISTROEMPLEADOS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TURNO] [varchar](10) NOT NULL,
	[FECHA] [date] NOT NULL,
	[OPERACION] [varchar](100) NOT NULL,
	[ORDENPRODUCCION] [varchar](25) NOT NULL,
	[EMPLEADO] [varchar](25) NOT NULL,
	[NOMBRE] [varchar](100) NOT NULL,
	[ROL] [varchar](25) NOT NULL,
	PARTICIPACION decimal(28,2) NULL,
	[CARGADO_ERP] BIT default 0 NOT NULL,
	[USUARIOCREACION] [varchar](50)  NULL,
	[FECHACREACION] [datetime]  NULL,
	[USUARIOUPDATE] [varchar](50)  NULL,
	[FECHAUPDATE] [datetime]  NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

drop TABLE [IBERPLAS].[CP_REGISTROPRODUCCION]
CREATE TABLE [IBERPLAS].[CP_REGISTROPRODUCCION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TURNO] [varchar](10) NOT NULL,
	[FECHA] [date] NOT NULL,
	[OPERACION] [varchar](100) NOT NULL,
	[ORDENPRODUCCION] [varchar](25) NOT NULL,
	[CICLOPIEZA] [decimal](28,2) NOT NULL,
	[METATURNO] [decimal](28,2) NOT NULL,
	[PRODUCCION] [decimal](28,2) NOT NULL,
	[EFICIENCIA] [decimal](28,2) NOT NULL,
	[DESPERDICIORECU] [decimal](28,2) NOT NULL,
	[DESPERDICIONORECU] [decimal](28,2) NOT NULL,
	[TOTAL] [decimal](28,2) NOT NULL,
	[CARGADO_ERP] BIT default 0 NOT NULL,
	[USUARIOCREACION] [varchar](50)  NULL,
	[FECHACREACION] [datetime]  NULL,
	[USUARIOUPDATE] [varchar](50)  NULL,
	[FECHAUPDATE] [datetime]  NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

drop table IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE
CREATE TABLE IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE(
      ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      core decimal(10,2) NOT NULL,
      fecha date NOT NULL,
      hora time	not null,
      turno varchar	(1) not null,
      orden varchar (2) not null,
      fechahora datetime null,
      fechaCalendario datetime null,
      dia varchar(1)  null,
      tipo varchar(4) null,
      estado varchar(25) null)
alter table IBERPLAS.CP_CALENDARIO_PLANIFICADOR_detalle add  turnodia varchar(3) null;
      
      
drop table [IBERPLAS].[CP_TEMP_PLANIFICACION]      
CREATE TABLE [IBERPLAS].[CP_TEMP_PLANIFICACION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[calendario_id] integer not null,
	[orden_prod] [varchar](50) not null,
	[hora] [time] NOT NULL,
	[horan] [decimal] (28,2)  NULL,
	[orden] [varchar](2) NOT NULL,
	[turno] [varchar](10) NOT NULL,
	[fecha] [date] NOT NULL,
	fechaCalendario datetime null,
	[operacion][varchar](50) NOT NULL,
	[centrocosto] [varchar] (50) NOT NULL,
	[secuencia] [varchar] (2) NOT NULL,
	[cantidadxhora] [decimal] (28,2) NOT NULL,
	ficha_tecnica integer ,
	[fechahora] [datetime] null,
	[USUARIOCREACION] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [IBERPLAS].[CP_TEMP_PLANIFICACION_ENCA](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[horaini] [varchar] (10) null,
	[horafin] [varchar] (10) null,
	[thoraini] [time]  null,
	[thorafin] [time]  null,
	[fhoraini][datetime] null,
	[fhorafin][datetime] null,
	[horas] [varchar](2)  NULL,
	[cantidad] [decimal] (28,2)  NULL,
	[turno] [varchar](10) NULL,
	ficha_tecnica integer ,
	[fecha] [date]  NULL,
	[operacion][varchar](50)  NULL,
	[centrocosto] [varchar] (50)  NULL,
	[secuencia] [varchar] (2)  NULL,
	[USUARIO] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


drop table [IBERPLAS].[CP_PLANIFICACION]
CREATE TABLE [IBERPLAS].[CP_PLANIFICACION](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[operacion] [varchar] (50) not null,
	[ordenproduccion] [varchar] (50)not null,
	[articulo] [varchar] (100) not null,
	[pedido][varchar](50) not null,
	[fechamin][datetime] null,
	[fechamax][datetime] null,
	[cantidad] [decimal] (28,2)  NULL,
	[estado] [varchar] (2) not null,
	[centrocosto] [varchar](50) not null,
	[horas] integer not null,
	[porcentaje] integer  null,
	FICHA_TECNICA integer null,
	CONFIRMADA VARCHAR(10) NULL,
	APROBADA VARCHAR(10) NULL,
	[USUARIOCREACION] [varchar](50)  NULL,
	[FECHACREACION] [datetime]  NULL,
	[USUARIOUPDATE] [varchar](50)  NULL,
	[FECHAUPDATE] [datetime]  NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
alter table IBERPLAS.CP_PLANIFICACION add fechaCalendariomin DATETIME null;
alter table IBERPLAS.CP_PLANIFICACION add fechaCalendariomax DATETIME null;


alter table IBERPLAS.EQUIPO add calendario_id varchar (25) null;

drop table [IBERPLAS].[CP_tasks]
CREATE TABLE IBERPLAS.CP_tasks(
      id			int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      text			VARCHAR(100)	NOT NULL,
      duration		integer NOT NULL,
      progress		float	NULL,
      start_date	datetime	 NULL,
      parent		integer	 NULL,
      centrocosto varchar(100)null,
      ordenproduccion varchar(100) null) 
drop table [IBERPLAS].[CP_events]      
CREATE TABLE IBERPLAS.CP_events(
      id			int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      start_date	datetime,
      end_date	datetime ,
      text		varchar(100),
      type_id	integer,
      centrocosto varchar(100)null,
      ordenproduccion varchar (100) null)
      
CREATE TABLE IBERPLAS.CP_types(
      id			int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      type_id varchar(50),
      name	varchar(50))
      
CREATE TABLE IBERPLAS.CP_globales(
      id			int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      produccdetallada varchar(50),
      ) 
      
DROP TABLE IBERPLAS.CP_consumo                  
CREATE TABLE IBERPLAS.CP_consumo(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      planificacion_id varchar(25) not null,
      orden_produccion	VARCHAR(25)	NOT NULL,
      articulo			VARCHAR(25)	NOT NULL,
      descripcion		VARCHAR(50)	NULL,
      cantidad			DECIMAL(28,8)	NOT NULL,
      operacion			varchar(25)	 NULL,
      procesada			varchar(1) null,
      idtransaccionsof	varchar(25) null,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      


USE [ibertplastic]
GO

/****** Object:  Table [dbo].[users]    Script Date: 03/12/2018 10:05:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[email] [nvarchar](255) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[remember_token] [nvarchar](100) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[nombres] [nvarchar](60) NOT NULL,
	[apellidos] [nvarchar](60) NOT NULL,
	[telefono] [nvarchar](60) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [ibertplastic]
GO

/****** Object:  Table [dbo].[roles]    Script Date: 03/12/2018 10:09:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[roles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[slug] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[special] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [ibertplastic]
GO

/****** Object:  Table [dbo].[role_user]    Script Date: 03/12/2018 10:09:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[role_user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[role_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[role_user]  WITH CHECK ADD  CONSTRAINT [role_user_role_id_foreign] FOREIGN KEY([role_id])
REFERENCES [dbo].[roles] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[role_user] CHECK CONSTRAINT [role_user_role_id_foreign]
GO

ALTER TABLE [dbo].[role_user]  WITH CHECK ADD  CONSTRAINT [role_user_user_id_foreign] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[role_user] CHECK CONSTRAINT [role_user_user_id_foreign]
GO

drop table [IBERPLAS].[CP_emails]
CREATE TABLE IBERPLAS.CP_emails(
      id			int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      email			VARCHAR(100)	NOT NULL,
      email01		varchar(10)  default ('N'),
      email02		varchar(10)	default ('N'),
      email03		varchar(10)	 default ('N'),
      email04		varchar(10)	 default ('N'),
      email05		varchar(10) default ('N'),
      email06		varchar(10) default ('N'),
      email07		varchar(10) default ('N'),
      email08		varchar(10) default ('N'),
      email09		varchar(10) default ('N'),
      email10		varchar(10) default ('N'),
      )   
      
 alter table IBERPLAS.ESTRUC_PROC_RUBRO add CP_TIEMPOCAMBIOMOLDE decimal (28,2) null;   
      
      
      
      --control de calidad
  drop table [IBERPLAS].[FT_FICHA] 
      CREATE TABLE IBERPLAS.FT_FICHA(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ARTICULO		varchar(25) not null,
      LINEA         VARCHAR(50) NULL,
      FAMILIA		VARCHAR(25)	NOT NULL,
      REVISION		VARCHAR(25)	NOT NULL,
      ESTADO		VARCHAR(1)	NULL,
      CODIGO_BARRA  VARCHAR(50) NULL,
      IMAGEN_CODIGOBARRA VARCHAR(50) NULL,
      CODIGO_DUN    VARCHAR(50) NULL,
      IMAGEN_CODIGODUN VARCHAR(50) NULL,
      DESCRIPCION_ART VARCHAR(100) NULL,
      CLIENTE VARCHAR(100) NULL,
      PAIS VARCHAR(100)NULL,
      OBSERVACION VARCHAR(250) NULL,
      FECHA			datetime	NOT NULL,
      IMAGEN_ARTICULO VARCHAR(50) NULL,
      IMAGEN_VINETA VARCHAR(50) NULL,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      
      drop table [IBERPLAS].[FT_INSERTADO] 
      CREATE TABLE IBERPLAS.FT_INSERTADO(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ficha_id int not null,
      NUM_BROCA		decimal(28,2)  null,
      NUM_AGUJEROS	decimal(28,2)	 NULL,
      NUM_FILAS		decimal(28,2)	 NULL,
      PROFU_AGUJERO		decimal(28,2)	NULL,
      PROFU_LENGUETA  decimal(28,2) NULL,
      MO_UTILIZADA    VARCHAR(50) NULL,
      OBSERVACION VARCHAR(250) NULL,
      FECHA			datetime	NOT NULL,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      
      
      drop table [IBERPLAS].[FT_SOPORTE] 
      CREATE TABLE IBERPLAS.FT_SOPORTE(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ficha_id int not null,
      SOPORTE                   VARCHAR(100) NULL,
      PESO_SOPOR_SIN_PERFO		decimal(28,2)  null,
      TOLERANCIA_1              decimal(28,2)  null,
      PESO_SOPOR_CON_PERFO	    decimal(28,2)	 NULL,
      TOLERANCIA_2              decimal(28,2)  null,
      COLOR		                VARCHAR(100)	 NULL,
      OBSERVACION VARCHAR(250) NULL,
      FECHA			datetime	NOT NULL,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      
      drop table [IBERPLAS].[FT_FIBRA_ALAMBRE] 
      CREATE TABLE IBERPLAS.FT_FIBRA_ALAMBRE(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ficha_id int not null,
      MONOCOLOR						VARCHAR(50) NULL,
      BICOLOR						VARCHAR(50)  null,
      COMBINACION_1					VARCHAR(100) NULL,
      COMBINACION_2					VARCHAR(100) NULL,
      COMBINACION_3					VARCHAR(100) NULL,
      COMBINACION_4					VARCHAR(100) NULL,
      COMBINACION_5					VARCHAR(100) NULL,
      COMBINACION_6					VARCHAR(100) NULL,
      COMBINACION_7					VARCHAR(100) NULL,
      COMBINACION_8					VARCHAR(100) NULL,
      COMBINACION_9					VARCHAR(100) NULL,
      COLOR_FIBRA_1					VARCHAR(100) NULL,
      PESO_FIBRA_1					DECIMAL(28,2) NULL,
      TOLERANCIA_1              decimal(28,2)  null,
      COLOR_FIBRA_2					VARCHAR(100) NULL,
      PESO_FIBRA_2					DECIMAL(28,2) NULL,
      TOLERANCIA_2              decimal(28,2)  null,
      LARGO_FIBRA				DECIMAL(28,2) NULL,
      TOLERANCIA_3				DECIMAL(28,2) NULL,
      DIAMETRO_FIBRA			DECIMAL(28,2) NULL,
      TOLERANCIA_4				DECIMAL(28,2) NULL,
      DIAMETRO_ALAMBRE			DECIMAL(28,2) NULL,
      TOLERANCIA_ALAMBRE		DECIMAL(28,2) NULL,
      PESO_ALAMBRE				DECIMAL(28,2) NULL,
      TIPO_FIBRA				VARCHAR(50) NULL,
      OBSERVACION VARCHAR(250) NULL,
      FECHA			datetime	NOT NULL,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      
      
      drop table [IBERPLAS].[FT_DIMESION_CEPILLO] 
      CREATE TABLE IBERPLAS.FT_DIMENSION_CEPILLO(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ficha_id int not null,
      LARGO					DECIMAL(28,2) NULL,
      TOLERANCIA_1			DECIMAL(28,2) NULL,
      ANCHO					DECIMAL(28,2) NULL,
      TOLERANCIA_2			DECIMAL(28,2) NULL,
      ALTO					DECIMAL(28,2) NULL,
      TOLERANCIA_3			DECIMAL(28,2) NULL,
      PLUMADO				DECIMAL(28,2) NULL,
      TOLERANCIA_4			DECIMAL(28,2) NULL,
      PESO_CEPILLO			DECIMAL(28,2) NULL,
      TOLERANCIA_5			DECIMAL(28,2) NULL,
      PESO_CEPILLO_SIN_PLUMA DECIMAL(28,2) NULL,
      TOLERANCIA_6			DECIMAL(28,2) NULL,
      OBSERVACION VARCHAR(250) NULL,
      FECHA			datetime	NOT NULL,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      
      
      drop table [IBERPLAS].[FT_BOLILLO] 
      CREATE TABLE IBERPLAS.FT_BOLILLO(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ficha_id int not null,
      TIPO					VARCHAR(25) NULL,
      CAPUCHON_COLGANTE		VARCHAR(2) NULL,
      COLOR					VARCHAR(50) NULL,
      CAPUCHON_ROSCA		VARCHAR(10) NULL,
      COLOR_PALO			VARCHAR(50) NULL,
      VINETA_PALO			VARCHAR(50) NULL,
      OBSERVACION           VARCHAR(250) NULL,
      FECHA			datetime	NOT NULL,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      
      drop table [IBERPLAS].[FT_CORRUGADO] 
      CREATE TABLE IBERPLAS.FT_CORRUGADO(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ficha_id int not null,
      CORRUGADO					VARCHAR(50) NULL,
      CAPUCHON_ROSCA			VARCHAR(100) NULL,
      DESCRIPCION				VARCHAR(200) NULL,
      LAMINA					VARCHAR(50) NULL,
      BOLSA		                VARCHAR(50) NULL,
      ESTANDAR_EMPAQUE			DECIMAL(28,2) NULL,
      ETIQUETA					VARCHAR(50) NULL,
      COMENTARIOS				VARCHAR(800) NULL,
      FECHA_ACTUALIZACION		DATETIME NOT NULL,
      OBSERVACION				VARCHAR(250) NULL,
      FECHA						datetime	NOT NULL,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      
      drop table [IBERPLAS].[FT_GANCHO] 
      CREATE TABLE IBERPLAS.FT_GANCHO(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ficha_id int not null,
      PESO_ALAMBRE					decimal(28,2) NULL,
      TOLERANCIA_1				decimal(28,2) NULL,
      DIAMETRO					decimal(28,2) NULL,
      TOLERANCIA_2	                decimal(28,2) NULL,
      LARGO			DECIMAL(28,2) NULL,
      TOLERANCIA_3					decimal(28,2) NULL,
      OBSERVACION				VARCHAR(250) NULL,
      FECHA						datetime	NOT NULL,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      
      drop table [IBERPLAS].[FT_RESORTE] 
      CREATE TABLE IBERPLAS.FT_RESORTE(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ficha_id int not null,
      PESO_ALAMBRE			    decimal(28,2) NULL,
      TOLERANCIA_1				decimal(28,2) NULL,
      DISTANCIA_PASO            decimal(28,2) NULL,
      TOLERANCIA_2	            decimal(28,2) NULL,
      LARGO						DECIMAL(28,2) NULL,
      TOLERANCIA_3				decimal(28,2) NULL,
      NUMERO_VUELTAS			DECIMAL(28,2) NULL,
      DIAMETRO					DECIMAL(28,2) NULL,
      TOLERANCIA_4				DECIMAL(28,2) NULL,
      OBSERVACION				VARCHAR(250) NULL,
      FECHA						datetime	NOT NULL,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      
      
      
      drop table [IBERPLAS].[FT_ESPECIFICACION] 
      CREATE TABLE IBERPLAS.FT_ESPECIFICACION(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ficha_id int not null,
      COLOR				varchar(25) not null,
      MAQUINA1			VARCHAR(25) NULL,
      MAQUINA2			VARCHAR(25)	NOT NULL,
      MAQUINA3			VARCHAR(25)	NOT NULL,
      MAQUINA4			VARCHAR(25)	NULL,
      MAQUINA5			VARCHAR(25) NULL,
      ESTANDAR_EMPAQUE	VARCHAR(50) NULL,
      LARGO				VARCHAR(50) NULL,
      TOLERANCIA1		decimal(28,2) NULL,
      DIAMETRO_ART		VARCHAR(100) NULL,
      TOLERANCIA2		decimal(28,2) NULL,
      OBSERVACION VARCHAR(250) NULL,
      FECHA			datetime	NOT NULL,
      usuariocreacion	varchar(50) not null,
      fechacreacion		datetime not null,
      usuarioedidt		varchar(25)  null,
      fechaedit			datetime  null)
      
      alter table IBERPLAS.FT_ESPECIFICACION add PESO decimal(28,2) null	
alter table IBERPLAS.FT_ESPECIFICACION add TOLERANCIA3	decimal(28,2) null
alter table IBERPLAS.FT_ESPECIFICACION add ANCHO	decimal(28,2) null
alter table IBERPLAS.FT_ESPECIFICACION add TOLERANCIA4	decimal (28,2) null
alter table IBERPLAS.FT_ESPECIFICACION add ALTO_ROSCA	decimal (28,2) null
alter table IBERPLAS.FT_ESPECIFICACION add TOLERANCIA5	decimal (28,2) null
alter table IBERPLAS.FT_ESPECIFICACION add ALTO_TOTAL	decimal(28,2) null
alter table IBERPLAS.FT_ESPECIFICACION add TOLERANCIA6	decimal(28,2) null
alter table IBERPLAS.FT_ESPECIFICACION add ESPESOR	decimal(28,2)null
alter table IBERPLAS.FT_ESPECIFICACION add TOLERANCIA7	decimal(28,2) null
alter table IBERPLAS.FT_ESPECIFICACION add PASO_ROSCA	decimal (28,2)null
alter table IBERPLAS.FT_ESPECIFICACION add PROFUNDIDAD_ROSCA	decimal(28,2)null
alter table IBERPLAS.FT_ESPECIFICACION add TOLERANCIA8	decimal(28,2)null
alter table IBERPLAS.FT_ESPECIFICACION add DIAMETRO_EXTERNO	 decimal(28,2)null
alter table IBERPLAS.FT_ESPECIFICACION add TOLERANCIA9	decimal(28,2)null
alter table IBERPLAS.FT_ESPECIFICACION add DIAMETRO_INTERNO	decimal(28,2)null
alter table IBERPLAS.FT_ESPECIFICACION add TOLARANCIA10	decimal(28,2)null
alter table IBERPLAS.FT_ESPECIFICACION add STD_EMPAQUE	decimal(28,2)null
alter table IBERPLAS.FT_ESPECIFICACION add CAVIDADES	decimal(28,2)null
alter table IBERPLAS.FT_ESPECIFICACION add FORMULA  decimal(28,2)nul


 drop table [IBERPLAS].[CP_RUBRO] 
      CREATE TABLE IBERPLAS.CP_RUBRO(
      id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
      ARTICULO				varchar(25) not null,
      CENTROCOSTO			VARCHAR(25) NULL,
      CANTIDAD			decimal(28,2)	NOT NULL,
      OPERACION			VARCHAR(25)	NOT NULL
      )


update IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE SET tipo=NULL
UPDATE IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE set tipo='A' where DATEPART(HOUR,hora)='08' 
UPDATE IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE set tipo='A' where DATEPART(HOUR,hora)='09'
UPDATE IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE set tipo='A' where DATEPART(HOUR,hora)='10'
UPDATE IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE set tipo='A' where DATEPART(HOUR,hora)='11'
UPDATE IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE set tipo='A' where DATEPART(HOUR,hora)='12'
UPDATE IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE set tipo='A' where DATEPART(HOUR,hora)='14'
UPDATE IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE set tipo='A' where DATEPART(HOUR,hora)='15'
UPDATE IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE set tipo='A' where DATEPART(HOUR,hora)='16'
UPDATE IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE set tipo='A' where DATEPART(HOUR,hora)='17'

-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-04-2022 a las 15:42:20
-- Versión del servidor: 10.4.18-MariaDB
-- Versión de PHP: 7.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `automotriz`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_agregarProducto` (IN `xidcat` INT(11), IN `xnom` VARCHAR(45), IN `xfoto` LONGBLOB, IN `xdesc` VARCHAR(45), IN `xprec` DOUBLE, IN `xstock` INT(11))  insert into producto (id_cat,nom_pro,foto_pro,desc_pro,prec_pro,stock_pro) values (xidcat,xnom,xfoto,xdesc,xprec,xstock)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_aumentarStock` (IN `ID` INT, IN `CANT` INT)  BEGIN
    DECLARE STOCK_ANTES INT;
    DECLARE STOCK_AHORA INT;
    SET STOCK_ANTES:=(SELECT stock_pro from producto WHERE id_producto = ID);
    SET STOCK_AHORA:= STOCK_ANTES + CANT;
    UPDATE producto SET stock_pro=STOCK_AHORA WHERE id_producto=ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_buscarProducto` (IN `xid` INT)  select p.id_producto, c.nom_cat, p.nom_pro, p.foto_pro, p.desc_pro, p.prec_pro,p.stock_pro from 
producto p inner join categoria c on p.id_cat=c.id_cat
where id_producto=xid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_descontarStock` (IN `ID` INT, IN `CANT` INT)  BEGIN
    DECLARE STOCK_ANTES INT;
    DECLARE STOCK_AHORA INT;
    SET STOCK_ANTES:=(SELECT stock_pro from producto WHERE id_producto = ID);
    SET STOCK_AHORA:= STOCK_ANTES - CANT;
    UPDATE producto SET stock_pro=STOCK_AHORA WHERE id_producto=ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_eliminarProducto` (IN `xid` INT)  delete from producto where id_producto = xid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_listarEntradas` ()  select e.id_ent, e.id_producto,p.nom_pro, e.can_ent, e.costo_ent, e.total_ent, e.fecha_ent
from entradas e
inner join producto p on p.id_producto = e.id_producto$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_listarProducto` ()  select p.id_producto, p.nom_pro, p.id_cat, c.nom_cat, p.prec_pro,p.stock_pro, p.id_prov, pr.nombre
from producto p 
inner join categoria c on p.id_cat=c.id_cat
inner join proveedores pr on p.id_prov = pr.id_prov$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_listarSalidas` ()  select s.id,s.id_producto, p.nom_pro, s.cantidad, s.costo, s.total, s.fecha
from salidas s
inner join producto p on s.id_producto = p.id_producto$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_modificarProducto` (IN `xid` INT, IN `xidcat` INT(11), IN `xnom` INT(45), IN `xfoto` LONGBLOB, IN `xdesc` INT(45), IN `xprec` DOUBLE, IN `xstock` INT(11))  update producto set id_cat=xid_cat, nom_pro=xnom,foto_pro=xfoto,desc_pro=xdesc,prec_pro=xprec,stock_pro=xstock where id_producto=xid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_reporteEntradas` (IN `fecini` DATE, IN `fecfin` DATE)  select p.nom_pro, s.can_ent, s.costo_ent, s.total_ent, s.fecha_ent
from entradas s 
inner join producto p on p.id_producto = s.id_producto
where s.fecha_ent BETWEEN fecini and fecfin$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_reporteSalidas` (IN `fecini` DATE, IN `fecfin` DATE)  select p.nom_pro, s.cantidad, s.costo, s.total, s.fecha
from salidas s 
inner join producto p on p.id_producto = s.id_producto
where s.fecha BETWEEN fecini and fecfin$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `id_cat` int(11) NOT NULL,
  `nom_cat` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id_cat`, `nom_cat`) VALUES
(1, 'Tubos'),
(2, 'Soldadura'),
(3, 'Sensores'),
(28, 'Herramientas'),
(61, 'BOTIQUIN');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

CREATE TABLE `empleado` (
  `id_emp` int(11) NOT NULL,
  `nombreEmpleado` varchar(45) NOT NULL,
  `apellidoEmpleado` varchar(50) NOT NULL,
  `dniEmpleado` int(11) NOT NULL,
  `userEmpleado` varchar(45) NOT NULL,
  `passEmpleado` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`id_emp`, `nombreEmpleado`, `apellidoEmpleado`, `dniEmpleado`, `userEmpleado`, `passEmpleado`) VALUES
(14, 'Diego Alonso ', 'Cuadros Tauma', 72216834, 'diegoact', '123');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entradas`
--

CREATE TABLE `entradas` (
  `id_ent` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `can_ent` int(11) NOT NULL,
  `costo_ent` decimal(10,2) NOT NULL,
  `total_ent` decimal(10,2) DEFAULT NULL,
  `fecha_ent` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `entradas`
--

INSERT INTO `entradas` (`id_ent`, `id_producto`, `can_ent`, `costo_ent`, `total_ent`, `fecha_ent`) VALUES
(1, 5, 2, '30.00', '60.00', '2021-09-04'),
(2, 3, 5, '20.00', '100.00', '2021-09-05'),
(5, 3, 10, '10.00', '100.00', '2021-10-15'),
(6, 5, 10, '10.00', '100.00', '2021-10-15'),
(7, 3, 10, '10.00', '118.00', '2021-10-15'),
(8, 5, 10, '10.00', '118.00', '2021-10-15'),
(11, 11, 10, '10.00', '100.00', '2021-10-25'),
(12, 3, 10, '10.00', '118.00', '2021-10-25'),
(13, 12, 10, '10.00', '100.00', '2021-10-29'),
(15, 7, 10, '10.00', '100.00', '2021-10-29'),
(16, 5, 10, '10.00', '118.00', '2021-10-29'),
(17, 7, 50, '10.00', '500.00', '2021-11-10'),
(18, 11, 50, '10.00', '590.00', '2021-11-10'),
(19, 3, 10, '2.50', '25.00', '2021-11-10'),
(20, 3, 10, '2.50', '25.00', '2021-11-10'),
(21, 7, 50, '10.00', '590.00', '2021-11-11'),
(22, 69, 10, '12.50', '147.50', '2021-12-01'),
(23, 3, 40, '164.00', '7740.80', '2021-12-01'),
(24, 3, 10, '50.00', '500.00', '2021-12-01'),
(25, 3, 10, '15.00', '150.00', '2021-12-02'),
(26, 3, 15, '15.00', '225.00', '2021-12-02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id_producto` int(11) NOT NULL,
  `id_cat` int(11) DEFAULT NULL,
  `nom_pro` varchar(200) NOT NULL,
  `prec_pro` decimal(10,2) NOT NULL,
  `stock_pro` int(11) NOT NULL,
  `id_prov` int(11) DEFAULT NULL,
  `foto_pro` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`id_producto`, `id_cat`, `nom_pro`, `prec_pro`, `stock_pro`, `id_prov`, `foto_pro`) VALUES
(3, 1, '1/4 pugaladas', '0.50', 125, 1, ''),
(5, 1, '1 pugaladas', '0.00', 90, 1, ''),
(7, 2, 'sensor de auto', '100.00', 310, 1, ''),
(8, 2, 'sensor de velocidad', '40.00', 30, 1, ''),
(11, 3, 'faja alternador Nissan Tiida', '1.00', 73, 1, ''),
(12, 3, 'faja  Volkswagen', '170.00', 11, 1, ''),
(53, 28, 'NUEVO PRODUCTO', '123.00', 3, 2, ''),
(57, 3, 'sergio0', '100.00', 150, 2, NULL),
(58, 3, 'faja alternador Nissan Tiida', '100.00', 100, 23, NULL),
(59, 3, 'sergio', '10.00', 10, 30, NULL),
(63, 1, 'sergio alonso', '11.50', 10, 1, NULL),
(64, 3, 'faja alternador Nissan Tiida', '7.50', 10, 1, NULL),
(69, 28, 'Sensor de retroceso', '12.50', 15, 7, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_prov` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `ruc` char(11) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `telefono` char(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_prov`, `nombre`, `ruc`, `direccion`, `telefono`) VALUES
(1, 'CLAVITO S.A.C', '12345678911', 'Av. Wilson, 564', '123456789'),
(2, 'sergio', '123456789', 'diego cpp', '123456789'),
(7, 'SERRUCHO S.A.C', '12345678911', 'Av. Cto Grande 372', '994173661'),
(23, 'PROVEEDOR1', '12312312317', 'ASDDSSD', '123123123'),
(30, 'santa clara123123', '20494099152', 'ALVARITHO', ''),
(57, 'pernito SAC', '20494099153', 'San clara1', ''),
(58, 'pernito SAC', '20494099152', 'diego', ''),
(61, 'pernito SAC', '20494099153', 'terrazas del pueblo mz c1 L2', ''),
(67, 'IMPACTOS', '20494099153', 'Centro de lima', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salidas`
--

CREATE TABLE `salidas` (
  `id` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `costo` decimal(10,2) NOT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `salidas`
--

INSERT INTO `salidas` (`id`, `id_producto`, `cantidad`, `costo`, `total`, `fecha`) VALUES
(1, 7, 24, '300.00', '600.00', '2021-09-04'),
(2, 11, 5, '10.00', '50.00', '2021-09-04'),
(3, 5, 55, '200.00', '1000.00', '2021-09-04'),
(6, 3, 15, '123.00', '123123.00', '2021-10-08'),
(7, 3, 1000, '10.00', '50.00', '2021-10-03'),
(9, 7, 100, '100.00', '100.00', '2021-10-22'),
(10, 8, 15, '12.00', '180.00', '2021-10-15'),
(11, 3, 12, '12.00', '144.00', '2021-10-15'),
(12, 3, 15, '12.00', '180.00', '2021-10-15'),
(13, 3, 15, '15.00', '225.00', '2021-10-15'),
(14, 3, 10, '10.00', '118.00', '2021-10-15'),
(15, 7, 12, '12.00', '144.00', '2021-10-15'),
(16, 11, 10, '10.00', '100.00', '2021-10-25'),
(19, 3, 10, '10.00', '100.00', '2021-10-29'),
(20, 3, 20, '20.00', '400.00', '2021-10-29'),
(21, 3, 10, '5.50', '55.00', '2021-11-10'),
(22, 69, 15, '10.00', '177.00', '2021-12-01'),
(23, 69, 10, '15.00', '177.00', '2021-12-01'),
(24, 3, 10, '10.00', '100.00', '2021-12-01'),
(25, 3, 40, '165.00', '7788.00', '2021-12-01'),
(26, 3, 10, '1.00', '11.80', '2021-12-01'),
(27, 3, 15, '10.00', '177.00', '2021-12-02'),
(28, 3, 15, '10.00', '150.00', '2021-12-02'),
(29, 3, 10, '15.00', '177.00', '2021-12-02');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id_cat`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`id_emp`);

--
-- Indices de la tabla `entradas`
--
ALTER TABLE `entradas`
  ADD PRIMARY KEY (`id_ent`),
  ADD KEY `fk_idproducto` (`id_producto`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `fk_idcat` (`id_cat`),
  ADD KEY `fk_idprov` (`id_prov`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_prov`);

--
-- Indices de la tabla `salidas`
--
ALTER TABLE `salidas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_producto` (`id_producto`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id_cat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT de la tabla `empleado`
--
ALTER TABLE `empleado`
  MODIFY `id_emp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `entradas`
--
ALTER TABLE `entradas`
  MODIFY `id_ent` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_prov` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT de la tabla `salidas`
--
ALTER TABLE `salidas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `entradas`
--
ALTER TABLE `entradas`
  ADD CONSTRAINT `fk_idproducto` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`);

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `fk_idcat` FOREIGN KEY (`id_cat`) REFERENCES `categoria` (`id_cat`),
  ADD CONSTRAINT `fk_idprov` FOREIGN KEY (`id_prov`) REFERENCES `proveedores` (`id_prov`);

--
-- Filtros para la tabla `salidas`
--
ALTER TABLE `salidas`
  ADD CONSTRAINT `fk_producto` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

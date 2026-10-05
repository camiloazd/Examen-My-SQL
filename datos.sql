-- =====================================================================
--  CAMPUS PIZZA - Datos de prueba
--  Ejecutar DESPUÉS de estructura.sql
--  Las fechas de los pedidos son RELATIVAS a hoy (CURDATE()), así las
--  consultas de "último mes" siempre devuelven resultados.
-- =====================================================================
USE campus_pizza;

-- ---------------------------------------------------------------------
-- Categorías
-- ---------------------------------------------------------------------
INSERT INTO categoria (id_categoria, nombre, descripcion) VALUES
(1, 'Pizza',      'Pizzas artesanales'),
(2, 'Panzarotti', 'Panzarottis fritos rellenos'),
(3, 'Bebida',     'Gaseosas, jugos y agua'),
(4, 'Postre',     'Postres y dulces');

-- ---------------------------------------------------------------------
-- Productos (1-8 elaborados, 9-15 no elaborados)
-- ---------------------------------------------------------------------
INSERT INTO producto (id_producto, nombre, descripcion, id_categoria, precio, es_elaborado) VALUES
(1,  'Pizza Margarita',          'Clásica con mozzarella y albahaca',          1, 28000, TRUE),
(2,  'Pizza Pepperoni',          'Mozzarella y pepperoni',                     1, 32000, TRUE),
(3,  'Pizza Hawaiana',           'Jamón y piña',                               1, 33000, TRUE),
(4,  'Pizza Cuatro Quesos',      'Mozzarella, azul, parmesano y cheddar',      1, 36000, TRUE),
(5,  'Pizza BBQ Pollo',          'Pollo desmechado con salsa BBQ',             1, 35000, TRUE),
(6,  'Panzarotti Jamón y Queso', 'Relleno de jamón y mozzarella',              2, 14000, TRUE),
(7,  'Panzarotti Pollo y Champiñones', 'Relleno de pollo, champiñones y queso',2, 16000, TRUE),
(8,  'Panzarotti Napolitano',    'Tomate, mozzarella y albahaca',              2, 15000, TRUE),
(9,  'Coca-Cola 400ml',          'Gaseosa personal',                           3,  4500, FALSE),
(10, 'Limonada Natural',         'Limonada fresca 12oz',                       3,  5500, FALSE),
(11, 'Agua Cristal 600ml',       'Agua sin gas',                               3,  3000, FALSE),
(12, 'Jugo Hit 330ml',           'Jugo de frutas',                             3,  4000, FALSE),
(13, 'Brownie con Helado',       'Brownie tibio con bola de helado',           4,  9000, FALSE),
(14, 'Tiramisú',                 'Porción de tiramisú',                        4, 11000, FALSE),
(15, 'Galleta de Chocolate',     'Galleta grande con chips de chocolate',      4,  3500, FALSE);

-- ---------------------------------------------------------------------
-- Ingredientes
-- ---------------------------------------------------------------------
INSERT INTO ingrediente (id_ingrediente, nombre) VALUES
(1,  'Masa'),
(2,  'Salsa de tomate'),
(3,  'Queso mozzarella'),
(4,  'Pepperoni'),
(5,  'Jamón'),
(6,  'Piña'),
(7,  'Pollo'),
(8,  'Champiñones'),
(9,  'Salsa BBQ'),
(10, 'Queso azul'),
(11, 'Queso parmesano'),
(12, 'Albahaca'),
(13, 'Queso cheddar');

INSERT INTO producto_ingrediente (id_producto, id_ingrediente) VALUES
(1,1),(1,2),(1,3),(1,12),
(2,1),(2,2),(2,3),(2,4),
(3,1),(3,2),(3,3),(3,5),(3,6),
(4,1),(4,2),(4,3),(4,10),(4,11),(4,13),
(5,1),(5,2),(5,3),(5,7),(5,9),
(6,1),(6,3),(6,5),
(7,1),(7,3),(7,7),(7,8),
(8,1),(8,2),(8,3),(8,12);

-- ---------------------------------------------------------------------
-- Adiciones
-- ---------------------------------------------------------------------
INSERT INTO adicion (id_adicion, nombre, precio) VALUES
(1, 'Extra queso',        3000),
(2, 'Salsa BBQ',          1500),
(3, 'Salsa de ajo',       1500),
(4, 'Tocineta',           3500),
(5, 'Champiñones extra',  2500),
(6, 'Jalapeños',          2000),
(7, 'Borde de queso',     4000);

-- ---------------------------------------------------------------------
-- Combos
-- ---------------------------------------------------------------------
INSERT INTO combo (id_combo, nombre, descripcion, precio) VALUES
(1, 'Combo Pareja',     '1 Pizza Pepperoni + 2 Coca-Colas',                          40000),
(2, 'Combo Familiar',   '1 Pizza Hawaiana + 1 Pizza Margarita + 2 Coca-Colas',       62000),
(3, 'Combo Panzarotti', '2 Panzarotti Jamón y Queso + 2 Jugos Hit',                  33000),
(4, 'Combo Dulce',      '1 Pizza BBQ Pollo + 1 Brownie con Helado + 1 Limonada',     46000),
(5, 'Combo Clásico',    '1 Pizza Margarita + 1 Tiramisú',                            36000);

INSERT INTO combo_producto (id_combo, id_producto, cantidad) VALUES
(1, 2, 1), (1, 9, 2),
(2, 3, 1), (2, 1, 1), (2, 9, 2),
(3, 6, 2), (3, 12, 2),
(4, 5, 1), (4, 13, 1), (4, 10, 1),
(5, 1, 1), (5, 14, 1);

-- ---------------------------------------------------------------------
-- Menús
-- ---------------------------------------------------------------------
INSERT INTO menu (id_menu, nombre, descripcion, activo) VALUES
(1, 'Menú Principal',       'Carta completa disponible todos los días', TRUE),
(2, 'Menú Fin de Semana',   'Selección especial para viernes a domingo', TRUE);

INSERT INTO menu_producto (id_menu, id_producto)
SELECT 1, id_producto FROM producto;

INSERT INTO menu_combo (id_menu, id_combo)
SELECT 1, id_combo FROM combo;

INSERT INTO menu_producto (id_menu, id_producto) VALUES
(2, 2), (2, 3), (2, 4), (2, 5), (2, 9), (2, 10), (2, 13), (2, 14);

INSERT INTO menu_combo (id_menu, id_combo) VALUES
(2, 1), (2, 2), (2, 4);

-- ---------------------------------------------------------------------
-- Clientes y tipos de pedido
-- ---------------------------------------------------------------------
INSERT INTO cliente (id_cliente, nombre, telefono, email) VALUES
(1, 'Laura Gómez',      '3101234567', 'laura.gomez@correo.com'),
(2, 'Andrés Pérez',     '3112345678', 'andres.perez@correo.com'),
(3, 'Marta Rodríguez',  '3123456789', 'marta.rodriguez@correo.com'),
(4, 'Juan Torres',      '3134567890', 'juan.torres@correo.com'),
(5, 'Sofía Ramírez',    '3145678901', 'sofia.ramirez@correo.com'),
(6, 'Carlos Díaz',      '3156789012', 'carlos.diaz@correo.com'),
(7, 'Valentina Cruz',   '3167890123', 'valentina.cruz@correo.com'),
(8, 'Diego Martínez',   '3178901234', 'diego.martinez@correo.com');

INSERT INTO tipo_pedido (id_tipo_pedido, nombre) VALUES
(1, 'Para recoger'),
(2, 'Consumir en el lugar');

-- ---------------------------------------------------------------------
-- Pedidos (total se calcula al final). Fecha = hoy - N días a una hora fija
-- ---------------------------------------------------------------------
INSERT INTO pedido (id_pedido, id_cliente, id_tipo_pedido, fecha_hora, estado, total) VALUES
-- Últimos 30 días
(1,  1, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 1  DAY), '19:10:00'), 'Entregado', 0),
(2,  1, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 3  DAY), '20:15:00'), 'Entregado', 0),
(3,  1, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 7  DAY), '19:30:00'), 'Entregado', 0),
(4,  1, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 10 DAY), '18:45:00'), 'Entregado', 0),
(5,  1, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 14 DAY), '13:20:00'), 'Entregado', 0),
(6,  1, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 21 DAY), '19:00:00'), 'Entregado', 0),
(7,  1, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 28 DAY), '20:05:00'), 'Entregado', 0),
(8,  2, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 2  DAY), '12:50:00'), 'Entregado', 0),
(9,  2, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 7  DAY), '13:10:00'), 'Entregado', 0),
(10, 2, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 12 DAY), '19:40:00'), 'Entregado', 0),
(11, 2, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 14 DAY), '20:30:00'), 'Entregado', 0),
(12, 2, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 21 DAY), '14:00:00'), 'Entregado', 0),
(13, 2, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 25 DAY), '21:00:00'), 'Entregado', 0),
(14, 3, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 7  DAY), '18:15:00'), 'Entregado', 0),
(15, 3, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 14 DAY), '19:55:00'), 'Entregado', 0),
(16, 3, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 20 DAY), '20:20:00'), 'Entregado', 0),
(17, 4, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 5  DAY), '17:30:00'), 'Entregado', 0),
(18, 4, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 21 DAY), '18:50:00'), 'Entregado', 0),
(19, 5, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 4  DAY), '13:45:00'), 'Entregado', 0),
(20, 5, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 7  DAY), '20:10:00'), 'Entregado', 0),
(21, 6, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 14 DAY), '19:20:00'), 'Entregado', 0),
(22, 7, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 9  DAY), '14:30:00'), 'Entregado', 0),
(23, 8, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 7  DAY), '18:00:00'), 'Entregado', 0),
-- Más de 30 días atrás
(24, 3, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 40 DAY), '20:00:00'), 'Entregado', 0),
(25, 4, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 45 DAY), '19:25:00'), 'Entregado', 0),
(26, 6, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 50 DAY), '13:15:00'), 'Entregado', 0),
(27, 8, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 35 DAY), '21:10:00'), 'Entregado', 0),
(28, 1, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 38 DAY), '19:45:00'), 'Entregado', 0),
(29, 5, 1, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 60 DAY), '18:30:00'), 'Entregado', 0),
(30, 2, 2, TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 33 DAY), '20:40:00'), 'Entregado', 0);

-- ---------------------------------------------------------------------
-- Detalle de pedidos (id_producto XOR id_combo)
-- ---------------------------------------------------------------------
INSERT INTO detalle_pedido (id_detalle, id_pedido, id_producto, id_combo, cantidad, precio_unitario) VALUES
-- Pedido 1
(1,  1,  2,    NULL, 1, 32000),
(2,  1,  9,    NULL, 2, 4500),
-- Pedido 2
(3,  2,  NULL, 1,    1, 40000),
(4,  2,  14,   NULL, 1, 11000),
-- Pedido 3 (4 líneas)
(5,  3,  3,    NULL, 1, 33000),
(6,  3,  6,    NULL, 2, 14000),
(7,  3,  10,   NULL, 2, 5500),
(8,  3,  13,   NULL, 1, 9000),
-- Pedido 4
(9,  4,  5,    NULL, 1, 35000),
(10, 4,  11,   NULL, 1, 3000),
-- Pedido 5
(11, 5,  NULL, 4,    1, 46000),
-- Pedido 6
(12, 6,  1,    NULL, 2, 28000),
-- Pedido 7
(13, 7,  4,    NULL, 1, 36000),
(14, 7,  12,   NULL, 1, 4000),
-- Pedido 8
(15, 8,  6,    NULL, 2, 14000),
(16, 8,  9,    NULL, 2, 4500),
-- Pedido 9
(17, 9,  7,    NULL, 1, 16000),
(18, 9,  8,    NULL, 1, 15000),
(19, 9,  10,   NULL, 1, 5500),
-- Pedido 10
(20, 10, NULL, 3,    1, 33000),
-- Pedido 11
(21, 11, 2,    NULL, 1, 32000),
(22, 11, 9,    NULL, 1, 4500),
-- Pedido 12
(23, 12, NULL, 2,    1, 62000),
(24, 12, 6,    NULL, 1, 14000),
-- Pedido 13
(25, 13, 3,    NULL, 1, 33000),
(26, 13, 14,   NULL, 2, 11000),
-- Pedido 14
(27, 14, 1,    NULL, 1, 28000),
(28, 14, 11,   NULL, 1, 3000),
-- Pedido 15 (4 líneas)
(29, 15, 4,    NULL, 1, 36000),
(30, 15, 7,    NULL, 1, 16000),
(31, 15, 12,   NULL, 1, 4000),
(32, 15, 15,   NULL, 2, 3500),
-- Pedido 16
(33, 16, NULL, 1,    1, 40000),
-- Pedido 17
(34, 17, 2,    NULL, 1, 32000),
(35, 17, 10,   NULL, 1, 5500),
-- Pedido 18
(36, 18, NULL, 5,    1, 36000),
-- Pedido 19
(37, 19, 3,    NULL, 1, 33000),
(38, 19, 8,    NULL, 1, 15000),
(39, 19, 9,    NULL, 2, 4500),
-- Pedido 20
(40, 20, 5,    NULL, 1, 35000),
(41, 20, 13,   NULL, 1, 9000),
-- Pedido 21
(42, 21, 1,    NULL, 1, 28000),
(43, 21, 11,   NULL, 1, 3000),
-- Pedido 22
(44, 22, NULL, 2,    1, 62000),
(45, 22, 14,   NULL, 1, 11000),
-- Pedido 23
(46, 23, 6,    NULL, 2, 14000),
(47, 23, 9,    NULL, 1, 4500),
-- Pedido 24
(48, 24, 2,    NULL, 2, 32000),
(49, 24, 9,    NULL, 2, 4500),
-- Pedido 25
(50, 25, 4,    NULL, 1, 36000),
-- Pedido 26
(51, 26, NULL, 4,    1, 46000),
-- Pedido 27
(52, 27, 1,    NULL, 1, 28000),
(53, 27, 15,   NULL, 1, 3500),
-- Pedido 28
(54, 28, 2,    NULL, 1, 32000),
-- Pedido 29
(55, 29, NULL, 3,    1, 33000),
-- Pedido 30
(56, 30, 5,    NULL, 1, 35000),
(57, 30, 10,   NULL, 1, 5500);

-- ---------------------------------------------------------------------
-- Adiciones por línea de pedido (personalización)
-- ---------------------------------------------------------------------
INSERT INTO detalle_adicion (id_detalle, id_adicion, cantidad, precio_unitario) VALUES
(1,  1, 1, 3000),   -- Pizza Pepperoni + extra queso
(1,  4, 1, 3500),   --                  + tocineta
(5,  7, 1, 4000),   -- Pizza Hawaiana + borde de queso
(6,  1, 2, 3000),   -- 2 Panzarotti Jamón y Queso + extra queso x2
(9,  2, 1, 1500),   -- Pizza BBQ + salsa BBQ
(12, 1, 1, 3000),   -- Pizzas Margarita + extra queso
(13, 6, 1, 2000),   -- Pizza Cuatro Quesos + jalapeños
(15, 1, 2, 3000),   -- 2 Panzarotti Jamón y Queso + extra queso x2
(17, 1, 1, 3000),   -- Panzarotti Pollo y Champiñones + extra queso
(24, 1, 1, 3000),   -- Panzarotti Jamón y Queso + extra queso
(25, 4, 1, 3500),   -- Pizza Hawaiana + tocineta
(29, 1, 1, 3000),   -- Pizza Cuatro Quesos + extra queso
(29, 3, 1, 1500),   --                      + salsa de ajo
(34, 5, 1, 2500),   -- Pizza Pepperoni + champiñones extra
(38, 3, 1, 1500),   -- Panzarotti Napolitano + salsa de ajo
(40, 2, 1, 1500),   -- Pizza BBQ + salsa BBQ
(40, 4, 1, 3500),   --            + tocineta
(46, 1, 2, 3000),   -- 2 Panzarotti Jamón y Queso + extra queso x2
(52, 1, 1, 3000),   -- Pizza Margarita + extra queso
(54, 1, 1, 3000);   -- Pizza Pepperoni + extra queso

-- ---------------------------------------------------------------------
-- Total de cada pedido = líneas + adiciones
-- ---------------------------------------------------------------------
UPDATE pedido p
SET p.total =
      COALESCE((SELECT SUM(dp.cantidad * dp.precio_unitario)
                FROM detalle_pedido dp
                WHERE dp.id_pedido = p.id_pedido), 0)
    + COALESCE((SELECT SUM(da.cantidad * da.precio_unitario)
                FROM detalle_pedido dp2
                JOIN detalle_adicion da ON da.id_detalle = dp2.id_detalle
                WHERE dp2.id_pedido = p.id_pedido), 0)
WHERE p.id_pedido > 0;

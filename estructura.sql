-- =====================================================================
--  CAMPUS PIZZA - Estructura de la base de datos (MySQL 8.0.16+)
-- =====================================================================
DROP DATABASE IF EXISTS campus_pizza;
CREATE DATABASE campus_pizza
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE campus_pizza;

-- ---------------------------------------------------------------------
-- 1. CATÁLOGO DE PRODUCTOS
-- ---------------------------------------------------------------------
CREATE TABLE categoria (
    id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(50)  NOT NULL,
    descripcion  VARCHAR(150) NULL,
    PRIMARY KEY (id_categoria),
    UNIQUE KEY uq_categoria_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE producto (
    id_producto  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100)  NOT NULL,
    descripcion  VARCHAR(255)  NULL,
    id_categoria INT UNSIGNED  NOT NULL,
    precio       DECIMAL(10,2) NOT NULL,
    es_elaborado BOOLEAN       NOT NULL DEFAULT TRUE,   -- TRUE: se prepara en cocina (pizza, panzarotti). FALSE: bebidas, postres, etc.
    activo       BOOLEAN       NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_producto),
    UNIQUE KEY uq_producto_nombre (nombre),
    CONSTRAINT chk_producto_precio CHECK (precio >= 0),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE ingrediente (
    id_ingrediente INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre         VARCHAR(80)  NOT NULL,
    PRIMARY KEY (id_ingrediente),
    UNIQUE KEY uq_ingrediente_nombre (nombre)
) ENGINE=InnoDB;

-- N:M producto <-> ingrediente (solo productos elaborados tienen ingredientes)
CREATE TABLE producto_ingrediente (
    id_producto    INT UNSIGNED NOT NULL,
    id_ingrediente INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_producto, id_ingrediente),
    CONSTRAINT fk_pi_producto FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pi_ingrediente FOREIGN KEY (id_ingrediente)
        REFERENCES ingrediente (id_ingrediente)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. ADICIONES
-- ---------------------------------------------------------------------
CREATE TABLE adicion (
    id_adicion INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nombre     VARCHAR(80)   NOT NULL,
    precio     DECIMAL(10,2) NOT NULL,
    activo     BOOLEAN       NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_adicion),
    UNIQUE KEY uq_adicion_nombre (nombre),
    CONSTRAINT chk_adicion_precio CHECK (precio >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. COMBOS
-- ---------------------------------------------------------------------
CREATE TABLE combo (
    id_combo    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(100)  NOT NULL,
    descripcion VARCHAR(255)  NULL,
    precio      DECIMAL(10,2) NOT NULL,   -- precio especial del combo
    activo      BOOLEAN       NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_combo),
    UNIQUE KEY uq_combo_nombre (nombre),
    CONSTRAINT chk_combo_precio CHECK (precio >= 0)
) ENGINE=InnoDB;

-- N:M combo <-> producto (con la cantidad de cada producto dentro del combo)
CREATE TABLE combo_producto (
    id_combo    INT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    cantidad    INT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id_combo, id_producto),
    CONSTRAINT chk_cp_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_cp_combo FOREIGN KEY (id_combo)
        REFERENCES combo (id_combo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_cp_producto FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. MENÚ
-- ---------------------------------------------------------------------
CREATE TABLE menu (
    id_menu     INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    activo      BOOLEAN      NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_menu),
    UNIQUE KEY uq_menu_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE menu_producto (
    id_menu     INT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_menu, id_producto),
    CONSTRAINT fk_mp_menu FOREIGN KEY (id_menu)
        REFERENCES menu (id_menu)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mp_producto FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE menu_combo (
    id_menu  INT UNSIGNED NOT NULL,
    id_combo INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_menu, id_combo),
    CONSTRAINT fk_mc_menu FOREIGN KEY (id_menu)
        REFERENCES menu (id_menu)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mc_combo FOREIGN KEY (id_combo)
        REFERENCES combo (id_combo)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. CLIENTES Y PEDIDOS
-- ---------------------------------------------------------------------
CREATE TABLE cliente (
    id_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre     VARCHAR(100) NOT NULL,
    telefono   VARCHAR(20)  NULL,
    email      VARCHAR(120) NULL,
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uq_cliente_email (email)
) ENGINE=InnoDB;

CREATE TABLE tipo_pedido (
    id_tipo_pedido INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre         VARCHAR(40)  NOT NULL,   -- 'Para recoger' | 'Consumir en el lugar'
    PRIMARY KEY (id_tipo_pedido),
    UNIQUE KEY uq_tipo_pedido_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE pedido (
    id_pedido      INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_cliente     INT UNSIGNED  NOT NULL,
    id_tipo_pedido INT UNSIGNED  NOT NULL,
    fecha_hora     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado         ENUM('Pendiente','En preparación','Listo','Entregado','Cancelado')
                                 NOT NULL DEFAULT 'Pendiente',
    total          DECIMAL(12,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (id_pedido),
    KEY idx_pedido_fecha (fecha_hora),
    CONSTRAINT chk_pedido_total CHECK (total >= 0),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_tipo FOREIGN KEY (id_tipo_pedido)
        REFERENCES tipo_pedido (id_tipo_pedido)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Cada línea del pedido es UN producto O UN combo (nunca ambos).
CREATE TABLE detalle_pedido (
    id_detalle      INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_pedido       INT UNSIGNED  NOT NULL,
    id_producto     INT UNSIGNED  NULL,
    id_combo        INT UNSIGNED  NULL,
    cantidad        INT UNSIGNED  NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,   -- precio al momento de la venta
    PRIMARY KEY (id_detalle),
    CONSTRAINT chk_dp_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_dp_producto_o_combo CHECK (
        (id_producto IS NOT NULL AND id_combo IS NULL) OR
        (id_producto IS NULL AND id_combo IS NOT NULL)
    ),
    CONSTRAINT fk_dp_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE ON DELETE CASCADE,
    -- Sin ON UPDATE CASCADE: MySQL no lo permite en columnas usadas en un CHECK (error 3823)
    CONSTRAINT fk_dp_producto FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_dp_combo FOREIGN KEY (id_combo)
        REFERENCES combo (id_combo)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Adiciones aplicadas a una línea del pedido (personalización)
CREATE TABLE detalle_adicion (
    id_detalle      INT UNSIGNED  NOT NULL,
    id_adicion      INT UNSIGNED  NOT NULL,
    cantidad        INT UNSIGNED  NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_detalle, id_adicion),
    CONSTRAINT chk_da_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_da_detalle FOREIGN KEY (id_detalle)
        REFERENCES detalle_pedido (id_detalle)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_da_adicion FOREIGN KEY (id_adicion)
        REFERENCES adicion (id_adicion)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

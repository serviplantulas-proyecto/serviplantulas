BEGIN;

ALTER TABLE public.pedidos
    ALTER COLUMN id_cliente DROP NOT NULL;

ALTER TABLE public.detalle_pedidos
    ALTER COLUMN id_producto DROP NOT NULL;

ALTER TABLE public.notificaciones
    ALTER COLUMN id_producto DROP NOT NULL;

COMMIT;

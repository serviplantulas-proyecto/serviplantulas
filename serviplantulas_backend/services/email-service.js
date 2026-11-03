import { BrevoClient } from '@getbrevo/brevo';

function clienteBrevo() {
  return new BrevoClient({
    apiKey: process.env.BREVO_API_KEY
  });
}

function sender() {
  return {
    name: process.env.EMAIL_FROM_NAME || 'Serviplantulas',
    email: process.env.EMAIL_USER
  };
}

export const enviarCodigoVerificacion = async (emailDestino, nombreDestino, codigo) => {
  try {
    const brevo = clienteBrevo();
    const result = await brevo.transactionalEmails.sendTransacEmail({
      subject: 'Codigo de verificacion - Serviplantulas',
      sender: sender(),
      to: [{ email: emailDestino, name: nombreDestino }],
      htmlContent: `
        <div style="font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto; padding: 24px; border: 1px solid #f0e6e6; border-radius: 12px; background-color: #ffffff;">
          <h2 style="color: #d81b60; text-align: center; margin-bottom: 8px;">Serviplantulas</h2>
          <h3 style="color: #333333; text-align: center; margin-top: 0;">Verifica tu cuenta</h3>
          <p style="color: #555555; font-size: 15px;">Hola <strong>${nombreDestino}</strong>,</p>
          <p style="color: #555555; font-size: 15px;">Gracias por unirte a Serviplantulas. Usa el siguiente codigo de verificacion de 6 digitos para activar tu cuenta. Este codigo vencera en <strong>15 minutos</strong>:</p>
          <div style="text-align: center; margin: 30px 0;">
            <span style="font-size: 32px; font-weight: bold; letter-spacing: 6px; color: #d81b60; background: #fdf2f4; padding: 12px 24px; border-radius: 8px; border: 1px dashed #d81b60; display: inline-block;">
              ${codigo}
            </span>
          </div>
          <p style="color: #888888; font-size: 12px; text-align: center; margin-top: 30px;">
            Si no creaste una cuenta en Serviplantulas, puedes ignorar este correo.
          </p>
        </div>
      `
    });
    console.log('Correo enviado con exito');
    return { exito: true, result };
  } catch (error) {
    console.error('Error enviando correo con Brevo:', error);
    return { exito: false, error };
  }
};

function money(v) {
  const n = Number(v) || 0;
  return n.toLocaleString('es-CO', { maximumFractionDigits: 0 }) + ' COP';
}

function esc(s) {
  return String(s ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

/**
 * Envía resumen completo de factura/venta al correo del usuario.
 * @param {string} emailDestino
 * @param {string} nombreDestino
 * @param {object} factura - datos del frontend
 */
export const enviarResumenFactura = async (emailDestino, nombreDestino, factura) => {
  try {
    const f = factura || {};
    const lineas = Array.isArray(f.lineas) ? f.lineas : [];
    const descuentoPct = Number(f.descuentoPct) || 0;
    const ivaPct = Number(f.ivaPct) || 19;

    let subtotal = 0;
    const filas = lineas.map((l) => {
      const cant = Number(l.cantidad) || 0;
      const unit = Number(l.unitario) || 0;
      const sub = cant * unit;
      subtotal += sub;
      return `
        <tr>
          <td style="padding:8px;border-bottom:1px solid #eee;">${esc(l.nombre)}</td>
          <td style="padding:8px;border-bottom:1px solid #eee;text-align:center;">${cant}</td>
          <td style="padding:8px;border-bottom:1px solid #eee;text-align:right;">${money(unit)}</td>
          <td style="padding:8px;border-bottom:1px solid #eee;text-align:right;">${money(sub)}</td>
        </tr>`;
    }).join('');

    const descuento = subtotal * (descuentoPct / 100);
    const base = subtotal - descuento;
    const iva = base * (ivaPct / 100);
    const total = Number(f.total) > 0 ? Number(f.total) : base + iva;

    const html = `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 24px; border: 1px solid #e8e8e8; border-radius: 12px; background:#fff;">
        <h2 style="color:#2e7d32;text-align:center;margin:0 0 4px;">Serviplantulas</h2>
        <h3 style="color:#333;text-align:center;margin:0 0 20px;">Resumen de Venta / Factura</h3>

        <p style="color:#555;font-size:14px;">Hola <strong>${esc(nombreDestino)}</strong>,</p>
        <p style="color:#555;font-size:14px;">Aquí tienes el detalle de la factura registrada en el sistema:</p>

        <table style="width:100%;border-collapse:collapse;margin:16px 0;font-size:14px;">
          <tr><td style="padding:6px 0;color:#888;">Factura</td><td style="padding:6px 0;text-align:right;font-weight:bold;">#${esc(f.id)}</td></tr>
          <tr><td style="padding:6px 0;color:#888;">Fecha</td><td style="padding:6px 0;text-align:right;">${esc(f.fecha)}</td></tr>
          <tr><td style="padding:6px 0;color:#888;">Cliente</td><td style="padding:6px 0;text-align:right;font-weight:bold;">${esc(f.cliente)}</td></tr>
          ${f.documento ? `<tr><td style="padding:6px 0;color:#888;">Documento</td><td style="padding:6px 0;text-align:right;">${esc(f.documento)}</td></tr>` : ''}
          <tr><td style="padding:6px 0;color:#888;">Método de pago</td><td style="padding:6px 0;text-align:right;">${esc(f.metodoPago || 'Efectivo')}</td></tr>
          <tr><td style="padding:6px 0;color:#888;">Estado</td><td style="padding:6px 0;text-align:right;">${esc(f.estado)}</td></tr>
          <tr><td style="padding:6px 0;color:#888;">Unidades</td><td style="padding:6px 0;text-align:right;">${esc(f.unidades)}</td></tr>
        </table>

        <table style="width:100%;border-collapse:collapse;font-size:13px;margin-top:8px;">
          <thead>
            <tr style="background:#f5f5f5;">
              <th style="padding:8px;text-align:left;">Producto</th>
              <th style="padding:8px;text-align:center;">Cant.</th>
              <th style="padding:8px;text-align:right;">Unitario</th>
              <th style="padding:8px;text-align:right;">Subtotal</th>
            </tr>
          </thead>
          <tbody>
            ${filas || '<tr><td colspan="4" style="padding:12px;text-align:center;color:#888;">Sin líneas</td></tr>'}
          </tbody>
        </table>

        <table style="width:100%;margin-top:16px;font-size:14px;">
          <tr><td style="padding:4px 0;color:#666;">Subtotal</td><td style="text-align:right;">${money(subtotal)}</td></tr>
          ${descuentoPct > 0 ? `<tr><td style="padding:4px 0;color:#666;">Descuento (${descuentoPct}%)</td><td style="text-align:right;">-${money(descuento)}</td></tr>` : ''}
          <tr><td style="padding:4px 0;color:#666;">IVA (${ivaPct}%)</td><td style="text-align:right;">${money(iva)}</td></tr>
          <tr><td style="padding:8px 0;font-weight:bold;font-size:16px;color:#2e7d32;">Total</td><td style="text-align:right;font-weight:bold;font-size:16px;color:#2e7d32;">${money(total)}</td></tr>
        </table>

        <p style="color:#999;font-size:12px;text-align:center;margin-top:28px;">
          Este correo fue generado automáticamente por Serviplantulas.
        </p>
      </div>
    `;

    const brevo = clienteBrevo();
    const result = await brevo.transactionalEmails.sendTransacEmail({
      subject: `Factura #${f.id || ''} - Serviplantulas`,
      sender: sender(),
      to: [{ email: emailDestino, name: nombreDestino || emailDestino }],
      htmlContent: html
    });

    console.log('Factura enviada por correo');
    return { exito: true, result };
  } catch (error) {
    console.error('Error enviando factura con Brevo:', error);
    return { exito: false, error };
  }
};
